import '../../models/user_role.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
  });
}
