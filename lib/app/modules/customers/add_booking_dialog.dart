import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../bookings/booking_model.dart';
import 'customer_controller.dart';
import 'customer_model.dart';

class AddBookingDialog extends StatefulWidget {
  final CustomerModel customer;

  const AddBookingDialog({super.key, required this.customer});

  @override
  State<AddBookingDialog> createState() => _AddBookingDialogState();
}

class _AddBookingDialogState extends State<AddBookingDialog> {
  final _formKey = GlobalKey<FormState>();
  final _destinationController = TextEditingController();
  final _notesController = TextEditingController();
  final _passengersController = TextEditingController();
  final _costController = TextEditingController();

  DateTime? _fromDate;
  DateTime? _toDate;

  void _pickDate(bool isFrom) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 2)),
    );

    if (picked != null) {
      setState(() {
        if (isFrom) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true ||
        _fromDate == null ||
        _toDate == null)
      return;

    final booking = BookingModel(
      id: const Uuid().v4(),
      destination: _destinationController.text.trim(),
      fromDate: _fromDate!,
      toDate: _toDate!,
      passengers: int.parse(_passengersController.text.trim()),
      cost: double.parse(_costController.text.trim()),
      notes: _notesController.text.trim(),
    );

    final controller = Get.find<CustomerController>();
    controller.addBooking(widget.customer.id, booking);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Booking'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _destinationController,
                decoration: const InputDecoration(labelText: 'Destination'),
                validator:
                    (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Required'
                            : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        _fromDate == null
                            ? 'From Date'
                            : DateFormat.yMMMd().format(_fromDate!),
                      ),
                      onPressed: () => _pickDate(true),
                    ),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        _toDate == null
                            ? 'To Date'
                            : DateFormat.yMMMd().format(_toDate!),
                      ),
                      onPressed: () => _pickDate(false),
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _passengersController,
                decoration: const InputDecoration(
                  labelText: 'No. of Passengers',
                ),
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Required'
                            : null,
              ),
              TextFormField(
                controller: _costController,
                decoration: const InputDecoration(
                  labelText: 'Estimated Cost (₹)',
                ),
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Required'
                            : null,
              ),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (optional)',
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _submit, child: const Text('Save')),
      ],
    );
  }
}
