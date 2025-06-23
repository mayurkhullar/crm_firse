import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../models/user_role.dart';
import 'user_controller.dart';
import 'user_model.dart';

class AddUserDialog extends StatefulWidget {
  final UserRole role;
  final UserModel? existingUser;

  const AddUserDialog({super.key, required this.role, this.existingUser});

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  UserRole? selectedRole;

  final controller = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    if (widget.existingUser != null) {
      nameController.text = widget.existingUser!.name;
      emailController.text = widget.existingUser!.email;
      phoneController.text = widget.existingUser!.phone;
      selectedRole = widget.existingUser!.role;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existingUser != null ? 'Edit User' : 'Add User'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<UserRole>(
              value: selectedRole,
              decoration: const InputDecoration(labelText: 'Role'),
              items:
                  UserRole.values.map((r) {
                    return DropdownMenuItem(value: r, child: Text(r.label));
                  }).toList(),
              onChanged: (val) => setState(() => selectedRole = val),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        ElevatedButton(onPressed: _submit, child: const Text('Save')),
      ],
    );
  }

  void _submit() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        selectedRole == null) {
      Get.dialog(
        const AlertDialog(
          title: Text('Incomplete'),
          content: Text('Please fill all fields.'),
        ),
      );
      return;
    }

    final user = UserModel(
      id: widget.existingUser?.id ?? const Uuid().v4(),
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      role: selectedRole!,
    );

    if (widget.existingUser != null) {
      controller.updateUser(user);
    } else {
      controller.addUser(user);
    }

    Get.back(); // Close dialog
  }
}
