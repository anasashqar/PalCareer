import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palcareer/l10n/generated/app_localizations.dart';

import '../../../core/theme/app_colors.dart';
import '../providers/onboarding_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != _currentPage) {
        setState(() {
          _currentPage = page;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Navigation & Progress Indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Row(
                children: [
                  AnimatedOpacity(
                    opacity: _currentPage > 0 ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onSurface),
                      onPressed: _currentPage > 0 ? _previousPage : null,
                    ),
                  ),
                  const Spacer(),
                  // Animated Page Indicator (Extending Dots)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(2, (index) {
                      final isSelected = _currentPage == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: isSelected ? 32 : 8,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.outlineVariant.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48), // To balance the back button
                ],
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Text(
                l10n.onboardingWelcome,
                style: GoogleFonts.cairo(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  height: 1.3,
                ),
              ),
            ),
            
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _StepOneWidget(onNext: _nextPage),
                  const _StepTwoWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepOneWidget extends ConsumerWidget {
  final VoidCallback onNext;

  const _StepOneWidget({required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            icon: Icons.school_rounded,
            title: l10n.onboardingAcademic,
            color: AppColors.secondary,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _SelectionCard(
                  label: l10n.student,
                  icon: Icons.auto_stories_rounded,
                  isSelected: state.academicLevel == 'student',
                  onTap: () => notifier.setAcademicLevel('student'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _SelectionCard(
                  label: l10n.freshGraduate,
                  icon: Icons.workspace_premium_rounded,
                  isSelected: state.academicLevel == 'graduate',
                  onTap: () => notifier.setAcademicLevel('graduate'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          
          _SectionHeader(
            icon: Icons.category_rounded,
            title: l10n.onboardingField,
            color: AppColors.primary,
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _TagCard(
                label: l10n.fieldIt,
                isSelected: state.fieldOfStudy == 'it',
                onTap: () => notifier.setFieldOfStudy('it'),
              ),
              _TagCard(
                label: l10n.fieldEngineering,
                isSelected: state.fieldOfStudy == 'engineering',
                onTap: () => notifier.setFieldOfStudy('engineering'),
              ),
              _TagCard(
                label: l10n.fieldBusiness,
                isSelected: state.fieldOfStudy == 'business',
                onTap: () => notifier.setFieldOfStudy('business'),
              ),
              _TagCard(
                label: l10n.fieldAccounting,
                isSelected: state.fieldOfStudy == 'accounting',
                onTap: () => notifier.setFieldOfStudy('accounting'),
              ),
            ],
          ),
          
          const SizedBox(height: 64),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.isStep1Complete ? onNext : null,
              style: _primaryButtonStyle(),
              child: Text(l10n.nextBtn, style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _StepTwoWidget extends ConsumerStatefulWidget {
  const _StepTwoWidget();

  @override
  ConsumerState<_StepTwoWidget> createState() => _StepTwoWidgetState();
}

class _StepTwoWidgetState extends ConsumerState<_StepTwoWidget> {
  bool _isLoading = false;

  void _finishOnboarding() async {
    setState(() => _isLoading = true);
    await ref.read(onboardingProvider.notifier).saveAndComplete();
    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            icon: Icons.work_history_rounded,
            title: l10n.onboardingWorkType,
            color: AppColors.tertiary,
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _TagCard(
                label: l10n.fullTime,
                isSelected: state.preferredWorkTypes.contains('full_time'),
                onTap: () => notifier.toggleWorkType('full_time'),
              ),
              _TagCard(
                label: l10n.partTime,
                isSelected: state.preferredWorkTypes.contains('part_time'),
                onTap: () => notifier.toggleWorkType('part_time'),
              ),
              _TagCard(
                label: l10n.remote,
                isSelected: state.preferredWorkTypes.contains('remote'),
                onTap: () => notifier.toggleWorkType('remote'),
              ),
            ],
          ),
          
          const SizedBox(height: 80), // To push button down slightly in scroll view
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.isStep2Complete && !_isLoading ? _finishOnboarding : null,
              style: _primaryButtonStyle(),
              child: _isLoading 
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text(l10n.saveFinishBtn, style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// Helper Widgets

ButtonStyle _primaryButtonStyle() {
  return ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.onPrimary,
    padding: const EdgeInsets.symmetric(vertical: 14),
    elevation: 4,
    shadowColor: AppColors.primary.withValues(alpha: 0.4),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  );
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _SectionHeader({required this.icon, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

class _SelectionCard extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectionCard({
    required this.label,
    this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary.withValues(alpha: 0.12) : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.secondary : AppColors.outlineVariant.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: AppColors.onSurface.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            else
               BoxShadow(
                color: AppColors.secondary.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              )
          ],
        ),
        child: Column(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 28,
                color: isSelected ? AppColors.secondary : AppColors.onSurfaceVariant.withValues(alpha: 0.6),
              ),
              const SizedBox(height: 12),
            ],
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? AppColors.onSurface : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TagCard extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TagCard({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outlineVariant.withValues(alpha: 0.5),
            width: 1,
          ),
          boxShadow: [
            if (isSelected)
               BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              )
          ],
        ),
        child: Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
