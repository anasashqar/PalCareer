import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/firestore_keys.dart';
import '../../../shared/models/job_model.dart';
import 'bookmarks_provider.dart';

final bookmarkedJobsProvider = FutureProvider<List<JobModel>>((ref) async {
  final savedJobIds = ref.watch(bookmarksProvider).toList();

  if (savedJobIds.isEmpty) {
    return [];
  }

  // Firebase 'whereIn' filter is limited to 10 items.
  // We chunk the list into smaller sub-lists of <= 10 items.
  final List<List<String>> chunks = [];
  for (var i = 0; i < savedJobIds.length; i += 10) {
    chunks.add(
      savedJobIds.sublist(
        i,
        i + 10 > savedJobIds.length ? savedJobIds.length : i + 10,
      ),
    );
  }

  final firestore = FirebaseFirestore.instance;
  final List<Future<QuerySnapshot<Map<String, dynamic>>>> futures = [];

  for (final chunk in chunks) {
    futures.add(
      firestore
          .collection(FirestoreKeys.jobsCollection)
          .where(FieldPath.documentId, whereIn: chunk)
          .get(),
    );
  }

  final snapshots = await Future.wait(futures);
  
  final List<JobModel> results = [];
  for (final snapshot in snapshots) {
    for (final doc in snapshot.docs) {
      if (doc.exists) {
        results.add(JobModel.fromMap(doc.data(), doc.id));
      }
    }
  }

  // Sort bookmarks by most recent posted date, or sort by id order
  results.sort((a, b) => b.postedAt.compareTo(a.postedAt));
  
  return results;
});
