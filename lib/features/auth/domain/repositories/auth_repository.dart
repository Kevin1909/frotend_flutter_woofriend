import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> registerUpdateUser(Map<String, dynamic> user);
  Future<User> checkAuthStatus(String token);
  Future<bool> deleteUser(String id);
}
