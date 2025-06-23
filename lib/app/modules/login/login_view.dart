import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/user_role.dart';
import '../../widgets/main_layout.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  UserRole? selectedRole;

  void _handleLogin() {
    if (selectedRole == null) {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('Select Role'),
              content: const Text('Please choose a role before proceeding.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
      return;
    }

    // Navigate to the main layout with sidebar and role-based access
    Get.off(() => MainLayout(role: selectedRole!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          elevation: 6,
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Login (Mock)',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<UserRole>(
                  value: selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'Select Role',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      UserRole.values.map((role) {
                        return DropdownMenuItem(
                          value: role,
                          child: Text(role.label),
                        );
                      }).toList(),
                  onChanged: (role) {
                    setState(() => selectedRole = role);
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _handleLogin,
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
