import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/domain.dart';
import 'animals_repository_provider.dart';

final animalInfoProvider = StateNotifierProvider.autoDispose
    .family<AnimalNotifier, AnimalState, String>((ref, animalId) {
  final animalsRepository = ref.watch(animalsRepositoryProvider);

  return AnimalNotifier(
      animalsRepository: animalsRepository, animalId: animalId);
});

class AnimalNotifier extends StateNotifier<AnimalState> {
  final AnimalsRepository animalsRepository;

  AnimalNotifier({
    required this.animalsRepository,
    required String animalId,
  }) : super(AnimalState(id: animalId)) {
    loadAnimal();
  }

  Animal newEmptyAnimal() {
    return Animal(
      id: 'new',
      typeanimal: "",
      birthdate: "",
      name: "",
      characteristics: "",
      race: "",
      vaccinationrecord: "",
      pathologiesdisabilities: "",
      photo: "",
    );
  }

  Future<void> loadAnimal() async {
    try {
      if (state.id == 'new') {
        state = state.copyWith(
          isLoading: false,
          animal: newEmptyAnimal(),
        );
        return;
      }

      final animal = await animalsRepository.getAnimalById(state.id);

      state = state.copyWith(isLoading: false, animal: animal);
    } catch (e) {
      // 404 product not found
      print(e);
    }
  }
}

class AnimalState {
  final String id;
  final Animal? animal;
  final bool isLoading;
  final bool isSaving;

  AnimalState({
    required this.id,
    this.animal,
    this.isLoading = true,
    this.isSaving = false,
  });

  AnimalState copyWith({
    String? id,
    Animal? animal,
    bool? isLoading,
    bool? isSaving,
  }) =>
      AnimalState(
        id: id ?? this.id,
        animal: animal ?? this.animal,
        isLoading: isLoading ?? this.isLoading,
        isSaving: isSaving ?? this.isSaving,
      );
}
