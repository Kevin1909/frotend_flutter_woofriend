import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:woofriend/features/BL_woofriend/domain/domain.dart';

//import '../../../config/helpers/human_formats.dart';

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
        
        _InfoAnimal(animal: animal, size: size, textStyles: textStyles),

        

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
      child: Column(
        children: [
         // Descripción
          SizedBox(
            width: (size.width - 5),
            child: Column(
              children: [
                const Text("Descripción", style: TextStyle(fontSize: 25, color: Colors.black26, fontWeight: FontWeight.w500), ),
                const SizedBox(height: 10),
                Text(animal!.characteristics),
                const SizedBox(height: 20),
                const Divider(color: Colors.black26, height: 0.5, indent: 40, endIndent: 40, thickness: 1,),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Raza:", style: TextStyle(fontSize: 13, color: Colors.black26, fontWeight: FontWeight.w500), ),
                        Text(animal!.race)
                      ],
                    ),
                    const SizedBox(width: 20),
                    Container(height: 35, width: 5, color: Colors.black38,),
                    const SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Nacimiento:", style: TextStyle(fontSize: 13, color: Colors.black26, fontWeight: FontWeight.w500), ),
                        Text(animal!.birthdate)
                      ],
                    ),

                    const SizedBox(width: 20),
                    Container(height: 35, width: 5, color: Colors.black38,),
                    const SizedBox(width: 20),
                  
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Tipo de animal:", style: TextStyle(fontSize: 13, color: Colors.black26, fontWeight: FontWeight.w500), ),
                        Text(animal!.typeanimal)
                      ],
                    ),



                  ],
                  
                ),


        

              ],
            ),
          )
        ],
      ),
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
      elevation: 2.0 ,
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
              child:  _Photo(photo: animal!.photo,)
            ),

            const _CustomGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [
                  0.2,
                  0.9
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

    if ( photo == "" ) {
      return  Image.asset('assets/images/no-image.jpg', fit: BoxFit.cover );
    }

          return  Image.network(
                photo,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) return const SizedBox();
                  return FadeIn(child: child);
                },
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
