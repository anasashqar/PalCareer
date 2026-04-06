import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@immutable
class JobModel {
  final String id;
  final Map<String, String> title;
  final String company;
  final Map<String, String> location;
  final DateTime postedAt;
  final DateTime expiresAt;
  final Map<String, String>? description;
  final Map<String, List<String>> requirements;
  final Map<String, List<String>> responsibilities;
  final String applyUrl;
  final String categoryId;
  final String subCategoryId;
  final String educationLevelId;
  final String iconId;
  final String jobType;
  final String level;
  final List<String> skills;
  final bool isActive;

  const JobModel({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.postedAt,
    required this.expiresAt,
    this.description,
    required this.requirements,
    required this.responsibilities,
    required this.applyUrl,
    required this.categoryId,
    required this.subCategoryId,
    required this.educationLevelId,
    required this.iconId,
    required this.jobType,
    required this.level,
    required this.skills,
    this.isActive = true,
  });

  bool get isNew {
    final now = DateTime.now();
    final difference = now.difference(postedAt).inDays;
    return difference <= 3;
  }

  String getLocalizedTitle(String languageCode) {
    return title[languageCode] ?? title['en'] ?? 'Unknown Position';
  }

  String getLocalizedLocation(String languageCode) {
    return location[languageCode] ?? location['en'] ?? 'Unknown Location';
  }

  String getLocalizedJobType(String languageCode) {
    if (languageCode == 'ar') {
      switch (jobType.toLowerCase()) {
        case 'full_time':
        case 'full-time':
          return 'دوام كامل';
        case 'part_time':
        case 'part-time':
          return 'دوام جزئي';
        case 'remote':
          return 'عن بُعد';
        case 'freelance':
          return 'عمل حر';
        case 'contract':
          return 'عقد';
        case 'internship':
          return 'تدريب';
        default:
          return jobType;
      }
    }
    // Format for English
    final words = jobType.replaceAll('_', ' ').replaceAll('-', ' ').split(' ');
    if (words.isEmpty) return jobType;
    return words
        .map(
          (w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '',
        )
        .join(' ');
  }

  String getLocalizedDescription(String languageCode) {
    if (description == null) return '';
    return description![languageCode] ?? description!['en'] ?? '';
  }

  List<String> getLocalizedRequirements(String languageCode) {
    return requirements[languageCode] ?? requirements['en'] ?? [];
  }

  List<String> getLocalizedResponsibilities(String languageCode) {
    return responsibilities[languageCode] ?? responsibilities['en'] ?? [];
  }

  JobModel copyWith({
    String? id,
    Map<String, String>? title,
    String? company,
    Map<String, String>? location,
    DateTime? postedAt,
    DateTime? expiresAt,
    Map<String, String>? description,
    Map<String, List<String>>? requirements,
    Map<String, List<String>>? responsibilities,
    String? applyUrl,
    String? categoryId,
    String? subCategoryId,
    String? educationLevelId,
    String? iconId,
    String? jobType,
    String? level,
    List<String>? skills,
    bool? isActive,
  }) {
    return JobModel(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      location: location ?? this.location,
      postedAt: postedAt ?? this.postedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      description: description ?? this.description,
      requirements: requirements ?? this.requirements,
      responsibilities: responsibilities ?? this.responsibilities,
      applyUrl: applyUrl ?? this.applyUrl,
      categoryId: categoryId ?? this.categoryId,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      educationLevelId: educationLevelId ?? this.educationLevelId,
      iconId: iconId ?? this.iconId,
      jobType: jobType ?? this.jobType,
      level: level ?? this.level,
      skills: skills ?? this.skills,
      isActive: isActive ?? this.isActive,
    );
  }

  factory JobModel.fromMap(Map<String, dynamic> map, String id) {
    return JobModel(
      id: id,
      title: Map<String, String>.from(map['title'] ?? {}),
      company: map['company'] as String? ?? 'Unknown Company',
      location: Map<String, String>.from(map['location'] ?? {}),
      postedAt: (map['postedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      expiresAt:
          (map['expiresAt'] as Timestamp?)?.toDate() ??
          DateTime.now().add(const Duration(days: 30)),
      description: map['description'] != null
          ? Map<String, String>.from(map['description'])
          : null,
      requirements:
          (map['requirements'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, List<String>.from(value)),
          ) ??
          {},
      responsibilities:
          (map['responsibilities'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, List<String>.from(value)),
          ) ??
          {},
      applyUrl: map['applyUrl'] as String? ?? '',
      categoryId: map['categoryId'] as String? ?? '',
      subCategoryId: map['subCategoryId'] as String? ?? '',
      educationLevelId: map['educationLevelId'] as String? ?? '',
      iconId: map['iconId'] as String? ?? '',
      jobType: map['jobType'] as String? ?? 'full_time',
      level: map['level'] as String? ?? 'mid',
      skills: List<String>.from(map['skills'] ?? []),
      isActive: map['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'company': company,
      'location': location,
      'postedAt': Timestamp.fromDate(postedAt),
      'expiresAt': Timestamp.fromDate(expiresAt),
      'description': description,
      'requirements': requirements,
      'responsibilities': responsibilities,
      'applyUrl': applyUrl,
      'categoryId': categoryId,
      'subCategoryId': subCategoryId,
      'educationLevelId': educationLevelId,
      'iconId': iconId,
      'jobType': jobType,
      'level': level,
      'skills': skills,
      'isActive': isActive,
    };
  }
}
