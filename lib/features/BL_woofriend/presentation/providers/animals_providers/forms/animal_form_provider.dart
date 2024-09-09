import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:woofriend/features/BL_woofriend/presentation/infrastructure/inputs_animal/inputs.dart';
import 'package:woofriend/features/BL_woofriend/presentation/providers/animals_providers/animals_provider.dart';

import '../../../../domain/domain.dart';

final animalFormProvider = StateNotifierProvider.autoDispose
    .family<AnimalFormNotifier, AnimalFormState, Animal>((ref, animal) {
  // final createUpdateCallback = ref.watch( productsRepositoryProvider ).createUpdateProduct;
  final createUpdateCallback =
      ref.watch(animalsProvider.notifier).createOrUpdateAnimal;

  return AnimalFormNotifier(
    animal: animal,
    onSubmitCallback: createUpdateCallback,
  );
});

class AnimalFormNotifier extends StateNotifier<AnimalFormState> {
  final Future<bool> Function(Map<String, dynamic> animalLike)?
      onSubmitCallback;

  AnimalFormNotifier({
    this.onSubmitCallback,
    required Animal animal,
  }) : super(AnimalFormState(
            id: animal.id,
            name: Name.dirty(animal.name),
            typeAnimal: TypeAnimal.dirty(animal.typeanimal),
            race: Race.dirty(animal.race),
            characteristics: Characteristics.dirty(animal.characteristics),
            birthdate: Birthdate.dirty(animal.birthdate),
            vaccinationrecord: animal.vaccinationrecord,
            pathologiesdisabilities: animal.pathologiesdisabilities,
            photo: animal.photo));

  Future<bool> onFormSubmit() async {
    _touchedEverything();
    if (!state.isFormValid) return false;

    // TODO: regresar
    if (onSubmitCallback == null) return false;

    final animalLike = {
      'id': (state.id == 'new') ? null : state.id,
      'name': state.name.value,
      'typeanimal': state.typeAnimal.value,
      'race': state.race.value,
      'characteristics': state.characteristics.value,
      'birthdate': state.birthdate.value,
      'vaccinationrecord': state.vaccinationrecord,
      'pathologiesdisabilities': state.pathologiesdisabilities,
      'photo': state.photo
    };

    try {
      return await onSubmitCallback!(animalLike);
    } catch (e) {
      return false;
    }
  }

  void _touchedEverything() {
    state = state.copyWith(
      isFormValid: Formz.validate([
        Name.dirty(state.name.value),
        TypeAnimal.dirty(state.typeAnimal.value),
        Race.dirty(state.race.value),
        Characteristics.dirty(state.characteristics.value),
        Birthdate.dirty(state.birthdate.value)
      ]),
    );
  }

  void updateAnimalImage(String photo) {
    state = state.copyWith(photo: photo);
  }

  void onNameChanged(String value) {
    state = state.copyWith(
        name: Name.dirty(value),
        isFormValid: Formz.validate([
          Name.dirty(value),
          TypeAnimal.dirty(state.typeAnimal.value),
          Race.dirty(state.race.value),
          Characteristics.dirty(state.characteristics.value),
          Birthdate.dirty(state.birthdate.value)
        ]));
  }

  void onTypeAnimalChanged(String value) {
    state = state.copyWith(
        typeAnimal: TypeAnimal.dirty(value),
        isFormValid: Formz.validate([
          Name.dirty(state.name.value),
          TypeAnimal.dirty(value),
          Race.dirty(state.race.value),
          Characteristics.dirty(state.characteristics.value),
          Birthdate.dirty(state.birthdate.value)
        ]));
  }

  void onRaceChanged(String value) {
    state = state.copyWith(
        race: Race.dirty(value),
        isFormValid: Formz.validate([
          Name.dirty(state.name.value),
          TypeAnimal.dirty(state.typeAnimal.value),
          Race.dirty(value),
          Characteristics.dirty(state.characteristics.value),
          Birthdate.dirty(state.birthdate.value)
        ]));
  }

  void onCharacteristicsChanged(String value) {
    state = state.copyWith(
        characteristics: Characteristics.dirty(value),
        isFormValid: Formz.validate([
          Name.dirty(state.name.value),
          TypeAnimal.dirty(state.typeAnimal.value),
          Race.dirty(state.race.value),
          Characteristics.dirty(value),
          Birthdate.dirty(state.birthdate.value)
        ]));
  }

  void onBirthdateChanged(String value) {
    state = state.copyWith(
        birthdate: Birthdate.dirty(value),
        isFormValid: Formz.validate([
          Name.dirty(state.name.value),
          TypeAnimal.dirty(state.typeAnimal.value),
          Race.dirty(state.race.value),
          Characteristics.dirty(state.characteristics.value),
          Birthdate.dirty(value)
        ]));
  }

  void onVaccinationRecordChanged(String vaccinationRecord) {
    state = state.copyWith(vaccinationrecord: vaccinationRecord);
  }

  void onPathologiesDisabilitiesChanged(String pathologiesDisabilities) {
    state = state.copyWith(pathologiesdisabilities: pathologiesDisabilities);
  }

  void onPhotoChanged(String photo) {
    state = state.copyWith(photo: photo);
  }
}

class AnimalFormState {
  final bool isFormValid;
  final String? id;
  final Name name;
  final TypeAnimal typeAnimal;
  final Race race;
  final Characteristics characteristics;
  final Birthdate birthdate;
  final String vaccinationrecord;
  final String pathologiesdisabilities;
  final String photo;

  AnimalFormState(
      {this.isFormValid = false,
      this.id,
      this.name = const Name.dirty(''),
      this.typeAnimal = const TypeAnimal.dirty(''),
      this.race = const Race.dirty(""),
      this.characteristics = const Characteristics.dirty(""),
      this.birthdate = const Birthdate.dirty(""),
      this.vaccinationrecord = "",
      this.pathologiesdisabilities = '',
      this.photo = ""});

  AnimalFormState copyWith({
    bool? isFormValid,
    String? id,
    Name? name,
    TypeAnimal? typeAnimal,
    Race? race,
    Characteristics? characteristics,
    Birthdate? birthdate,
    String? vaccinationrecord,
    String? pathologiesdisabilities,
    String? photo,
  }) =>
      AnimalFormState(
        isFormValid: isFormValid ?? this.isFormValid,
        id: id ?? this.id,
        name: name ?? this.name,
        typeAnimal: typeAnimal ?? this.typeAnimal,
        race: race ?? this.race,
        characteristics: characteristics ?? this.characteristics,
        birthdate: birthdate ?? this.birthdate,
        vaccinationrecord: vaccinationrecord ?? this.vaccinationrecord,
        pathologiesdisabilities:
            pathologiesdisabilities ?? this.pathologiesdisabilities,
        photo: photo ?? this.photo,
      );
}
