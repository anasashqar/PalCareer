import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'theme_config.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme(ThemeConfig config) {
    final baseTheme = ThemeData.light();

    // The Display Voice
    final headlineTheme = GoogleFonts.manropeTextTheme(baseTheme.textTheme)
        .copyWith(
          displayLarge: GoogleFonts.manrope(
            color: config.onSurface,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: GoogleFonts.manrope(
            color: config.onSurface,
            fontWeight: FontWeight.bold,
          ),
          displaySmall: GoogleFonts.manrope(
            color: config.onSurface,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: GoogleFonts.manrope(
            color: config.onSurface,
            fontWeight: FontWeight.w600,
          ),
          titleMedium: GoogleFonts.manrope(
            color: config.onSurface,
            fontWeight: FontWeight.w600,
          ),
          titleSmall: GoogleFonts.manrope(
            color: config.onSurface,
            fontWeight: FontWeight.w600,
          ),
        );

    // The Utility Voice
    final bodyTheme = GoogleFonts.interTextTheme(headlineTheme).copyWith(
      bodyLarge: GoogleFonts.inter(color: config.onSurface),
      bodyMedium: GoogleFonts.inter(color: config.onSurface),
      bodySmall: GoogleFonts.inter(color: config.onSurfaceVariant),
      labelLarge: GoogleFonts.inter(
        color: config.onSurface,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
      labelMedium: GoogleFonts.inter(
        color: config.onSurface,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: GoogleFonts.inter(
        color: config.onSurfaceVariant,
        fontWeight: FontWeight.w500,
      ),
    );

    return ThemeData(
      useMaterial3: true,
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
      textTheme: bodyTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: config.primary,
          foregroundColor: config.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0), // xl rounded corners
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: bodyTheme.labelLarge?.copyWith(
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
          ), // "Ghost Border"
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
    );
  }
}
