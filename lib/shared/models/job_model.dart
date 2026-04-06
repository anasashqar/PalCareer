import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@immutable
class JobModel {
  final String id;
  final Map<String, String> title;
  final String company;
  final Map<String, String> location;
  final List<String> types; // e.g. full-time, remote
  final DateTime postedAt;
  final DateTime expiresAt;
  final Map<String, String>? description;
  final Map<String, List<String>> requirements;
  final Map<String, List<String>> responsibilities;
  final String applyUrl;
  
  final String? primarySector;
  final List<String> subSectors;

  const JobModel({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.types,
    required this.postedAt,
    required this.expiresAt,
    this.description,
    required this.requirements,
    required this.responsibilities,
    required this.applyUrl,
    this.primarySector,
    this.subSectors = const [],
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

  List<String> getLocalizedTypes(String languageCode) {
    if (languageCode == 'ar') {
      return types.map((type) {
        switch (type.toLowerCase()) {
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
            return type;
        }
      }).toList();
    }
    // Format for English
    return types.map((type) {
        final words = type.replaceAll('_', ' ').replaceAll('-', ' ').split(' ');
        if (words.isEmpty) return type;
        return words.map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '').join(' ');
    }).toList();
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
    List<String>? types,
    DateTime? postedAt,
    DateTime? expiresAt,
    Map<String, String>? description,
    Map<String, List<String>>? requirements,
    Map<String, List<String>>? responsibilities,
    String? applyUrl,
    String? primarySector,
    List<String>? subSectors,
  }) {
    return JobModel(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      location: location ?? this.location,
      types: types ?? this.types,
      postedAt: postedAt ?? this.postedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      description: description ?? this.description,
      requirements: requirements ?? this.requirements,
      responsibilities: responsibilities ?? this.responsibilities,
      applyUrl: applyUrl ?? this.applyUrl,
      primarySector: primarySector ?? this.primarySector,
      subSectors: subSectors ?? this.subSectors,
    );
  }

  factory JobModel.fromMap(Map<String, dynamic> map, String id) {
    return JobModel(
      id: id,
      title: Map<String, String>.from(map['title'] ?? {}),
      company: map['company'] as String? ?? 'Unknown Company',
      location: Map<String, String>.from(map['location'] ?? {}),
      types: List<String>.from(map['types'] ?? []),
      postedAt: (map['postedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      expiresAt: (map['expiresAt'] as Timestamp?)?.toDate() ?? DateTime.now().add(const Duration(days: 30)),
      description: map['description'] != null ? Map<String, String>.from(map['description']) : null,
      requirements: (map['requirements'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, List<String>.from(value)),
          ) ?? {},
      responsibilities: (map['responsibilities'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, List<String>.from(value)),
          ) ?? {},
      applyUrl: map['applyUrl'] as String? ?? '',
      primarySector: map['primarySector'] as String?,
      subSectors: List<String>.from(map['subSectors'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'company': company,
      'location': location,
      'types': types,
      'postedAt': Timestamp.fromDate(postedAt),
      'expiresAt': Timestamp.fromDate(expiresAt),
      'description': description,
      'requirements': requirements,
      'responsibilities': responsibilities,
      'applyUrl': applyUrl,
      'primarySector': primarySector,
      'subSectors': subSectors,
    };
  }
}
