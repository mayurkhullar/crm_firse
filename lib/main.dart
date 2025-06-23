import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/config/app_config.dart';
import 'app/routes/app_pages.dart';
import 'app/themes/app_theme.dart';

void main() {
  runApp(const TravelCRMApp());
}

class TravelCRMApp extends StatelessWidget {
  const TravelCRMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConfig.companyName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, // Uses your custom theme (see below)
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      // You can set default transition, locale, etc. here if needed
    );
  }
}
