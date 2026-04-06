import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling a background message: ${message.messageId}");
}

final fcmServiceProvider = Provider((ref) => FirebaseMessagingService());

class FirebaseMessagingService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  String? _currentSectorSubscription;

  Future<void> init() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('FCM Authorization: ${settings.authorizationStatus}');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Foreground Message: ${message.notification?.title}');
    });
  }

  /// Ensures user is subscribed ONLY to their relevant sector topic
  Future<void> updateSectorSubscription(String sectorId) async {
    if (sectorId.isEmpty) return;

    // Unsubscribe from old topic if it changed
    if (_currentSectorSubscription != null && _currentSectorSubscription != sectorId) {
      try {
        await _fcm.unsubscribeFromTopic('sector_$_currentSectorSubscription');
      } catch (e) {
        debugPrint('FCM Unsubscribe error: $e');
      }
    }

    // Subscribe to new topic
    if (_currentSectorSubscription != sectorId) {
      try {
        // Sanitize topic name (no spaces/special chars)
        final safeTopic = sectorId.replaceAll(RegExp(r'[^a-zA-Z0-9-_.~%]+'), '_');
        await _fcm.subscribeToTopic('sector_$safeTopic');
        _currentSectorSubscription = sectorId;
        debugPrint('FCM Subscribed to: sector_$safeTopic');
      } catch (e) {
        debugPrint('FCM Subscribe error: $e');
      }
    }
  }
}
