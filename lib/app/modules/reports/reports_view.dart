import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../models/user_role.dart';
import '../bookings/booking_model.dart';
import '../customers/customer_controller.dart';
import '../customers/customer_model.dart';
import '../customers/destination_model.dart';

class ReportsView extends StatefulWidget {
  final UserRole role;

  const ReportsView({super.key, required this.role});

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView> {
  final CustomerController customerController = Get.find<CustomerController>();

  // Filter state
  String? selectedUser;
  String? selectedDestination;
  String? selectedStatus;
  String selectedPeriod = 'Month';
  DateTime? startDate;
  DateTime? endDate;

  List<String> get allUsers {
    return customerController.customers
        .map((c) => c.assignedTo.label)
        .toSet()
        .toList();
  }

  List<String> get allDestinations {
    return customerController.customers
        .expand((c) => c.destinations)
        .map((d) => d.name)
        .toSet()
        .toList();
  }

  List<String> get allStatuses => [
    'New Lead',
    'Contacted',
    'Not Reachable',
    'Packages Shared',
    'Customization',
    'Cancelled',
    'Converted',
  ];

  List<BookingModel> get filteredBookings {
    // Admin/Manager: see all, others: see their assigned
    final List<CustomerModel> customers =
        (widget.role == UserRole.admin || widget.role == UserRole.manager)
            ? customerController.customers
            : customerController.customers
                .where((c) => c.assignedTo == widget.role)
                .toList();

    var bookings = customers.expand((c) => c.bookings).toList();

    // Apply filters
    if (selectedUser != null && selectedUser!.isNotEmpty) {
      bookings =
          bookings
              .where(
                (b) =>
                    customers
                        .firstWhere((c) => c.bookings.contains(b))
                        .assignedTo
                        .label ==
                    selectedUser,
              )
              .toList();
    }
    if (selectedDestination != null && selectedDestination!.isNotEmpty) {
      bookings =
          bookings.where((b) => b.destination == selectedDestination).toList();
    }
    if (startDate != null) {
      bookings = bookings.where((b) => b.fromDate.isAfter(startDate!)).toList();
    }
    if (endDate != null) {
      bookings = bookings.where((b) => b.toDate.isBefore(endDate!)).toList();
    }
    // No booking status in BookingModel, status filter applies to destinations
    return bookings;
  }

  List<DestinationModel> get filteredDestinations {
    final List<CustomerModel> customers =
        (widget.role == UserRole.admin || widget.role == UserRole.manager)
            ? customerController.customers
            : customerController.customers
                .where((c) => c.assignedTo == widget.role)
                .toList();
    var dests = customers.expand((c) => c.destinations).toList();
    if (selectedDestination != null && selectedDestination!.isNotEmpty) {
      dests = dests.where((d) => d.name == selectedDestination).toList();
    }
    if (selectedStatus != null && selectedStatus!.isNotEmpty) {
      dests = dests.where((d) => d.status == selectedStatus).toList();
    }
    return dests;
  }

  int get totalCustomers =>
      (widget.role == UserRole.admin || widget.role == UserRole.manager)
          ? customerController.customers.length
          : customerController.customers
              .where((c) => c.assignedTo == widget.role)
              .length;

  int get totalBookings => filteredBookings.length;

  double get totalSales =>
      filteredBookings.fold(0, (sum, b) => sum + (b.cost.isNaN ? 0 : b.cost));

  List<MapEntry<String, int>> get topDestinations {
    final destCounts = <String, int>{};
    for (var b in filteredBookings) {
      destCounts[b.destination] = (destCounts[b.destination] ?? 0) + 1;
    }
    var entries = destCounts.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports & Analytics')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _filters(context),
            const SizedBox(height: 24),
            Wrap(
              spacing: 24,
              runSpacing: 24,
              children: [
                _metricCard('Total Customers', totalCustomers.toString()),
                _metricCard('Total Bookings', totalBookings.toString()),
                _metricCard(
                  'Total Sales (INR)',
                  '₹${totalSales.toStringAsFixed(2)}',
                ),
                _topDestinationsCard(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _filters(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Wrap(
          spacing: 16,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // User filter (admin/manager only)
            if (widget.role == UserRole.admin ||
                widget.role == UserRole.manager)
              DropdownButton<String>(
                value: selectedUser,
                hint: const Text('Filter by User'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('All')),
                  ...allUsers.map(
                    (u) => DropdownMenuItem(value: u, child: Text(u)),
                  ),
                ],
                onChanged: (v) => setState(() => selectedUser = v),
              ),
            // Destination filter
            DropdownButton<String>(
              value: selectedDestination,
              hint: const Text('Filter by Destination'),
              items: [
                const DropdownMenuItem(value: null, child: Text('All')),
                ...allDestinations.map(
                  (d) => DropdownMenuItem(value: d, child: Text(d)),
                ),
              ],
              onChanged: (v) => setState(() => selectedDestination = v),
            ),
            // Status filter
            DropdownButton<String>(
              value: selectedStatus,
              hint: const Text('Filter by Status'),
              items: [
                const DropdownMenuItem(value: null, child: Text('All')),
                ...allStatuses.map(
                  (s) => DropdownMenuItem(value: s, child: Text(s)),
                ),
              ],
              onChanged: (v) => setState(() => selectedStatus = v),
            ),
            // Period (Day/Month/Year)
            DropdownButton<String>(
              value: selectedPeriod,
              items:
                  ['Day', 'Month', 'Year']
                      .map(
                        (p) => DropdownMenuItem(value: p, child: Text('By $p')),
                      )
                      .toList(),
              onChanged: (v) => setState(() => selectedPeriod = v!),
            ),
            // Start Date
            _datePickerButton(
              label: 'Start Date',
              date: startDate,
              onPick: (picked) => setState(() => startDate = picked),
            ),
            // End Date
            _datePickerButton(
              label: 'End Date',
              date: endDate,
              onPick: (picked) => setState(() => endDate = picked),
            ),
            // Clear
            TextButton.icon(
              icon: const Icon(Icons.clear),
              label: const Text('Clear Filters'),
              onPressed: () {
                setState(() {
                  selectedUser = null;
                  selectedDestination = null;
                  selectedStatus = null;
                  startDate = null;
                  endDate = null;
                  selectedPeriod = 'Month';
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _datePickerButton({
    required String label,
    DateTime? date,
    required void Function(DateTime picked) onPick,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
      onPressed: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) onPick(picked);
      },
      child: Text(
        date == null ? label : '$label: ${DateFormat.yMMMd().format(date)}',
      ),
    );
  }

  Widget _metricCard(String title, String value) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 220,
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topDestinationsCard() {
    if (topDestinations.isEmpty) {
      return _metricCard('Top Destinations', 'No Data');
    }
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 240,
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top Destinations',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            ),
            const SizedBox(height: 7),
            ...topDestinations.map(
              (e) => Text(
                '${e.key}: ${e.value} bookings',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
