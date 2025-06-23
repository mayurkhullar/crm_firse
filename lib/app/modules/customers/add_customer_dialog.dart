import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../models/user_role.dart';
import 'customer_controller.dart';
import 'customer_model.dart';
import 'destination_model.dart';

class AddCustomerDialog extends StatefulWidget {
  final UserRole role;

  const AddCustomerDialog({super.key, required this.role});

  @override
  State<AddCustomerDialog> createState() => _AddCustomerDialogState();
}

class _AddCustomerDialogState extends State<AddCustomerDialog> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final destinationController = TextEditingController();
  final adultsController = TextEditingController();
  final childrenController = TextEditingController();
  final durationController = TextEditingController();
  final budgetController = TextEditingController();

  final controller = Get.find<CustomerController>();
  String? error;

  bool _emailExists(String email) {
    return controller.customers.any(
      (c) => c.email.toLowerCase() == email.toLowerCase(),
    );
  }

  bool _phoneExists(String phone) {
    return controller.customers.any((c) => c.phone == phone);
  }

  void _submit() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final destination = destinationController.text.trim();
    final adults = int.tryParse(adultsController.text.trim()) ?? 0;
    final children = int.tryParse(childrenController.text.trim()) ?? 0;
    final duration = int.tryParse(durationController.text.trim()) ?? 0;
    final budget = double.tryParse(budgetController.text.trim()) ?? 0;

    if ([name, phone, destination].any((e) => e.isEmpty) || budget <= 0) {
      setState(() => error = 'Name, Destination, and Budget are required.');
      return;
    }

    if (!_isValidPhone(phone)) {
      setState(() => error = 'Phone must be 10–11 digits');
      return;
    }

    if (email.isNotEmpty && !_isValidEmail(email)) {
      setState(() => error = 'Invalid email format');
      return;
    }

    if (_emailExists(email)) {
      setState(() => error = 'Email already exists');
      return;
    }

    if (_phoneExists(phone)) {
      setState(() => error = 'Phone number already exists');
      return;
    }

    final destinationEntry = DestinationModel(
      name: destination,
      adults: adults,
      children: children,
      duration: duration,
      budget: budget,
      quotedPackage: null,
      notes: '',
    );

    final newCustomer = CustomerModel(
      id: const Uuid().v4(),
      name: name,
      email: email,
      phone: phone,
      assignedTo: UserRole.salesAgent,
      destinations: [destinationEntry],
    );

    controller.customers.add(newCustomer);
    Get.back();
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^\d{10,11}$');
    return phoneRegex.hasMatch(phone);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.role != UserRole.admin && widget.role != UserRole.manager) {
      return const SizedBox.shrink();
    }

    return AlertDialog(
      title: const Text('Add Customer'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _input(nameController, 'Full Name *'),
            _input(emailController, 'Email'),
            _input(
              phoneController,
              'Phone Number *',
              inputType: TextInputType.phone,
            ),
            _input(destinationController, 'Destination *'),
            _input(adultsController, 'Adults', inputType: TextInputType.number),
            _input(
              childrenController,
              'Children',
              inputType: TextInputType.number,
            ),
            _input(
              durationController,
              'Duration (days)',
              inputType: TextInputType.number,
            ),
            _input(
              budgetController,
              'Budget (INR) *',
              inputType: TextInputType.number,
            ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text(error!, style: const TextStyle(color: Colors.red)),
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

  Widget _input(
    TextEditingController controller,
    String label, {
    TextInputType? inputType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(labelText: label),
        onChanged: (_) => setState(() => error = null),
      ),
    );
  }
}
