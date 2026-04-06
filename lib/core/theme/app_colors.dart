import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // The Civic Curator Design System Colors
  static Color primary = const Color(0xFF004655); // Deep Sea
  static Color primaryContainer = const Color(0xFF005F73);
  static Color onPrimary = Colors.white;

  static Color secondary = const Color(0xFF0E7C7B); // Teal Horizon
  // secondary in Stitch data originally had #006a69, but overriden to #0E7C7B
  static Color secondaryContainer = const Color(0xFF98F2F0);
  static Color onSecondary = Colors.white;

  static Color tertiary = const Color(0xFFD4AF37); // Gold override
  static Color tertiaryContainer = const Color(0xFFCCA830);
  static Color tertiaryFixed = const Color(0xFFFFE088);

  static Color background = const Color(0xFFEFF5F6); // Very light Deep Sea tint
  static Color onBackground = const Color(0xFF001F25); // Deep Teal text

  static Color surface = const Color(0xFFEFF5F6);
  static Color surfaceContainerLow = const Color(
    0xFFE3EFF1,
  ); // Slightly darker for pills/containers
  static Color surfaceContainerLowest = const Color(
    0xFFFFFFFF,
  ); // Keep white for cards
  static Color surfaceBright = const Color(0xFFEFF5F6);
  static Color onSurface = const Color(0xFF001F25);
  static Color onSurfaceVariant = const Color(0xFF3A4B4F);

  static Color error = const Color(0xFFBA1A1A);
  static Color errorContainer = const Color(0xFFFFDAD6);
  static Color onError = Colors.white;

  static Color outline = const Color(0xFF6F797C);
  static Color outlineVariant = const Color(0xFFBFC8CC);
}
