import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:palcareer/core/services/remote_config_service.dart';

class RemoteConfigAssetLoader extends AssetLoader {
  const RemoteConfigAssetLoader();

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    // Return the translations fetched and cached by Firebase Remote Config
    return RemoteConfigService.getI18nStrings(locale.languageCode);
  }
}
