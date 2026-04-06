import 'package:flutter/foundation.dart';

@immutable
class SubCategoryModel {
  final String id;
  final String categoryId;
  final Map<String, String> name;
  final bool isActive;

  const SubCategoryModel({
    required this.id,
    required this.categoryId,
    required this.name,
    this.isActive = true,
  });

  String getLocalizedName(String languageCode) {
    return name[languageCode] ?? name['en'] ?? 'Unknown SubCategory';
  }

  SubCategoryModel copyWith({
    String? id,
    String? categoryId,
    Map<String, String>? name,
    bool? isActive,
  }) {
    return SubCategoryModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
    );
  }

  factory SubCategoryModel.fromMap(Map<String, dynamic> map, String id) {
    return SubCategoryModel(
      id: id,
      categoryId: map['categoryId'] as String? ?? '',
      name: Map<String, String>.from(map['name'] ?? {}),
      isActive: map['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'name': name,
      'isActive': isActive,
    };
  }
}
