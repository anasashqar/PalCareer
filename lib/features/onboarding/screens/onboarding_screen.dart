import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:palcareer/l10n/generated/app_localizations.dart';

import '../../../shared/models/career_taxonomy.dart';
import '../../../core/providers/taxonomy_provider.dart';
import '../providers/onboarding_provider.dart';
import '../../jobs/providers/jobs_provider.dart';

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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Navigation & Progress Indicator
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Row(
                children: [
                  AnimatedOpacity(
                    opacity: _currentPage > 0 ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      onPressed: _currentPage > 0 ? _previousPage : null,
                    ),
                  ),
                  const Spacer(),
                  // Animated Page Indicator (3 Steps now)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(3, (index) {
                      final isSelected = _currentPage == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: isSelected ? 32 : 8,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48), // Spacer to balance back button
                ],
              ),
            ),

            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _StepOneSector(onNext: _nextPage),
                  _StepTwoSpecialization(onNext: _nextPage),
                  const _StepThreePreferences(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Step 1: Main Sector
// -----------------------------------------------------------------------------
class _StepOneSector extends ConsumerWidget {
  final VoidCallback onNext;

  const _StepOneSector({required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);
    final langCode = Localizations.localeOf(context).languageCode;
    final taxonomyAsync = ref.watch(taxonomyProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            langCode == 'ar'
                ? 'ما هو قطاعك المهني؟'
                : 'What is your career sector?', // dynamic if no l10n entry
            style: TextStyle(fontFamily: 'Alexandria',
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).colorScheme.primary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            langCode == 'ar'
                ? 'اختر مجالك الرئيسي لنقوم بتخصيص باقي الخيارات.'
                : 'Select your main field to customize your experience.',
            style: TextStyle(fontFamily: 'Alexandria',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),

          if (taxonomyAsync.hasValue)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: taxonomyAsync.value!.sectors.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final sector = taxonomyAsync.value!.sectors[index];
                return _SelectionCard(
                label: sector.getLocalizedName(langCode),
                icon: sector.icon,
                isSelected: state.selectedSector == sector.id,
                onTap: () => notifier.setSector(sector.id),
              );
            },
          ),

          const SizedBox(height: 64),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.isStep1Complete ? onNext : null,
              style: _primaryButtonStyle(context),
              child: Text(
                l10n.nextBtn,
                style: const TextStyle(fontFamily: 'Alexandria',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Step 2: Specializations
// -----------------------------------------------------------------------------
class _StepTwoSpecialization extends ConsumerWidget {
  final VoidCallback onNext;

  const _StepTwoSpecialization({required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);
    final langCode = Localizations.localeOf(context).languageCode;
    final taxonomyAsync = ref.watch(taxonomyProvider);

    final subSectors = state.selectedSector != null && taxonomyAsync.hasValue
        ? taxonomyAsync.value!.subSectors[state.selectedSector!] ?? <TaxonomyItem>[]
        : <TaxonomyItem>[];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            langCode == 'ar'
                ? 'أين تجد نفسك تحديداً؟'
                : 'Where do you specialize?',
            style: TextStyle(fontFamily: 'Alexandria',
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).colorScheme.primary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            langCode == 'ar'
                ? 'يمكنك اختيار أكثر من تخصص لتنويع فرصك.'
                : 'You can select multiple specializations.',
            style: TextStyle(fontFamily: 'Alexandria',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),

          if (subSectors.isEmpty)
            Text(
              langCode == 'ar'
                  ? 'لا يوجد تخصصات متوفرة لهذا القطاع حالياً.'
                  : 'No specializations available.',
              style: TextStyle(fontFamily: 'Alexandria',color: Theme.of(context).colorScheme.error),
            )
          else
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: subSectors.map((sub) {
                final isSelected = state.fieldsOfStudy.contains(sub.id);
                return _TagCard(
                  label: sub.getLocalizedName(langCode),
                  isSelected: isSelected,
                  onTap: () => notifier.toggleFieldOfStudy(sub.id),
                );
              }).toList(),
            ),

          const SizedBox(height: 64),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.isStep2Complete ? onNext : null,
              style: _primaryButtonStyle(context),
              child: Text(
                l10n.nextBtn,
                style: const TextStyle(fontFamily: 'Alexandria',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Step 3: Preferences & Level
// -----------------------------------------------------------------------------
class _StepThreePreferences extends ConsumerStatefulWidget {
  const _StepThreePreferences();

  @override
  ConsumerState<_StepThreePreferences> createState() =>
      _StepThreePreferencesState();
}

class _StepThreePreferencesState extends ConsumerState<_StepThreePreferences> {
  bool _isLoading = false;

  void _finishOnboarding() async {
    setState(() => _isLoading = true);
    await ref.read(onboardingProvider.notifier).saveAndComplete();
    
    // Clear search and filters so they land on a fresh Tiered Feed
    ref.invalidate(searchQueryProvider);
    ref.invalidate(contractTypeProvider);
    ref.invalidate(workModeProvider);
    ref.invalidate(experienceLevelProvider);
    ref.invalidate(datePostedProvider);

    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);
    final langCode = Localizations.localeOf(context).languageCode;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            langCode == 'ar' ? 'الخطوة الأخيرة!' : 'Final Step!',
            style: TextStyle(fontFamily: 'Alexandria',
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).colorScheme.primary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            langCode == 'ar'
                ? 'أخبرنا عن مستواك وتفضيلات العمل لتصلك الفرص المناسبة.'
                : 'Share your level and work preferences.',
            style: TextStyle(fontFamily: 'Alexandria',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),

          _SectionHeader(
            icon: Icons.school_rounded,
            title: l10n.onboardingAcademic,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _SelectionCardSimple(
                  label: l10n.student,
                  isSelected: state.academicLevel == 'student',
                  onTap: () => notifier.setAcademicLevel('student'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _SelectionCardSimple(
                  label: l10n.freshGraduate,
                  isSelected: state.academicLevel == 'graduate',
                  onTap: () => notifier.setAcademicLevel('graduate'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          _SectionHeader(
            icon: Icons.work_history_rounded,
            title: l10n.onboardingWorkType,
            color: Theme.of(context).colorScheme.tertiary,
          ),
          const SizedBox(height: 16),
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

          const SizedBox(height: 64),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.isStep3Complete && !_isLoading
                  ? _finishOnboarding
                  : null,
              style: _primaryButtonStyle(context),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      l10n.saveFinishBtn,
                      style: const TextStyle(fontFamily: 'Alexandria',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Helper Widgets
// -----------------------------------------------------------------------------

ButtonStyle _primaryButtonStyle(BuildContext context) {
  return ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Theme.of(context).colorScheme.onPrimary,
    padding: const EdgeInsets.symmetric(vertical: 14),
    elevation: 4,
    shadowColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  );
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            title,
            style: TextStyle(fontFamily: 'Alexandria',
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
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
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.secondary.withValues(alpha: 0.12)
              : Theme.of(context).colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            else
              BoxShadow(
                color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
          ],
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2)
                      : Theme.of(context).colorScheme.surfaceContainerLow,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: isSelected
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontFamily: 'Alexandria',
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected
                      ? Theme.of(context).colorScheme.onSurface
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: Theme.of(context).colorScheme.secondary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}

class _SelectionCardSimple extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectionCardSimple({
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
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.secondary.withValues(alpha: 0.12)
              : Theme.of(context).colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Alexandria',
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
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
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
            width: 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              )
            else
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(fontFamily: 'Alexandria',
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
