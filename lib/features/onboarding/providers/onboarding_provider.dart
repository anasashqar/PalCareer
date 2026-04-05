import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingState {
  final String? academicLevel;
  final String? fieldOfStudy;
  final List<String> preferredWorkTypes;

  OnboardingState({
    this.academicLevel,
    this.fieldOfStudy,
    this.preferredWorkTypes = const [],
  });

  bool get isStep1Complete => academicLevel != null && fieldOfStudy != null;
  bool get isStep2Complete => preferredWorkTypes.isNotEmpty;

  OnboardingState copyWith({
    String? academicLevel,
    String? fieldOfStudy,
    List<String>? preferredWorkTypes,
  }) {
    return OnboardingState(
      academicLevel: academicLevel ?? this.academicLevel,
      fieldOfStudy: fieldOfStudy ?? this.fieldOfStudy,
      preferredWorkTypes: preferredWorkTypes ?? this.preferredWorkTypes,
    );
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(OnboardingState());

  void setAcademicLevel(String level) {
    state = state.copyWith(academicLevel: level);
  }

  void setFieldOfStudy(String field) {
    state = state.copyWith(fieldOfStudy: field);
  }

  void toggleWorkType(String type) {
    final current = List<String>.from(state.preferredWorkTypes);
    if (current.contains(type)) {
      current.remove(type);
    } else {
      current.add(type);
    }
    state = state.copyWith(preferredWorkTypes: current);
  }

  Future<void> saveAndComplete() async {
    // In V1 Firebase implementation, we would save to Firestore here.
    // For now, it's a mock delay.
    await Future.delayed(const Duration(seconds: 1));
  }
}

final onboardingProvider = StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier();
});
