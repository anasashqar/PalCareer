import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/job_model.dart';
import '../../onboarding/providers/onboarding_provider.dart';

class JobGroup {
  final String titleId;
  final List<JobModel> jobs;

  JobGroup(this.titleId, this.jobs);
}

final jobsProvider = FutureProvider<List<JobGroup>>((ref) async {
  final obState = ref.watch(onboardingProvider);
  
  await Future.delayed(const Duration(milliseconds: 800)); // Mock network delay
  
  final allJobs = [
    // ---------------- IT SECTOR ----------------
    JobModel(
      id: 'job_1',
      title: {'en': 'Senior Flutter Developer', 'ar': 'مطور تطبيقات Flutter أول'},
      company: 'TechMakers', location: {'en': 'Ramallah', 'ar': 'رام الله، المنطقة التكنولوجية'},
      types: ['full_time', 'remote'], postedAt: DateTime.now().subtract(const Duration(hours: 5)),
      description: {
        'en': 'We are looking for a highly skilled Flutter Developer to build our next generation apps.',
        'ar': 'نحن نبحث عن مطور فلتر موهوب للانضمام لشركة TechMakers. نحن نقوم ببناء تطبيقات الجيل القادم لقطاع التكنولوجيا المالية (FinTech) وسيكون دورك محورياً في قيادة تطوير واجهات المستخدم عالية الأداء وضمان تجربة مستخدم سلسة جداً.',
      },
      requirements: {
        'en': ['3+ years in Flutter', 'State management (Riverpod/Bloc)', 'CI/CD experience'],
        'ar': ['خبرة لا تقل عن 3 سنوات في بناء تطبيقات ببيئة Flutter.', 'إتقان تام لإدارة حالة التطبيقات (State Management) يفضل Riverpod أو Bloc.', 'خبرة سابقة في دمج منصات Firebase و REST APIs.', 'القدرة على العمل في بيئة Agile متسارعة.'],
      },
      responsibilities: {
        'en': ['UI/UX: Build clean interfaces', 'Performance: Optimize apps for 60fps'],
        'ar': ['هندسة الواجهات: بناء شاشات عالية الدقة التزاماً بنظام التصميم (Figma).', 'تحسين الأداء: مراقبة أداء التطبيق وحل مشكلات الجانك لضمان سلاسة بمعدل 60FPS.', 'تدريب الفريق: توجيه وإرشاد المطورين المبتدئين في الفريق.', 'تطوير النظم: المساهمة في تطوير هيكلية البيانات وإعداد بنية النظام الأساسية.'],
      },
      applyUrl: 'https://example.com/apply', primarySector: 'it', subSectors: ['mobile_dev'],
    ),
    JobModel(
      id: 'job_2',
      title: {'en': 'Backend Node.js Engineer', 'ar': 'مهندس خلفيات Node.js'},
      company: 'Pioneers Tech', location: {'en': 'Nablus', 'ar': 'نابلس'},
      types: ['full_time'], postedAt: DateTime.now().subtract(const Duration(days: 1)),
      description: {'en': 'Server-side logic and database integration.', 'ar': 'بناء وتطوير خدمات سحابية تتحمل ضغط العمل العالي باستخدام Node.js وقواعد بيانات MongoDB.'},
      requirements: {'en': ['Node.js', 'MongoDB', 'AWS'], 'ar': ['خبرة معمقة في Node.js', 'تصميم قواعد بيانات MongoDB', 'التعامل مع AWS']},
      responsibilities: {'en': ['API: Design architecture'], 'ar': ['بناء الأنظمة: تصميم وهندسة RESTful APIs بكفاءة.', 'الأمن السيبراني: تأمين البيانات ومنع الاختراقات.']},
      applyUrl: '', primarySector: 'it', subSectors: ['software_dev', 'web_dev'],
    ),
    JobModel(
      id: 'job_3',
      title: {'en': 'UI/UX Designer', 'ar': 'مصمم واجهات وتجربة مستخدم (UI/UX)'},
      company: 'AppStudio', location: {'en': 'Remote', 'ar': 'عن بُعد'},
      types: ['part_time'], postedAt: DateTime.now().subtract(const Duration(days: 2)),
      description: {'en': 'Creative designer for modern apps.', 'ar': 'نحن نبحث عن مصمم شغوف بتحليل رحلات المستخدمين، لترجمة الأفكار لحلول بصرية تبهر العملاء.'},
      requirements: {'en': ['Figma'], 'ar': ['إتقان Figma بدرجة احترافية', 'فهم مسبق لـ Material 3 Design', 'محفظة أعمال قوية']},
      responsibilities: {'en': ['Wireframing: Draft user flows'], 'ar': ['رسم مسارات المستخدمين: تبسيط تجربة التطبيق لتكون بديهية.', 'أنظمة التصميم: بناء Design System موحد ليستخدمه فريق البرمجة.']},
      applyUrl: '', primarySector: 'it', subSectors: ['design_ux'],
    ),
    JobModel(
      id: 'job_4',
      title: {'en': 'Data Analyst', 'ar': 'محلل بيانات'},
      company: 'DataMind', location: {'en': 'Hebron', 'ar': 'الخليل'},
      types: ['full_time'], postedAt: DateTime.now().subtract(const Duration(hours: 12)),
      description: {'en':'Parse data sets.','ar': 'تحليل جداول البيانات الضخمة للمساعدة في اتخاذ القرارات الإدارية.'},
      requirements: {'en': ['Python'], 'ar': ['بايثون وتحليل البيانات', 'إجادة SQL']}, 
      responsibilities: {'en': ['Reports: Build dashboards'], 'ar': ['التقارير الإحصائية: بناء لوحات تحكم ديناميكية.', 'تحليل السوق: استخراج الاتجاهات بناءً على البيانات.']},
      applyUrl: '', primarySector: 'it', subSectors: ['data_ai'],
    ),
    JobModel(
      id: 'job_5',
      title: {'en': 'Cyber Security Expert', 'ar': 'خبير أمن سيبراني'},
      company: 'SafeNet', location: {'en': 'Ramallah', 'ar': 'رام الله'},
      types: ['full_time'], postedAt: DateTime.now().subtract(const Duration(days: 3)),
      description: {'en':'Secure networks.','ar':'تأمين الشبكات والأنظمة الداخلية للشركة وضمان حمايتها من هجمات التصيد والاختراقات.'},
      requirements: {'en': ['Cisco'], 'ar': ['Cisco CCNA/CCNP', 'Pen testing']}, 
      responsibilities: {'en': ['Testing: Pen testing'], 'ar': ['فحص الثغرات: عمل Penetration Testing بشكل دوري.', 'التدريب: توعية الموظفين أمنياً.']},
      applyUrl: '', primarySector: 'it', subSectors: ['networks'],
    ),

    // ---------------- MEDICINE SECTOR ----------------
    JobModel(
      id: 'job_6',
      title: {'en': 'General Practitioner (GP)', 'ar': 'طبيب عام'},
      company: 'Al-Shifa Hospital', location: {'en': 'Gaza', 'ar': 'غزة'},
      types: ['full_time'], postedAt: DateTime.now().subtract(const Duration(hours: 2)),
      description: {'en':'Provide general care.','ar': 'تقديم الاستشارات الطبية العامة والتشخيص الأولي للمرضى ضمن قسم الطوارئ والعيادات.'},
      requirements: {'en': ['MBBS', 'License'], 'ar': ['شهادة بكالوريوس طب وجراحة', 'مزاولة مهنة سارية المفعول']}, 
      responsibilities: {'en': ['Diagnosis: Treat patients'], 'ar': ['التشخيص المبدئي: فحص ومعالجة المرضى يومياً.', 'تحويل الحالات: توجيه المريض للعيادة التخصصية المناسبة.']},
      applyUrl: '', primarySector: 'medicine', subSectors: ['general_medicine'],
    ),
    JobModel(
      id: 'job_7',
      title: {'en': 'Registered Nurse', 'ar': 'ممرض/ة مسجل/ة'},
      company: 'Care Center', location: {'en': 'Nablus', 'ar': 'نابلس'},
      types: ['full_time', 'part_time'], postedAt: DateTime.now().subtract(const Duration(hours: 20)),
      description: {'en':'Care duties.','ar': 'توفير رعاية تمريضية ممتازة في وحدة العناية المركزية والعيادات الخارجية.'},
      requirements: {'en': ['Nursing degree'], 'ar': ['شهادة دبلوم أو بكالوريوس تمريض', 'تحمل ضغط العمل بنظام الشفتات']}, 
      responsibilities: {'en': ['Monitoring: Vitals'], 'ar': ['مراقبة العلامات الحيوية: متابعة المرضى بشكل دوري على مدار الشفت.', 'إعطاء الأدوية: الالتزام بالجدول العلاجي للمريض بدقة.']},
      applyUrl: '', primarySector: 'medicine', subSectors: ['nursing'],
    ),
    JobModel(
      id: 'job_8',
      title: {'en': 'Pharmacist', 'ar': 'صيدلاني/ة'},
      company: 'HealthPlus Pharmacy', location: {'en': 'Ramallah', 'ar': 'رام الله'},
      types: ['full_time'], postedAt: DateTime.now().subtract(const Duration(days: 4)),
       description: {'en':'Distribute meds.','ar': 'صرف الأدوية للمرضى وتقديم الإرشادات الصيدلانية، مع إدارة مخزون الصيدلية.'},
      requirements: {'en': ['Pharmacy degree'], 'ar': ['بكالوريوس في الصيدلة', 'معرفة ممتازة بالأدوية وبدائلها']}, 
      responsibilities: {'en': ['Dispensing: Prescriptions'], 'ar': ['صرف الوصفات: التأكد من مطابقة الوصفات الطبية بدقة.', 'الجرد المالي: الاهتمام بطلبيات وجرد المخزون الطبي.']},
      applyUrl: '', primarySector: 'medicine', subSectors: ['pharmacy'],
    ),
    JobModel(
      id: 'job_9',
      title: {'en': 'Dentist', 'ar': 'طبيب أسنان (أخصائي جراحة وتقويم)'},
      company: 'Smile Clinic', location: {'en': 'Bethlehem', 'ar': 'بيت لحم'},
      types: ['part_time'], postedAt: DateTime.now().subtract(const Duration(hours: 1)),
      description: {
        'en': 'Experienced dentist required for part-time shift.',
        'ar': 'عيادة Smile Clinic تبحث عن طبيب أسنان بخبرة لا تقل عن 5 سنوات في الجراحة التجميلية لطب الأسنان وزراعتها، الدوام جزئي ومناسب للعمل الخاص. العيادة مجهزة بأحدث آلات الـ X-Ray السنية والتكنولوجيا الألمانية المتقدمة.',
      },
      requirements: {
         'en': ['Dentistry'],
         'ar': ['شهادة بكالوريوس في جراحة الفم والأسنان.', 'حاصل على شهادة بورد في زراعة الأسنان أو ما يعادلها.', 'خبرة سابقة لا تقل عن 5 سنوات في عيادات معتمدة.', 'مهارات تواصل عالية جداً مع المراجعين.']
      }, 
      responsibilities: {
         'en': ['Surgery: Perform operations'], 
         'ar': ['العمليات الجراحية: التركيبات السنية وزراعة الأسنان باحترافية عالية.', 'الفحص السريري: تقديم استشارات وتحديد الخطط العلاجية المتكاملة للمرضى.', 'التوثيق المكتبي: إبقاء سجلات المرضى محدثة ومكتملة بشكل يومي.', 'مكافحة العدوى: التأكد التام من نظافة وتعقيم بيئة العيادة.']
      },
      applyUrl: '', primarySector: 'medicine', subSectors: ['dentistry'],
    ),

    // ---------------- ENGINEERING SECTOR ----------------
    JobModel(
      id: 'job_10',
      title: {'en': 'Civil Engineer (Site Manager)', 'ar': 'مهندس مدني (مدير موقع)'},
      company: 'BuildCo', location: {'en': 'Jenin', 'ar': 'جنين'},
      types: ['full_time'], postedAt: DateTime.now().subtract(const Duration(hours: 8)),
      description: {'en':'Site management','ar': 'الإشراف على تشييد المباني الكبرى والمجمعات التجارية في قلب المدينة.'},
      requirements: {'en': ['Civil Eng'], 'ar': ['هندسة مدنية خبرة 4 سنوات', 'إجادة AutoCad']}, 
      responsibilities: {'en': ['Site Work: Oversight'], 'ar': ['الإشراف الهندسي: إدارة العمال والمشرفين في الموقع يومياً.', 'متابعة المشتريات: فحص مطابقة المواد لمواصفات البناء.']},
      applyUrl: '', primarySector: 'engineering', subSectors: ['civil'],
    ),
    JobModel(
      id: 'job_11',
      title: {'en': 'Architectural Designer', 'ar': 'مهندس/ة معماري/ة'},
      company: 'Modern Homes', location: {'en': 'Ramallah', 'ar': 'رام الله'},
      types: ['full_time'], postedAt: DateTime.now().subtract(const Duration(days: 2)),
      description: {'en':'Design houses','ar': 'تصميم المخططات المعمارية والديكور الداخلي لفلل سكنية حديثة.'},
      requirements: {'en': ['Architecture'], 'ar': ['خبرة في 3D Max والتصميم المعماري']}, 
      responsibilities: {'en': ['Planning: Draw'], 'ar': ['المخططات: بناء تصاميم هندسية وتوزيع الفراغات.', 'الإخراج البصري: إنشاء ريندر 3D واقعي ليراه العميل.']},
      applyUrl: '', primarySector: 'engineering', subSectors: ['architecture'],
    ),
    JobModel(
      id: 'job_12',
      title: {'en': 'Electrical Engineer', 'ar': 'مهندس كهربائي'},
      company: 'PowerGrid', location: {'en': 'Hebron', 'ar': 'الخليل'},
      types: ['full_time'], postedAt: DateTime.now().subtract(const Duration(days: 3)),
       description: {'en':'Power grid design','ar': 'تصميم وتنفيذ أنظمة كهرباء الجهد المنخفض والمنازل الذكية.'},
      requirements: {'en': ['Electrical Exp'], 'ar': ['خبرة تمديدات ولوحات طاقة شمسية']}, 
      responsibilities: {'en': ['wiring: cables'], 'ar': ['التمديدات: الإشراف على مقاولي الكهرباء.', 'دراسات الأحمال: حساب مقاطع الكابلات وأنظمة التحويل.']},
      applyUrl: '', primarySector: 'engineering', subSectors: ['electrical'],
    ),

    // ---------------- BUSINESS SECTOR ----------------
    JobModel(
      id: 'job_13',
      title: {'en': 'Digital Marketing Specialist', 'ar': 'أخصائي تسويق رقمي'},
      company: 'GrowthHub', location: {'en': 'Remote', 'ar': 'عن بُعد'},
      types: ['remote'], postedAt: DateTime.now().subtract(const Duration(hours: 1)),
       description: {'en':'Online ads','ar': 'تسويق وإطلاق حملات إعلانية مدفوعة وإدارة ميزانيات السوشيال ميديا.'},
      requirements: {'en': ['Marketing'], 'ar': ['خبرة في Meta Ads و Google Ads']}, 
      responsibilities: {'en': ['Campaigns: Run ads'], 'ar': ['الحملات: إطلاق وتحسين إعلانات السوشيال ميديا يومياً.', 'كتابة المحتوى: توجيه كتاب وصناع المحتوى.']},
      applyUrl: '', primarySector: 'business', subSectors: ['marketing'],
    ),
    JobModel(
      id: 'job_14',
      title: {'en': 'Senior Accountant', 'ar': 'محاسب أول'},
      company: 'PalBank', location: {'en': 'Ramallah', 'ar': 'رام الله'},
      types: ['full_time'], postedAt: DateTime.now().subtract(const Duration(days: 4)),
       description: {'en':'Auditing','ar': 'وظيفة في المقر الرئيسي للبنك لرصد الحركات المالية والتدقيق الداخلي.'},
      requirements: {'en': ['Accounting'], 'ar': ['محاسبة', 'برنامج الشامل']}, 
      responsibilities: {'en': ['Auditing: Books'], 'ar': ['التدقيق المالي: إعداد القوائم المالية الشهرية.', 'متابعة البنوك: عمليات التسوية والمطابقة.']},
      applyUrl: '', primarySector: 'business', subSectors: ['accounting'],
    ),
    JobModel(
      id: 'job_15',
      title: {'en': 'HR Director', 'ar': 'مدير الموارد البشرية'},
      company: 'MegaTech', location: {'en': 'Nablus', 'ar': 'نابلس'},
      types: ['full_time'], postedAt: DateTime.now().subtract(const Duration(days: 6)),
      description: {'en':'Manage employees','ar': 'قيادة موظفي الشركة والإشراف على عمليات التوظيف والتقييم.'},
      requirements: {'en': ['HR'], 'ar': ['شهادة متقدمة في الموارد البشرية']}, 
      responsibilities: {'en': ['Recruitment: Hiring'], 'ar': ['التوظيف: إجراء المقابلات واختيار الكفاءات.', 'بيئة العمل: السهر على راحة وإنتاجية الموظفين.']},
      applyUrl: '', primarySector: 'business', subSectors: ['hr'],
    ),
    
    // ---------------- EDUCATION SECTOR ----------------
    JobModel(
      id: 'job_16',
      title: {'en': 'English Teacher', 'ar': 'مدرس/ة لغة إنجليزية'},
      company: 'Excellence Academy', location: {'en': 'Jerusalem', 'ar': 'القدس'},
      types: ['full_time'], postedAt: DateTime.now().subtract(const Duration(hours: 18)),
       description: {'en':'Teaching','ar': 'تدريس الأطفال والمرحلة الأساسية بطرق تفاعلية حديثة.'},
      requirements: {'en': ['Teaching'], 'ar': ['تدريس']}, 
      responsibilities: {'en': ['Classes: Teach'], 'ar': ['التدريس: إعطاء الحصص للطلبة.', 'التقييم: تصحيح أوراق العمل وإعداد الامتحانات.']},
      applyUrl: '', primarySector: 'education', subSectors: ['teaching'],
    ),
  ];

  final perfectMatches = <JobModel>[];
  final sectorMatches = <JobModel>[];
  final exploreMore = <JobModel>[];

  if (obState.selectedSector == null) {
    return [JobGroup('explore_jobs', allJobs)];
  }

  for (final job in allJobs) {
    bool isPerfect = false;
    
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
