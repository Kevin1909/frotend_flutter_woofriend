import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woofriend/config/theme/app_theme.dart';
import 'package:woofriend/features/BL_woofriend/presentation/providers/animals_providers/animals_provider.dart';
import 'package:woofriend/features/shared/shared.dart';

class PetsView extends ConsumerStatefulWidget {
  const PetsView({super.key});

  @override
  PetsViewState createState() => PetsViewState();
}

class PetsViewState extends ConsumerState<PetsView> {
  @override
  void initState() {
    super.initState();

    ref.read(animalsProvider.notifier).loadNextPage();
  }
  

  @override
  Widget build(BuildContext context) {
    final animalsForAdoption = ref.watch(animalsProvider);

    const backGroundColor = colorSecondaryTheme;
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          expandedHeight: 20,
          backgroundColor: backGroundColor,
          titleSpacing: 0.0,
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.symmetric(vertical: 5),
            centerTitle: true,
            title: CustomAppbar(),
          ),
        ),
        SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          return Column(
            children: [
              PetsScreen(animals: animalsForAdoption.animals, loadNextPage: () => ref.read(animalsProvider.notifier).loadNextPage(), deleteAnimal: ref.read(animalsProvider.notifier).deleteAnimal),
            
               
                
            ],
          );
        }, childCount: 1))
      ],
    );
  }
}
