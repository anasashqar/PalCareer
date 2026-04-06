import 'dart:math';
import '../../../shared/models/job_model.dart';

class MockJobs {
  static List<JobModel> get defaultJobs {
    final List<JobModel> generatedJobs = [];
    final random = Random(42); // Fixed seed for consistent output

    final locations = [
      {'ar': 'رام الله، فلسطين', 'en': 'Ramallah, Palestine'},
      {'ar': 'نابلس، فلسطين', 'en': 'Nablus, Palestine'},
      {'ar': 'الخليل، فلسطين', 'en': 'Hebron, Palestine'},
      {'ar': 'بيت لحم، فلسطين', 'en': 'Bethlehem, Palestine'},
      {'ar': 'جنين، فلسطين', 'en': 'Jenin, Palestine'},
      {'ar': 'طولكرم، فلسطين', 'en': 'Tulkarm, Palestine'},
      {'ar': 'عن بُعد', 'en': 'Remote'},
    ];

    final companies = [
      'TechMinds Solutions', 'CloudGate Systems', 'BuildPro Construction',
      'MarketGrowth Agency', 'Aqar Investments', 'Arab Care Hospital',
      'Pioneer Trade', 'Skyline Architects', 'Future Vision Tech',
      'Global Solutions', 'Smart Apps', 'Elite Financial Services',
      'National Bank', 'Bright Minds Academy', 'Balsam Pharmacies'
    ];

    final itRoles = [
      {'titleAr': 'مطور تطبيقات فلاتر', 'titleEn': 'Flutter Developer', 'subId': 'mobile_dev', 'icon': 'code_icon', 'skills': ['Flutter', 'Dart', 'Firebase']},
      {'titleAr': 'مطور الواجهة الأمامية React', 'titleEn': 'Frontend React Developer', 'subId': 'web_dev', 'icon': 'code_icon', 'skills': ['React.js', 'JavaScript', 'CSS']},
      {'titleAr': 'مطور الواجهة الخلفية Node.js', 'titleEn': 'Backend Node.js Developer', 'subId': 'web_dev', 'icon': 'server_icon', 'skills': ['Node.js', 'MongoDB', 'Express']},
      {'titleAr': 'محلل بيانات', 'titleEn': 'Data Analyst', 'subId': 'data_science', 'icon': 'analytics_icon', 'skills': ['SQL', 'Python', 'PowerBI']},
      {'titleAr': 'مهندس أمن سيبراني', 'titleEn': 'Cybersecurity Engineer', 'subId': 'security', 'icon': 'security_icon', 'skills': ['Networks', 'Ethical Hacking', 'Linux']},
      {'titleAr': 'مصمم واجهات (UI/UX)', 'titleEn': 'UI/UX Designer', 'subId': 'design', 'icon': 'design_icon', 'skills': ['Figma', 'Adobe XD', 'Prototyping']},
      {'titleAr': 'مهندس ذكاء اصطناعي', 'titleEn': 'AI Engineer', 'subId': 'data_science', 'icon': 'code_icon', 'skills': ['Machine Learning', 'TensorFlow', 'Python']},
      {'titleAr': 'مدير مشاريع برمجية', 'titleEn': 'Software Project Manager', 'subId': 'management', 'icon': 'management_icon', 'skills': ['Agile', 'Scrum', 'Jira']},
      {'titleAr': 'مهندس DevOps', 'titleEn': 'DevOps Engineer', 'subId': 'security', 'icon': 'server_icon', 'skills': ['Docker', 'Kubernetes', 'CI/CD']},
      {'titleAr': 'مطوّر ألعاب (Unity)', 'titleEn': 'Unity Game Developer', 'subId': 'web_dev', 'icon': 'code_icon', 'skills': ['Unity', 'C#', '3D Modeling']},
    ];

    final engRoles = [
      {'titleAr': 'مهندس مدني', 'titleEn': 'Civil Engineer', 'subId': 'civil', 'icon': 'construct_icon', 'skills': ['AutoCAD', 'Structural Engineering']},
      {'titleAr': 'مهندس معماري', 'titleEn': 'Architect', 'subId': 'architect', 'icon': 'architecture_icon', 'skills': ['3ds Max', 'SketchUp', 'Revit']},
      {'titleAr': 'مهندس كهرباء', 'titleEn': 'Electrical Engineer', 'subId': 'electrical', 'icon': 'bolt_icon', 'skills': ['Power Systems', 'Control Systems']},
      {'titleAr': 'مهندس ميكانيك', 'titleEn': 'Mechanical Engineer', 'subId': 'mechanical', 'icon': 'gear_icon', 'skills': ['SolidWorks', 'HVAC']},
      {'titleAr': 'رسام هندسي', 'titleEn': 'Draftsman', 'subId': 'draftsman', 'icon': 'design_icon', 'skills': ['AutoCAD', 'Blueprint Reading']},
      {'titleAr': 'مهندس مساحة', 'titleEn': 'Surveying Engineer', 'subId': 'civil', 'icon': 'construct_icon', 'skills': ['GIS', 'Topography']},
      {'titleAr': 'مهندس ميكاترونكس', 'titleEn': 'Mechatronics Engineer', 'subId': 'electrical', 'icon': 'gear_icon', 'skills': ['Robotics', 'Automation']},
    ];

    final busRoles = [
      {'titleAr': 'أخصائي تسويق رقمي', 'titleEn': 'Digital Marketing Specialist', 'subId': 'marketing', 'icon': 'bullhorn_icon', 'skills': ['SEO', 'Google Ads', 'Social Media']},
      {'titleAr': 'مدير مبيعات', 'titleEn': 'Sales Manager', 'subId': 'sales', 'icon': 'sales_icon', 'skills': ['B2B', 'Negotiation', 'Leadership']},
      {'titleAr': 'مطور أعمال', 'titleEn': 'Business Developer', 'subId': 'bd', 'icon': 'briefcase_icon', 'skills': ['Market Research', 'Partnerships']},
      {'titleAr': 'مسؤول موارد بشرية', 'titleEn': 'HR Officer', 'subId': 'hr', 'icon': 'people_icon', 'skills': ['Recruitment', 'Labor Law']},
      {'titleAr': 'مدير تسويق', 'titleEn': 'Marketing Manager', 'subId': 'marketing', 'icon': 'bullhorn_icon', 'skills': ['Strategy', 'Budgeting', 'Branding']},
      {'titleAr': 'محلل أعمال', 'titleEn': 'Business Analyst', 'subId': 'analysis', 'icon': 'chart_icon', 'skills': ['Reporting', 'Agile', 'BPMN']},
      {'titleAr': 'أخصائي علاقات عامة', 'titleEn': 'Public Relations', 'subId': 'marketing', 'icon': 'people_icon', 'skills': ['Communication', 'Events Management']},
      {'titleAr': 'سكرتير/ة تنفيذي', 'titleEn': 'Executive Secretary', 'subId': 'hr', 'icon': 'doc_icon', 'skills': ['Filing', 'Office Admin', 'Scheduling']},
    ];

    final accRoles = [
      {'titleAr': 'محاسب عام', 'titleEn': 'General Accountant', 'subId': 'accountant', 'icon': 'calculator_icon', 'skills': ['Bookkeeping', 'Excel']},
      {'titleAr': 'محاسب مالي رئيسي', 'titleEn': 'Senior Financial Accountant', 'subId': 'accountant', 'icon': 'calculator_icon', 'skills': ['Bisan', 'Reporting', 'Tax']},
      {'titleAr': 'مدقق داخلي', 'titleEn': 'Internal Auditor', 'subId': 'auditor', 'icon': 'doc_icon', 'skills': ['Compliance', 'Risk Management']},
      {'titleAr': 'أخصائي ضرائب', 'titleEn': 'Tax Specialist', 'subId': 'tax', 'icon': 'money_icon', 'skills': ['VAT', 'Income Tax']},
      {'titleAr': 'محلل مالي', 'titleEn': 'Financial Analyst', 'subId': 'accountant', 'icon': 'analytics_icon', 'skills': ['Forecasting', 'Valuation']},
      {'titleAr': 'أمين صندوق', 'titleEn': 'Cashier/Teller', 'subId': 'accountant', 'icon': 'money_icon', 'skills': ['Cash Handling', 'Customer Service']},
    ];

    final eduRoles = [
      {'titleAr': 'مدرس/ة لغة إنجليزية', 'titleEn': 'English Teacher', 'subId': 'teacher', 'icon': 'educate_icon', 'skills': ['Teaching', 'English Grammar']},
      {'titleAr': 'مدرس رياضيات', 'titleEn': 'Math Teacher', 'subId': 'teacher', 'icon': 'educate_icon', 'skills': ['Algebra', 'Geometry', 'Patience']},
      {'titleAr': 'مرشد تربوي', 'titleEn': 'Educational Counselor', 'subId': 'counselor', 'icon': 'people_icon', 'skills': ['Psychology', 'Mentoring']},
      {'titleAr': 'مدرب علوم وتكنولوجيا', 'titleEn': 'STEM Trainer', 'subId': 'trainer', 'icon': 'computer_icon', 'skills': ['Robotics', 'Coding for Kids']},
      {'titleAr': 'مدير روضة أطفال', 'titleEn': 'Kindergarten Manager', 'subId': 'management', 'icon': 'management_icon', 'skills': ['Administration', 'Child Care']},
      {'titleAr': 'أستاذ جامعي (علوم حاسوب)', 'titleEn': 'University Professor (CS)', 'subId': 'teacher', 'icon': 'educate_icon', 'skills': ['Research', 'Algorithms']},
    ];

    final healthRoles = [
      {'titleAr': 'ممرض/ة قانوني', 'titleEn': 'Registered Nurse', 'subId': 'nurse', 'icon': 'medical_icon', 'skills': ['Patient Care', 'Vitals', 'Injections']},
      {'titleAr': 'صيدلي مرخص', 'titleEn': 'Licensed Pharmacist', 'subId': 'pharmacist', 'icon': 'pharmacy_icon', 'skills': ['Medications', 'Customer Advising']},
      {'titleAr': 'طبيب طوارئ', 'titleEn': 'Emergency Doctor', 'subId': 'doctor', 'icon': 'medical_icon', 'skills': ['Trauma', 'Fast Decision Making']},
      {'titleAr': 'فني مختبرات طبية', 'titleEn': 'Lab Technician', 'subId': 'laboratory', 'icon': 'microscope_icon', 'skills': ['Blood Drawing', 'Sample Analysis']},
      {'titleAr': 'أخصائي علاج طبيعي', 'titleEn': 'Physiotherapist', 'subId': 'physio', 'icon': 'medical_icon', 'skills': ['Rehabilitation', 'Massage']},
      {'titleAr': 'طبيب أسنان', 'titleEn': 'Dentist', 'subId': 'doctor', 'icon': 'medical_icon', 'skills': ['Oral Surgery', 'Cosmetic Dentistry']},
    ];

    final otherRoles = [
      {'titleAr': 'مصمم جرافيك حر', 'titleEn': 'Freelance Graphic Designer', 'subId': 'freelance', 'icon': 'camera_icon', 'skills': ['Photoshop', 'Illustrator']},
      {'titleAr': 'كاتب محتوى ابداعي', 'titleEn': 'Creative Content Writer', 'subId': 'writer', 'icon': 'doc_icon', 'skills': ['Copywriting', 'SEO']},
      {'titleAr': 'مترجم (عربي - إنجليزي)', 'titleEn': 'Translator (AR-EN)', 'subId': 'translator', 'icon': 'translate_icon', 'skills': ['Translation', 'Grammar']},
      {'titleAr': 'مونتير فيديو', 'titleEn': 'Video Editor', 'subId': 'freelance', 'icon': 'camera_icon', 'skills': ['Premiere Pro', 'After Effects']},
      {'titleAr': 'ممثل خدمة عملاء', 'titleEn': 'Customer Service Agent', 'subId': 'admin', 'icon': 'people_icon', 'skills': ['Communication', 'Call Handling']},
    ];

    final Map<String, List<Map<String, dynamic>>> categories = {
      'it': itRoles,
      'engineering': engRoles,
      'business': busRoles,
      'accounting': accRoles,
      'education': eduRoles,
      'health': healthRoles,
      'other': otherRoles,
    };

    int globalIndex = 1;

    final reqsAr = ['درجة البكالوريوس في المجال أو ما يعادلها', 'خبرة عملية سابقة لا تقل عن سنتين', 'مهارات تواصل ممتازة والقدرة على العمل الجماعي', 'القدرة على العمل تحت الضغط', 'إجادة اللغة الإنجليزية محادثة وكتابة', 'الرغبة في التعلم والتطوير المستمر'];
    final reqsEn = ['BSc degree or equivalent', 'At least 2 years of practical experience', 'Excellent communication and teamwork skills', 'Ability to work under pressure', 'English proficiency in speaking and writing', 'Desire for continuous learning'];
    final respAr = ['تنفيذ المهام اليومية المطلوبة بدقة عالية', 'الالتزام بمواعيد التسليم', 'كتابة تقارير دورية للإدارة المباشرة', 'التنسيق والتعاون مع باقي أفراد الفريق', 'تحسين وتطوير آليات العمل الحالية'];
    final respEn = ['Execute daily tasks accurately', 'Commit to deadlines consistently', 'Submit periodic reports to management', 'Coordinate and cooperate with team members', 'Improve and develop current workflows'];
    
    final levelTypes = ['entry', 'mid', 'senior'];
    final jobTypes = ['full-time', 'part-time', 'remote', 'freelance', 'contract'];
    final eduLevels = ['bachelor', 'diploma', 'master'];

    categories.forEach((catId, roles) {
      // Create 2 jobs for each role definitions, yielding approx 80-90 total jobs.
      for (var role in roles) {
        for (int i = 0; i < 2; i++) {
          final comp = companies[random.nextInt(companies.length)];
          final loc = locations[random.nextInt(locations.length)];
          
          final lvl = levelTypes[random.nextInt(levelTypes.length)];
          final eLvl = eduLevels[random.nextInt(eduLevels.length)];
          
          // Make sure Remote works logically:
          String jType = jobTypes[random.nextInt(jobTypes.length)];
          if (loc['en'] == 'Remote') {
            jType = 'remote';
          }

          final isActive = random.nextDouble() > 0.08; // ~92% active, 8% expired
          
          DateTime postDate = DateTime.now().subtract(Duration(days: random.nextInt(15), hours: random.nextInt(24)));
          DateTime expDate = isActive 
            ? DateTime.now().add(Duration(days: random.nextInt(30) + 2))
            : DateTime.now().subtract(Duration(days: random.nextInt(10) + 1));

          final specificSkills = List<String>.from(role['skills']);
          
          final sampleUrls = [
            'https://www.linkedin.com/jobs',
            'https://rabt.ps/jobs',
            'https://careers.google.com',
          ];
          final pickedUrl = sampleUrls[random.nextInt(sampleUrls.length)];

          generatedJobs.add(JobModel(
            id: 'job_${catId}_${globalIndex++}',
            title: {'ar': role['titleAr'], 'en': role['titleEn']},
            company: comp,
            location: loc,
            postedAt: postDate,
            expiresAt: expDate,
            description: {
              'ar': 'نحن في $comp نبحث عن ${role['titleAr']} للانضمام إلى فريقنا الرائع والمساهمة في تحقيق أهداف الشركة من خلال الإبداع والتميز والالتزام بالمهام الوظيفية والنمو معنا.',
              'en': 'At $comp, we are looking for a ${role['titleEn']} to join our amazing team and contribute to achieving company goals through creativity, excellence, and commitment to the role.',
            },
            requirements: {
              'ar': [
                reqsAr[random.nextInt(3)], 
                reqsAr[random.nextInt(3) + 3], 
                'إجادة المهارات الأساسية: ${specificSkills.join(' و ')}'
              ],
              'en': [
                reqsEn[random.nextInt(3)], 
                reqsEn[random.nextInt(3) + 3], 
                'Proficiency in core skills: ${specificSkills.join(', ')}'
              ],
            },
            responsibilities: {
              'ar': [
                respAr[random.nextInt(2)], 
                respAr[random.nextInt(3) + 2], 
                'الإشراف على مهام ${role['titleAr']} وتطوير الأداء العام'
              ],
              'en': [
                respEn[random.nextInt(2)], 
                respEn[random.nextInt(3) + 2], 
                'Supervise ${role['titleEn']} tasks and develop overall performance'
              ],
            },
            applyUrl: pickedUrl,
            categoryId: catId,
            subCategoryId: role['subId'],
            educationLevelId: eLvl,
            iconId: role['icon'],
            jobType: jType,
            level: lvl,
            skills: specificSkills,
            isActive: isActive,
          ));
        }
      }
    });

    return generatedJobs;
  }
}
