import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/app_config.dart';
import '../../models/user_role.dart';
import 'add_customer_dialog.dart';
import 'customer_controller.dart';
import 'customer_detail_view.dart';

class CustomersView extends StatelessWidget {
  final CustomerController controller = Get.put(CustomerController());
  final UserRole role;

  CustomersView({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final customers = controller.getCustomersForRole(role);

    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        title: const Text('Customers'),
        backgroundColor: AppConfig.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          if (role == UserRole.admin || role == UserRole.manager)
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Add Customer',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AddCustomerDialog(role: role),
                );
              },
            ),
        ],
      ),
      body:
          customers.isEmpty
              ? Center(
                child: Text(
                  'No customers found.',
                  style: TextStyle(color: AppConfig.textMuted, fontSize: 18),
                ),
              )
              : Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 6 : 28,
                  vertical: isMobile ? 12 : 24,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: ListView.separated(
                      itemCount: customers.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (_, index) {
                        final customer = customers[index];
                        return InkWell(
                          onTap: () {
                            Get.to(
                              () => CustomerDetailView(
                                customerId: customer.id,
                                role: role,
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: Card(
                            color: AppConfig.cardColor,
                            elevation: 3,
                            shadowColor: AppConfig.primaryColor.withOpacity(
                              0.06,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 12 : 22,
                                vertical: isMobile ? 14 : 18,
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: AppConfig.accentColor
                                        .withOpacity(0.14),
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
                                  const SizedBox(width: 18),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          customer.name,
                                          style: TextStyle(
                                            color: AppConfig.textMain,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          customer.email,
                                          style: TextStyle(
                                            color: AppConfig.textMuted,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          customer.phone,
                                          style: TextStyle(
                                            color: AppConfig.textMuted,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (!isMobile) ...[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Assigned to',
                                          style: TextStyle(
                                            color: AppConfig.textMuted,
                                            fontSize: 13,
                                          ),
                                        ),
                                        Text(
                                          customer.assignedTo.label,
                                          style: TextStyle(
                                            color: AppConfig.accentColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                  const SizedBox(width: 10),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 20,
                                    color: Color(0xFF726A8A),
                                  ),
                                ],
                              ),
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
