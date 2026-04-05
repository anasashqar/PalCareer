import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palcareer/l10n/generated/app_localizations.dart';

import '../../../core/theme/app_colors.dart';
import '../providers/jobs_provider.dart';
import '../widgets/job_card.dart';

class JobsFeedScreen extends ConsumerStatefulWidget {
  const JobsFeedScreen({super.key});

  @override
  ConsumerState<JobsFeedScreen> createState() => _JobsFeedScreenState();
}

class _JobsFeedScreenState extends ConsumerState<JobsFeedScreen> {
  int _selectedFilterIndex = 0;

  @override
  Widget build(BuildContext context) {
    final jobsAsyncValue = ref.watch(jobsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              elevation: 0,
              backgroundColor: AppColors.surface.withOpacity(0.95),
              surfaceTintColor: Colors.transparent,
              expandedHeight: 140,
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 16, left: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.notifications_none_rounded, color: AppColors.onSurface),
                    onPressed: () => context.push('/notifications'),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                expandedTitleScale: 1.0,
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.jobsHomeTitle,
                      style: GoogleFonts.cairo(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    jobsAsyncValue.maybeWhen(
                      data: (jobs) => Text(
                        '${jobs.length} ${l10n.availableJobs}',
                        style: GoogleFonts.cairo(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      orElse: () => const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
            
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Row(
                  children: [
                    _FilterChip(
                      label: l10n.fieldIt, 
                      isSelected: _selectedFilterIndex == 0,
                      onTap: () => setState(() => _selectedFilterIndex = 0),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: l10n.remote, 
                      isSelected: _selectedFilterIndex == 1,
                      onTap: () => setState(() => _selectedFilterIndex = 1),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: l10n.fullTime, 
                      isSelected: _selectedFilterIndex == 2,
                      onTap: () => setState(() => _selectedFilterIndex = 2),
                    ),
                  ],
                ),
              ),
            ),
            
            jobsAsyncValue.when(
              data: (jobs) {
                if (jobs.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        l10n.noJobs,
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          color: AppColors.onSurfaceVariant,
                        )
                      ),
                    ),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.only(bottom: 120), // Padding to clear the floating bottom nav
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final job = jobs[index];
                        return TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: Duration(milliseconds: 400 + (index * 80).clamp(0, 600)),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, 40 * (1 - value)),
                                child: child,
                              ),
                            );
                          },
                          child: JobCardWidget(
                            job: job,
                            onTap: () => context.push('/job-details', extra: job),
                          ),
                        );
                      },
                      childCount: jobs.length,
                    ),
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
              ),
              error: (err, stack) => SliverFillRemaining(
                child: Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.outlineVariant.withOpacity(0.4),
          width: 1.2,
        ),
        boxShadow: isSelected 
            ? [BoxShadow(color: AppColors.primary.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 6))] 
            : [],
      ),
      child: Text(
        label,
        style: GoogleFonts.cairo(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: isSelected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
        ),
      ),
    )); // Closed AnimatedContainer and GestureDetector properly
  }
}
