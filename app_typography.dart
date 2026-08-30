import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Large, readable type scale — students read this on small phone screens
/// after long study hours, so we bias sizes up and keep line-height generous.
class AppTypography {
  AppTypography._();

  static TextTheme textTheme(Color primaryText, Color secondaryText) {
    final base = GoogleFonts.plusJakartaSansTextTheme();
    return base
        .copyWith(
          displaySmall: base.displaySmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: primaryText,
            height: 1.2,
          ),
          headlineSmall: base.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: primaryText,
            height: 1.25,
          ),
          titleLarge: base.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: primaryText,
          ),
          titleMedium: base.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: primaryText,
          ),
          bodyLarge: base.bodyLarge?.copyWith(
            fontSize: 16,
            color: primaryText,
            height: 1.45,
          ),
          bodyMedium: base.bodyMedium?.copyWith(
            fontSize: 14.5,
            color: secondaryText,
            height: 1.45,
          ),
          labelLarge: base.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: primaryText,
          ),
        )
        .apply(
          bodyColor: primaryText,
          displayColor: primaryText,
        );
  }

  static final lightTextTheme =
      textTheme(AppColors.lightTextPrimary, AppColors.lightTextSecondary);
  static final darkTextTheme =
      textTheme(AppColors.darkTextPrimary, AppColors.darkTextSecondary);
}
