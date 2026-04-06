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

  String _getLocalizedHeader(String titleId, String langCode) {
    if (langCode == 'ar') {
      switch (titleId) {
        case 'perfect_matches': return '🔥 الأنسب لاختياراتك';
        case 'sector_matches': return '💡 مقترحات أخرى في مجالك';
        case 'explore_jobs': return '🌍 استكشف وظائف منوعة';
        case 'search_results': return '🔍 نتائج البحث';
        default: return titleId;
      }
    } else {
      switch (titleId) {
        case 'perfect_matches': return '🔥 Top Matches For You';
        case 'sector_matches': return '💡 Other in your field';
        case 'explore_jobs': return '🌍 Explore More Jobs';
        case 'search_results': return '🔍 Search Results';
        default: return titleId;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final jobsAsyncValue = ref.watch(jobsProvider);
    final isFilterActive = ref.watch(contractTypeProvider) != null || ref.watch(workModeProvider) != null;
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

            // Search and Filter Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                        ),
                        child: TextField(
                          onChanged: (val) {
                             ref.read(searchQueryProvider.notifier).state = val;
                          },
                          decoration: InputDecoration(
                            hintText: langCode == 'ar' ? 'بحث عن المسمى الوظيفي أو الشركة...' : 'Search jobs or companies...',
                            hintStyle: GoogleFonts.cairo(color: AppColors.onSurfaceVariant, fontSize: 14),
                            prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                          style: GoogleFonts.cairo(color: AppColors.onSurface),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: isFilterActive ? AppColors.secondary : AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isFilterActive ? AppColors.secondary : AppColors.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.tune_rounded, 
                          color: isFilterActive ? Colors.white : AppColors.primary
                        ),
                        onPressed: () => _showFilterSheet(context),
                      ),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off_rounded, size: 64, color: AppColors.outlineVariant),
                          const SizedBox(height: 16),
                          Text(
                            langCode == 'ar' ? 'لا توجد نتائج مطابقة لبحثك' : 'No matches found',
                            style: GoogleFonts.cairo(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.onSurfaceVariant,
                            )
                          ),
                        ],
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
                            
                            final delayMs = (400 + globalIndex * 80).clamp(0, 600).toInt();
                            
                            return TweenAnimationBuilder<double>(
                              // Add a distinct key per job so the widget tree animates them correctly
                              key: ValueKey(job.id),
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration: Duration(milliseconds: delayMs),
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
                            const SizedBox(height: 16), // Light bottom padding
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

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _FilterSheetContent(),
    );
  }
}

class _FilterSheetContent extends ConsumerWidget {
  const _FilterSheetContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contractFilter = ref.watch(contractTypeProvider);
    final workModeFilter = ref.watch(workModeProvider);
    final langCode = Localizations.localeOf(context).languageCode;
    final isAr = langCode == 'ar';

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isAr ? "تصفية متطورة" : "Advanced Filters",
                style: GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primary),
              ),
              if (contractFilter != null || workModeFilter != null)
                TextButton(
                  onPressed: () {
                    ref.read(contractTypeProvider.notifier).state = null;
                    ref.read(workModeProvider.notifier).state = null;
                  },
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  child: Text(isAr ? 'مسح الكل' : 'Clear All', style: GoogleFonts.cairo(color: Colors.redAccent, fontWeight: FontWeight.w700)),
                )
            ],
          ),
          const SizedBox(height: 24),
          Text(isAr ? "طبيعة العمل" : "Work Mode", style: GoogleFonts.cairo(fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _FilterChip(
                label: isAr ? 'الكل' : 'All',
                isSelected: workModeFilter == null,
                onTap: () => ref.read(workModeProvider.notifier).state = null,
              ),
              _FilterChip(
                label: isAr ? 'عن بُعد' : 'Remote',
                isSelected: workModeFilter == 'remote',
                onTap: () => ref.read(workModeProvider.notifier).state = 'remote',
              ),
              _FilterChip(
                label: isAr ? 'مكتبي' : 'On-Site',
                isSelected: workModeFilter == 'on_site',
                onTap: () => ref.read(workModeProvider.notifier).state = 'on_site',
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(isAr ? "نوع العقد" : "Contract Type", style: GoogleFonts.cairo(fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _FilterChip(
                label: isAr ? 'الكل' : 'All',
                isSelected: contractFilter == null,
                onTap: () => ref.read(contractTypeProvider.notifier).state = null,
              ),
              _FilterChip(
                label: isAr ? 'دوام كامل' : 'Full Time',
                isSelected: contractFilter == 'full_time',
                onTap: () => ref.read(contractTypeProvider.notifier).state = 'full_time',
              ),
              _FilterChip(
                label: isAr ? 'دوام جزئي' : 'Part Time',
                isSelected: contractFilter == 'part_time',
                onTap: () => ref.read(contractTypeProvider.notifier).state = 'part_time',
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.secondary : AppColors.outlineVariant.withValues(alpha: 0.3)),
        ),
        child: Text(
          label,
          style: GoogleFonts.cairo(
            color: isSelected ? Colors.white : AppColors.onSurface,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
