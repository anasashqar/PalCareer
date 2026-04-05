import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class AuthRepository {
  Future<void> signInWithGoogle();
  Future<void> signOut();
  Stream<bool> get authStateChanges;
}

class MockAuthRepository implements AuthRepository {
  // Simulate delay
  @override
  Future<void> signInWithGoogle() async {
    await Future.delayed(const Duration(seconds: 2));
    // Simulate successful login
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Stream<bool> get authStateChanges => Stream.value(false); // Default to not authenticated for UI demo
}

// Global Provider for the Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return MockAuthRepository(); 
});
