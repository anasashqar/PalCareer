import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingState {
  final String? selectedSector;
  final String? academicLevel;
  final List<String> fieldsOfStudy;
  final List<String> preferredWorkTypes;

  OnboardingState({
    this.selectedSector,
    this.academicLevel,
    this.fieldsOfStudy = const [],
    this.preferredWorkTypes = const [],
  });

  bool get isStep1Complete => selectedSector != null;
  bool get isStep2Complete => fieldsOfStudy.isNotEmpty;
  bool get isStep3Complete => academicLevel != null && preferredWorkTypes.isNotEmpty;

  OnboardingState copyWith({
    String? selectedSector,
    String? academicLevel,
    List<String>? fieldsOfStudy,
    List<String>? preferredWorkTypes,
  }) {
    return OnboardingState(
      selectedSector: selectedSector ?? this.selectedSector,
      academicLevel: academicLevel ?? this.academicLevel,
      fieldsOfStudy: fieldsOfStudy ?? this.fieldsOfStudy,
      preferredWorkTypes: preferredWorkTypes ?? this.preferredWorkTypes,
    );
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(OnboardingState());

  void setSector(String sector) {
    if (state.selectedSector != sector) {
      state = state.copyWith(selectedSector: sector, fieldsOfStudy: []);
    }
  }

  void setAcademicLevel(String level) {
    state = state.copyWith(academicLevel: level);
  }

  void toggleFieldOfStudy(String field) {
    final current = List<String>.from(state.fieldsOfStudy);
    if (current.contains(field)) {
      current.remove(field);
    } else {
      current.add(field);
    }
    state = state.copyWith(fieldsOfStudy: current);
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
