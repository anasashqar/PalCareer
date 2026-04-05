import 'package:flutter/foundation.dart';

@immutable
class UserModel {
  final String uid;
  final String displayName;
  final String email;
  final String? photoUrl;
  final String? academicLevel;
  final String? primarySector;
  final List<String> specialties;
  final List<String> workTypes;
  final String? fcmToken;
  final bool pushEnabled;

  const UserModel({
    required this.uid,
    required this.displayName,
    required this.email,
    this.photoUrl,
    this.academicLevel,
    this.primarySector,
    this.specialties = const [],
    this.workTypes = const [],
    this.fcmToken,
    this.pushEnabled = true,
  });

  UserModel copyWith({
    String? uid,
    String? displayName,
    String? email,
    String? photoUrl,
    String? academicLevel,
    String? primarySector,
    List<String>? specialties,
    List<String>? workTypes,
    String? fcmToken,
    bool? pushEnabled,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      academicLevel: academicLevel ?? this.academicLevel,
      primarySector: primarySector ?? this.primarySector,
      specialties: specialties ?? this.specialties,
      workTypes: workTypes ?? this.workTypes,
      fcmToken: fcmToken ?? this.fcmToken,
      pushEnabled: pushEnabled ?? this.pushEnabled,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      uid: id,
      displayName: map['displayName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      photoUrl: map['photoUrl'] as String?,
      academicLevel: map['academicLevel'] as String?,
      primarySector: map['primarySector'] as String?,
      specialties: List<String>.from(map['specialties'] ?? []),
      workTypes: List<String>.from(map['workTypes'] ?? []),
      fcmToken: map['fcmToken'] as String?,
      pushEnabled: map['pushEnabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'academicLevel': academicLevel,
      'primarySector': primarySector,
      'specialties': specialties,
      'workTypes': workTypes,
      'fcmToken': fcmToken,
      'pushEnabled': pushEnabled,
    };
  }
}
