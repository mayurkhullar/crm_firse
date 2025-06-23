import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../models/user_role.dart';
import 'user_model.dart';

class UserController extends GetxController {
  final users = <UserModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Dummy users
    users.assignAll([
      UserModel(
        id: const Uuid().v4(),
        name: 'Amit Sharma',
        email: 'amit@travelcrm.com',
        phone: '9876543210',
        role: UserRole.admin,
      ),
      UserModel(
        id: const Uuid().v4(),
        name: 'Priya Verma',
        email: 'priya@travelcrm.com',
        phone: '9123456789',
        role: UserRole.salesAgent,
      ),
    ]);
  }

  void addUser(UserModel user) {
    users.add(user);
  }

  void updateUser(UserModel updatedUser) {
    final index = users.indexWhere((u) => u.id == updatedUser.id);
    if (index != -1) {
      users[index] = updatedUser;
    }
  }

  void deleteUser(String id) {
    users.removeWhere((u) => u.id == id);
  }
}
