import 'package:flutter/material.dart';

import 'destination_model.dart';

class AddEditDestinationDialog extends StatefulWidget {
  final DestinationModel? existing;
  final void Function(DestinationModel destination) onSave;

  const AddEditDestinationDialog({
    super.key,
    this.existing,
    required this.onSave,
  });

  @override
  State<AddEditDestinationDialog> createState() =>
      _AddEditDestinationDialogState();
}

class _AddEditDestinationDialogState extends State<AddEditDestinationDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController adultsController;
  late TextEditingController childrenController;
  late TextEditingController durationController;
  late TextEditingController budgetController;
  late TextEditingController packageController;
  late TextEditingController notesController;
  late String status;

  final List<String> statusOptions = [
    'New Lead',
    'Contacted',
    'Not Reachable',
    'Packages Shared',
    'Customization',
    'Cancelled',
    'Converted',
  ];

  @override
  void initState() {
    super.initState();
    final d = widget.existing;
    nameController = TextEditingController(text: d?.name ?? '');
    adultsController = TextEditingController(text: d?.adults.toString() ?? '');
    childrenController = TextEditingController(
      text: d?.children.toString() ?? '',
    );
    durationController = TextEditingController(
      text: d?.duration.toString() ?? '',
    );
    budgetController = TextEditingController(text: d?.budget.toString() ?? '');
    packageController = TextEditingController(text: d?.quotedPackage ?? '');
    notesController = TextEditingController(text: d?.notes ?? '');
    status = d?.status ?? 'New Lead';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.existing == null ? 'Add Destination' : 'Edit Destination',
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _field(nameController, 'Destination Name'),
              Row(
                children: [
                  Expanded(
                    child: _field(
                      adultsController,
                      'Adults',
                      inputType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _field(
                      childrenController,
                      'Children',
                      inputType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              _field(
                durationController,
                'Duration (days)',
                inputType: TextInputType.number,
              ),
              _field(
                budgetController,
                'Budget (INR)',
                inputType: TextInputType.number,
              ),
              _field(packageController, 'Quoted Package (optional)'),
              _field(notesController, 'Notes'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: status,
                decoration: const InputDecoration(labelText: 'Status'),
                items:
                    statusOptions
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                onChanged:
                    (v) => setState(() => status = v ?? statusOptions.first),
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
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() != true) return;
            final dest = DestinationModel(
              name: nameController.text.trim(),
              adults: int.tryParse(adultsController.text) ?? 0,
              children: int.tryParse(childrenController.text) ?? 0,
              duration: int.tryParse(durationController.text) ?? 0,
              budget: double.tryParse(budgetController.text) ?? 0,
              quotedPackage: packageController.text.trim(),
              notes: notesController.text.trim(),
              status: status,
            );
            widget.onSave(dest);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  Widget _field(
    TextEditingController c,
    String label, {
    TextInputType? inputType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: c,
        decoration: InputDecoration(labelText: label),
        keyboardType: inputType,
        validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
      ),
    );
  }
}
