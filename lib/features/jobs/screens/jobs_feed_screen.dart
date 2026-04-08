import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:palcareer/l10n/generated/app_localizations.dart';

import '../providers/jobs_provider.dart';
import '../widgets/job_card.dart';
import '../widgets/job_card_skeleton.dart';

class JobsFeedScreen extends ConsumerStatefulWidget {
  const JobsFeedScreen({super.key});

  @override
  ConsumerState<JobsFeedScreen> createState() => _JobsFeedScreenState();
}

class _JobsFeedScreenState extends ConsumerState<JobsFeedScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(jobsProvider.notifier).fetchJobs(fetchMore: true);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final jobsState = ref.watch(jobsProvider);
    final isFilterActive =
        ref.watch(contractTypeProvider) != null ||
        ref.watch(workModeProvider) != null ||
        ref.watch(experienceLevelProvider) != null ||
        ref.watch(datePostedProvider) != null;
    final l10n = AppLocalizations.of(context)!;
    final langCode = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(jobsProvider);
            await Future.delayed(const Duration(milliseconds: 600));
          },
          color: Theme.of(context).colorScheme.primary,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverAppBar(
                floating: true,
                pinned: true,
                elevation: 0,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surface.withValues(alpha: 0.95),
                surfaceTintColor: Colors.transparent,
                expandedHeight: 120,
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 16, left: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerLowest,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.notifications_none_rounded,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      onPressed: () => context.push('/notifications'),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  expandedTitleScale: 1.0,
                  title: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: langCode == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                    child: Text(
                      l10n.jobsHomeTitle,
                      style: TextStyle(
                        fontFamily: 'Alexandria',
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.onSurface,
                        letterSpacing: -0.5,
                      ),
                    ),
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
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .outlineVariant
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Consumer(
                            builder: (context, ref, _) {
                              final search = ref.watch(searchQueryProvider);
                              // Keep the local controller in sync ONLY IF it is completely out of sync textwise
                              // To avoid cursor jumping, we only set it if the entire word changed from outside.
                              if (_searchController.text != search &&
                                  (_searchController.text.trim().isEmpty ||
                                      search.isEmpty)) {
                                _searchController.text = search;
                              }

                              return TextField(
                                controller: _searchController,
                                onChanged: (val) {
                                  ref.read(searchQueryProvider.notifier).state =
                                      val;
                                },
                                decoration: InputDecoration(
                                  hintText: langCode == 'ar'
                                      ? 'بحث عن وظيفة...'
                                      : 'Search jobs...',
                                  hintStyle: TextStyle(fontFamily: 'Alexandria',
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                    fontSize: 14,
                                  ),
                                  prefixIcon: IconButton(
                                    icon: Icon(
                                      Icons.manage_accounts_rounded,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                    onPressed: () {
                                      // Using StatefulNavigationShell to jump to Profile Tab (index 2)
                                      try {
                                        final shell =
                                            StatefulNavigationShell.of(context);
                                        shell.goBranch(2);
                                      } catch (e) {
                                        context.push('/profile');
                                      }
                                    },
                                    tooltip: langCode == 'ar'
                                        ? 'حسابي'
                                        : 'My Account',
                                  ),
                                  suffixIcon: search.isNotEmpty
                                      ? IconButton(
                                          icon: Icon(
                                            Icons.close_rounded,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurfaceVariant,
                                          ),
                                          onPressed: () {
                                            _searchController.clear();
                                            ref
                                                    .read(
                                                      searchQueryProvider
                                                          .notifier,
                                                    )
                                                    .state =
                                                '';
                                          },
                                        )
                                      : Icon(
                                          Icons.search_rounded,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                                style: TextStyle(fontFamily: 'Alexandria',
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: isFilterActive
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isFilterActive
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).colorScheme.outlineVariant
                                      .withValues(alpha: 0.3),
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.tune_rounded,
                            color: isFilterActive
                                ? Colors.white
                                : Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () => _showFilterSheet(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (jobsState.isLoading && jobsState.isEmpty)
                SliverFillRemaining(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 24, bottom: 24),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return const JobCardSkeleton();
                    },
                  ),
                )
              else if (jobsState.error != null && jobsState.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Text('Error: ${jobsState.error}', style: const TextStyle(color: Colors.red)),
                  ),
                )
              else if (jobsState.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 64,
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          langCode == 'ar' ? 'لا توجد نتائج مطابقة لبحثك' : 'No matches found',
                          style: TextStyle(fontFamily: 'Alexandria',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else ...[
                if (jobsState.bestMatches.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
                      child: Text(
                        langCode == 'ar' ? '🔥 الأنسب لاختياراتك' : '🔥 Top Matches',
                        style: TextStyle(fontFamily: 'Alexandria',
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final job = jobsState.bestMatches[index];
                        return _buildAnimatedJobCard(context, job);
                      },
                      childCount: jobsState.bestMatches.length,
                    ),
                  ),
                ],
                if (jobsState.goodMatches.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                      child: Text(
                        langCode == 'ar' ? '💡 مقترحات أخرى في مجالك' : '💡 Suggestions In Your Field',
                        style: TextStyle(fontFamily: 'Alexandria',
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final job = jobsState.goodMatches[index];
                        return _buildAnimatedJobCard(context, job);
                      },
                      childCount: jobsState.goodMatches.length,
                    ),
                  ),
                ],
                if (jobsState.otherJobs.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                      child: Text(
                        langCode == 'ar' ? '🔭 استكشف وظائف متنوعة' : '🔭 Explore Diverse Jobs',
                        style: TextStyle(fontFamily: 'Alexandria',
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final job = jobsState.otherJobs[index];
                        return _buildAnimatedJobCard(context, job);
                      },
                      childCount: jobsState.otherJobs.length,
                    ),
                  ),
                ],
                SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: jobsState.isFetchingMore
                          ? const CircularProgressIndicator()
                          : (jobsState.hasRechedEnd && !jobsState.isEmpty
                              ? Text(
                                  langCode == 'ar' ? 'نهاية الوظائف' : 'End of jobs',
                                  style: TextStyle(fontFamily: 'Alexandria',color: Theme.of(context).colorScheme.onSurfaceVariant),
                                )
                              : const SizedBox.shrink()),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
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
    final experienceFilter = ref.watch(experienceLevelProvider);
    final dateFilter = ref.watch(datePostedProvider);
    final langCode = Localizations.localeOf(context).languageCode;
    final isAr = langCode == 'ar';

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isAr ? 'تصفية متطورة' : 'Advanced Filters',
                    style: TextStyle(fontFamily: 'Alexandria',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  if (contractFilter != null ||
                      workModeFilter != null ||
                      experienceFilter != null ||
                      dateFilter != null)
                    TextButton(
                      onPressed: () {
                        ref.read(contractTypeProvider.notifier).state = null;
                        ref.read(workModeProvider.notifier).state = null;
                        ref.read(experienceLevelProvider.notifier).state = null;
                        ref.read(datePostedProvider.notifier).state = null;
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        isAr ? 'مسح الكل' : 'Clear All',
                        style: TextStyle(fontFamily: 'Alexandria',
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                isAr ? 'طبيعة العمل' : 'Work Mode',
                style: TextStyle(fontFamily: 'Alexandria',
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _FilterChip(
                    label: isAr ? 'الكل' : 'All',
                    isSelected: workModeFilter == null,
                    onTap: () =>
                        ref.read(workModeProvider.notifier).state = null,
                  ),
                  _FilterChip(
                    label: isAr ? 'عن بُعد' : 'Remote',
                    isSelected: workModeFilter == 'remote',
                    onTap: () =>
                        ref.read(workModeProvider.notifier).state = 'remote',
                  ),
                  _FilterChip(
                    label: isAr ? 'مكتبي' : 'On-Site',
                    isSelected: workModeFilter == 'on_site',
                    onTap: () =>
                        ref.read(workModeProvider.notifier).state = 'on_site',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                isAr ? 'مستوى الخبرة' : 'Experience Level',
                style: TextStyle(fontFamily: 'Alexandria',
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _FilterChip(
                    label: isAr ? 'الكل' : 'All',
                    isSelected: experienceFilter == null,
                    onTap: () =>
                        ref.read(experienceLevelProvider.notifier).state = null,
                  ),
                  _FilterChip(
                    label: isAr ? 'مبتدئ' : 'Junior',
                    isSelected: experienceFilter == 'junior',
                    onTap: () =>
                        ref.read(experienceLevelProvider.notifier).state =
                            'junior',
                  ),
                  _FilterChip(
                    label: isAr ? 'متوسط' : 'Mid-Level',
                    isSelected: experienceFilter == 'mid',
                    onTap: () =>
                        ref.read(experienceLevelProvider.notifier).state =
                            'mid',
                  ),
                  _FilterChip(
                    label: isAr ? 'خبير' : 'Senior',
                    isSelected: experienceFilter == 'senior',
                    onTap: () =>
                        ref.read(experienceLevelProvider.notifier).state =
                            'senior',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                isAr ? 'نوع العقد' : 'Contract Type',
                style: TextStyle(fontFamily: 'Alexandria',
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _FilterChip(
                    label: isAr ? 'الكل' : 'All',
                    isSelected: contractFilter == null,
                    onTap: () =>
                        ref.read(contractTypeProvider.notifier).state = null,
                  ),
                  _FilterChip(
                    label: isAr ? 'دوام كامل' : 'Full Time',
                    isSelected: contractFilter == 'full_time',
                    onTap: () => ref.read(contractTypeProvider.notifier).state =
                        'full_time',
                  ),
                  _FilterChip(
                    label: isAr ? 'دوام جزئي' : 'Part Time',
                    isSelected: contractFilter == 'part_time',
                    onTap: () => ref.read(contractTypeProvider.notifier).state =
                        'part_time',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                isAr ? 'تاريخ النشر' : 'Date Posted',
                style: TextStyle(fontFamily: 'Alexandria',
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _FilterChip(
                    label: isAr ? 'الكل' : 'Anytime',
                    isSelected: dateFilter == null,
                    onTap: () =>
                        ref.read(datePostedProvider.notifier).state = null,
                  ),
                  _FilterChip(
                    label: isAr ? 'آخر 24 ساعة' : 'Past 24h',
                    isSelected: dateFilter == 'past_24h',
                    onTap: () => ref.read(datePostedProvider.notifier).state =
                        'past_24h',
                  ),
                  _FilterChip(
                    label: isAr ? 'آخر أسبوع' : 'Past Week',
                    isSelected: dateFilter == 'past_week',
                    onTap: () => ref.read(datePostedProvider.notifier).state =
                        'past_week',
                  ),
                  _FilterChip(
                    label: isAr ? 'آخر شهر' : 'Past Month',
                    isSelected: dateFilter == 'past_month',
                    onTap: () => ref.read(datePostedProvider.notifier).state =
                        'past_month',
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(
                    context,
                  ).colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(fontFamily: 'Alexandria',
            color: isSelected
                ? Colors.white
                : Theme.of(context).colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

Widget _buildAnimatedJobCard(BuildContext context, dynamic job) {
  return TweenAnimationBuilder<double>(
    key: ValueKey(job.id),
    tween: Tween(begin: 0.0, end: 1.0),
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeOutCubic,
    builder: (context, value, child) {
      return Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: child,
        ),
      );
    },
    child: JobCardWidget(
      job: job,
      onTap: () => context.push('/job-details', extra: job),
    ),
  );
}
