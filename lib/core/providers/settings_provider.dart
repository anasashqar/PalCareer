import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocaleNotifier extends StateNotifier<Locale> {
  final Box _box = Hive.box('settings');

  LocaleNotifier() : super(const Locale('ar')) {
    final savedCode = _box.get('languageCode');
    if (savedCode != null) {
      state = Locale(savedCode);
    }
  }

  void setLocale(Locale locale) {
    state = locale;
    _box.put('languageCode', locale.languageCode);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) => LocaleNotifier());

class PushNotificationsNotifier extends StateNotifier<bool> {
  final Box _box = Hive.box('settings');

  PushNotificationsNotifier() : super(false) {
    final saved = _box.get('pushEnabled');
    if (saved != null) {
      state = saved;
    }
  }

  void setEnabled(bool enabled) {
    state = enabled;
    _box.put('pushEnabled', enabled);
  }
}

final pushNotificationsProvider = StateNotifierProvider<PushNotificationsNotifier, bool>((ref) => PushNotificationsNotifier());

final userNameProvider = StateProvider<String>((ref) => 'مستخدم تجريبي');
