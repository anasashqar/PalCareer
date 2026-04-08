import 'package:flutter/material.dart';

import 'theme_config.dart';

const String _fontFamily = 'Alexandria';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme(ThemeConfig config) {
    final baseTheme = ThemeData.light();

    final textTheme = baseTheme.textTheme.copyWith(
      displayLarge: TextStyle(fontFamily: _fontFamily, color: config.onSurface, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(fontFamily: _fontFamily, color: config.onSurface, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(fontFamily: _fontFamily, color: config.onSurface, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontFamily: _fontFamily, color: config.onSurface, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(fontFamily: _fontFamily, color: config.onSurface, fontWeight: FontWeight.w600),
      titleSmall: TextStyle(fontFamily: _fontFamily, color: config.onSurface, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontFamily: _fontFamily, color: config.onSurface),
      bodyMedium: TextStyle(fontFamily: _fontFamily, color: config.onSurface),
      bodySmall: TextStyle(fontFamily: _fontFamily, color: config.onSurfaceVariant),
      labelLarge: TextStyle(fontFamily: _fontFamily, color: config.onSurface, fontWeight: FontWeight.w500, letterSpacing: 0.5),
      labelMedium: TextStyle(fontFamily: _fontFamily, color: config.onSurface, fontWeight: FontWeight.w500),
      labelSmall: TextStyle(fontFamily: _fontFamily, color: config.onSurfaceVariant, fontWeight: FontWeight.w500),
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: _fontFamily,
      colorScheme: ColorScheme.light(
        primary: config.primary,
        primaryContainer: config.primaryContainer,
        onPrimary: config.onPrimary,
        secondary: config.secondary,
        secondaryContainer: config.secondaryContainer,
        onSecondary: config.onSecondary,
        tertiary: config.tertiary,
        tertiaryContainer: config.tertiaryContainer,
        surface: config.surface,
        onSurface: config.onSurface,
        error: config.error,
        onError: config.onError,
        outline: config.outline,
        outlineVariant: config.outlineVariant,
      ),
      scaffoldBackgroundColor: config.background,
      textTheme: textTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: config.primary,
          foregroundColor: config.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: config.onSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          side: BorderSide(
            color: config.outlineVariant,
            width: 1,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
    );
  }
}
