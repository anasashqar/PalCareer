import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../constants/firestore_keys.dart';
import '../constants/mock_jobs.dart';

class FirebaseSeeder {
  static Future<void> seedJobs() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final jobs = MockJobs.defaultJobs;
      final batch = firestore.batch();

      for (final job in jobs) {
        final docRef = firestore
            .collection(FirestoreKeys.jobsCollection)
            .doc(job.id);
        batch.set(docRef, job.toMap());
      }

      await batch.commit();
      debugPrint('Successfully seeded ${jobs.length} jobs to Firestore.');
    } catch (e) {
      debugPrint('Error seeding jobs: $e');
      rethrow;
    }
  }
}
