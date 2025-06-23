import 'package:flutter/material.dart';

import '../models/user_role.dart';
import '../modules/bookings/my_bookings_view.dart';
import '../modules/customers/customers_view.dart';
import '../modules/dashboard/dashboard_view.dart';
import '../modules/reports/reports_view.dart';
import '../modules/users/users_view.dart';

class MainLayout extends StatefulWidget {
  final UserRole role;

  const MainLayout({super.key, required this.role});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<String> _titles = [
    'Dashboard',
    'Customers',
    'Bookings',
    'Reports',
    'Manage Users',
  ];

  final Color primaryDark = const Color(0xFF3D155F);
  final Color accentPink = const Color(0xFFDF678C);
  final Color softWhite = const Color(0xFFEAFFFD);
  final Color lightBlue = const Color(0xFFC9F0FF);
  final Color backgroundGray = const Color(0xFFEFEFF0);

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardView(role: widget.role),
      CustomersView(role: widget.role),
      MyBookingsView(role: widget.role),
      ReportsView(role: widget.role),
      UsersView(role: widget.role), // Pass role to UsersView
    ];

    final visibleScreens = List<Widget>.from(screens);
    final visibleTitles = List<String>.from(_titles);

    // Only admin can see Manage Users
    if (widget.role != UserRole.admin) {
      visibleScreens.removeLast();
      visibleTitles.removeLast();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(visibleTitles[_selectedIndex]),
        backgroundColor: primaryDark,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        backgroundColor: backgroundGray,
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: primaryDark),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.account_circle,
                    size: 50,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.role.label,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
            ...List.generate(visibleTitles.length, (index) {
              final isSelected = index == _selectedIndex;
              return ListTile(
                leading: Icon(
                  _getIconForIndex(index),
                  color: isSelected ? accentPink : Colors.black87,
                ),
                title: Text(
                  visibleTitles[index],
                  style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? accentPink : Colors.black87,
                  ),
                ),
                tileColor:
                    isSelected
                        ? lightBlue.withAlpha((255 * 0.4).round())
                        : null,
                onTap: () {
                  setState(() => _selectedIndex = index);
                  Navigator.pop(context); // close drawer
                },
              );
            }),
          ],
        ),
      ),
      body: Container(color: softWhite, child: visibleScreens[_selectedIndex]),
    );
  }

  IconData _getIconForIndex(int i) {
    switch (i) {
      case 0:
        return Icons.dashboard;
      case 1:
        return Icons.people;
      case 2:
        return Icons.book_online;
      case 3:
        return Icons.bar_chart;
      case 4:
        return Icons.admin_panel_settings;
      default:
        return Icons.circle;
    }
  }
}
