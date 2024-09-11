import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:woofriend/features/BL_woofriend/domain/domain.dart';

//import '../../../config/helpers/human_formats.dart';

import '../../../shared/widgets/custom_update_field.dart';
import '../providers/animals_providers/providers.dart';

class AnimalScreen extends ConsumerWidget {
  final String animalId;

  const AnimalScreen({super.key, required this.animalId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animal = ref.watch(animalInfoProvider(animalId));

    if (animal.animal == null) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator(strokeWidth: 2)));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F7),
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(animal: animal.animal),
          SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => _AnimalDetails(animal: animal.animal),
                  childCount: 1))
        ],
      ),
    );
  }
}

class _AnimalDetails extends StatelessWidget {
  final Animal? animal;

  const _AnimalDetails({required this.animal});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 35,
        ),
        const _LogoWoofriend(),
        const SizedBox(
          height: 16,
        ),
        _InfoAnimal(animal: animal, size: size, textStyles: textStyles),
        const SizedBox(
          height: 16,
        ),
        _InfoAditionalAnimal(
          animal: animal,
          size: size,
        ),
         const SizedBox(
          height: 16,
        ),
        const _TextIcon(),
         const SizedBox(
          height: 16,
        ),
      ],
    );
  }
}

class _InfoAnimal extends StatelessWidget {
  const _InfoAnimal({
    required this.animal,
    required this.size,
    required this.textStyles,
  });

  final Animal? animal;
  final Size size;
  final TextTheme textStyles;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: SizedBox(
          width: (size.width - 5),
          child: Column(
            children: [
              // Descripción
              const Text(
                "Descripción",
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.black26,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Text(animal!.characteristics),
              const SizedBox(height: 20),
              const Divider(
                color: Colors.black26,
                height: 0.5,
                indent: 25,
                endIndent: 25,
                thickness: 1,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Raza:",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black26,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(animal!.race)
                    ],
                  ),

                  const SizedBox(width: 40),
                  //Container(height: 35, width: 1, color: Colors.black38,),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Nacimiento:",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black26,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(animal!.birthdate)
                    ],
                  ),

                  const SizedBox(width: 40),
                  //Container(height: 35, width: 1, color: Colors.black38,),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Tipo de animal:",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black26,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(animal!.typeanimal)
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

class _InfoAditionalAnimal extends StatelessWidget {
  const _InfoAditionalAnimal({
    required this.animal,
    required this.size,
  });
  final Animal? animal;
  final Size size;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: SizedBox(
        width: size.width - 5,
        child: Column(
          children: [
            CustomUpdateField(
              readOnly: true,
              isBottomField: true,
              isTopField: true,
              keyboardType: TextInputType.name,
              label: 'Registro de vacunas',
              initialValue: animal!.vaccinationrecord,
            ),
            CustomUpdateField(
              isTopField: true,
              isBottomField: true,
              readOnly: true,
              label: 'Patologías o incapacidades',
              keyboardType: TextInputType.text,
              initialValue: animal!.pathologiesdisabilities,
            ),
            CustomUpdateField(
              readOnly: true,
              isTopField: true,
              isBottomField: true,
              keyboardType: TextInputType.datetime,
              label: 'Número de contacto',
              initialValue: animal!.user!.phone,
            ),
          ],
        ),
      ),
    );
  }
}

class _TextIcon extends StatelessWidget {
  const _TextIcon();

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.check_circle_outline_outlined),
      label: const Text('Adoptar'),
    );
  }
}

class _CustomSliverAppBar extends StatelessWidget {
  final Animal? animal;

  const _CustomSliverAppBar({required this.animal});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;

    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(bottom: 0),
        title: Text(animal!.name, style: textStyle.titleLarge),
        centerTitle: true,
        background: Stack(
          children: [
            SizedBox.expand(
                child: _Photo(
              photo: animal!.photo,
            )),

            const _CustomGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [
                  0.0,
                  0.4
                ],
                colors: [
                  Colors.white60,
                  Colors.transparent,
                ]),

            //* Back arrow background
            const _CustomGradient(begin: Alignment.topLeft, stops: [
              0.0,
              0.3
            ], colors: [
              Colors.black87,
              Colors.transparent,
            ]),
          ],
        ),
      ),
    );
  }
}

class _Photo extends StatelessWidget {
  final String photo;
  const _Photo({required this.photo});

  @override
  Widget build(BuildContext context) {
    if (photo == "") {
      return Image.asset('assets/images/no-image.jpg', fit: BoxFit.cover);
    }

    return Image.network(
      photo,
      fit: BoxFit.fitHeight,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress != null) return const SizedBox();
        return FadeIn(child: child);
      },
    );
  }
}

class _LogoWoofriend extends StatelessWidget {
  const _LogoWoofriend();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset('assets/images/Woofriend_logo_blanco.png',
            fit: BoxFit.cover, height: 70));
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
