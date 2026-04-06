import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../../core/constants/firestore_keys.dart';
import '../../../shared/models/job_model.dart';
import '../../onboarding/providers/onboarding_provider.dart';

class JobGroup {
  final String titleId;
  final List<JobModel> jobs;

  JobGroup(this.titleId, this.jobs);
}

final searchQueryProvider = StateProvider<String>((ref) => '');
final contractTypeProvider = StateProvider<String?>((ref) => null);
final workModeProvider = StateProvider<String?>((ref) => null);
final experienceLevelProvider = StateProvider<String?>((ref) => null);
final datePostedProvider = StateProvider<String?>((ref) => null);
final jobsProvider = FutureProvider<List<JobGroup>>((ref) async {
  final obState = ref.watch(onboardingProvider);

  List<JobModel> allJobs = [];
  try {
    final firestore = FirebaseFirestore.instance;
    final snapshot = await firestore
        .collection(FirestoreKeys.jobsCollection)
        .where('isActive', isEqualTo: true)
        .get();

    allJobs = snapshot.docs
        .map((doc) => JobModel.fromMap(doc.data(), doc.id))
        .toList()
      ..sort((a, b) => b.postedAt.compareTo(a.postedAt));
  } catch (e) {
    debugPrint('Error Fetching Jobs, falling back to mock data: $e');
  }

  // Only use Firestore, do not fall back to mock data
  if (allJobs.isEmpty) {
    debugPrint('No jobs found in Firestore!');
  }

  final search = ref.watch(searchQueryProvider).toLowerCase().trim();
  final contractFilter = ref.watch(contractTypeProvider);
  final workModeFilter = ref.watch(workModeProvider);
  final experienceFilter = ref.watch(experienceLevelProvider);
  final dateFilter = ref.watch(datePostedProvider);

  // Check if any search or filter is active
  final isSearchActive =
      search.isNotEmpty ||
      contractFilter != null ||
      workModeFilter != null ||
      experienceFilter != null ||
      dateFilter != null;

  final filteredJobs = allJobs.where((job) {
    bool matchesSearch = true;
    if (search.isNotEmpty) {
      matchesSearch =
          (job.title['ar']?.toLowerCase().contains(search) ?? false) ||
          (job.title['en']?.toLowerCase().contains(search) ?? false) ||
          job.company.toLowerCase().contains(search);
    }

    final matchesContract =
        contractFilter == null || job.jobType == contractFilter;
    final matchesWorkMode =
        workModeFilter == null ||
        (workModeFilter == 'remote' && job.jobType == 'remote') ||
        (workModeFilter == 'on_site' && job.jobType != 'remote');

    final matchesExperience =
        experienceFilter == null || job.level == experienceFilter;

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

    return matchesSearch &&
        matchesContract &&
        matchesWorkMode &&
        matchesExperience &&
        matchesDate;
  }).toList();

  // THE LINKEDIN MODEL: If searching/filtering, return flat list of results instead of tiered matching
  if (isSearchActive) {
    // Sort by most recent for search results as standard practice
    filteredJobs.sort((a, b) => b.postedAt.compareTo(a.postedAt));
    return [JobGroup('search_results', filteredJobs)];
  }

  // ELSE: Return standard Tiered Feed
  final perfectlyFilteredJobs = filteredJobs;
  final perfectMatches = <JobModel>[];
  final sectorMatches = <JobModel>[];
  final exploreMore = <JobModel>[];

  if (obState.selectedSector == null) {
    return [JobGroup('explore_jobs', perfectlyFilteredJobs)];
  }

  for (final job in perfectlyFilteredJobs) {
    bool isPerfect = false;

    for (final userSub in obState.fieldsOfStudy) {
      if (job.subCategoryId == userSub) {
        isPerfect = true;
        break;
      }
    }

    if (isPerfect) {
      perfectMatches.add(job);
    } else if (job.categoryId == obState.selectedSector) {
      sectorMatches.add(job);
    } else {
      exploreMore.add(job);
    }
  }

  final List<JobGroup> groups = [];

  if (perfectMatches.isNotEmpty) {
    groups.add(JobGroup('perfect_matches', perfectMatches));
  }
  if (sectorMatches.isNotEmpty) {
    groups.add(JobGroup('sector_matches', sectorMatches));
  }

  if (exploreMore.isNotEmpty) {
    exploreMore.shuffle();
    groups.add(JobGroup('explore_jobs', exploreMore));
  }

  return groups;
});
