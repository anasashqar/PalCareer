import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:palcareer/l10n/generated/app_localizations.dart';

import '../providers/jobs_provider.dart';
import '../widgets/job_card.dart';

class JobsFeedScreen extends ConsumerWidget {
  const JobsFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsAsyncValue = ref.watch(jobsProvider);
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              elevation: 0,
              backgroundColor: colorScheme.background,
              actions: [
                IconButton(
                  icon: Icon(Icons.notifications_none, color: colorScheme.onSurface),
                  onPressed: () => context.push('/notifications'),
                ),
                const SizedBox(width: 8),
              ],
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.jobsHomeTitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  jobsAsyncValue.maybeWhen(
                    data: (jobs) => Text(
                      '${jobs.length} ${l10n.availableJobs}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    orElse: () => const SizedBox.shrink(),
                  ),
                ],
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    children: [
                      _FilterChip(label: l10n.fieldIt, isSelected: true),
                      const SizedBox(width: 8),
                      _FilterChip(label: l10n.remote, isSelected: false),
                      const SizedBox(width: 8),
                      _FilterChip(label: l10n.fullTime, isSelected: false),
                    ],
                  ),
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
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final job = jobs[index];
                      return JobCardWidget(
                        job: job,
                        onTap: () => context.push('/job-details', extra: job),
                      );
                    },
                    childCount: jobs.length,
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => SliverFillRemaining(
                child: Center(child: Text('Error: $err')),
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

  const _FilterChip({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? colorScheme.primary : colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
            ),
      ),
    );
  }
}
