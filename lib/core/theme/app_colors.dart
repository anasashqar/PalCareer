import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // The Civic Curator Design System Colors
  static const Color primary = Color(0xFF004655); // Deep Sea
  static const Color primaryContainer = Color(0xFF005F73); 
  static const Color onPrimary = Colors.white;

  static const Color secondary = Color(0xFF0E7C7B); // Teal Horizon 
  // secondary in Stitch data originally had #006a69, but overriden to #0E7C7B
  static const Color secondaryContainer = Color(0xFF98F2F0);
  static const Color onSecondary = Colors.white;

  static const Color tertiary = Color(0xFFD4AF37); // Gold override
  static const Color tertiaryContainer = Color(0xFFCCA830);
  static const Color tertiaryFixed = Color(0xFFFFE088);

  static const Color background = Color(0xFFF8F9FA);
  static const Color onBackground = Color(0xFF191C1D);

  static const Color surface = Color(0xFFF8F9FA);
  static const Color surfaceContainerLow = Color(0xFFF3F4F5);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceBright = Color(0xFFF8F9FA); // Usually same as surface but for overlays
  static const Color onSurface = Color(0xFF191C1D);
  static const Color onSurfaceVariant = Color(0xFF3F484C);

  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onError = Colors.white;

  static const Color outline = Color(0xFF6F797C);
  static const Color outlineVariant = Color(0xFFBFC8CC);
}
