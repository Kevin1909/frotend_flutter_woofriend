


import 'package:woofriend/features/BL_woofriend/domain/domain.dart';

abstract class AnimalsRepository {

  Future<List<Animal>> getAnimalsByPage({ int limit = 10, int offset = 0 });
  Future<Animal> getAnimalById(String id);

  Future<List<Animal>> searchAnimalByTerm( String term );
  
  Future<Animal> createUpdateAnimal( Map<String,dynamic> animalLike );


}

