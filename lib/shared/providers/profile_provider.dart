import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../../core/services/firebase_messaging_service.dart';

class ProfileNotifier extends Notifier<UserModel?> {
  @override
  UserModel? build() {
    return null; // By default, no user is loaded
  }

  void setUser(UserModel user) {
    state = user;
    if (user.preferredCategoryIds.isNotEmpty) {
      FirebaseMessagingService().updateSectorSubscription(user.preferredCategoryIds.first);
    }
  }

  void clearUser() {
    state = null;
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, UserModel?>(() {
  return ProfileNotifier();
});
