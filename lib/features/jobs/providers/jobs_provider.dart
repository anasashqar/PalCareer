import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/job_model.dart';


final jobsProvider = FutureProvider<List<JobModel>>((ref) async {
  // Mock data for V1 UI building phase
  await Future.delayed(const Duration(seconds: 1));
  
  return [
    JobModel(
      id: 'job_1',
      title: {'en': 'Senior Flutter Developer', 'ar': 'مطور Flutter أول'},
      company: 'TechPal Solutions',
      location: {'en': 'Ramallah, Palestine', 'ar': 'رام الله، فلسطين'},
      types: ['full_time', 'remote'],
      postedAt: DateTime.now().subtract(const Duration(hours: 5)),
      requirements: {
        'en': ['3+ years with Flutter', 'Experience with Riverpod', 'Published apps on stores'],
        'ar': ['خبرة 3+ سنوات في Flutter', 'خبرة عملية في Riverpod', 'تطبيقات منشورة على المتاجر']
      },
      responsibilities: {
        'en': ['Build UI components', 'Integrate with Firebase', 'Mentor junior devs'],
        'ar': ['بناء مكونات الواجهات', 'الربط مع Firebase', 'توجيه المطورين المبتدئين']
      },
      applyUrl: 'https://example.com/apply1',
      isPerfectMatch: true,
    ),
    JobModel(
      id: 'job_2',
      title: {'en': 'UX/UI Designer', 'ar': 'مصمم واجهات وتجربة مستخدم'},
      company: 'Pioneers Tech',
      location: {'en': 'Nablus, Palestine', 'ar': 'نابلس، فلسطين'},
      types: ['full_time'],
      postedAt: DateTime.now().subtract(const Duration(days: 2)),
      requirements: {
        'en': ['Figma mastery', 'Portfolio required', 'Arabic & English fluency'],
        'ar': ['إتقان العمل على Figma', 'يشترط وجود معرض أعمال', 'إجادة العربية والإنجليزية']
      },
      responsibilities: {
        'en': ['Design mobile apps', 'Create design systems'],
        'ar': ['تصميم تطبيقات الجوال', 'بناء أنظمة التصميم']
      },
      applyUrl: 'https://example.com/apply2',
      isPerfectMatch: false,
    ),
    JobModel(
      id: 'job_3',
      title: {'en': 'Marketing Specialist', 'ar': 'أخصائي تسويق'},
      company: 'GrowthMakers',
      location: {'en': 'Remote', 'ar': 'عن بُعد'},
      types: ['part_time', 'remote'],
      postedAt: DateTime.now().subtract(const Duration(days: 5)),
      requirements: {
        'en': ['Social media management', 'Content creation'],
        'ar': ['إدارة وسائل التواصل', 'صناعة المحتوى']
      },
      responsibilities: {
        'en': ['Plan campaigns', 'Analyze metrics'],
        'ar': ['تخطيط الحملات', 'تحليل الأداء']
      },
      applyUrl: 'https://example.com/apply3',
      isPerfectMatch: false,
    ),
  ];
});
