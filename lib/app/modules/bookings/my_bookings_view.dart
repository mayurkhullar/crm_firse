import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../config/app_config.dart';
import '../../models/user_role.dart';
import '../customers/customer_controller.dart';
import '../customers/customer_model.dart';

class MyBookingsView extends StatelessWidget {
  final UserRole role;
  final controller = Get.find<CustomerController>();

  MyBookingsView({super.key, required this.role});

  List<Map<String, dynamic>> _getBookingsWithFallback(
    List<CustomerModel> customers,
  ) {
    final allBookings =
        customers.expand((c) {
          return c.bookings.map(
            (b) => {
              'customer': c,
              'destination': b.destination,
              'fromDate': b.fromDate,
              'toDate': b.toDate,
              'passengers': b.passengers,
              'cost': b.cost,
              'notes': b.notes,
              'id': b.id,
            },
          );
        }).toList();

    // If no bookings, show dummy bookings for design preview
    if (allBookings.isEmpty) {
      return [
        {
          'customer': CustomerModel(
            id: 'dummy-1',
            name: 'Rohit Singh',
            email: 'rohit@gmail.com',
            phone: '9876543211',
            assignedTo: UserRole.salesAgent,
          ),
          'destination': 'Dubai',
          'fromDate': DateTime.now().add(const Duration(days: 7)),
          'toDate': DateTime.now().add(const Duration(days: 14)),
          'passengers': 2,
          'cost': 55000.0,
          'notes': 'Luxury 5D4N Package',
          'id': 'bk-dummy1',
        },
        {
          'customer': CustomerModel(
            id: 'dummy-2',
            name: 'Ankita Mehra',
            email: 'ankita@gmail.com',
            phone: '9123456790',
            assignedTo: UserRole.salesAgent,
          ),
          'destination': 'Singapore',
          'fromDate': DateTime.now().add(const Duration(days: 15)),
          'toDate': DateTime.now().add(const Duration(days: 20)),
          'passengers': 3,
          'cost': 38000.0,
          'notes': 'Budget Group Tour',
          'id': 'bk-dummy2',
        },
      ];
    }

    return allBookings;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final customers = controller.getCustomersForRole(role);
    final bookings = _getBookingsWithFallback(customers);

    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: AppConfig.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 8 : 32,
          vertical: isMobile ? 12 : 28,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child:
                bookings.isEmpty
                    ? Center(
                      child: Text(
                        'No bookings found.',
                        style: TextStyle(
                          color: AppConfig.textMuted,
                          fontSize: 18,
                        ),
                      ),
                    )
                    : ListView.separated(
                      itemCount: bookings.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (_, index) {
                        final item = bookings[index];
                        final customer = item['customer'] as CustomerModel;
                        final from = DateFormat.yMMMd().format(
                          item['fromDate'] as DateTime,
                        );
                        final to = DateFormat.yMMMd().format(
                          item['toDate'] as DateTime,
                        );

                        return Card(
                          color: AppConfig.cardColor,
                          elevation: 4,
                          shadowColor: AppConfig.primaryColor.withOpacity(0.08),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 10 : 22,
                              vertical: isMobile ? 12 : 18,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppConfig.primaryColor
                                      .withOpacity(0.15),
                                  radius: 24,
                                  child: Text(
                                    customer.name.isNotEmpty
                                        ? customer.name[0].toUpperCase()
                                        : '',
                                    style: TextStyle(
                                      color: AppConfig.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${item['destination']} • ${customer.name}',
                                        style: TextStyle(
                                          color: AppConfig.primaryColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: isMobile ? 15 : 18,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '$from → $to',
                                        style: TextStyle(
                                          color: AppConfig.textMuted,
                                          fontSize: isMobile ? 13 : 15,
                                        ),
                                      ),
                                      Text(
                                        '₹${(item['cost'] as double).toStringAsFixed(2)} • ${item['passengers']} Pax',
                                        style: TextStyle(
                                          color: AppConfig.accentColor,
                                          fontSize: isMobile ? 13 : 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if ((item['notes'] as String).isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 2,
                                          ),
                                          child: Text(
                                            item['notes'],
                                            style: TextStyle(
                                              color: AppConfig.textMuted,
                                              fontSize: isMobile ? 12 : 14,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '#${(item['id'] as String).substring(0, 6)}',
                                  style: TextStyle(
                                    color: AppConfig.accentColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: isMobile ? 13 : 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ),
      ),
    );
  }
}
