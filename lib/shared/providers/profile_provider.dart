import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../../core/services/firebase_messaging_service.dart';
import '../../core/constants/firestore_keys.dart';
import '../../shared/services/firestore_service.dart';
class ProfileNotifier extends Notifier<UserModel?> {
  @override
  UserModel? build() {
    return null; // By default, no user is loaded
  }

  void setUser(UserModel user) {
    state = user;
    if (user.preferredCategoryIds.isNotEmpty) {
      ref.read(fcmServiceProvider).updateSectorSubscription(user.preferredCategoryIds.first);
    }
  }

  Future<void> updateUserDisplayName(String newName) async {
    final authUser = FirebaseAuth.instance.currentUser;
    if (authUser == null) return;

    // 1. Update Firebase Auth Profile
    await authUser.updateDisplayName(newName);

    // 2. Update Firestore Schema Document correctly
    try {
      await ref.read(firestoreServiceProvider).updateDocument(
        FirestoreKeys.usersContent,
        authUser.uid,
        {'displayName': newName},
      );
    } catch (_) {
      // Document might not be constructed yet
    }

    // 3. Update Local State if loaded
    if (state != null) {
      state = state!.copyWith(displayName: newName);
    }
  }

  void clearUser() {
    state = null;
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, UserModel?>(() {
  return ProfileNotifier();
});
