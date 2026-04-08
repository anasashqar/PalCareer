import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../../core/constants/firestore_keys.dart';
import '../../../shared/models/job_model.dart';
import '../../../shared/providers/profile_provider.dart';
import 'dart:async';

final searchQueryProvider = StateProvider<String>((ref) => '');
final contractTypeProvider = StateProvider<String?>((ref) => null);
final workModeProvider = StateProvider<String?>((ref) => null);
final experienceLevelProvider = StateProvider<String?>((ref) => null);
final datePostedProvider = StateProvider<String?>((ref) => null);

class JobsState {
  final List<JobModel> bestMatches;
  final List<JobModel> goodMatches;
  final List<JobModel> otherJobs;
  final bool isLoading;
  final bool isFetchingMore;
  final bool hasRechedEnd;
  final DocumentSnapshot? lastDoc;
  final String? error;

  JobsState({
    this.bestMatches = const [],
    this.goodMatches = const [],
    this.otherJobs = const [],
    this.isLoading = true,
    this.isFetchingMore = false,
    this.hasRechedEnd = false,
    this.lastDoc,
    this.error,
  });

  bool get isEmpty => bestMatches.isEmpty && goodMatches.isEmpty && otherJobs.isEmpty;
  List<JobModel> get jobs => [...bestMatches, ...goodMatches, ...otherJobs];

  JobsState copyWith({
    List<JobModel>? bestMatches,
    List<JobModel>? goodMatches,
    List<JobModel>? otherJobs,
    bool? isLoading,
    bool? isFetchingMore,
    bool? hasRechedEnd,
    DocumentSnapshot? lastDoc,
    String? error,
  }) {
    return JobsState(
      bestMatches: bestMatches ?? this.bestMatches,
      goodMatches: goodMatches ?? this.goodMatches,
      otherJobs: otherJobs ?? this.otherJobs,
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
  Timer? _debounceTimer;

  @override
  JobsState build() {
    // Listen to filter state changes so we auto-refresh when they change
    ref.listen(searchQueryProvider, (previous, next) => _refresh());
    ref.listen(contractTypeProvider, (previous, next) => _refresh());
    ref.listen(workModeProvider, (previous, next) => _refresh());
    ref.listen(experienceLevelProvider, (previous, next) => _refresh());
    ref.listen(datePostedProvider, (previous, next) => _refresh());
    
    // Listen to profile updates so the categorization matches their newly selected fields
    ref.listen(profileProvider, (previous, next) {
      if (previous != next) {
        _refresh();
      }
    });

    Future.microtask(() => fetchJobs());
    return JobsState();
  }

  void _refresh() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 100), () {
      state = JobsState(); // Reset state completely
      fetchJobs();
    });
  }

  Future<void> fetchJobs({bool fetchMore = false}) async {
    if (state.hasRechedEnd) return;
    if (fetchMore && state.isFetchingMore) return;
    if (!fetchMore && !state.isLoading) return;

    if (fetchMore) {
      state = state.copyWith(isFetchingMore: true);
    } else {
      state = state.copyWith(isLoading: true);
    }

    try {
      final firestore = FirebaseFirestore.instance;
      final user = ref.read(profileProvider);

      List<JobModel> newBestMatches = [];
      List<JobModel> newGoodMatches = [];
      List<JobModel> newOtherJobs = [];

      // Filters to apply locally across ALL fetched jobs
      final contractFilter = ref.read(contractTypeProvider);
      final experienceFilter = ref.read(experienceLevelProvider);
      final search = ref.read(searchQueryProvider).toLowerCase().trim();
      final workModeFilter = ref.read(workModeProvider);
      final dateFilter = ref.read(datePostedProvider);

      bool passesLocalFilters(JobModel job) {
        if (contractFilter != null && job.jobType != contractFilter) return false;
        if (experienceFilter != null && job.level != experienceFilter) return false;
        if (workModeFilter != null) {
          if (workModeFilter == 'remote' && job.jobType != 'remote') return false;
          if (workModeFilter == 'on_site' && job.jobType == 'remote') return false; // assuming anything else is on-site
        }
        if (dateFilter != null) {
          final now = DateTime.now();
          if (dateFilter == 'past_24h' && now.difference(job.postedAt).inDays > 1) return false;
          if (dateFilter == 'past_week' && now.difference(job.postedAt).inDays > 7) return false;
          if (dateFilter == 'past_month' && now.difference(job.postedAt).inDays > 30) return false;
        }
        if (search.isNotEmpty) {
          final matchesSearch =
              (job.title['ar']?.toLowerCase().contains(search) ?? false) ||
              (job.title['en']?.toLowerCase().contains(search) ?? false) ||
              job.company.toLowerCase().contains(search);
          if (!matchesSearch) return false;
        }
        return true;
      }

      // 1 & 2. Fetch Top Tiers (Only on initial load, not pagination)
      if (!fetchMore && user != null) {
        // --- Best Matches ---
        if (user.preferredSubCategoryIds.isNotEmpty) {
          try {
            final chunks = user.preferredSubCategoryIds.take(10).toList();
            final snap = await firestore.collection(FirestoreKeys.jobsCollection)
                .where('isActive', isEqualTo: true)
                .where('subCategoryId', whereIn: chunks)
                .limit(30) // Fallback limit to prevent giant reads
                .get();
            var list = snap.docs.map((d) => JobModel.fromMap(d.data(), d.id)).toList();
            list.sort((a, b) => b.postedAt.compareTo(a.postedAt));
            newBestMatches = list.where(passesLocalFilters).take(10).toList();
          } catch(e) { debugPrint('Best Matches Error: $e'); }
        }

        // --- Good Matches ---
        if (user.preferredCategoryIds.isNotEmpty) {
          try {
            final chunks = user.preferredCategoryIds.take(10).toList();
            final snap = await firestore.collection(FirestoreKeys.jobsCollection)
                .where('isActive', isEqualTo: true)
                .where('categoryId', whereIn: chunks)
                .limit(40)
                .get();
            var list = snap.docs.map((d) => JobModel.fromMap(d.data(), d.id)).toList();
            list.sort((a, b) => b.postedAt.compareTo(a.postedAt));
            // Exclude jobs already in Best Matches
            final bestIds = newBestMatches.map((e) => e.id).toSet();
            newGoodMatches = list.where((j) => passesLocalFilters(j) && !bestIds.contains(j.id)).take(15).toList();
          } catch(e) { debugPrint('Good Matches Error: $e'); }
        }
      } // End of top tiers fetch

      // 3. Fetch Diverse / Other Jobs (Paginated Stream)
      Query qDiverse = firestore.collection(FirestoreKeys.jobsCollection)
          .where('isActive', isEqualTo: true);
      // We can keep these server-side to help basic pagination efficiency for Explore
      if (contractFilter != null) qDiverse = qDiverse.where('jobType', isEqualTo: contractFilter);
      if (experienceFilter != null) qDiverse = qDiverse.where('level', isEqualTo: experienceFilter);
      
      qDiverse = qDiverse.orderBy('postedAt', descending: true).limit(_limit);

      if (fetchMore && state.lastDoc != null) {
        qDiverse = qDiverse.startAfterDocument(state.lastDoc!);
      }

      final snapshot = await qDiverse.get();
      var paginatedList = snapshot.docs.map((doc) => JobModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
      
      // Filter the paginated list locally for search & dates
      paginatedList = paginatedList.where(passesLocalFilters).toList();

      // Exclude jobs that are already sitting in Best or Good from previous pages or top fetches
      final existingBestIds = fetchMore ? state.bestMatches.map((e)=>e.id).toSet() : newBestMatches.map((e)=>e.id).toSet();
      final existingGoodIds = fetchMore ? state.goodMatches.map((e)=>e.id).toSet() : newGoodMatches.map((e)=>e.id).toSet();
      
      for (var job in paginatedList) {
        if (!existingBestIds.contains(job.id) && !existingGoodIds.contains(job.id)) {
          newOtherJobs.add(job);
        }
      }

      state = state.copyWith(
        bestMatches: fetchMore ? state.bestMatches : newBestMatches,
        goodMatches: fetchMore ? state.goodMatches : newGoodMatches,
        otherJobs: fetchMore ? [...state.otherJobs, ...newOtherJobs] : newOtherJobs,
        lastDoc: snapshot.docs.isNotEmpty ? snapshot.docs.last : state.lastDoc,
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
