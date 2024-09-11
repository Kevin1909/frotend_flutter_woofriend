import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:woofriend/features/BL_woofriend/presentation/providers/animals_providers/animal_provider.dart';

import '../../../shared/infrastructure/services/camera_gallery_service_impl.dart';
import '../../../shared/widgets/custom_update_field.dart';
import '../../../shared/widgets/full_screen_loader.dart';
import '../../domain/domain.dart';
import '../providers/animals_providers/providers.dart';

class AnimalUpdateScreen extends ConsumerWidget {
  final String animalId;

  const AnimalUpdateScreen({super.key, required this.animalId});

  void showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Animal Actualizado')));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animalState = ref.watch(animalInfoProvider(animalId));

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F7F7),
        appBar: AppBar(
          title: const Text('Editar Animal'),
          actions: [
            IconButton(
                onPressed: () async {
                  final photoPath =
                      await CameraGalleryServiceImpl().selectPhoto();
                  if (photoPath == null) return;

                  ref
                      .read(animalFormProvider(animalState.animal!).notifier)
                      .updateAnimalImage(photoPath);
                },
                icon: const Icon(Icons.photo_library_outlined)),
            IconButton(
                onPressed: () async {
                  final photoPath =
                      await CameraGalleryServiceImpl().takePhoto();
                  if (photoPath == null) return;

                  ref
                      .read(animalFormProvider(animalState.animal!).notifier)
                      .updateAnimalImage(photoPath);
                },
                icon: const Icon(Icons.camera_alt_outlined))
          ],
        ),
        body: animalState.isLoading
            ? const FullScreenLoader()
            : _ProductView(animal: animalState.animal!),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (animalState.animal == null) return;

            ref
                .read(animalFormProvider(animalState.animal!).notifier)
                .onFormSubmit()
                .then((value) {
              if (!value) return;
              showSnackbar(context);
              context.pop();
            });
          },
          child: const Icon(Icons.save_as_outlined),
        ),
      ),
    );
  }
}

class _ProductView extends ConsumerWidget {
  final Animal animal;

  const _ProductView({required this.animal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animalForm = ref.watch(animalFormProvider(animal));

    final textStyles = Theme.of(context).textTheme;

    return ListView(
      children: [
        const SizedBox(
          height: 25,
        ),
        SizedBox(
          height: 250,
          width: 600,
          child: _ImageGallery(image: animalForm.photo),
        ),
        const SizedBox(height: 10),
        Center(
            child: Text(
          animalForm.name.value,
          style: textStyles.titleSmall,
          textAlign: TextAlign.center,
        )),
        const SizedBox(height: 10),
        _AnimalInformation(animal: animal),
      ],
    );
  }
}

class _AnimalInformation extends ConsumerWidget {
  final Animal animal;
  const _AnimalInformation({required this.animal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animalForm = ref.watch(animalFormProvider(animal));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Información'),
          const SizedBox(height: 15),
          CustomUpdateField(
            isTopField: true,
            keyboardType: TextInputType.name,
            label: 'Nombre',
            initialValue: animalForm.name.value,
            onChanged:
                ref.read(animalFormProvider(animal).notifier).onNameChanged,
            errorMessage: animalForm.name.errorMessage,
          ),
          CustomUpdateField(
            label: 'Tipo de animal',
            keyboardType: TextInputType.text,
            initialValue: animalForm.typeAnimal.value,
            onChanged: ref
                .read(animalFormProvider(animal).notifier)
                .onTypeAnimalChanged,
            errorMessage: animalForm.typeAnimal.errorMessage,
          ),
          CustomUpdateField(
            keyboardType: TextInputType.text,
            label: 'Raza',
            initialValue: animalForm.race.value,
            onChanged:
                ref.read(animalFormProvider(animal).notifier).onRaceChanged,
            errorMessage: animalForm.race.errorMessage,
          ),
          CustomUpdateField(
            isBottomField: true,
            keyboardType: TextInputType.datetime,
            label: 'Nacimiento',
            initialValue: animalForm.birthdate.value,
            onChanged: ref
                .read(animalFormProvider(animal).notifier)
                .onBirthdateChanged,
            errorMessage: animalForm.birthdate.errorMessage,
          ),
          const SizedBox(
            height: 27,
          ),
          CustomUpdateField(
            maxLines: 6,
            isTopField: true,
            isBottomField: true,
            keyboardType: TextInputType.text,
            label: 'Características',
            initialValue: animalForm.characteristics.value,
            onChanged: ref
                .read(animalFormProvider(animal).notifier)
                .onCharacteristicsChanged,
            errorMessage: animalForm.characteristics.errorMessage,
          ),
          const SizedBox(height: 15),
          const Text('Adicional'),
          const SizedBox(height: 15),
          CustomUpdateField(
            isTopField: true,
            label: 'Registro de vacunas',
            keyboardType: TextInputType.text,
            initialValue: animalForm.vaccinationrecord,
            onChanged: ref
                .read(animalFormProvider(animal).notifier)
                .onVaccinationRecordChanged,
          ),
          CustomUpdateField(
            isBottomField: true,
            label: 'Patologías',
            keyboardType: TextInputType.text,
            initialValue: animalForm.pathologiesdisabilities,
            onChanged: ref
                .read(animalFormProvider(animal).notifier)
                .onPathologiesDisabilitiesChanged,
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _ImageGallery extends StatelessWidget {
  final String image;
  const _ImageGallery({required this.image});

  @override
  Widget build(BuildContext context) {
    late ImageProvider imageProvider;
    if (image.startsWith('http')) {
      imageProvider = NetworkImage(image);
    } else {
      imageProvider = FileImage(File(image));
    }
    if (image == "") {
      return ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: Image.asset('assets/images/no-image.jpg', fit: BoxFit.cover));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: FadeInImage(
            fit: BoxFit.cover,
            image: imageProvider,
            placeholder: const AssetImage('assets/loaders/bottle-loader.gif'),
          )),
    );
  }
}
