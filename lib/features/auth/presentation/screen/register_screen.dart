import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:woofriend/config/theme/app_theme.dart';

import 'package:woofriend/features/auth/presentation/providers/forms/register_form_provider.dart';

import 'package:woofriend/features/shared/shared.dart';

import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: colorPrimaryTheme,
        body: IconBackground(
            child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const SizedBox(
              height: 80,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      //if ( !context.canPop() ) return;
                      //context.pop();
                    },
                    icon: const Icon(Icons.arrow_back_rounded,
                        size: 40, color: Colors.white)),
                const Spacer(flex: 1),
                Text('Crear cuenta',
                    style: textStyle.titleLarge?.copyWith(color: Colors.white)),
                const Spacer(flex: 2),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: size.height - 35,
              width: double.infinity,
              margin: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                  color: Color(0xFFF8F7F7),
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: const _RegisterForm(),
            )
          ]),
        )),
      ),
    );
  }
}

class _RegisterForm extends ConsumerWidget {
  const _RegisterForm();

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(duration: const Duration(seconds: 3), content: Text(message)));
  }
  void openDialogRegistered(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 255, 247, 247),
        actionsAlignment: MainAxisAlignment.spaceAround,
        icon: const Icon(Icons.create_rounded),
        title: const Text('¡Cuenta registrada satisfactoriamente!'),
        actions: [
          TextButton(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.black12)),
              onPressed: () {
                context.push("/login");
              },
              child: const Text('¡Ingresar!')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petloverForm = ref.watch(registerFormProvider);
    final authUser = ref.watch(authProvider);
    
    ref.listen(registerFormProvider, (previous, next) {
      if (!next.userRegistered) return;
      openDialogRegistered(context);
    });

    if (!petloverForm.userRegistered) {
      ref.listen(authProvider, (previous, next) {
        if (next.errorMessage.isEmpty) return;
        showSnackbar(context, next.errorMessage);
        authUser.copyWith(errorMessage: "");
      });
    }

    final textStyle = Theme.of(context).textTheme;
    const sizeIcons = Size.square(40);
    const sizeWidth = 10.0;

    const iconUser = "icons/user-square.svg";
    const iconMail = "icons/mail.svg";
    const iconLocation = "icons/location.svg";
    const iconPhone = "icons/device-mobile.svg";
    const iconPassword = "icons/lock.svg";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          const SizedBox(
            height: 35,
          ),
          Text("Registrar petlover", style: textStyle.titleMedium),
          const SizedBox(
            height: 35,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            const SvgIcon(assetIcon: iconUser, size: sizeIcons),
            const SizedBox(
              width: sizeWidth,
            ),
            SizedBox(
              width: 240,
              child: CustomTextFormField(
                label: "Nombre",
                keyboardType: TextInputType.name,
                onChanged:
                    ref.read(registerFormProvider.notifier).onNameChanged,
                errorMessage: petloverForm.isFormPosted
                    ? petloverForm.name.errorMessage
                    : null,
              ),
            ),
          ]),
          const SizedBox(
            height: 30,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            const SvgIcon(assetIcon: iconMail, size: sizeIcons),
            const SizedBox(
              width: sizeWidth,
            ),
            SizedBox(
              width: 240,
              child: CustomTextFormField(
                label: "Correo electrónico",
                keyboardType: TextInputType.emailAddress,
                onChanged:
                    ref.read(registerFormProvider.notifier).onEmailChange,
                errorMessage: petloverForm.isFormPosted
                    ? petloverForm.email.errorMessage
                    : null,
              ),
            ),
          ]),
          const SizedBox(
            height: 30,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            const SvgIcon(assetIcon: iconLocation, size: sizeIcons),
            const SizedBox(
              width: sizeWidth,
            ),
            SizedBox(
              width: 240,
              child: CustomTextFormField(
                label: "Ciudad y departamento",
                keyboardType: TextInputType.streetAddress,
                onChanged:
                    ref.read(registerFormProvider.notifier).onUbicationChanged,
                errorMessage: petloverForm.isFormPosted
                    ? petloverForm.ubication.errorMessage
                    : null,
              ),
            ),
          ]),
          const SizedBox(
            height: 30,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            const SvgIcon(assetIcon: iconPhone, size: sizeIcons),
            const SizedBox(
              width: sizeWidth,
            ),
            SizedBox(
              width: 240,
              child: CustomTextFormField(
                label: "Teléfono",
                keyboardType: TextInputType.phone,
                onChanged:
                    ref.read(registerFormProvider.notifier).onPhoneChanged,
                errorMessage: petloverForm.isFormPosted
                    ? petloverForm.phone.errorMessage
                    : null,
              ),
            ),
          ]),
          const SizedBox(
            height: 30,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            const SvgIcon(assetIcon: iconPassword, size: sizeIcons),
            const SizedBox(
              width: sizeWidth,
            ),
            SizedBox(
              width: 240,
              child: CustomTextFormField(
                obscureText: true,
                label: "Contraseña",
                keyboardType: TextInputType.visiblePassword,
                onChanged:
                    ref.read(registerFormProvider.notifier).onPasswordChanged,
                errorMessage: petloverForm.isFormPosted
                    ? petloverForm.password.errorMessage
                    : null,
              ),
            ),
          ]),
          const SizedBox(
            height: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '¿Ya estás registrado?',
                style: textStyle.bodyMedium,
              ),
              TextButton(
                  onPressed: () => context.push('/login'),
                  child: Text(
                    'Click aquí',
                    style: textStyle.titleSmall,
                  ))
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          SizedBox(
            width: 150,
            height: 45,
            child: CustomFilledButton(
                text: "Registrar",
                buttonColor: colorTertiaryTheme,
                colorText: colorSecondaryTheme,
                onPressed: petloverForm.isPosting
                    ? null
                    : () {
                       
                        ref
                            .read(registerFormProvider.notifier)
                            .onFormSubmitRegister(
                              "new",
                              "user_petlover",
                            );
                      
                      }),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
