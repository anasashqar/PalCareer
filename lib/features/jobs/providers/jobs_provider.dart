import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../../core/constants/firestore_keys.dart';
import '../../../shared/models/job_model.dart';


final searchQueryProvider = StateProvider<String>((ref) => '');
final contractTypeProvider = StateProvider<String?>((ref) => null);
final workModeProvider = StateProvider<String?>((ref) => null);
final experienceLevelProvider = StateProvider<String?>((ref) => null);
final datePostedProvider = StateProvider<String?>((ref) => null);

class JobsState {
  final List<JobModel> jobs;
  final bool isLoading;
  final bool isFetchingMore;
  final bool hasRechedEnd;
  final DocumentSnapshot? lastDoc;
  final String? error;

  JobsState({
    this.jobs = const [],
    this.isLoading = true,
    this.isFetchingMore = false,
    this.hasRechedEnd = false,
    this.lastDoc,
    this.error,
  });

  JobsState copyWith({
    List<JobModel>? jobs,
    bool? isLoading,
    bool? isFetchingMore,
    bool? hasRechedEnd,
    DocumentSnapshot? lastDoc,
    String? error,
  }) {
    return JobsState(
      jobs: jobs ?? this.jobs,
      isLoading: isLoading ?? this.isLoading,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      hasRechedEnd: hasRechedEnd ?? this.hasRechedEnd,
      lastDoc: lastDoc ?? this.lastDoc,
      error: error, // overwrite error if passed or keep null
    );
  }
}

class JobsNotifier extends Notifier<JobsState> {
  static const int _limit = 10;

  @override
  JobsState build() {
    // Listen to filter state changes so we auto-refresh when they change
    ref.listen(searchQueryProvider, (previous, next) => _refresh());
    ref.listen(contractTypeProvider, (previous, next) => _refresh());
    ref.listen(workModeProvider, (previous, next) => _refresh());
    ref.listen(experienceLevelProvider, (previous, next) => _refresh());
    ref.listen(datePostedProvider, (previous, next) => _refresh());

    Future.microtask(() => fetchJobs());
    return JobsState();
  }

  void _refresh() {
    state = JobsState(); // Reset state completely
    fetchJobs();
  }

  Future<void> fetchJobs({bool fetchMore = false}) async {
    if (state.hasRechedEnd) return;
    if (fetchMore && state.isFetchingMore) return;
    if (!fetchMore && !state.isLoading) {
       // Already fetching initial
       return;
    }

    if (fetchMore) {
      state = state.copyWith(isFetchingMore: true);
    } else {
      state = state.copyWith(isLoading: true);
    }

    try {
      final firestore = FirebaseFirestore.instance;
      Query query = firestore
          .collection(FirestoreKeys.jobsCollection)
          .where('isActive', isEqualTo: true);

      // Apply server-side filters where possible
      final contractFilter = ref.read(contractTypeProvider);
      final experienceFilter = ref.read(experienceLevelProvider);

      if (contractFilter != null) {
        query = query.where('jobType', isEqualTo: contractFilter);
      }
      if (experienceFilter != null) {
        query = query.where('level', isEqualTo: experienceFilter);
      }

      // Order by date descending
      query = query.orderBy('postedAt', descending: true);

      // Apply pagination cursor
      if (fetchMore && state.lastDoc != null) {
        query = query.startAfterDocument(state.lastDoc!);
      }

      query = query.limit(_limit);

      final snapshot = await query.get();

      if (snapshot.docs.isEmpty) {
        state = state.copyWith(
          isFetchingMore: false,
          isLoading: false,
          hasRechedEnd: true,
        );
        return;
      }

      var newJobs = snapshot.docs
          .map((doc) => JobModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      // Client-Side filtering for fields that can't be easily compound-indexed dynamically
      // like textual search or complex date math, but applied ONLY to the fetched chunk:
      final search = ref.read(searchQueryProvider).toLowerCase().trim();
      final workModeFilter = ref.read(workModeProvider);
      final dateFilter = ref.read(datePostedProvider);

      newJobs = newJobs.where((job) {
        bool matchesSearch = true;
        if (search.isNotEmpty) {
          matchesSearch =
              (job.title['ar']?.toLowerCase().contains(search) ?? false) ||
              (job.title['en']?.toLowerCase().contains(search) ?? false) ||
              job.company.toLowerCase().contains(search);
        }

        final matchesWorkMode = workModeFilter == null ||
            (workModeFilter == 'remote' && job.jobType == 'remote') ||
            (workModeFilter == 'on_site' && job.jobType != 'remote');

        bool matchesDate = true;
        if (dateFilter != null) {
          final now = DateTime.now();
          if (dateFilter == 'past_24h') {
            matchesDate = now.difference(job.postedAt).inDays <= 1;
          } else if (dateFilter == 'past_week') {
            matchesDate = now.difference(job.postedAt).inDays <= 7;
          } else if (dateFilter == 'past_month') {
            matchesDate = now.difference(job.postedAt).inDays <= 30;
          }
        }

        return matchesSearch && matchesWorkMode && matchesDate;
      }).toList();

      state = state.copyWith(
        jobs: fetchMore ? [...state.jobs, ...newJobs] : newJobs,
        lastDoc: snapshot.docs.last,
        isLoading: false,
        isFetchingMore: false,
        hasRechedEnd: snapshot.docs.length < _limit,
      );
    } catch (e) {
      debugPrint('Error fetching jobs: $e');
      state = state.copyWith(
        isLoading: false,
        isFetchingMore: false,
        error: e.toString(),
      );
    }
  }

  void refreshManual() {
    _refresh();
  }
}

final jobsProvider = NotifierProvider<JobsNotifier, JobsState>(() {
  return JobsNotifier();
});
