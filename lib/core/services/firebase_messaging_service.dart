import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_router/go_router.dart';
import '../router/app_router.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling a background message: ${message.messageId}');
}

final fcmServiceProvider = Provider((ref) => FirebaseMessagingService());

class FirebaseMessagingService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('FCM Authorization: ${settings.authorizationStatus}');

    String? token = await _fcm.getToken();
    debugPrint('📱 MY TOKEN IS: $token');

    // Handle tapping on notification when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessageTap(message);
    });

    // Handle notification when app is terminated
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      // Delay navigation slightly to let the router and root widget mount
      Future.delayed(const Duration(milliseconds: 1500), () {
        _handleMessageTap(initialMessage);
      });
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Foreground Message: ${message.notification?.title}');
    });
  }

  void _handleMessageTap(RemoteMessage message) {
    debugPrint('Message clicked! Data: ${message.data}');
    final String? jobId = message.data['jobId'] ?? message.data['id'];
    
    if (jobId != null && jobId.isNotEmpty) {
      final context = rootNavigatorKey.currentContext;
      if (context != null) {
        context.push('/job-details?id=$jobId');
      }
    }
  }

  /// Ensures user is subscribed ONLY to their relevant sector topic
  Future<void> updateSectorSubscription(String sectorId) async {
    if (sectorId.isEmpty) return;

    final box = Hive.box('settings');
    final String? currentSubscription = box.get('current_fcm_sector');

    // Sanitize topic name (no spaces/special chars) first!
    final safeTopic = sectorId.replaceAll(RegExp(r'[^a-zA-Z0-9-_.~%]+'), '_');

    // Unsubscribe from old topic if it changed
    if (currentSubscription != null && currentSubscription != safeTopic) {
      try {
        await _fcm.unsubscribeFromTopic('sector_$currentSubscription');
        debugPrint('FCM Unsubscribed from: sector_$currentSubscription');
      } catch (e) {
        debugPrint('FCM Unsubscribe error: $e');
      }
    }

    // Subscribe to new topic
    if (currentSubscription != safeTopic) {
      try {
        await _fcm.subscribeToTopic('sector_$safeTopic');
        await box.put('current_fcm_sector', safeTopic);
        debugPrint('FCM Subscribed to: sector_$safeTopic');
      } catch (e) {
        debugPrint('FCM Subscribe error: $e');
      }
    }
  }
}
