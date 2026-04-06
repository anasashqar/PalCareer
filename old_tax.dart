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
      name: {'en': 'Tech & IT', 'ar': '╪ز┘é┘┘è╪ر ╪د┘┘à╪╣┘┘ê┘à╪د╪ز'},
      icon: Icons.computer_rounded,
    ),
    TaxonomyItem(
      id: 'engineering',
      name: {'en': 'Engineering', 'ar': '╪د┘┘ç┘╪»╪│╪ر'},
      icon: Icons.precision_manufacturing_rounded,
    ),
    TaxonomyItem(
      id: 'medicine',
      name: {'en': 'Healthcare', 'ar': '╪د┘╪╖╪ذ ┘ê╪د┘╪╡╪ص╪ر'},
      icon: Icons.medical_services_rounded,
    ),
    TaxonomyItem(
      id: 'business',
      name: {'en': 'Business & Finance', 'ar': '╪د┘╪ث╪╣┘à╪د┘ ┘ê╪د┘┘à╪د┘┘è╪ر'},
      icon: Icons.business_center_rounded,
    ),
    TaxonomyItem(
      id: 'education',
      name: {'en': 'Education', 'ar': '╪د┘╪ز╪╣┘┘è┘à'},
      icon: Icons.school_rounded,
    ),
  ];

  static const Map<String, List<TaxonomyItem>> subSectors = {
    'it': [
      TaxonomyItem(
        id: 'software_dev',
        name: {'en': 'Software Dev', 'ar': '╪ز╪╖┘ê┘è╪▒ ╪د┘╪ذ╪▒┘à╪ش┘è╪د╪ز'},
      ),
      TaxonomyItem(
        id: 'mobile_dev',
        name: {'en': 'Mobile Apps', 'ar': '╪ز╪╖╪ذ┘è┘é╪د╪ز ╪د┘┘à┘ê╪ذ╪د┘è┘'},
      ),
      TaxonomyItem(id: 'web_dev', name: {'en': 'Web Dev', 'ar': '╪ز╪╖┘ê┘è╪▒ ╪د┘┘ê┘è╪ذ'}),
      TaxonomyItem(
        id: 'data_ai',
        name: {'en': 'Data & AI', 'ar': '╪ذ┘è╪د┘╪د╪ز ┘ê╪░┘â╪د╪ة ╪د╪╡╪╖┘╪د╪╣┘è'},
      ),
      TaxonomyItem(
        id: 'networks',
        name: {'en': 'Networks & Security', 'ar': '╪د┘╪┤╪ذ┘â╪د╪ز ┘ê╪د┘╪ص┘à╪د┘è╪ر'},
      ),
      TaxonomyItem(
        id: 'design_ux',
        name: {'en': 'UI/UX Design', 'ar': '╪ز╪╡┘à┘è┘à ┘ê╪د╪ش┘ç╪د╪ز'},
      ),
    ],
    'engineering': [
      TaxonomyItem(id: 'civil', name: {'en': 'Civil Eng', 'ar': '┘ç┘╪»╪│╪ر ┘à╪»┘┘è╪ر'}),
      TaxonomyItem(
        id: 'architecture',
        name: {'en': 'Architecture', 'ar': '┘ç┘╪»╪│╪ر ┘à╪╣┘à╪د╪▒┘è╪ر'},
      ),
      TaxonomyItem(
        id: 'electrical',
        name: {'en': 'Electrical Eng', 'ar': '┘ç┘╪»╪│╪ر ┘â┘ç╪▒╪ذ╪د╪خ┘è╪ر'},
      ),
      TaxonomyItem(
        id: 'mechanical',
        name: {'en': 'Mechanical Eng', 'ar': '┘ç┘╪»╪│╪ر ┘à┘è┘â╪د┘┘è┘â┘è╪ر'},
      ),
    ],
    'medicine': [
      TaxonomyItem(
        id: 'general_medicine',
        name: {'en': 'General Medicine', 'ar': '╪╖╪ذ ╪╣╪د┘à'},
      ),
      TaxonomyItem(id: 'nursing', name: {'en': 'Nursing', 'ar': '╪د┘╪ز┘à╪▒┘è╪╢'}),
      TaxonomyItem(id: 'pharmacy', name: {'en': 'Pharmacy', 'ar': '╪د┘╪╡┘è╪»┘╪ر'}),
      TaxonomyItem(
        id: 'dentistry',
        name: {'en': 'Dentistry', 'ar': '╪╖╪ذ ╪د┘╪ث╪│┘╪د┘'},
      ),
      TaxonomyItem(
        id: 'physical_therapy',
        name: {'en': 'Physical Therapy', 'ar': '╪╣┘╪د╪ش ╪╖╪ذ┘è╪╣┘è'},
      ),
    ],
    'business': [
      TaxonomyItem(
        id: 'accounting',
        name: {'en': 'Accounting', 'ar': '╪د┘┘à╪ص╪د╪│╪ذ╪ر'},
      ),
      TaxonomyItem(
        id: 'marketing',
        name: {'en': 'Marketing', 'ar': '╪د┘╪ز╪│┘ê┘è┘é ┘ê╪د┘┘à╪ذ┘è╪╣╪د╪ز'},
      ),
      TaxonomyItem(
        id: 'hr',
        name: {'en': 'Human Resources', 'ar': '╪د┘┘à┘ê╪د╪▒╪» ╪د┘╪ذ╪┤╪▒┘è╪ر'},
      ),
      TaxonomyItem(
        id: 'management',
        name: {'en': 'Project Management', 'ar': '╪ح╪»╪د╪▒╪ر ╪د┘┘à╪┤╪د╪▒┘è╪╣'},
      ),
    ],
    'education': [
      TaxonomyItem(id: 'teaching', name: {'en': 'Teaching', 'ar': '╪د┘╪ز╪»╪▒┘è╪│'}),
      TaxonomyItem(
        id: 'counseling',
        name: {'en': 'Counseling', 'ar': '╪ح╪▒╪┤╪د╪» ╪ز╪▒╪ذ┘ê┘è'},
      ),
      TaxonomyItem(
        id: 'special_ed',
        name: {'en': 'Special Education', 'ar': '╪د┘╪ز╪▒╪ذ┘è╪ر ╪د┘╪«╪د╪╡╪ر'},
      ),
    ],
  };

  static List<TaxonomyItem> getSubSectors(String sectorId) {
    return subSectors[sectorId] ?? [];
  }
}
