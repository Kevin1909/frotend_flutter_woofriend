import 'package:woofriend/features/auth/domain/domain.dart';

class User {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String ubication;
  final String password;
  final List<String> roles;
  final String token;
  final UserProfile profile;

  User( {
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.ubication,
    required this.password,
    required this.roles,
    required this.token,
    required this.profile,
  });

  bool get isAdmin {
    return roles.contains('admin');
  }
}
