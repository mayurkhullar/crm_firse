import 'package:flutter/material.dart';

import '../config/app_config.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: false,
    primaryColor: AppConfig.primaryColor,
    scaffoldBackgroundColor: AppConfig.backgroundColor,
    canvasColor: AppConfig.surfaceColor,
    cardColor: AppConfig.cardColor,
    appBarTheme: AppBarTheme(
      backgroundColor: AppConfig.primaryColor,
      foregroundColor: Colors.white,
      elevation: 1,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: AppConfig.primaryColor,
      secondary: AppConfig.accentColor,
      surface: AppConfig.surfaceColor,
      background: AppConfig.backgroundColor,
      error: AppConfig.danger,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppConfig.textMain),
      bodyMedium: TextStyle(color: AppConfig.textMain),
      bodySmall: TextStyle(color: AppConfig.textMuted),
      labelLarge: TextStyle(color: AppConfig.accentColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppConfig.primaryColor,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppConfig.primaryColor.withOpacity(0.15)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppConfig.surfaceColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppConfig.primaryColor, width: 2),
      ),
      filled: true,
      fillColor: AppConfig.surfaceColor,
      labelStyle: TextStyle(color: AppConfig.textMuted),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: AppConfig.backgroundColor,
      titleTextStyle: TextStyle(
        color: AppConfig.primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      contentTextStyle: TextStyle(color: AppConfig.textMain),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    dividerColor: AppConfig.surfaceColor,
    iconTheme: IconThemeData(color: AppConfig.primaryColor),
  );
}
