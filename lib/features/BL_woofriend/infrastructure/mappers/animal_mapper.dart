import '../../../auth/infrastructure/infrastructure.dart';
import '../../domain/domain.dart';

class AnimalMapper {
  static jsonToEntity(Map<String, dynamic> json) => Animal(
      id: json['id'],
      typeanimal: json['typeanimal'],
      name: json['name'],
      birthdate: json['birthdate'],
      race: json['race'],
      characteristics: json['characteristics'],
      vaccinationrecord: json['vaccinationrecord'] ?? "",
      pathologiesdisabilities: json['pathologiesdisabilities'] ?? "",
      photo: json['photo'] ?? "",
      user: UserMapper.userJsonToEntity(json['user']));
}
