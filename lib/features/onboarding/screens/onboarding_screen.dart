import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:palcareer/l10n/generated/app_localizations.dart';

import '../providers/onboarding_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              Text(
                l10n.onboardingWelcome,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 48),
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


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.onboardingAcademic,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _SelectionCard(
                label: l10n.student,
                isSelected: state.academicLevel == 'student',
                onTap: () => notifier.setAcademicLevel('student'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _SelectionCard(
                label: l10n.freshGraduate,
                isSelected: state.academicLevel == 'graduate',
                onTap: () => notifier.setAcademicLevel('graduate'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Text(
          l10n.onboardingField,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
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
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: state.isStep1Complete ? onNext : null,
            child: Text(l10n.nextBtn),
          ),
        ),
      ],
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.onboardingWorkType,
          style: Theme.of(context).textTheme.titleLarge,
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
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: state.isStep2Complete && !_isLoading ? _finishOnboarding : null,
            child: _isLoading 
              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Text(l10n.saveFinishBtn),
          ),
        ),
      ],
    );
  }
}

class _SelectionCard extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectionCard({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primaryContainer.withOpacity(0.3) : colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            width: 2,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isSelected ? colorScheme.primary : colorScheme.onSurface,
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
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
              ),
        ),
      ),
    );
  }
}
