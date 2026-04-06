import 'package:flutter/foundation.dart';

@immutable
class IconModel {
  final String id;
  final Map<String, String> name;
  final String flutterIdentifier;

  const IconModel({
    required this.id,
    required this.name,
    required this.flutterIdentifier,
  });

  String getLocalizedName(String languageCode) {
    return name[languageCode] ?? name['en'] ?? 'Unknown Icon';
  }

  IconModel copyWith({
    String? id,
    Map<String, String>? name,
    String? flutterIdentifier,
  }) {
    return IconModel(
      id: id ?? this.id,
      name: name ?? this.name,
      flutterIdentifier: flutterIdentifier ?? this.flutterIdentifier,
    );
  }

  factory IconModel.fromMap(Map<String, dynamic> map, String id) {
    return IconModel(
      id: id,
      name: Map<String, String>.from(map['name'] ?? {}),
      flutterIdentifier: map['flutterIdentifier'] as String? ?? 'Icons.error',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'flutterIdentifier': flutterIdentifier,
    };
  }
}
