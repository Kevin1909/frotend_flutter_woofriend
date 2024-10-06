import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:woofriend/config/theme/app_theme.dart';
import 'package:woofriend/features/auth/presentation/providers/auth_provider.dart';
import 'package:woofriend/features/auth/presentation/providers/forms/register_form_provider.dart';
import 'package:woofriend/features/shared/infrastructure/services/camera_gallery_service_impl.dart';
import 'package:woofriend/features/shared/shared.dart';

import '../../../../auth/domain/domain.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProvider = ref.watch(authProvider);
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        _CustomSliverAppBar(
          userProvider.user,
        ),
        SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index) => _ProfileDetails(
                      user: userProvider.user!,
                      deleteUser: ref.read(authProvider.notifier).deleteUser,
                    ),
                childCount: 1))
      ],
    ));
  }
}

class _ProfileDetails extends StatelessWidget {
  final User user;
  final Function(String id)? deleteUser;
  const _ProfileDetails({required this.user, this.deleteUser});
  @override
  Widget build(
    BuildContext context,
  ) {
    const Color colorTertiary = colorTertiaryTheme;
    const Color colorSecondary = colorSecondaryTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ButtonsProfile(
          colorTheme: colorTertiary,
          colorTheme2: colorSecondary,
          deleteUser: deleteUser,
        ),
        _InfoAditional(user: user)
      ],
    );
  }
}

class _ButtonsProfile extends ConsumerWidget {
  final Color colorTheme;
  final Color colorTheme2;
  final Function(String id)? deleteUser;
  const _ButtonsProfile(
      {required this.colorTheme, required this.colorTheme2, this.deleteUser});

  void showCustomDialog(BuildContext context, String id) {
    const colorDialog = colorTertiaryTheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorDialog,
        actionsAlignment: MainAxisAlignment.spaceAround,
        title: const Text('¿Desea eliminar la cuenta?'),
        titleTextStyle: const TextStyle(
          fontStyle: FontStyle.normal,
          color: Colors.white,
        ),
        actions: [
          TextButton(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.white70)),
              onPressed: () {
                deleteUser!(id);
                context.pop();
              },
              child: const Text('¡Sí!')),
          TextButton(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.white70)),
              onPressed: () => context.pop(),
              child: const Text('¡No!')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user!.id;
    

    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 45,
            width: 130,
            child: CustomFilledButton(
              onPressed: () => context.push("/userUpdateScreen"),
              text: "Editar",
              buttonColor: colorTheme,
              colorText: colorTheme2,
            ),
          ),
          SizedBox(
              height: 45,
              width: 130,
              child: CustomFilledButton(
                onPressed: () {
                  showCustomDialog(context, user);
                },
                text: "Eliminar",
                buttonColor: colorTheme,
                colorText: colorTheme2,
              )),
        ],
      ),
    );
  }
}

class _CustomSliverAppBar extends ConsumerWidget {
  final User? user;

  const _CustomSliverAppBar(
    this.user,
  );

  ImageProvider isNetworkOrFile() {
    if (user!.photoUser.startsWith("http")) {
      return NetworkImage(user!.photoUser);
    }
    if (user!.photoUser != "") {
      return FileImage(File(user!.photoUser));
    } else {
      return const AssetImage('assets/images/no_photo_profile.png');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //const iconCamera = "icons/camara.svg";
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor: colorSecondaryTheme,
      expandedHeight: size.height * 0.5,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(children: [
          const _CustomGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.2, 1.0],
              colors: [Colors.black54, Colors.transparent]),
          Align(
            child: SizedBox(
              height: 250,
              width: 250,
              child: CircleAvatar(
                  radius: 20.0, backgroundImage: isNetworkOrFile()),
            ),
          ),
          Positioned(
            bottom: 120,
            right: 95,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.black87,
                    child: IconButton(
                        onPressed: () {
                          context.push("/userUpdateScreen");
                        },
                        icon: const Icon(
                            color: Colors.white, Icons.camera_alt_sharp)))),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              user!.name,
              style: textStyle.titleLarge,
            ),
          ),
        ]),
      ),
    );
  }
}

class _InfoAditional extends StatelessWidget {
  final User? user;
  const _InfoAditional({this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.email_rounded),
            const SizedBox(
              width: 5,
            ),
            Text(user!.email)
          ]),
          const SizedBox(
            height: 18,
          ),
          Row(children: [
            const Icon(Icons.phone_android_rounded),
            const SizedBox(
              width: 5,
            ),
            Text(user!.phone)
          ]),
          const SizedBox(
            height: 18,
          ),
          Row(children: [
            const Icon(Icons.map),
            const SizedBox(
              width: 5,
            ),
            Text(user!.ubication)
          ]),
          const SizedBox(
            height: 18,
          ),
          const Divider(
            color: Colors.black26,
            height: 0.5,
            indent: 25,
            endIndent: 25,
            thickness: 1,
          ),
          const SizedBox(
            height: 18,
          ),
          _TextFormFieldUser(const Icon(Icons.person_3_rounded),
              "¿Por qué te uniste a esta comunidad?", user!.firstcontent),
          const SizedBox(
            height: 18,
          ),
          _TextFormFieldUser(const Icon(Icons.favorite_rounded),
              "¿Cuál animal es tu favorito y por qué?", user!.secondcontent),
          const SizedBox(
            height: 18,
          ),
          _TextFormFieldUser(const Icon(Icons.catching_pokemon_rounded),
              "¿Tienes mascotas?, ¿Qué mascotas tienes?", user!.thirdcontent),
          const SizedBox(
            height: 18,
          ),
        ],
      ),
    );
  }
}

class _CustomGradient extends StatelessWidget {
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<double> stops;
  final List<Color> colors;

  const _CustomGradient(
      {this.begin = Alignment.centerLeft,
      this.end = Alignment.centerRight,
      required this.stops,
      required this.colors});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: begin, end: end, stops: stops, colors: colors))),
    );
  }
}

class _TextFormFieldUser extends StatelessWidget {
  final Icon? icon;
  final String? text;
  final String? textUser;
  const _TextFormFieldUser(this.icon, this.text, this.textUser);

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    const outlineInputBorder = UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
            bottomRight: Radius.circular(40),
            bottomLeft: Radius.circular(40)));

    final inputDecoration = InputDecoration(
      helperMaxLines: 2,
      label: Text(
        text!,
        maxLines: 2,
      ),
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder,
      filled: true,
      suffixIcon: IconButton(
        icon: icon!,
        onPressed: () {
          null;
        },
      ),
    );
    return TextFormField(
        style: textStyle.bodyMedium,
        readOnly: true,
        decoration: inputDecoration,
        maxLines: 6,
        initialValue: textUser);
  }
}
