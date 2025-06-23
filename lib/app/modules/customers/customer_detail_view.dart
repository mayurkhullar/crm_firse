import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../config/app_config.dart';
import '../../models/user_role.dart';
import '../bookings/booking_model.dart';
import 'add_edit_destination_dialog.dart';
import 'customer_controller.dart';
import 'customer_model.dart';
import 'destination_model.dart';
import 'update_destination_status_dialog.dart';

class CustomerDetailView extends StatelessWidget {
  final String customerId;
  final UserRole role;

  CustomerDetailView({super.key, required this.customerId, required this.role});

  final List<String> _statusOptions = [
    'New Lead',
    'Contacted',
    'Not Reachable',
    'Packages Shared',
    'Customization',
    'Cancelled',
    'Converted',
  ];

  bool _canUpdateStatus(UserRole role, CustomerModel customer) {
    return role == UserRole.admin ||
        role == UserRole.manager ||
        role == UserRole.teamLeader ||
        (role == UserRole.salesAgent && customer.assignedTo == role);
  }

  List<String> _getAllowedNextStatuses(String current) {
    final i = _statusOptions.indexOf(current);
    if (i == -1 || i == _statusOptions.length - 1) return [];
    // Only next one status allowed (no skipping)
    return [_statusOptions[i + 1]];
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final controller = Get.find<CustomerController>();
    final CustomerModel? customer = controller.getById(customerId);

    if (customer == null) {
      return const Scaffold(body: Center(child: Text('Customer not found.')));
    }

    if (role == UserRole.salesAgent && customer.assignedTo != role) {
      return const Scaffold(body: Center(child: Text('Access Denied')));
    }

    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        title: Text('Customer: ${customer.name}'),
        backgroundColor: AppConfig.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 6 : 28,
          vertical: isMobile ? 12 : 24,
        ),
        child: ListView(
          children: [
            _infoCard(customer, isMobile),
            const SizedBox(height: 24),

            // Destinations Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Destinations',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConfig.textMain,
                  ),
                ),
                if (role == UserRole.admin || role == UserRole.manager)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConfig.accentColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      textStyle: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Destination'),
                    onPressed:
                        () => _showAddDestinationDialog(
                          context,
                          controller,
                          customer,
                        ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            ...customer.destinations.asMap().entries.map(
              (entry) => _destinationCard(
                context,
                controller,
                customer,
                entry.key,
                entry.value,
                isMobile,
              ),
            ),

            const SizedBox(height: 28),
            Text(
              'Bookings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppConfig.textMain,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConfig.primaryColor,
                foregroundColor: Colors.white,
                elevation: 1,
              ),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Booking'),
              onPressed:
                  () => _showAddBookingDialog(context, controller, customer),
            ),
            const SizedBox(height: 8),
            ...customer.bookings.map(
              (b) => Card(
                color: AppConfig.cardColor,
                elevation: 2,
                shadowColor: AppConfig.primaryColor.withOpacity(0.06),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 12 : 20,
                    vertical: isMobile ? 10 : 14,
                  ),
                  title: Text(
                    '${b.destination} (${b.fromDate.toLocal().toString().split(' ')[0]} - ${b.toDate.toLocal().toString().split(' ')[0]})',
                    style: TextStyle(
                      color: AppConfig.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: isMobile ? 15 : 17,
                    ),
                  ),
                  subtitle: Text(
                    '₹${b.cost.toStringAsFixed(2)} • ${b.passengers} Pax\n${b.notes}',
                    style: TextStyle(
                      color: AppConfig.textMuted,
                      fontSize: isMobile ? 13 : 15,
                    ),
                  ),
                  trailing: Text(
                    '#${b.id.substring(0, 6)}',
                    style: TextStyle(
                      color: AppConfig.accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: isMobile ? 13 : 15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(CustomerModel customer, bool isMobile) {
    return Card(
      color: AppConfig.cardColor,
      elevation: 4,
      shadowColor: AppConfig.primaryColor.withOpacity(0.10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 14 : 28,
          vertical: isMobile ? 18 : 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _info('Name', customer.name),
            _info('Email', customer.email),
            _info('Phone', customer.phone),
            _info('Assigned To', customer.assignedTo.label),
          ],
        ),
      ),
    );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppConfig.textMuted,
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: AppConfig.textMain),
            ),
          ),
        ],
      ),
    );
  }

  Widget _destinationCard(
    BuildContext context,
    CustomerController controller,
    CustomerModel customer,
    int index,
    DestinationModel d,
    bool isMobile,
  ) {
    return Card(
      color: AppConfig.surfaceColor,
      elevation: 3,
      shadowColor: AppConfig.primaryColor.withOpacity(0.08),
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 20,
          vertical: isMobile ? 12 : 18,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    d.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppConfig.primaryColor,
                    ),
                  ),
                ),
                if (role == UserRole.admin || role == UserRole.manager)
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    tooltip: 'Edit',
                    color: AppConfig.accentColor,
                    onPressed:
                        () => _showEditDestinationDialog(
                          context,
                          controller,
                          customer,
                          index,
                          d,
                        ),
                  ),
                if (_canUpdateStatus(role, customer))
                  OutlinedButton.icon(
                    icon: const Icon(Icons.check_circle, size: 16),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppConfig.success,
                      side: BorderSide(color: AppConfig.success, width: 1.2),
                      textStyle: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    label: const Text('Update Status'),
                    onPressed: () {
                      final allowedStatuses = _getAllowedNextStatuses(d.status);
                      if (allowedStatuses.isEmpty) {
                        showDialog(
                          context: context,
                          builder:
                              (_) => AlertDialog(
                                title: const Text('No Further Status'),
                                content: const Text(
                                  'No further statuses allowed.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                        );
                        return;
                      }
                      showDialog(
                        context: context,
                        builder:
                            (_) => UpdateDestinationStatusDialog(
                              currentStatus: d.status,
                              allowedNextStatuses: allowedStatuses,
                              onSave: (newStatus, note) {
                                d.status = newStatus;
                                d.history.add(
                                  DestinationStatusHistory(
                                    status: newStatus,
                                    note: note,
                                    updatedBy: role.label,
                                    date: DateTime.now(),
                                  ),
                                );
                                controller.customers.refresh();
                              },
                            ),
                      );
                    },
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _destinationInfoChip(
                  'Pax: ${d.adults}A, ${d.children}C',
                  AppConfig.textMuted,
                ),
                const SizedBox(width: 8),
                _destinationInfoChip(
                  'Duration: ${d.duration} days',
                  AppConfig.accentColor,
                ),
                const SizedBox(width: 8),
                _destinationInfoChip(
                  'Budget: ₹${d.budget.toStringAsFixed(2)}',
                  AppConfig.primaryColor,
                ),
              ],
            ),
            if (d.quotedPackage != null && d.quotedPackage!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Quoted Package: ${d.quotedPackage}',
                  style: TextStyle(
                    color: AppConfig.accentColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            if (d.notes.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  'Notes: ${d.notes}',
                  style: TextStyle(color: AppConfig.textMain),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Row(
                children: [
                  Text(
                    'Status: ',
                    style: TextStyle(
                      color: AppConfig.textMuted,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  _statusBadge(d.status),
                ],
              ),
            ),
            const SizedBox(height: 8),
            if (d.history.isNotEmpty) ...[
              const Text(
                'Status History:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              ...d.history.map(
                (h) => Padding(
                  padding: const EdgeInsets.only(left: 6.0, top: 2, bottom: 2),
                  child: Text(
                    '${h.status} (${h.updatedBy}) • ${h.date.toLocal().toString().split(".")[0]}\nNote: ${h.note}',
                    style: TextStyle(fontSize: 13, color: AppConfig.textMuted),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _destinationInfoChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 13)),
    );
  }

  Widget _statusBadge(String status) {
    Color color;
    switch (status) {
      case 'New Lead':
        color = AppConfig.primaryColor;
        break;
      case 'Contacted':
        color = AppConfig.accentColor;
        break;
      case 'Not Reachable':
        color = AppConfig.warning;
        break;
      case 'Packages Shared':
        color = AppConfig.accentBlue;
        break;
      case 'Customization':
        color = AppConfig.success;
        break;
      case 'Cancelled':
        color = AppConfig.danger;
        break;
      case 'Converted':
        color = AppConfig.success;
        break;
      default:
        color = AppConfig.textMain;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  void _showAddDestinationDialog(
    BuildContext context,
    CustomerController controller,
    CustomerModel customer,
  ) {
    showDialog(
      context: context,
      builder:
          (_) => AddEditDestinationDialog(
            onSave: (destination) {
              customer.destinations.add(destination);
              controller.customers.refresh();
            },
          ),
    );
  }

  void _showEditDestinationDialog(
    BuildContext context,
    CustomerController controller,
    CustomerModel customer,
    int index,
    DestinationModel existing,
  ) {
    showDialog(
      context: context,
      builder:
          (_) => AddEditDestinationDialog(
            existing: existing,
            onSave: (destination) {
              customer.destinations[index] = destination;
              controller.customers.refresh();
            },
          ),
    );
  }

  void _showAddBookingDialog(
    BuildContext context,
    CustomerController controller,
    CustomerModel customer,
  ) {
    final destinationController = TextEditingController();
    final costController = TextEditingController();
    final notesController = TextEditingController();
    final paxController = TextEditingController();
    DateTime? fromDate;
    DateTime? toDate;
    String? error;

    showDialog(
      context: context,
      builder:
          (_) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: const Text('Add Booking'),
                  content: SingleChildScrollView(
                    child: Column(
                      children: [
                        _input(destinationController, 'Destination'),
                        _input(
                          costController,
                          'Total Cost (INR)',
                          inputType: TextInputType.number,
                        ),
                        _input(
                          paxController,
                          'No. of Passengers',
                          inputType: TextInputType.number,
                        ),
                        _input(notesController, 'Notes'),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2023),
                                    lastDate: DateTime(2030),
                                  );
                                  if (picked != null) {
                                    setState(() => fromDate = picked);
                                  }
                                },
                                child: Text(
                                  fromDate == null
                                      ? 'From Date'
                                      : 'From: ${fromDate!.toLocal()}'.split(
                                        ' ',
                                      )[0],
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextButton(
                                onPressed: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now().add(
                                      const Duration(days: 1),
                                    ),
                                    firstDate: DateTime(2023),
                                    lastDate: DateTime(2030),
                                  );
                                  if (picked != null) {
                                    setState(() => toDate = picked);
                                  }
                                },
                                child: Text(
                                  toDate == null
                                      ? 'To Date'
                                      : 'To: ${toDate!.toLocal()}'.split(
                                        ' ',
                                      )[0],
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (error != null)
                          Text(
                            error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final dest = destinationController.text.trim();
                        final notes = notesController.text.trim();
                        final cost =
                            double.tryParse(costController.text.trim()) ?? 0;
                        final pax =
                            int.tryParse(paxController.text.trim()) ?? 0;

                        if (dest.isEmpty ||
                            fromDate == null ||
                            toDate == null ||
                            cost <= 0 ||
                            pax <= 0) {
                          setState(() => error = 'All fields are required.');
                          return;
                        }

                        final booking = BookingModel(
                          id: const Uuid().v4(),
                          destination: dest,
                          fromDate: fromDate!,
                          toDate: toDate!,
                          cost: cost,
                          passengers: pax,
                          notes: notes,
                        );

                        customer.bookings.add(booking);
                        controller.customers.refresh();
                        Get.back();
                      },
                      child: const Text('Add Booking'),
                    ),
                  ],
                ),
          ),
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
      ),
    );
  }
}
