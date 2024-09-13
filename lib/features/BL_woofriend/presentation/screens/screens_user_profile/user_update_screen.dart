
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:woofriend/features/auth/domain/domain.dart';

import '../../../../auth/presentation/providers/providers.dart';
import '../../../../auth/presentation/providers/user_auth_provider.dart';
import '../../../../shared/widgets/custom_update_field.dart';
import '../../../../shared/widgets/full_screen_loader.dart';


class UserUpdateScreen extends ConsumerWidget {
  final String userId;

  const UserUpdateScreen({super.key, required this.userId});

  void showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Perfil Actualizado')));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userInfoProvider(userId));

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F7F7),
        appBar: AppBar(
          title: const Text('Editar Perfil'),
        ),
        body: userState.isLoading
            ? const FullScreenLoader()
            : _ProductView(user: userState.user!),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (userState.user == null) return;

            ref
                .read(registerFormProvider.notifier)
                .onFormSubmitRegister(userState.user!.roles.toString(), userId)
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
  final User user;

  const _ProductView({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        const SizedBox(
          height: 25,
        ),
        _UserInformation(user: user),
      ],
    );
  }
}

class _UserInformation extends ConsumerWidget {
  final User user;
  const _UserInformation({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userById = ref.watch(userInfoProvider(user.id)).user;
    final userForm = ref.watch(registerFormProvider);

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
            initialValue: userById!.name,
            onChanged: ref.read(registerFormProvider.notifier).onNameChanged,
            errorMessage: userForm.name.errorMessage,
          ),
          CustomUpdateField(
            
            keyboardType: TextInputType.emailAddress,
            label: 'Correo',
            initialValue: userById.email,
            onChanged: ref.read(registerFormProvider.notifier).onEmailChange,
            errorMessage: userForm.email.errorMessage,
          ),
        
          CustomUpdateField(
            keyboardType: TextInputType.text,
            label: 'Dirección',
            initialValue: userById.ubication,
            onChanged:
                ref.read(registerFormProvider.notifier).onUbicationChanged,
            errorMessage: userForm.ubication.errorMessage,
          ),
          CustomUpdateField(
            keyboardType: TextInputType.phone,
            label: 'Teléfono',
            initialValue: userById.phone,
            onChanged: ref
                .read(registerFormProvider.notifier).onPhoneChanged,
            errorMessage: userForm.phone.errorMessage,
          ),
          CustomUpdateField(
            keyboardType: TextInputType.text,
            obscureText: true,
            label: 'Contraseña',
            initialValue: userById.password,
            onChanged: ref
                .read(registerFormProvider.notifier).onPasswordChanged,
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
            initialValue: userById.profile.firstcontent,
            onChanged: ref
                .read(registerFormProvider.notifier).updateFirstContent
          ),
          CustomUpdateField(
            maxLines: 6,
            label: 'Cuál animal es tu favorito y por qué?',
            keyboardType: TextInputType.multiline,
            initialValue: userById.profile.secondcontent,
            onChanged: ref
                .read(registerFormProvider.notifier).updateSecondContent
          ),
           CustomUpdateField(
            isBottomField: true,
            maxLines: 6,
            label: '¿Tienes mascotas?, ¿Qué mascotas tienes?',
            keyboardType: TextInputType.multiline,
            initialValue: userById.profile.thirdcontent,
            onChanged: ref
                .read(registerFormProvider.notifier).updateThirdContent
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

