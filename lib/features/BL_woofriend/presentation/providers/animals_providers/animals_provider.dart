import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/domain.dart';
import 'animals_repository_provider.dart';

final animalsProvider =
    StateNotifierProvider<AnimalsNotifier, AnimalsState>((ref) {
  final animalsRepository = ref.watch(animalsRepositoryProvider);
  return AnimalsNotifier(animalsRepository: animalsRepository);
});

class AnimalsNotifier extends StateNotifier<AnimalsState> {
  final AnimalsRepository animalsRepository;

  AnimalsNotifier({required this.animalsRepository}) : super(AnimalsState()) {
    loadNextPage();
  }

  Future<bool> createOrUpdateAnimal(Map<String, dynamic> animalLike) async {
    try {
      final animal = await animalsRepository.createUpdateAnimal(animalLike);
      final isAnimalInList =
          state.animals.any((element) => element.id == animal.id);

      if (!isAnimalInList) {
        state = state.copyWith(animals: [animal, ...state.animals,]);
        return true;
      }

      state = state.copyWith(
          animals: state.animals
              .map(
                (element) => (element.id == animal.id) ? animal : element,
              )
              .toList());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteAnimal(String id) async {
    try {
      final animalIsDeleted = await animalsRepository.deleteAnimal(id);
      if (animalIsDeleted) {
        final animal = state.animals.firstWhere((element) => element.id == id);
        state.animals.remove(animal);
        state = state.copyWith(animals: [
          ...state.animals,
        ]);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future loadNextPage() async {
    if (state.isLoading || state.isLastPage) return;

    state = state.copyWith(isLoading: true);

    final animals = await animalsRepository.getAnimalsByPage(
        limit: state.limit, offset: state.offset);

    if (animals.isEmpty) {
      state = state.copyWith(isLoading: false, isLastPage: true);
      return;
    }

    state = state.copyWith(
        isLastPage: false,
        isLoading: false,
        offset: state.offset + 5,
        animals: [...state.animals, ...animals]);
  }
}

class AnimalsState {
  final bool isLastPage;
  final int limit;
  final int offset;
  final bool isLoading;
  final List<Animal> animals;

  AnimalsState(
      {this.isLastPage = false,
      this.limit = 10,
      this.offset = 0,
      this.isLoading = false,
      this.animals = const []});

  AnimalsState copyWith({
    bool? isLastPage,
    int? limit,
    int? offset,
    bool? isLoading,
    List<Animal>? animals,
  }) =>
      AnimalsState(
        isLastPage: isLastPage ?? this.isLastPage,
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
        isLoading: isLoading ?? this.isLoading,
        animals: animals ?? this.animals,
      );
}
