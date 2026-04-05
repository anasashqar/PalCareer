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

  String _getLocalizedHeader(String titleId, String langCode) {
    if (langCode == 'ar') {
      switch (titleId) {
        case 'perfect_matches': return '🔥 الأنسب لاختياراتك';
        case 'sector_matches': return '💡 مقترحات أخرى في مجالك';
        case 'explore_jobs': return '🌍 استكشف وظائف منوعة';
        default: return titleId;
      }
    } else {
      switch (titleId) {
        case 'perfect_matches': return '🔥 Top Matches For You';
        case 'sector_matches': return '💡 Other in your field';
        case 'explore_jobs': return '🌍 Explore More Jobs';
        default: return titleId;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final jobsAsyncValue = ref.watch(jobsProvider);
    final l10n = AppLocalizations.of(context)!;
    final langCode = Localizations.localeOf(context).languageCode;

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
              backgroundColor: AppColors.surface.withValues(alpha: 0.95),
              surfaceTintColor: Colors.transparent,
              expandedHeight: 120,
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 16, left: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))
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
                  ],
                ),
              ),
            ),
            
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
              data: (groups) {
                if (groups.isEmpty) {
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
                
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, groupIndex) {
                      final group = groups[groupIndex];
                      
                      // For the very last group, add bottom padding
                      final isLastGroup = groupIndex == groups.length - 1;
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Group Header
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                            child: Text(
                              _getLocalizedHeader(group.titleId, langCode),
                              style: GoogleFonts.cairo(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: group.titleId == 'perfect_matches' ? AppColors.secondary : AppColors.onSurface,
                              ),
                            ),
                          ),
                          
                          // Jobs List in this group
                          ...group.jobs.asMap().entries.map((entry) {
                            final jobIndex = entry.key;
                            final job = entry.value;
                            
                            // Calculate global index for animation delay roughly
                            int globalIndex = jobIndex;
                            for (var i = 0; i < groupIndex; i++) {
                              globalIndex += groups[i].jobs.length;
                            }
                            
                            return TweenAnimationBuilder<double>(
                              // Add a distinct key per job so the widget tree animates them correctly
                              key: ValueKey(job.id),
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration: Duration(milliseconds: 400 + (globalIndex * 80).clamp(0, 600)),
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
                          }),
                          
                          if (isLastGroup)
                            const SizedBox(height: 120), // Bottom padding for navbar
                        ],
                      );
                    },
                    childCount: groups.length,
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
          color: isSelected ? AppColors.primary : AppColors.outlineVariant.withValues(alpha: 0.4),
          width: 1.2,
        ),
        boxShadow: isSelected 
            ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.35), blurRadius: 12, offset: const Offset(0, 6))] 
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
