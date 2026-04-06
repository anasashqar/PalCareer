import 'package:flutter/material.dart';
import 'package:palcareer/core/services/remote_config_service.dart';

class ThemeConfig {
  final Color primary;
  final Color primaryContainer;
  final Color onPrimary;
  final Color secondary;
  final Color secondaryContainer;
  final Color onSecondary;
  final Color tertiary;
  final Color tertiaryContainer;
  final Color tertiaryFixed;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color surfaceContainerLow;
  final Color surfaceContainerLowest;
  final Color surfaceBright;
  final Color onSurface;
  final Color onSurfaceVariant;
  final Color error;
  final Color errorContainer;
  final Color onError;
  final Color outline;
  final Color outlineVariant;

  ThemeConfig({
    required this.primary,
    required this.primaryContainer,
    required this.onPrimary,
    required this.secondary,
    required this.secondaryContainer,
    required this.onSecondary,
    required this.tertiary,
    required this.tertiaryContainer,
    required this.tertiaryFixed,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.surfaceContainerLow,
    required this.surfaceContainerLowest,
    required this.surfaceBright,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.error,
    required this.errorContainer,
    required this.onError,
    required this.outline,
    required this.outlineVariant,
  });

  factory ThemeConfig.fromJson(Map<String, dynamic> json) {
    Color parseColor(String key, Color fallback) {
      if (json[key] == null) return fallback;
      final hexCode = json[key].toString().replaceAll('#', '');
      if (hexCode.length == 6) {
        return Color(int.parse('FF$hexCode', radix: 16));
      }
      if (hexCode.length == 8) {
        return Color(int.parse(hexCode, radix: 16));
      }
      return fallback;
    }

    // Default Civic Curator Design System Colors for fallback
    return ThemeConfig(
      primary: parseColor('primary', const Color(0xFF004655)),
      primaryContainer: parseColor('primaryContainer', const Color(0xFF005F73)),
      onPrimary: parseColor('onPrimary', Colors.white),
      secondary: parseColor('secondary', const Color(0xFF0E7C7B)),
      secondaryContainer: parseColor(
        'secondaryContainer',
        const Color(0xFF98F2F0),
      ),
      onSecondary: parseColor('onSecondary', Colors.white),
      tertiary: parseColor('tertiary', const Color(0xFFD4AF37)),
      tertiaryContainer: parseColor(
        'tertiaryContainer',
        const Color(0xFFCCA830),
      ),
      tertiaryFixed: parseColor('tertiaryFixed', const Color(0xFFFFE088)),
      background: parseColor('background', const Color(0xFFEFF5F6)),
      onBackground: parseColor('onBackground', const Color(0xFF001F25)),
      surface: parseColor('surface', const Color(0xFFEFF5F6)),
      surfaceContainerLow: parseColor(
        'surfaceContainerLow',
        const Color(0xFFE3EFF1),
      ),
      surfaceContainerLowest: parseColor(
        'surfaceContainerLowest',
        const Color(0xFFFFFFFF),
      ),
      surfaceBright: parseColor('surfaceBright', const Color(0xFFEFF5F6)),
      onSurface: parseColor('onSurface', const Color(0xFF001F25)),
      onSurfaceVariant: parseColor('onSurfaceVariant', const Color(0xFF3A4B4F)),
      error: parseColor('error', const Color(0xFFBA1A1A)),
      errorContainer: parseColor('errorContainer', const Color(0xFFFFDAD6)),
      onError: parseColor('onError', Colors.white),
      outline: parseColor('outline', const Color(0xFF6F797C)),
      outlineVariant: parseColor('outlineVariant', const Color(0xFFBFC8CC)),
    );
  }

  factory ThemeConfig.fromRemoteConfig() {
    return ThemeConfig.fromJson(RemoteConfigService.getThemeConfig());
  }
}
