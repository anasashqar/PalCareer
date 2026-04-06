import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/providers/theme_provider.dart';

import 'package:palcareer/l10n/generated/app_localizations.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/services/remote_config_service.dart';
import 'core/services/remote_config_asset_loader.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:palcareer/firebase_options.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/services/firebase_messaging_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('settings');
  await Hive.openBox<List>('bookmarks');
  await Hive.openBox<bool>('read_notifications');

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize Remote Config for App Strings and Theme
    await RemoteConfigService.init();

    // Initialize FCM Push Notifications
    await FirebaseMessagingService().init();
  } catch (e) {
    debugPrint('Firebase/GoogleSignIn initialization error = $e');
  }

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/i18n',
      assetLoader: const RemoteConfigAssetLoader(),
      fallbackLocale: const Locale('ar'),
      child: const ProviderScope(child: PalCareerApp()),
    ),
  );
}

class PalCareerApp extends ConsumerWidget {
  const PalCareerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeConfig = ref.watch(themeConfigProvider);

    return MaterialApp.router(
      title: 'PalCareer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(themeConfig),
      routerConfig: appRouter,

      // i18n support setup
      localizationsDelegates: [
        ...context.localizationDelegates,
        AppLocalizations.delegate,
      ],
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
