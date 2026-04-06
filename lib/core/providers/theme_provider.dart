import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palcareer/core/theme/theme_config.dart';

final themeConfigProvider = Provider<ThemeConfig>((ref) {
  // Read parsed ThemeConfig from Remote Config Service
  return ThemeConfig.fromRemoteConfig();
});
