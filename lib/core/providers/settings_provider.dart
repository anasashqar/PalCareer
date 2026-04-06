import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localeProvider = StateProvider<Locale>((ref) => const Locale('ar'));
final pushNotificationsProvider = StateProvider<bool>(
  (ref) => false,
); // false by default so user can toggle and see permission
final userNameProvider = StateProvider<String>((ref) => 'مستخدم تجريبي');
