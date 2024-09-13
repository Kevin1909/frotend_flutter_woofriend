import '../entities/user.dart';

abstract class AuthDataSource {
  Future<User> login(String email, String password);
  Future<User> registerUpdateUser(Map<String, dynamic> user);

  Future<User> checkAuthStatus(String token);

  Future<User> getUserById(String id);
}
