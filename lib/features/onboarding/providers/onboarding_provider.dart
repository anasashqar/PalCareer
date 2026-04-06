import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/repositories/auth_repository.dart';
import '../../../shared/services/firestore_service.dart';
import '../../../core/constants/firestore_keys.dart';
import '../../../shared/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OnboardingState {
  final String? selectedSector;
  final String? academicLevel;
  final List<String> fieldsOfStudy;
  final List<String> preferredWorkTypes;
  final bool isLoading;
  final String? error;

  OnboardingState({
    this.selectedSector,
    this.academicLevel,
    this.fieldsOfStudy = const [],
    this.preferredWorkTypes = const [],
    this.isLoading = false,
    this.error,
  });

  bool get isStep1Complete => selectedSector != null;
  bool get isStep2Complete => fieldsOfStudy.isNotEmpty;
  bool get isStep3Complete => academicLevel != null && preferredWorkTypes.isNotEmpty;

  OnboardingState copyWith({
    String? selectedSector,
    String? academicLevel,
    List<String>? fieldsOfStudy,
    List<String>? preferredWorkTypes,
    bool? isLoading,
    String? error,
  }) {
    return OnboardingState(
      selectedSector: selectedSector ?? this.selectedSector,
      academicLevel: academicLevel ?? this.academicLevel,
      fieldsOfStudy: fieldsOfStudy ?? this.fieldsOfStudy,
      preferredWorkTypes: preferredWorkTypes ?? this.preferredWorkTypes,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final FirestoreService _firestoreService;
  final AuthRepository _authRepository;

  OnboardingNotifier(this._firestoreService, this._authRepository) : super(OnboardingState());

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
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final User? currentUser = _authRepository.currentUser;
      
      if (currentUser == null) {
        throw Exception('غير مصرح لك للقيام بهذه العملية.');
      }

      final userModel = UserModel(
        uid: currentUser.uid,
        displayName: currentUser.displayName ?? 'مستخدم',
        email: currentUser.email ?? '',
        photoUrl: currentUser.photoURL,
        educationLevelId: state.academicLevel,
        preferredCategoryIds: state.selectedSector != null ? [state.selectedSector!] : [],
        preferredSubCategoryIds: state.fieldsOfStudy,
        preferredJobTypes: state.preferredWorkTypes,
      );

      await _firestoreService.addDocument(
        FirestoreKeys.usersContent, 
        currentUser.uid, 
        userModel.toMap(),
      );

      state = state.copyWith(isLoading: false);
    } catch (e) {
      // Using e.toString() directly or stripping 'Exception: '
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      state = state.copyWith(isLoading: false, error: errorMessage);
      throw Exception(errorMessage);
    }
  }
}

final onboardingProvider = StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier(
    ref.watch(firestoreServiceProvider),
    ref.watch(authRepositoryProvider),
  );
});
