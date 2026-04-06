import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final baseTheme = ThemeData.light();

    // The Display Voice
    final headlineTheme = GoogleFonts.manropeTextTheme(baseTheme.textTheme)
        .copyWith(
          displayLarge: GoogleFonts.manrope(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: GoogleFonts.manrope(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
          ),
          displaySmall: GoogleFonts.manrope(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: GoogleFonts.manrope(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
          titleMedium: GoogleFonts.manrope(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
          titleSmall: GoogleFonts.manrope(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        );

    // The Utility Voice
    final bodyTheme = GoogleFonts.interTextTheme(headlineTheme).copyWith(
      bodyLarge: GoogleFonts.inter(color: AppColors.onSurface),
      bodyMedium: GoogleFonts.inter(color: AppColors.onSurface),
      bodySmall: GoogleFonts.inter(color: AppColors.onSurfaceVariant),
      labelLarge: GoogleFonts.inter(
        color: AppColors.onSurface,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
      labelMedium: GoogleFonts.inter(
        color: AppColors.onSurface,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: GoogleFonts.inter(
        color: AppColors.onSurfaceVariant,
        fontWeight: FontWeight.w500,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryContainer,
        onPrimary: AppColors.onPrimary,
        secondary: AppColors.secondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondary: AppColors.onSecondary,
        tertiary: AppColors.tertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        error: AppColors.error,
        onError: AppColors.onError,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: bodyTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
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
          foregroundColor: AppColors.onSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          side: const BorderSide(
            color: AppColors.outlineVariant,
            width: 1,
          ), // "Ghost Border"
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
    );
  }
}
