import 'package:flutter/material.dart';

/// Global color palette for CineShelf application.
///
/// Defines a consistent dark theme with golden/amber accents
/// emphasizing a cinematic, premium aesthetic.
abstract class CineColors {
  // Golds & Ambers
  static const Color amber = Color(0xFFFFB000);

  // Backgrounds
  static const Color bgDark = Color(0xFF0D0B0A);

  // Text
  static const Color textSecondary = Color(0xFFB7A59A);
  static const Color textMuted = Color(0x73FFFFFF);
  static const Color textLight = Color(0xFFD6D1CD);
  static const Color textHint = Color(0x99FFFFFF);

  // Other
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
}

/// Consistent spacing scale used throughout the application.
///
/// Provides a harmonic spacing system for layout consistency.
abstract class CineSpacing {
  static const double sm = 10.0;
  static const double md = 12.0;
  static const double lg = 14.0;
  static const double xl = 18.0;
  static const double xxl = 24.0;
  static const double xxxl = 30.0;
}

/// Border radius constants for consistent rounded corners.
abstract class CineRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 18.0;
  static const double xl = 22.0;
}

/// Standardized component dimensions.
abstract class CineSizes {
  static const double buttonHeight = 56.0;
  static const double iconSize = 24.0;
  static const double iconSizeSmall = 18.0;
}

/// Predefined typography styles for consistent text rendering.
///
/// Aligns with Material Design principles while maintaining brand identity.
abstract class CineTypography {
  static const TextStyle headline1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: CineColors.amber,
    height: 1.05,
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: CineColors.amber,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    color: CineColors.white,
  );
}

/// Builds the application's Material theme configuration.
///
/// Configures:
/// - Material 3 design system
/// - Dark mode with custom background
/// - Typography using CineTypography styles
/// - Icon theme with amber accent
///
/// Returns ThemeData configured for MaterialApp.
ThemeData buildCineTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: CineColors.bgDark,
    textTheme: const TextTheme(
      displayLarge: CineTypography.headline1,
      displayMedium: CineTypography.headline2,
      bodyMedium: CineTypography.bodyMedium,
    ),
    iconTheme: const IconThemeData(color: CineColors.amber),
  );
}
