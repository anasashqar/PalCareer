import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/job_model.dart';
import '../../onboarding/providers/onboarding_provider.dart';

class JobGroup {
  final String titleId; // Used for translation key conceptually
  final List<JobModel> jobs;

  JobGroup(this.titleId, this.jobs);
}

final jobsProvider = FutureProvider<List<JobGroup>>((ref) async {
  // To simulate the matching algorithm, we watch the onboarding state
  final obState = ref.watch(onboardingProvider);
  
  await Future.delayed(const Duration(seconds: 1)); // Mock network delay
  
  // 1. Mock Data Pool
  final allJobs = [
    JobModel(
      id: 'job_1',
      title: {'en': 'Senior Flutter Developer', 'ar': 'مطور تطبيقات Flutter'},
      company: 'TechMakers',
      location: {'en': 'Ramallah, Palestine', 'ar': 'رام الله، فلسطين'},
      types: ['full_time', 'remote'],
      postedAt: DateTime.now().subtract(const Duration(hours: 5)),
      description: {
        'en': 'We are looking for a highly skilled Flutter Developer.',
        'ar': 'نحن نبحث عن مطور فلتر موهوب للانضمام لفريقنا.',
      },
      requirements: {
        'en': ['3+ years Flutter', 'State management'],
        'ar': ['خبرة 3 سنوات', 'إدارة الحالة']
      },
      responsibilities: {
        'en': ['Build UI', 'Optimize performance'],
        'ar': ['بناء الواجهات', 'تحسين الأداء']
      },
      applyUrl: 'https://example.com/apply1',
      primarySector: 'it',
      subSectors: ['it_mobile', 'it_software'],
    ),
    JobModel(
      id: 'job_2',
      title: {'en': 'Backend Node.js Developer', 'ar': 'مطور خلفيات Node.js'},
      company: 'Pioneers Tech',
      location: {'en': 'Nablus, Palestine', 'ar': 'نابلس، فلسطين'},
      types: ['full_time'],
      postedAt: DateTime.now().subtract(const Duration(days: 2)),
      description: {
        'en': 'Looking for a Backend Developer.',
        'ar': 'نبحث عن مطور خلفيات مبدع.',
      },
      requirements: {
        'en': ['Node.js', 'MongoDB', 'AWS'],
        'ar': ['Node.js', 'MongoDB', 'AWS']
      },
      responsibilities: {
        'en': ['Design APIs'],
        'ar': ['تصميم الـ APIs']
      },
      applyUrl: 'https://example.com/apply2',
      primarySector: 'it',
      subSectors: ['it_software'],
    ),
    JobModel(
      id: 'job_3',
      title: {'en': 'Clinical Nurse', 'ar': 'ممرض/ة في عيادة'},
      company: 'Care Center',
      location: {'en': 'Ramallah', 'ar': 'رام الله'},
      types: ['full_time'],
      postedAt: DateTime.now().subtract(const Duration(days: 4)),
      description: {
        'en': 'Seeking a registered nurse.',
        'ar': 'مطلوب ممرض مسجل للعمل في عيادة طبية.',
      },
      requirements: {
        'en': ['Nursing degree'],
        'ar': ['شهادة في التمريض']
      },
      responsibilities: {
        'en': ['Patient care'],
        'ar': ['رعاية المرضى']
      },
      applyUrl: 'https://example.com/apply3',
      primarySector: 'health',
      subSectors: ['health_nursing'],
    ),
    JobModel(
      id: 'job_4',
      title: {'en': 'Marketing Manager', 'ar': 'مدير/ة تسويق'},
      company: 'GrowthHub',
      location: {'en': 'Remote', 'ar': 'عن بُعد'},
      types: ['part_time', 'remote'],
      postedAt: DateTime.now().subtract(const Duration(days: 5)),
      description: {
        'en': 'Remote marketing role.',
        'ar': 'وظيفة عن بعد لإدارة الحملات المكتوبة.',
      },
      requirements: {
        'en': ['Marketing EXP'],
        'ar': ['خبرة في التسويق']
      },
      responsibilities: {
        'en': ['Campaigns'],
        'ar': ['إدارة الحملات']
      },
      applyUrl: 'https://example.com/apply4',
      primarySector: 'business',
      subSectors: ['bz_marketing'],
    ),
    JobModel(
      id: 'job_5',
      title: {'en': 'Civil Engineer', 'ar': 'مهندس/ة مدني'},
      company: 'BuildCo',
      location: {'en': 'Hebron', 'ar': 'الخليل'},
      types: ['full_time'],
      postedAt: DateTime.now().subtract(const Duration(days: 1)),
      description: {
        'en': 'Required civil engineer.',
        'ar': 'مطلوب مهندس مدني لموقع بناء.',
      },
      requirements: {
        'en': ['Engineering degree'],
        'ar': ['بكالوريوس هندسة']
      },
      responsibilities: {
        'en': ['Site management'],
        'ar': ['إدارة الموقع']
      },
      applyUrl: 'https://example.com/apply5',
      primarySector: 'engineering',
      subSectors: ['eng_civil'],
    ),
  ];

  // 2. The Matching Algorithm (Waterfall)
  final perfectMatches = <JobModel>[];
  final sectorMatches = <JobModel>[];
  final exploreMore = <JobModel>[];

  if (obState.selectedSector == null) {
    // If user has no preferences (e.g. guest), return all in one list
    return [JobGroup('explore_jobs', allJobs)];
  }

  for (final job in allJobs) {
    bool isPerfect = false;
    
    // Check intersection of sub-sectors
    for (final userSub in obState.fieldsOfStudy) {
      if (job.subSectors.contains(userSub)) {
        isPerfect = true;
        break;
      }
    }

    if (isPerfect) {
      perfectMatches.add(job);
    } else if (job.primarySector == obState.selectedSector) {
      sectorMatches.add(job);
    } else {
      exploreMore.add(job);
    }
  }

  final List<JobGroup> groups = [];
  
  if (perfectMatches.isNotEmpty) {
    groups.add(JobGroup('perfect_matches', perfectMatches)); // 🔥 الأنسب لك
  }
  if (sectorMatches.isNotEmpty) {
    groups.add(JobGroup('sector_matches', sectorMatches)); // مقترحات في مجالك
  }
  if (exploreMore.isNotEmpty) {
    groups.add(JobGroup('explore_jobs', exploreMore)); // استكشف المزيد
  }

  return groups;
});
