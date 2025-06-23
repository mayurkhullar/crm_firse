import 'package:flutter/material.dart';

class UpdateDestinationStatusDialog extends StatefulWidget {
  final String currentStatus;
  final List<String> allowedNextStatuses;
  final void Function(String newStatus, String note) onSave;

  const UpdateDestinationStatusDialog({
    super.key,
    required this.currentStatus,
    required this.allowedNextStatuses,
    required this.onSave,
  });

  @override
  State<UpdateDestinationStatusDialog> createState() =>
      _UpdateDestinationStatusDialogState();
}

class _UpdateDestinationStatusDialogState
    extends State<UpdateDestinationStatusDialog> {
  String? selectedStatus;
  final TextEditingController noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    selectedStatus =
        widget.allowedNextStatuses.isNotEmpty
            ? widget.allowedNextStatuses.first
            : null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Status'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: selectedStatus,
              decoration: const InputDecoration(labelText: 'New Status'),
              items:
                  widget.allowedNextStatuses
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
              onChanged: (v) => setState(() => selectedStatus = v),
              validator: (v) => v == null ? 'Select status' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: noteController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Note *'),
              validator:
                  (v) =>
                      v == null || v.trim().isEmpty ? 'Note is required' : null,
            ),
          ],
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
            widget.onSave(selectedStatus!, noteController.text.trim());
            Navigator.of(context).pop();
          },
          child: const Text('Update'),
        ),
      ],
    );
  }
}
