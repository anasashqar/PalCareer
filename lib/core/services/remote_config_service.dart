import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class RemoteConfigService {
  static final _remoteConfig = FirebaseRemoteConfig.instance;

  static Future<void> init() async {
    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: kDebugMode
              ? const Duration(minutes: 5)
              : const Duration(hours: 12),
        ),
      );

      // Load defaults from local assets as fallback
      final themeConfigString = await rootBundle.loadString(
        'assets/config/theme_config.json',
      );
      final enStrings = await rootBundle.loadString('assets/i18n/en.json');
      final arStrings = await rootBundle.loadString('assets/i18n/ar.json');

      await _remoteConfig.setDefaults({
        'theme_config': themeConfigString,
        'i18n_en': enStrings,
        'i18n_ar': arStrings,
      });

      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      debugPrint('Failed to initialize Remote Config: $e');
    }
  }

  static Map<String, dynamic> getThemeConfig() {
    final val = _remoteConfig.getString('theme_config');
    try {
      return jsonDecode(val) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  static Map<String, dynamic> getI18nStrings(String languageCode) {
    final val = _remoteConfig.getString('i18n_$languageCode');
    try {
      return jsonDecode(val) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }
}
