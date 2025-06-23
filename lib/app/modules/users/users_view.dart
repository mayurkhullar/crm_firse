import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/user_role.dart';
import 'add_user_dialog.dart';
import 'user_controller.dart';

class UsersView extends StatelessWidget {
  final UserController controller = Get.put(UserController());
  final UserRole role;

  UsersView({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    // Hide this view from Sales Agents
    if (role == UserRole.salesAgent) {
      return const Scaffold(body: Center(child: Text('Access Denied')));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          if (role == UserRole.admin || role == UserRole.manager)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed:
                  () => showDialog(
                    context: context,
                    builder: (_) => AddUserDialog(role: role),
                  ),
            ),
        ],
      ),
      body: Obx(() {
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.users.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (_, index) {
            final user = controller.users[index];
            return ListTile(
              title: Text(user.name),
              subtitle: Text('${user.email} • ${user.phone}'),
              trailing: Text(user.role.label),
              onTap:
                  (role == UserRole.admin || role == UserRole.manager)
                      ? () => showDialog(
                        context: context,
                        builder:
                            (_) =>
                                AddUserDialog(role: role, existingUser: user),
                      )
                      : null,
              onLongPress:
                  (role == UserRole.admin || role == UserRole.manager)
                      ? () => _confirmDelete(context, user.id)
                      : null,
            );
          },
        );
      }),
    );
  }

  void _confirmDelete(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text('Are you sure you want to delete this user?'),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.deleteUser(userId);
                  Get.back();
                },
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}
