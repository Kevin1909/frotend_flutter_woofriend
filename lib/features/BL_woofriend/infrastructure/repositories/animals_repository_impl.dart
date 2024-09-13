
import '../../domain/domain.dart';



class AnimalsRepositoryImpl extends AnimalsRepository {

  final AnimalsDatasource datasource;

  AnimalsRepositoryImpl(this.datasource);


  @override
  Future<Animal> createUpdateAnimal(Map<String, dynamic> animalLike) {
    return datasource.createUpdateAnimal(animalLike);
  }

  @override
  Future<Animal> getAnimalById(String id) {
    return datasource.getAnimalById(id);
  }

  @override
  Future<List<Animal>> getAnimalsByPage({int limit = 10, int offset = 0}) {
    return datasource.getAnimalsByPage( limit: limit, offset: offset );
  }

  @override
  Future<List<Animal>> searchAnimalByTerm(String term) {
    return datasource.searchAnimalByTerm(term);
  }
  
  @override
  Future<bool> deleteAnimal(String id) {
    return datasource.deleteAnimal(id);
  }

}