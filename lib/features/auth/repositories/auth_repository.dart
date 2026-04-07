import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

abstract class AuthRepository {
  Future<UserCredential?> signInWithGoogle();
  Future<void> signOut();
  Stream<User?> get authStateChanges;
  User? get currentUser;
}

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthRepository(this._firebaseAuth, this._googleSignIn);

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // Use Firebase Auth native web popup instead of google_sign_in package
        final googleProvider = GoogleAuthProvider();
        return await _firebaseAuth.signInWithPopup(googleProvider);
      }

      // Prompt user to select Google Account (For Android/iOS)
      final GoogleSignInAccount googleUser = await _googleSignIn
          .authenticate();

      // Obtain the identity details (idToken)
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Request authorization to get the accessToken
      final authResult = await googleUser.authorizationClient.authorizeScopes([
        'email',
        'profile',
      ]);

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: authResult.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential
      return await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      if (e.toString().contains('تم إلغاء')) {
        rethrow;
      }
      throw Exception(
        'حدث خطأ أثناء الاتصال بجوجل. تأكد من اتصالك بالإنترنت ($e)',
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      try {
        await _googleSignIn.signOut();
      } catch (_) {
        // Ignore Google Sign In errors, we just want to clear Firebase Auth
      }

      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('فشل تسجيل الخروج. حاول مرة أخرى.');
    }
  }

  Exception _handleAuthException(FirebaseAuthException error) {
    switch (error.code) {
      case 'network-request-failed':
        return Exception('لا يوجد اتصال بالإنترنت. يرجى التحقق من الشبكة.');
      case 'user-disabled':
        return Exception('تم حظر هذا الحساب من قبل الإدارة.');
      case 'invalid-credential':
        return Exception('بيانات الاعتماد غير صالحة أو منتهية.');
      default:
        return Exception('حدث خطأ في المصادقة: ${error.message}');
    }
  }
}

// Global Provider for the Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository(FirebaseAuth.instance, GoogleSignIn.instance);
});
