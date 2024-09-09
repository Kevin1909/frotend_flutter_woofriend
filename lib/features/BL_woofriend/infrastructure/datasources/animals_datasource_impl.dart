import 'dart:io';

import 'package:dio/dio.dart';
import 'package:woofriend/config/config.dart';

import 'package:woofriend/features/BL_woofriend/domain/domain.dart';
import 'package:woofriend/features/auth/infrastructure/infrastructure.dart';

import '../mappers/animal_mapper.dart';

class AnimalsDatasourceImpl extends AnimalsDatasource {
  late final Dio dio;
  final String accessToken;

  AnimalsDatasourceImpl({required this.accessToken})
      : dio = Dio(BaseOptions(
            baseUrl: Environment.apiUrl,
            headers: {'Authorization': 'Bearer $accessToken'}));

  Future<String> _uploadFile(String path) async {
    try {
      final fileName = path.split('/').last;
      final FormData data = FormData.fromMap({
        'file': MultipartFile.fromFileSync(
          path,
          filename: fileName,
        )
      });

      final respose = await dio.post('/files/animal',
          data: data,);

      return respose.data;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<Animal> createUpdateAnimal(Map<String, dynamic> animalLike) async {
    try {
      final String? animalId = animalLike['id'];
      final String method = (animalId == null) ? 'POST' : 'PATCH';
      final String url = (animalId == null) ? '/animals' : '/animals/$animalId';

      animalLike.remove('id');
      animalLike['photo'] = await _uploadFile(animalLike['photo']);

      final response = await dio.request(url,
          data: animalLike, options: Options(method: method));

      final animal = AnimalMapper.jsonToEntity(response.data);
      return animal;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<Animal> getAnimalById(String id) async {
    try {
      final response = await dio.get('/animals/$id');
      final animal = AnimalMapper.jsonToEntity(response.data);
      return animal;
    } on DioException catch (e) {
      if (e.response!.statusCode == 404)
        throw CustomError("No se pudo encontrar");
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<Animal>> getAnimalsByPage(
      {int limit = 10, int offset = 0}) async {
    try {
      final response = await dio.get<List>('/animals');
      final List<Animal> animals = [];
      for (final animal in response.data ?? []) {
        animals.add(AnimalMapper.jsonToEntity(animal));
      }
      return animals;
    } on DioException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<Animal>> searchAnimalByTerm(String term) {
    // TODO: implement searchProductByTerm
    throw UnimplementedError();
  }
}
