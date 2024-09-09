import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import 'package:woofriend/config/constants/environment.dart';

import '../../domain/domain.dart';
import '../infrastructure.dart';

class AuthDataSourceImpl extends AuthDataSource {
  final dio = Dio(BaseOptions(
    baseUrl: Environment.apiUrl,
  ));

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await dio.get('/auth/check-status',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      final user = UserMapper.userJsonToEntity(response.data);

      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('Token incorrecto');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };

      final response = await dio
          .post('/auth/login', data: {'email': email, 'password': password});

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
            'Credenciales incorrectas, vuelve a intentar');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> registerUpdateUser(Map<String, dynamic> user) async {
    try {
      final String? userId = user['id'];
      final String method = (userId == null) ? 'POST' : 'PATCH';
      final String url = (userId == null) ? '/auth/register' : '/auth/$userId';

      user.remove('id');

      final response =
          await dio.request(url, data: user, options: Options(method: method));

      final userLike = UserMapper.userJsonToEntity(response.data);
      return userLike;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw CustomError("El correo ya existe");
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet');
      }
      throw Exception();
    }
  }
}
