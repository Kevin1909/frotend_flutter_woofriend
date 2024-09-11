import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:woofriend/config/theme/app_theme.dart';

import 'package:woofriend/features/shared/shared.dart';

import '../providers/providers.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const background = colorPrimaryTheme;
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: background,
        body: IconBackground(
            child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const SizedBox(
              height: 80,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 10
                      
                    )
                  ]),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset('assets/images/dog_cute.png',
                        fit: BoxFit.cover, height:125,)),
              ),
            
            const SizedBox(
              height: 60,
            ),
            Container(
              height: size.height - 250,
              width: double.infinity,
              margin: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                  color: Color(0xFFF8F7F7),
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: const _LoginForm(),
            )
          ]),
        )),
      ),
    );
  }
}

class _LoginForm extends ConsumerWidget {
  const _LoginForm();

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void openDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF8F7F7),
        actionsAlignment: MainAxisAlignment.spaceAround,
        icon: const Icon(Icons.pets_rounded),
        title: const Text('¿Cómo te quieres registrar?'),
        contentTextStyle: const TextStyle(
          fontStyle: FontStyle.normal,
          color: Colors.black,
        ),
        content: const Text(
          "Registrarse como:",
        ),
        actions: [
          TextButton(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.black12)),
              onPressed: () => context.push('/petlover'),
              child: const Text('Petlover')),
          TextButton(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.black12)),
              onPressed: () => context.push('/foundation'),
              child: const Text('Fundación')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginForm = ref.watch(loginFormProvider);
    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackbar(context, next.errorMessage);
    });

    final textStyle = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          const SizedBox(
            height: 55,
          ),
          Text("¡Bienvenido!", style: textStyle.titleLarge),
          const SizedBox(
            height: 65,
          ),
          CustomTextFormField(
            label: "Correo",
            keyboardType: TextInputType.emailAddress,
            onChanged: ref.read(loginFormProvider.notifier).onEmailChange,
            errorMessage:
                loginForm.isFormPosted ? loginForm.email.errorMessage : null,
          ),
          const SizedBox(
            height: 30,
          ),
          CustomTextFormField(
            label: "Contraseña",
            obscureText: true,
            onChanged: ref.read(loginFormProvider.notifier).onPasswordChanged,
            errorMessage:
                loginForm.isFormPosted ? loginForm.password.errorMessage : null,
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '¿Olvidaste tu contraseña?',
                style: textStyle.bodyMedium,
              ),
              TextButton(
                  onPressed: () {
                    // ignore: avoid_print
                    print("boton presionado");
                  },
                  child: Text(
                    'Click aquí',
                    style: textStyle.titleSmall,
                  ))
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 150,
            height: 45,
            child: CustomFilledButton(
              text: "Ingresar",
              buttonColor: colorTertiaryTheme,
              colorText: colorSecondaryTheme,
              onPressed: loginForm.isPosting
                  ? null
                  : ref.read(loginFormProvider.notifier).onFormSubmit,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 150,
            height: 45,
            child: CustomFilledButton(
                text: "Registrarse",
                buttonColor: colorTertiaryTheme,
                colorText: colorSecondaryTheme,
                onPressed: () => openDialog(context)),
          ),
        ],
      ),
    );
  }
}
