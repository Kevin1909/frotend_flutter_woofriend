class User {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String ubication;
  final List<String> roles;
  final String token;

  User(
      {required this.id,
      required this.email,
      required this.name,
      required this.phone,
      required this.ubication, 
      required this.roles,
      required this.token});

  bool get isAdmin {
    return roles.contains('admin');
  }
}
