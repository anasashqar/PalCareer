import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/firestore_keys.dart';
import '../../../shared/models/job_model.dart';
import '../../../shared/models/notification_model.dart';
import '../../../shared/providers/profile_provider.dart';

enum FetchPhase { subCategory, category }

class NotificationsState {
  final List<NotificationModel> notifications;
  final bool isLoading;
  final bool isFetchingMore;
  final bool hasReachedEnd;
  final DocumentSnapshot? lastSubCategoryDoc;
  final DocumentSnapshot? lastCategoryDoc;
  final FetchPhase phase;
  final String? error;

  NotificationsState({
    this.notifications = const [],
    this.isLoading = false,
    this.isFetchingMore = false,
    this.hasReachedEnd = false,
    this.lastSubCategoryDoc,
    this.lastCategoryDoc,
    this.phase = FetchPhase.subCategory,
    this.error,
  });

  NotificationsState copyWith({
    List<NotificationModel>? notifications,
    bool? isLoading,
    bool? isFetchingMore,
    bool? hasReachedEnd,
    DocumentSnapshot? lastSubCategoryDoc,
    DocumentSnapshot? lastCategoryDoc,
    FetchPhase? phase,
    String? error,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      lastSubCategoryDoc: lastSubCategoryDoc ?? this.lastSubCategoryDoc,
      lastCategoryDoc: lastCategoryDoc ?? this.lastCategoryDoc,
      phase: phase ?? this.phase,
      error: error,
    );
  }
}

class NotificationsNotifier extends Notifier<NotificationsState> {
  static const int _limit = 15;

  @override
  NotificationsState build() {
    ref.listen(profileProvider, (previous, next) {
      if (previous != next && next != null) {
        fetchInitial();
      }
    });
    Future.microtask(() => fetchInitial());
    return NotificationsState(isLoading: true);
  }

  Future<void> fetchInitial() async {
    state = NotificationsState(isLoading: true);
    await _fetchNotifications(fetchMore: false);
  }

  Future<void> fetchMore() async {
    if (state.hasReachedEnd || state.isLoading || state.isFetchingMore) return;
    await _fetchNotifications(fetchMore: true);
  }

  Future<void> _fetchNotifications({required bool fetchMore}) async {
    if (fetchMore) {
      state = state.copyWith(isFetchingMore: true);
    }

    try {
      final user = ref.read(profileProvider);
      if (user == null || (user.preferredCategoryIds.isEmpty && user.preferredSubCategoryIds.isEmpty)) {
        state = state.copyWith(isLoading: false, isFetchingMore: false, hasReachedEnd: true);
        return;
      }

      final firestore = FirebaseFirestore.instance;
      List<JobModel> newJobs = [];
      int amountNeeded = _limit;
      FetchPhase currentPhase = state.phase;
      DocumentSnapshot? currentSubCatDoc = state.lastSubCategoryDoc;
      DocumentSnapshot? currentCatDoc = state.lastCategoryDoc;

      // 1. Fetch from subcategories if we are still in that phase
      if (currentPhase == FetchPhase.subCategory && user.preferredSubCategoryIds.isNotEmpty) {
        final chunks = user.preferredSubCategoryIds.take(10).toList();
        Query q = firestore.collection(FirestoreKeys.jobsCollection)
            .where('isActive', isEqualTo: true)
            .where('subCategoryId', whereIn: chunks)
            .orderBy('postedAt', descending: true)
            .limit(amountNeeded);

        if (fetchMore && currentSubCatDoc != null) {
          q = q.startAfterDocument(currentSubCatDoc);
        }

        final snap = await q.get();
        newJobs.addAll(snap.docs.map((d) => JobModel.fromMap(d.data() as Map<String, dynamic>, d.id)));
        
        if (snap.docs.isNotEmpty) {
          currentSubCatDoc = snap.docs.last;
        }

        amountNeeded -= snap.docs.length;

        if (snap.docs.length < _limit) {
          // Exhausted subcategories, transition to categories
          currentPhase = FetchPhase.category;
        }
      } else if (currentPhase == FetchPhase.subCategory && user.preferredSubCategoryIds.isEmpty) {
        currentPhase = FetchPhase.category;
      }

      // 2. Fetch from categories to fill the gap if needed
      if (amountNeeded > 0 && currentPhase == FetchPhase.category && user.preferredCategoryIds.isNotEmpty) {
        final chunks = user.preferredCategoryIds.take(10).toList();
        Query q = firestore.collection(FirestoreKeys.jobsCollection)
            .where('isActive', isEqualTo: true)
            .where('categoryId', whereIn: chunks)
            .orderBy('postedAt', descending: true)
            .limit(amountNeeded);

        if (currentCatDoc != null) {
          q = q.startAfterDocument(currentCatDoc);
        }

        final snap = await q.get();
        final catJobs = snap.docs.map((d) => JobModel.fromMap(d.data() as Map<String, dynamic>, d.id)).toList();
        
        // Exclude duplicates that might have already been fetched from subCategories
        final existingIds = (fetchMore ? state.notifications.map((n) => n.job.id).toSet() : <String>{});
        existingIds.addAll(newJobs.map((j) => j.id));
        
        for (var job in catJobs) {
          if (!existingIds.contains(job.id)) {
            newJobs.add(job);
          }
        }

        if (snap.docs.isNotEmpty) {
          currentCatDoc = snap.docs.last;
        } else {
           amountNeeded -= 1; // force reached end logic
        }
      }

      // 3. Map to NotificationModel
      final box = Hive.box<bool>('read_notifications');
      final newNotifications = newJobs.map((job) {
        return NotificationModel(
          job: job,
          isUnread: !box.containsKey(job.id),
        );
      }).toList();

      final allNotifications = fetchMore ? [...state.notifications, ...newNotifications] : newNotifications;

      state = state.copyWith(
        notifications: allNotifications,
        hasReachedEnd: newJobs.isEmpty || (amountNeeded > 0 && currentPhase == FetchPhase.category),
        lastSubCategoryDoc: currentSubCatDoc,
        lastCategoryDoc: currentCatDoc,
        phase: currentPhase,
        isLoading: false,
        isFetchingMore: false,
      );

    } catch (e) {
      debugPrint('Notifications Error: $e');
      state = state.copyWith(isLoading: false, isFetchingMore: false, error: e.toString());
    }
  }

  void markAsRead(String jobId) {
    final box = Hive.box<bool>('read_notifications');
    if (!box.containsKey(jobId)) {
      box.put(jobId, true);
      state = state.copyWith(
        notifications: state.notifications.map((n) {
          if (n.job.id == jobId) {
            return n.copyWith(isUnread: false);
          }
          return n;
        }).toList()
      );
    }
  }

  void markAllAsRead() {
    final box = Hive.box<bool>('read_notifications');
    final Map<String, bool> updates = {};
    for (var n in state.notifications) {
      if (n.isUnread) {
        updates[n.job.id] = true;
      }
    }
    box.putAll(updates);
    state = state.copyWith(
      notifications: state.notifications.map((n) => n.copyWith(isUnread: false)).toList()
    );
  }
}

final notificationsProvider = NotifierProvider<NotificationsNotifier, NotificationsState>(() {
  return NotificationsNotifier();
});
