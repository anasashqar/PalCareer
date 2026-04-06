import 'package:flutter/foundation.dart';

@immutable
class EducationLevelModel {
  final String id;
  final Map<String, String> name;
  final int order;
  final bool isActive;

  const EducationLevelModel({
    required this.id,
    required this.name,
    required this.order,
    this.isActive = true,
  });

  String getLocalizedName(String languageCode) {
    return name[languageCode] ?? name['en'] ?? 'Unknown Level';
  }

  EducationLevelModel copyWith({
    String? id,
    Map<String, String>? name,
    int? order,
    bool? isActive,
  }) {
    return EducationLevelModel(
      id: id ?? this.id,
      name: name ?? this.name,
      order: order ?? this.order,
      isActive: isActive ?? this.isActive,
    );
  }

  factory EducationLevelModel.fromMap(Map<String, dynamic> map, String id) {
    return EducationLevelModel(
      id: id,
      name: Map<String, String>.from(map['name'] ?? {}),
      order: map['order'] as int? ?? 0,
      isActive: map['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'order': order, 'isActive': isActive};
  }
}
