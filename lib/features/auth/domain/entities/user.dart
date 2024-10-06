import 'package:woofriend/features/auth/domain/domain.dart';

class User {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String ubication;
  final List<String> roles;
  final String token;
  final String firstcontent;
  final String secondcontent;
  final String thirdcontent;
  final String photoUser;

  User( {
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.ubication,
    required this.roles,
    required this.token,
    required this.firstcontent,
    required this.secondcontent,
    required this.thirdcontent,
    required this.photoUser,
   
  });

  bool get isAdmin {
    return roles.contains('admin');
  }
}
