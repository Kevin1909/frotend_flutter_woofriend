import 'package:woofriend/features/auth/domain/domain.dart';
import '../infrastructure.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDataSource dataSource;

  AuthRepositoryImpl({AuthDataSource? dataSource})
      : dataSource = dataSource ?? AuthDataSourceImpl();

  @override
  Future<User> checkAuthStatus(String token) {
    return dataSource.checkAuthStatus(token);
  }

  @override
  Future<User> login(String email, String password) {
    return dataSource.login(email, password);
  }

  @override
  Future<User> registerUpdateUser(
    Map<String, dynamic> user,
  ) {
    return dataSource.registerUpdateUser(
      user,
    );
  }

  @override
  Future<bool> deleteUser(String id) {
    return dataSource.deleteUser(
      id,
    );
  }
}
