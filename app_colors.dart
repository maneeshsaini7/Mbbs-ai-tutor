import 'package:flutter/material.dart';

/// Original palette for MBBS AI Tutor: a calm clinical teal as the primary
/// (distinct from typical ed-tech blues/purples), warm amber for streaks and
/// highlights, and a soft coral for "weak topic" signals — deliberately not
/// matching any existing study app's branding.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF0E7C7B); // clinical teal
  static const Color primaryDark = Color(0xFF0A5D5C);
  static const Color primaryLight = Color(0xFFE6F4F3);

  static const Color accentAmber = Color(0xFFE8A33D); // streaks / highlights
  static const Color accentCoral = Color(0xFFE2665A); // weak topics / alerts
  static const Color accentLavender = Color(0xFF7C6FE0); // AI tutor accent

  // Light theme surfaces
  static const Color lightBackground = Color(0xFFF7F9F9);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE3E8E7);
  static const Color lightTextPrimary = Color(0xFF16211F);
  static const Color lightTextSecondary = Color(0xFF5B6B69);

  // Dark theme surfaces
  static const Color darkBackground = Color(0xFF0F1614);
  static const Color darkSurface = Color(0xFF16201E);
  static const Color darkBorder = Color(0xFF283432);
  static const Color darkTextPrimary = Color(0xFFEAF2F1);
  static const Color darkTextSecondary = Color(0xFF9DB0AD);

  static const Color success = Color(0xFF3FA66A);
}
