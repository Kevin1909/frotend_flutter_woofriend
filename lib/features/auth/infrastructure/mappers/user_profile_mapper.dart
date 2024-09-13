import '../../domain/domain.dart';

class UserProfileMapper {
  static UserProfile userProfileJsonToEntity(Map<String, dynamic> json) =>
      UserProfile(
        firstcontent: json['firstcontent'] ?? "",
        secondcontent: json['secondcontent'] ?? "",
        thirdcontent: json['thirdcontent'] ?? "",
        photoUser: json['photo'] ?? "",
      );
}
