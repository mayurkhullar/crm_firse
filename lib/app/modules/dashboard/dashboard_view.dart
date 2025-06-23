import 'package:flutter/material.dart';

import '../../config/app_config.dart';
import '../../models/user_role.dart';

class DashboardView extends StatelessWidget {
  final UserRole role;

  const DashboardView({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      // appBar: AppBar(
      //   title: Text('${AppConfig.companyName} - Dashboard'),
      //   backgroundColor: AppConfig.primaryColor,
      //   foregroundColor: Colors.white,
      //   elevation: 0.5,
      // ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final cardWidth =
              constraints.maxWidth > 900
                  ? 300.0
                  : constraints.maxWidth > 600
                  ? 240.0
                  : double.infinity;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 8 : 32,
              vertical: isMobile ? 16 : 32,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Wrap(
                  spacing: 24,
                  runSpacing: 24,
                  alignment: WrapAlignment.start,
                  children: [
                    _dashboardCard('Total Bookings', '52', cardWidth),
                    _dashboardCard('Total Customers', '38', cardWidth),
                    _dashboardCard('Total Sale Amount', '₹192,000', cardWidth),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _dashboardCard(String title, String value, double width) {
    return Card(
      color: AppConfig.cardColor,
      elevation: 5,
      shadowColor: AppConfig.primaryColor.withOpacity(0.10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Container(
        width: width,
        height: 110,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: AppConfig.textMuted,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                color: AppConfig.primaryColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
