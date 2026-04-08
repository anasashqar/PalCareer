import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/auth_repository.dart';
import '../../../shared/services/firestore_service.dart';
import '../../../core/constants/firestore_keys.dart';
import '../../../shared/models/user_model.dart';
import 'package:flutter/foundation.dart';

// Represents the state of our authentication
class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final String? error;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    String? error,
    bool clearError = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final FirestoreService _firestoreService;

  AuthNotifier(this._repository, this._firestoreService)
    : super(AuthState(isAuthenticated: _repository.currentUser != null)) {
    _repository.authStateChanges.listen((user) {
      if (mounted) {
        state = state.copyWith(isAuthenticated: user != null);
      }
    });
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.signInWithGoogle();

      final currentUser = _repository.currentUser;
      if (currentUser != null) {
        try {
          final docSnapshot = await _firestoreService.getDocument(
            FirestoreKeys.usersContent,
            currentUser.uid,
          );
          if (!docSnapshot.exists) {
            final userModel = UserModel(
              uid: currentUser.uid,
              displayName: currentUser.displayName ?? 'مستخدم',
              email: currentUser.email ?? '',
              photoUrl: currentUser.photoURL,
            );
            await _firestoreService.addDocument(
              FirestoreKeys.usersContent,
              currentUser.uid,
              userModel.toMap(),
            );
          } else {
            // Update the existing profile to ensure it is not stale
            await _firestoreService.addDocument(
              FirestoreKeys.usersContent,
              currentUser.uid,
              {
                'displayName': currentUser.displayName ?? 'مستخدم',
                if (currentUser.photoURL != null) 'photoUrl': currentUser.photoURL,
              },
            );
          }
        } catch (e) {
          debugPrint('Could not initialize user profile: $e');
        }
        
        state = state.copyWith(isLoading: false, isAuthenticated: true);
      } else {
         // User canceled sign-in
         state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    await _repository.signOut();
    state = state.copyWith(isLoading: false, isAuthenticated: false);
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  return AuthNotifier(
    ref.watch(authRepositoryProvider),
    ref.watch(firestoreServiceProvider),
  );
});
