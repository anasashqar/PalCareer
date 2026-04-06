import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../jobs/providers/jobs_provider.dart';
import '../../onboarding/providers/onboarding_provider.dart';
import '../../../shared/models/notification_model.dart';

class ReadNotificationsNotifier extends StateNotifier<Set<String>> {
  final Box<bool> _box;

  ReadNotificationsNotifier(this._box) : super({}) {
    // Load existing read IDs
    final keys = _box.keys.whereType<String>().toSet();
    state = keys;
  }

  void markAsRead(String jobId) {
    if (!state.contains(jobId)) {
      _box.put(jobId, true);
      state = {...state, jobId};
    }
  }

  void markAllAsRead(List<String> jobIds) {
    bool changed = false;
    final newState = {...state};
    for (var id in jobIds) {
      if (!newState.contains(id)) {
        _box.put(id, true);
        newState.add(id);
        changed = true;
      }
    }
    if (changed) {
      state = newState;
    }
  }
}

final readNotificationsProvider = StateNotifierProvider<ReadNotificationsNotifier, Set<String>>((ref) {
  final box = Hive.box<bool>('read_notifications');
  return ReadNotificationsNotifier(box);
});

final notificationsProvider = Provider<List<NotificationModel>>((ref) {
  final jobsState = ref.watch(jobsProvider);
  final obState = ref.watch(onboardingProvider);
  final readIds = ref.watch(readNotificationsProvider);
  
  if (!jobsState.hasValue || jobsState.value == null) return [];
  
  // Flatten job groups to get unique jobs
  final allJobs = jobsState.value!.expand((group) => group.jobs).toSet().toList();
  final sectorId = obState.selectedSector;
  
  // Filter jobs by matching category
  final matchedJobs = sectorId != null && sectorId.isNotEmpty
      ? allJobs.where((job) => job.categoryId == sectorId).toList()
      : allJobs.take(10).toList(); // Fallback if no sector
      
  // Sort descending by postedAt
  matchedJobs.sort((a, b) => b.postedAt.compareTo(a.postedAt));

  return matchedJobs.map((job) => NotificationModel(
    job: job,
    isUnread: !readIds.contains(job.id),
  )).toList();
});
