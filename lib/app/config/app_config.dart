import 'package:flutter/material.dart';

class AppConfig {
  static const companyName = 'K. Holiday Maps';

  // --- Main Colors ---
  static const Color primaryColor = Color(0xFF3D155F); // Deep Plum
  static const Color accentColor = Color(0xFFDF678C); // Vibrant Pink
  static const Color accentBlue = Color(0xFFC9F0FF); // Soft Sky Blue
  static const Color backgroundColor = Color(0xFFEAFFFD); // Mint White
  static const Color surfaceColor = Color(0xFFEFEFF0); // Subtle Grey

  // --- Text Colors ---
  static const Color textMain = Color(0xFF2A223A); // Rich Graphite
  static const Color textMuted = Color(0xFF726A8A); // Muted Lavender-Grey

  // --- Status Colors ---
  static const Color success = Color(0xFF38BFA7); // Teal Success
  static const Color warning = Color(0xFFFFC155); // Amber Warning
  static const Color danger = Color(0xFFEF3B6D); // Punch Pink/Red

  // --- UI Helpers ---
  static const Color cardColor = accentBlue;
  static const Color dividerColor = surfaceColor;

  // You can add more helpers if needed, e.g., for shadows, overlays, etc.
}
