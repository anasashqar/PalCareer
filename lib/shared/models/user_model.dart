import 'package:flutter/foundation.dart';

@immutable
class UserModel {
  final String uid;
  final String displayName;
  final String email;
  final String? photoUrl;
  final String? educationLevelId;
  final List<String> preferredCategoryIds;
  final List<String> preferredSubCategoryIds;
  final List<String> preferredJobTypes;
  final String? fcmToken;
  final bool pushEnabled;

  const UserModel({
    required this.uid,
    required this.displayName,
    required this.email,
    this.photoUrl,
    this.educationLevelId,
    this.preferredCategoryIds = const [],
    this.preferredSubCategoryIds = const [],
    this.preferredJobTypes = const [],
    this.fcmToken,
    this.pushEnabled = true,
  });

  UserModel copyWith({
    String? uid,
    String? displayName,
    String? email,
    String? photoUrl,
    String? educationLevelId,
    List<String>? preferredCategoryIds,
    List<String>? preferredSubCategoryIds,
    List<String>? preferredJobTypes,
    String? fcmToken,
    bool? pushEnabled,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      educationLevelId: educationLevelId ?? this.educationLevelId,
      preferredCategoryIds: preferredCategoryIds ?? this.preferredCategoryIds,
      preferredSubCategoryIds:
          preferredSubCategoryIds ?? this.preferredSubCategoryIds,
      preferredJobTypes: preferredJobTypes ?? this.preferredJobTypes,
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
      educationLevelId: map['educationLevelId'] as String?,
      preferredCategoryIds: List<String>.from(
        map['preferredCategoryIds'] ?? [],
      ),
      preferredSubCategoryIds: List<String>.from(
        map['preferredSubCategoryIds'] ?? [],
      ),
      preferredJobTypes: List<String>.from(map['preferredJobTypes'] ?? []),
      fcmToken: map['fcmToken'] as String?,
      pushEnabled: map['pushEnabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'educationLevelId': educationLevelId,
      'preferredCategoryIds': preferredCategoryIds,
      'preferredSubCategoryIds': preferredSubCategoryIds,
      'preferredJobTypes': preferredJobTypes,
      'fcmToken': fcmToken,
      'pushEnabled': pushEnabled,
    };
  }
}
