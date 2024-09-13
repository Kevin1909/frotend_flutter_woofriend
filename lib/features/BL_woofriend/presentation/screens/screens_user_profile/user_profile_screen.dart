import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:woofriend/config/theme/app_theme.dart';
import 'package:woofriend/features/auth/presentation/providers/auth_provider.dart';
import 'package:woofriend/features/auth/presentation/providers/forms/register_form_provider.dart';
import 'package:woofriend/features/shared/infrastructure/services/camera_gallery_service_impl.dart';
import 'package:woofriend/features/shared/shared.dart';

import '../../../../auth/domain/domain.dart';

class UserProfileScreen extends ConsumerWidget {
  final String userId;
  const UserProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProvider = ref.watch(authProvider);
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        _CustomSliverAppBar(userProvider.user),
        SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index) => _ProfileDetails(),
                childCount: 1))
      ],
    ));
  }
}

class _ProfileDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    //final textStyles = Theme.of(context).textTheme;
    const Color colorTertiary = colorTertiaryTheme;
    const Color colorSecondary = colorSecondaryTheme;

    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ButtonsProfile(
          colorTheme: colorTertiary,
          colorTheme2: colorSecondary,
        )
      ],
    );
  }
}

class _ButtonsProfile extends StatelessWidget {
  final Color colorTheme;
  final Color colorTheme2;
  const _ButtonsProfile({required this.colorTheme, required this.colorTheme2});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 45,
            width: 130,
            child: CustomFilledButton(
              text: "Editar",
              buttonColor: colorTheme,
              colorText: colorTheme2,
            ),
          ),
          SizedBox(
              height: 45,
              width: 130,
              child: CustomFilledButton(
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
    if (user!.profile.photoUser.startsWith("http"))
      return NetworkImage(user!.profile.photoUser);

    return FileImage(File(user!.profile.photoUser));
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
          if (user!.profile.photoUser == "")
            const Align(
              child: SizedBox(
                height: 250,
                width: 250,
                child: CircleAvatar(
                    radius: 20.0,
                    backgroundImage: AssetImage('assets/images/no_photo_profile.png')),
              ),
            ),
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
                    color: colorTertiaryTheme,
                    child: IconButton(
                        onPressed: () async {
                          final photoPath =
                              await CameraGalleryServiceImpl().takePhoto();
                          if (photoPath == null) return;

                          ref
                              .read(registerFormProvider.notifier)
                              .updateUserImage(photoPath);
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
