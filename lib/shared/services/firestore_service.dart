import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addDocument(
    String collectionPath,
    String documentId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.collection(collectionPath).doc(documentId).set(data);
    } on FirebaseException catch (e) {
      debugPrint('Firestore Error [addDocument]: ${e.message}');
      throw _handleFirebaseException(e);
    } catch (e) {
      debugPrint('Unknown Error [addDocument]: $e');
      throw Exception('حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.');
    }
  }

  Future<void> updateDocument(
    String collectionPath,
    String documentId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.collection(collectionPath).doc(documentId).update(data);
    } on FirebaseException catch (e) {
      debugPrint('Firestore Error [updateDocument]: ${e.message}');
      throw _handleFirebaseException(e);
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.');
    }
  }

  Future<DocumentSnapshot> getDocument(
    String collectionPath,
    String documentId,
  ) async {
    try {
      return await _firestore.collection(collectionPath).doc(documentId).get();
    } on FirebaseException catch (e) {
      debugPrint('Firestore Error [getDocument]: ${e.message}');
      throw _handleFirebaseException(e);
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع أثناء جلب البيانات.');
    }
  }

  Stream<QuerySnapshot> getCollectionStream(String collectionPath) {
    return _firestore.collection(collectionPath).snapshots();
  }

  Exception _handleFirebaseException(FirebaseException error) {
    // Translate common Firestore errors to Arabic
    switch (error.code) {
      case 'permission-denied':
        return Exception('ليس لديك صلاحية للوصول إلى هذه البيانات.');
      case 'unavailable':
        return Exception(
          'الخدمة غير متوفرة حالياً، ربما بسبب انقطاع الإنترنت.',
        );
      case 'not-found':
        return Exception('المستند المطلوب غير موجود في قاعدة البيانات.');
      default:
        return Exception(error.message ?? 'حدث خطأ في قاعدة البيانات.');
    }
  }
}
