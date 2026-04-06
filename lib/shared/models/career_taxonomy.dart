import 'package:flutter/material.dart';

class TaxonomyItem {
  final String id;
  final Map<String, String> name;
  final String? iconString;

  const TaxonomyItem({required this.id, required this.name, this.iconString});

  String getLocalizedName(String langCode) {
    return name[langCode] ?? name['en'] ?? id;
  }

  factory TaxonomyItem.fromJson(Map<String, dynamic> json) {
    return TaxonomyItem(
      id: json['id'] as String,
      name: Map<String, String>.from(json['name'] as Map),
      iconString: json['icon'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'icon': iconString};
  }

  IconData? get icon {
    switch (iconString) {
      case 'computer_rounded':
        return Icons.computer_rounded;
      case 'precision_manufacturing_rounded':
        return Icons.precision_manufacturing_rounded;
      case 'medical_services_rounded':
        return Icons.medical_services_rounded;
      case 'business_center_rounded':
        return Icons.business_center_rounded;
      case 'school_rounded':
        return Icons.school_rounded;
      default:
        return Icons.category_rounded;
    }
  }
}

class CareerTaxonomy {
  final List<TaxonomyItem> sectors;
  final Map<String, List<TaxonomyItem>> subSectors;

  const CareerTaxonomy({this.sectors = const [], this.subSectors = const {}});

  factory CareerTaxonomy.fromJson(Map<String, dynamic> json) {
    var rawSectors = json['sectors'] as List? ?? [];
    List<TaxonomyItem> parsedSectors = rawSectors
        .map((e) => TaxonomyItem.fromJson(e as Map<String, dynamic>))
        .toList();

    var rawSubSectors = json['subSectors'] as Map<String, dynamic>? ?? {};
    Map<String, List<TaxonomyItem>> parsedSub = {};
    rawSubSectors.forEach((key, value) {
      if (value is List) {
        parsedSub[key] = value
            .map((e) => TaxonomyItem.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    });

    return CareerTaxonomy(sectors: parsedSectors, subSectors: parsedSub);
  }

  Map<String, dynamic> toJson() {
    return {
      'sectors': sectors.map((e) => e.toJson()).toList(),
      'subSectors': subSectors.map(
        (key, value) => MapEntry(key, value.map((e) => e.toJson()).toList()),
      ),
    };
  }

  List<TaxonomyItem> getSubSectors(String sectorId) {
    return subSectors[sectorId] ?? [];
  }

  static CareerTaxonomy get fallback {
    return const CareerTaxonomy(
      sectors: [
        TaxonomyItem(
          id: 'it',
          name: {'en': 'Tech & IT', 'ar': 'تقنية المعلومات'},
          iconString: 'computer_rounded',
        ),
        TaxonomyItem(
          id: 'engineering',
          name: {'en': 'Engineering', 'ar': 'الهندسة'},
          iconString: 'precision_manufacturing_rounded',
        ),
        TaxonomyItem(
          id: 'medicine',
          name: {'en': 'Healthcare', 'ar': 'الطب والصحة'},
          iconString: 'medical_services_rounded',
        ),
        TaxonomyItem(
          id: 'business',
          name: {'en': 'Business & Finance', 'ar': 'الأعمال والمالية'},
          iconString: 'business_center_rounded',
        ),
        TaxonomyItem(
          id: 'education',
          name: {'en': 'Education', 'ar': 'التعليم'},
          iconString: 'school_rounded',
        ),
      ],
      subSectors: {
        'it': [
          TaxonomyItem(id: 'software_dev', name: {'en': 'Software Dev', 'ar': 'تطوير البرمجيات'}),
          TaxonomyItem(id: 'mobile_dev', name: {'en': 'Mobile Apps', 'ar': 'تطبيقات الموبايل'}),
          TaxonomyItem(id: 'web_dev', name: {'en': 'Web Dev', 'ar': 'تطوير الويب'}),
          TaxonomyItem(id: 'data_ai', name: {'en': 'Data & AI', 'ar': 'بيانات وذكاء اصطناعي'}),
          TaxonomyItem(id: 'networks', name: {'en': 'Networks & Security', 'ar': 'الشبكات والحماية'}),
          TaxonomyItem(id: 'design_ux', name: {'en': 'UI/UX Design', 'ar': 'تصميم واجهات'}),
        ],
        'engineering': [
          TaxonomyItem(id: 'civil', name: {'en': 'Civil Eng', 'ar': 'هندسة مدنية'}),
          TaxonomyItem(id: 'architecture', name: {'en': 'Architecture', 'ar': 'هندسة معمارية'}),
          TaxonomyItem(id: 'electrical', name: {'en': 'Electrical Eng', 'ar': 'هندسة كهربائية'}),
          TaxonomyItem(id: 'mechanical', name: {'en': 'Mechanical Eng', 'ar': 'هندسة ميكانيكية'}),
        ],
        'medicine': [
          TaxonomyItem(id: 'general_medicine', name: {'en': 'General Medicine', 'ar': 'طب عام'}),
          TaxonomyItem(id: 'nursing', name: {'en': 'Nursing', 'ar': 'التمريض'}),
          TaxonomyItem(id: 'pharmacy', name: {'en': 'Pharmacy', 'ar': 'الصيدلة'}),
          TaxonomyItem(id: 'dentistry', name: {'en': 'Dentistry', 'ar': 'طب الأسنان'}),
          TaxonomyItem(id: 'physical_therapy', name: {'en': 'Physical Therapy', 'ar': 'علاج طبيعي'}),
        ],
        'business': [
          TaxonomyItem(id: 'accounting', name: {'en': 'Accounting', 'ar': 'المحاسبة'}),
          TaxonomyItem(id: 'marketing', name: {'en': 'Marketing', 'ar': 'التسويق والمبيعات'}),
          TaxonomyItem(id: 'hr', name: {'en': 'Human Resources', 'ar': 'الموارد البشرية'}),
          TaxonomyItem(id: 'management', name: {'en': 'Project Management', 'ar': 'إدارة المشاريع'}),
        ],
        'education': [
          TaxonomyItem(id: 'teaching', name: {'en': 'Teaching', 'ar': 'التدريس'}),
          TaxonomyItem(id: 'counseling', name: {'en': 'Counseling', 'ar': 'إرشاد تربوي'}),
          TaxonomyItem(id: 'special_ed', name: {'en': 'Special Education', 'ar': 'التربية الخاصة'}),
        ],
      },
    );
  }
}
