import 'package:woofriend/features/auth/infrastructure/mappers/user_profile_mapper.dart';

import '../../domain/domain.dart';

class UserMapper {
  static User userJsonToEntity(Map<String, dynamic> json) => User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      ubication: json['ubication'],
      password: json['password'],
      roles: List<String>.from(json['roles'].map((role) => role)),
      token: json['token'] ?? '',
      profile: UserProfileMapper.userProfileJsonToEntity(json['profile']));
}
