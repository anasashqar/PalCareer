import 'package:flutter/material.dart';

class TaxonomyItem {
  final String id;
  final Map<String, String> name;
  final IconData? icon;

  const TaxonomyItem({required this.id, required this.name, this.icon});

  String getLocalizedName(String langCode) {
    return name[langCode] ?? name['en'] ?? id;
  }
}

class CareerTaxonomy {
  static const List<TaxonomyItem> sectors = [
    TaxonomyItem(
      id: 'it',
      name: {'en': 'Tech & IT', 'ar': 'تقنية المعلومات'},
      icon: Icons.computer_rounded,
    ),
    TaxonomyItem(
      id: 'engineering',
      name: {'en': 'Engineering', 'ar': 'الهندسة'},
      icon: Icons.precision_manufacturing_rounded,
    ),
    TaxonomyItem(
      id: 'medicine',
      name: {'en': 'Healthcare', 'ar': 'الطب والصحة'},
      icon: Icons.medical_services_rounded,
    ),
    TaxonomyItem(
      id: 'business',
      name: {'en': 'Business & Finance', 'ar': 'الأعمال والمالية'},
      icon: Icons.business_center_rounded,
    ),
    TaxonomyItem(
      id: 'education',
      name: {'en': 'Education', 'ar': 'التعليم'},
      icon: Icons.school_rounded,
    ),
  ];

  static const Map<String, List<TaxonomyItem>> subSectors = {
    'it': [
      TaxonomyItem(
        id: 'software_dev',
        name: {'en': 'Software Dev', 'ar': 'تطوير البرمجيات'},
      ),
      TaxonomyItem(
        id: 'mobile_dev',
        name: {'en': 'Mobile Apps', 'ar': 'تطبيقات الموبايل'},
      ),
      TaxonomyItem(id: 'web_dev', name: {'en': 'Web Dev', 'ar': 'تطوير الويب'}),
      TaxonomyItem(
        id: 'data_ai',
        name: {'en': 'Data & AI', 'ar': 'بيانات وذكاء اصطناعي'},
      ),
      TaxonomyItem(
        id: 'networks',
        name: {'en': 'Networks & Security', 'ar': 'الشبكات والحماية'},
      ),
      TaxonomyItem(
        id: 'design_ux',
        name: {'en': 'UI/UX Design', 'ar': 'تصميم واجهات'},
      ),
    ],
    'engineering': [
      TaxonomyItem(id: 'civil', name: {'en': 'Civil Eng', 'ar': 'هندسة مدنية'}),
      TaxonomyItem(
        id: 'architecture',
        name: {'en': 'Architecture', 'ar': 'هندسة معمارية'},
      ),
      TaxonomyItem(
        id: 'electrical',
        name: {'en': 'Electrical Eng', 'ar': 'هندسة كهربائية'},
      ),
      TaxonomyItem(
        id: 'mechanical',
        name: {'en': 'Mechanical Eng', 'ar': 'هندسة ميكانيكية'},
      ),
    ],
    'medicine': [
      TaxonomyItem(
        id: 'general_medicine',
        name: {'en': 'General Medicine', 'ar': 'طب عام'},
      ),
      TaxonomyItem(id: 'nursing', name: {'en': 'Nursing', 'ar': 'التمريض'}),
      TaxonomyItem(id: 'pharmacy', name: {'en': 'Pharmacy', 'ar': 'الصيدلة'}),
      TaxonomyItem(
        id: 'dentistry',
        name: {'en': 'Dentistry', 'ar': 'طب الأسنان'},
      ),
      TaxonomyItem(
        id: 'physical_therapy',
        name: {'en': 'Physical Therapy', 'ar': 'علاج طبيعي'},
      ),
    ],
    'business': [
      TaxonomyItem(
        id: 'accounting',
        name: {'en': 'Accounting', 'ar': 'المحاسبة'},
      ),
      TaxonomyItem(
        id: 'marketing',
        name: {'en': 'Marketing', 'ar': 'التسويق والمبيعات'},
      ),
      TaxonomyItem(
        id: 'hr',
        name: {'en': 'Human Resources', 'ar': 'الموارد البشرية'},
      ),
      TaxonomyItem(
        id: 'management',
        name: {'en': 'Project Management', 'ar': 'إدارة المشاريع'},
      ),
    ],
    'education': [
      TaxonomyItem(id: 'teaching', name: {'en': 'Teaching', 'ar': 'التدريس'}),
      TaxonomyItem(
        id: 'counseling',
        name: {'en': 'Counseling', 'ar': 'إرشاد تربوي'},
      ),
      TaxonomyItem(
        id: 'special_ed',
        name: {'en': 'Special Education', 'ar': 'التربية الخاصة'},
      ),
    ],
  };

  static List<TaxonomyItem> getSubSectors(String sectorId) {
    return subSectors[sectorId] ?? [];
  }
}
