import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:woofriend/config/theme/app_theme.dart';
import 'package:woofriend/features/BL_woofriend/domain/domain.dart';
import 'package:woofriend/features/auth/presentation/providers/providers.dart';
import 'package:woofriend/features/shared/shared.dart';

import '../../../auth/domain/domain.dart';

class PetsScreen extends ConsumerStatefulWidget {
  final List<Animal> animals;
  final VoidCallback? loadNextPage;
  final Function(String id)? deleteAnimal;

  const PetsScreen(
      {super.key, this.deleteAnimal, this.loadNextPage, required this.animals});

  @override
  PetsScreenState createState() => PetsScreenState();
}

class PetsScreenState extends ConsumerState<PetsScreen> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (widget.loadNextPage == null) return;

      if ((scrollController.position.pixels + 200) >=
          scrollController.position.maxScrollExtent) {
        widget.loadNextPage!();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = ref.watch(authProvider).user;

    return SizedBox(
      height: (size.height * 0.9) - 120,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.animals.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return FadeInRight(
                    child: _SlideAnimals(
                  animal: widget.animals[index],
                  user: user,
                  deleteAnimal: widget.deleteAnimal,
                ));
              },
            ),
          )
        ],
      ),
    );
  }
}

class _SlideAnimals extends StatelessWidget {
  final Animal animal;
  final User? user;
  final Function(String id)? deleteAnimal;

  const _SlideAnimals({required this.animal, this.user, this.deleteAnimal});

  void showCustomDialog(BuildContext context) {
    const colorDialog = colorTertiaryTheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorDialog,
        actionsAlignment: MainAxisAlignment.spaceAround,
        title: const Text('¿Desea eliminar la mascota?'),
        titleTextStyle: const TextStyle(
          fontStyle: FontStyle.normal,
          color: Colors.white,
        ),
        actions: [
          TextButton(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.white70)),
              onPressed: () {
                deleteAnimal!(animal.id);
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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isMatchedUser() {
      if (animal.user!.id == user!.id) return true;
      return false;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: SizedBox(
                  width: size.width * 0.3,
                  height: 200,
                  child: (animal.photo != "")
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: FadeInImage(
                            fit: BoxFit.fill,
                            width: double.infinity,
                            height: 300,
                            placeholder:
                                const AssetImage('assets/loaders/wait_dog.gif'),
                            image: NetworkImage(animal.photo),
                          ))
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset('assets/images/no-image.jpg',
                              fit: BoxFit.cover)),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: (size.width - 40) * 0.55,
                      child: Text(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          animal.characteristics),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      const CircleAvatar(
                        child: Icon(Icons.person_2_rounded),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      SizedBox(
                        width: size.width * 0.2,
                        child: Text(
                          animal.user!.name,
                          maxLines: 2,
                          style: const TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      )
                    ]),
                    const SizedBox(
                      height: 10,
                    ),
                    if (isMatchedUser())
                      Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(width: 120),
                            IconButton(
                              iconSize: 25,
                              icon: const Icon(Icons.update_rounded),
                              onPressed: () {
                                context.push('/animalUpdate/${animal.id}');
                              },
                            ),
                            IconButton(
                                iconSize: 25,
                                icon: const Icon(Icons.delete_forever_rounded),
                                onPressed: () => showCustomDialog(context)),
                          ]),
                    const SizedBox()
                  ])
            ]),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: SizedBox(
                width: 80,
                height: 50,
                child: CustomFilledButton(
                    onPressed: () => context.push('/animal/${animal.id}'),
                    text: "Ver",
                    buttonColor: const Color.fromARGB(255, 201, 201, 201),
                    colorText: Colors.black87),
              ),
            ),
          ],
        )
      ]),
    );
  }
}
