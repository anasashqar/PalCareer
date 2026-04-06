import 'package:flutter/foundation.dart';

@immutable
class CategoryModel {
  final String id;
  final Map<String, String> name;
  final String iconId;
  final int order;
  final bool isActive;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.iconId,
    required this.order,
    this.isActive = true,
  });

  String getLocalizedName(String languageCode) {
    return name[languageCode] ?? name['en'] ?? 'Unknown Category';
  }

  CategoryModel copyWith({
    String? id,
    Map<String, String>? name,
    String? iconId,
    int? order,
    bool? isActive,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      iconId: iconId ?? this.iconId,
      order: order ?? this.order,
      isActive: isActive ?? this.isActive,
    );
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map, String id) {
    return CategoryModel(
      id: id,
      name: Map<String, String>.from(map['name'] ?? {}),
      iconId: map['iconId'] as String? ?? '',
      order: map['order'] as int? ?? 0,
      isActive: map['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'iconId': iconId,
      'order': order,
      'isActive': isActive,
    };
  }
}
