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
  final Map<String, String>? description;
  final Map<String, List<String>> requirements;
  final Map<String, List<String>> responsibilities;
  final String applyUrl;
  
  // Client-side fields only
  final bool isPerfectMatch;

  const JobModel({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.types,
    required this.postedAt,
    this.description,
    required this.requirements,
    required this.responsibilities,
    required this.applyUrl,
    this.isPerfectMatch = false,
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
    Map<String, String>? description,
    Map<String, List<String>>? requirements,
    Map<String, List<String>>? responsibilities,
    String? applyUrl,
    bool? isPerfectMatch,
  }) {
    return JobModel(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      location: location ?? this.location,
      types: types ?? this.types,
      postedAt: postedAt ?? this.postedAt,
      description: description ?? this.description,
      requirements: requirements ?? this.requirements,
      responsibilities: responsibilities ?? this.responsibilities,
      applyUrl: applyUrl ?? this.applyUrl,
      isPerfectMatch: isPerfectMatch ?? this.isPerfectMatch,
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
      description: map['description'] != null ? Map<String, String>.from(map['description']) : null,
      requirements: (map['requirements'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, List<String>.from(value)),
          ) ?? {},
      responsibilities: (map['responsibilities'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, List<String>.from(value)),
          ) ?? {},
      applyUrl: map['applyUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'company': company,
      'location': location,
      'types': types,
      'postedAt': Timestamp.fromDate(postedAt),
      'description': description,
      'requirements': requirements,
      'responsibilities': responsibilities,
      'applyUrl': applyUrl,
    };
  }
}
