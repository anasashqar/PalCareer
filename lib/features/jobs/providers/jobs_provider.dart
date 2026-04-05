import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/job_model.dart';


final jobsProvider = FutureProvider<List<JobModel>>((ref) async {
  // Mock data for V1 UI building phase
  await Future.delayed(const Duration(seconds: 1));
  
  return [
    JobModel(
      id: 'job_1',
      title: {'en': 'Senior Flutter Developer', 'ar': 'مطور تطبيقات Flutter'},
      company: 'شركة التقنية العالمية',
      location: {'en': 'Ramallah, Palestine', 'ar': 'رام الله، فلسطين'},
      types: ['full_time', 'remote'],
      postedAt: DateTime.now().subtract(const Duration(hours: 5)),
      description: {
        'en': 'We are looking for a highly skilled and passionate Senior Flutter Developer to join our growing team. You will be responsible for building and maintaining high-quality mobile applications with visual appeal and efficiency. We expect you to be able to turn design visions into tangible reality.',
        'ar': 'نحن نبحث عن مطور تطبيقات Flutter موهوب وشغوف للانضمام إلى فريقنا المتنامي في شركة التقنية العالمية. ستكون مسؤولاً عن بناء وصيانة تطبيقات جوال عالية الجودة تتسم بالكفاءة والجمال البصري. نتوقع منك أن تكون قادراً على تحويل الرؤى التصميمية إلى واقع ملموس، والعمل بشكل تعاوني مع فرق البرمجة والتصميم لتقديم أفضل تجربة مستخدم ممكنة في السوق الفلسطيني والإقليمي.',
      },
      requirements: {
        'en': ['3+ years with Flutter & Dart', 'Deep understanding of state management (Riverpod, Bloc, or Provider)', 'Experience dealing with RESTful APIs and third-party services', 'Strong skills in building complex and smooth UIs', 'Ability to work in a team and commit to deadlines'],
        'ar': ['خبرة لا تقل عن سنتين في تطوير التطبيقات باستخدام Flutter و Dart.', 'فهم عميق لإدارة الحالة (Riverpod, Bloc, or Provider).', 'خبرة في التعامل مع RESTful APIs ودمج خدمات الطرف الثالث.', 'مهارات قوية في بناء واجهات مستخدم معقدة وسلسة.', 'القدرة على العمل ضمن فريق والالتزام بالمواعيد النهائية.'],
      },
      responsibilities: {
        'en': ['Feature Development: Transform designs to Flutter code', 'Performance Optimization: Monitor and fix issues for speed'],
        'ar': ['تطوير الميزات: تحويل النماذج التصميمية إلى كود Flutter نظيف وقابل للصيانة.', 'تحسين الأداء: مراقبة وإصلاح المشاكل التقنية لضمان سرعة واستجابة التطبيق.']
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
      description: {
        'ar': 'نبحث عن مصمم مبدع لقيادة تجربة المستخدم.',
        'en': 'Looking for a creative designer.',
      },
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
      description: {
        'ar': 'وظيفة عن بعد لإدارة حسابات التواصل.',
        'en': 'Remote job for social media.',
      },
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
