import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:woofriend/features/auth/domain/domain.dart';
import 'package:woofriend/features/shared/infrastructure/services/camera_gallery_service_impl.dart';

import '../../../../auth/presentation/providers/providers.dart';
import '../../../../shared/widgets/custom_update_field.dart';

class UserUpdateScreen extends ConsumerWidget {
  const UserUpdateScreen({
    super.key,
  });

  void showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Perfil Actualizado')));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(authProvider);

    userUpdate() {
      ref
          .read(registerFormProvider.notifier)
          .onUpdateUser(userState.user!, userState.passwordTemp!);
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F7F7),
        appBar: AppBar(
          title: const Text('Editar Perfil'),
          actions: [
            IconButton(
                onPressed: () async {
                  final photoPath =
                      await CameraGalleryServiceImpl().selectPhoto();
                  if (photoPath == null) return;

                  ref
                      .read(registerFormProvider.notifier)
                      .updateUserImage(photoPath);
                },
                icon: const Icon(Icons.photo_library_outlined)),
            IconButton(
                onPressed: () async {
                  final photoPath =
                      await CameraGalleryServiceImpl().takePhoto();
                  if (photoPath == null) return;

                  ref
                      .read(registerFormProvider.notifier)
                      .updateUserImage(photoPath);
                },
                icon: const Icon(Icons.camera_alt_outlined))
          ],
        ),
        body: _ProductView(
          user: userState.user!,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            userUpdate();
            await Future.delayed(const Duration(milliseconds: 300));
            ref
                .read(registerFormProvider.notifier)
                .onFormSubmitRegister(
                  userState.user!.id,
                  userState.user!.roles.first,
                )
                .then((value) {
              if (!value) return;
              context.pop();
              showSnackbar(context);
            });
          },
          child: const Icon(Icons.save_as_outlined),
        ),
      ),
    );
  }
}

class _ProductView extends ConsumerWidget {
  final User user;

  const _ProductView({
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPhotoForm = ref.watch(registerFormProvider).photo;
    return ListView(
      children: [
        const SizedBox(
          height: 25,
        ),
        _ImageGallery(
            image: (userPhotoForm == "") ? user.photoUser : userPhotoForm),
        const SizedBox(
          height: 25,
        ),
        _UserInformation(
          user: user,
        ),
      ],
    );
  }
}

class _UserInformation extends ConsumerWidget {
  final User user;

  const _UserInformation({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userForm = ref.watch(registerFormProvider);
    final passwordTemp = ref.watch(authProvider).passwordTemp;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Información personal'),
          const SizedBox(height: 15),
          CustomUpdateField(
            isTopField: true,
            keyboardType: TextInputType.name,
            label: 'Nombre',
            initialValue: user.name,
            onChanged: ref.read(registerFormProvider.notifier).onNameChanged,
            errorMessage: userForm.name.errorMessage,
          ),
          CustomUpdateField(
            keyboardType: TextInputType.emailAddress,
            label: 'Correo',
            initialValue: user.email,
            onChanged: ref.read(registerFormProvider.notifier).onEmailChange,
            errorMessage: userForm.email.errorMessage,
          ),
          CustomUpdateField(
            keyboardType: TextInputType.text,
            label: 'Dirección',
            initialValue: user.ubication,
            onChanged:
                ref.read(registerFormProvider.notifier).onUbicationChanged,
            errorMessage: userForm.ubication.errorMessage,
          ),
          CustomUpdateField(
            keyboardType: TextInputType.phone,
            label: 'Teléfono',
            initialValue: user.phone,
            onChanged: ref.read(registerFormProvider.notifier).onPhoneChanged,
            errorMessage: userForm.phone.errorMessage,
          ),
          CustomUpdateField(
            keyboardType: TextInputType.text,
            obscureText: true,
            label: 'Contraseña',
            initialValue: passwordTemp!,
            onChanged:
                ref.read(registerFormProvider.notifier).onPasswordChanged,
            errorMessage: userForm.password.errorMessage,
          ),
          const SizedBox(height: 15),
          const Text('Información de perfil'),
          const SizedBox(height: 15),
          CustomUpdateField(
              isTopField: true,
              maxLines: 6,
              label: '¿Por qué te uniste a esta comunidad?',
              keyboardType: TextInputType.multiline,
              initialValue: user.firstcontent,
              onChanged:
                  ref.read(registerFormProvider.notifier).updateFirstContent),
          CustomUpdateField(
              maxLines: 6,
              label: '¿Cuál animal es tu favorito y por qué?',
              keyboardType: TextInputType.multiline,
              initialValue: user.secondcontent,
              onChanged:
                  ref.read(registerFormProvider.notifier).updateSecondContent),
          CustomUpdateField(
              isBottomField: true,
              maxLines: 4,
              label: '¿Tienes mascotas?, ¿Qué mascotas tienes?',
              keyboardType: TextInputType.multiline,
              initialValue: user.thirdcontent,
              onChanged:
                  ref.read(registerFormProvider.notifier).updateThirdContent),
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
    ImageProvider isNetworkOrFile() {
      if (image.startsWith("http")) {
        return NetworkImage(image);
      }
      if (image != "") {
        return FileImage(File(image));
      } else {
        return const AssetImage('assets/images/no_photo_profile.png');
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 400,
        width: 300,
        child: CircleAvatar(radius: 20.0, backgroundImage: isNetworkOrFile()),
      ),
    );
  }
}
