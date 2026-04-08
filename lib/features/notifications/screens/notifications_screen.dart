import 'package:flutter/material.dart';

import 'package:palcareer/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/notifications_provider.dart';
import '../../../shared/models/notification_model.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Set up Arabic timeago locale if needed (timeago package supports it)
    timeago.setLocaleMessages('ar', timeago.ArMessages());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(notificationsProvider.notifier).fetchMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          l10n.notificationsTitle,
          style: TextStyle(
            fontFamily: 'Alexandria',
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        actions: [
          if (state.notifications.isNotEmpty && state.notifications.any((n) => n.isUnread))
            IconButton(
              icon: Icon(
                Icons.done_all,
                color: Theme.of(context).colorScheme.primary,
              ),
              tooltip: 'تحديد الكل كمقروء',
              onPressed: () {
                ref.read(notificationsProvider.notifier).markAllAsRead();
              },
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.2),
            height: 1.0,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(notificationsProvider.notifier).fetchInitial();
        },
        color: Theme.of(context).colorScheme.primary,
        child: _buildBody(context, state),
      ),
    );
  }

  Widget _buildBody(BuildContext context, NotificationsState state) {
    if (state.isLoading && state.notifications.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            const Text(
              'حدث خطأ في تحميل الإشعارات',
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => ref.read(notificationsProvider.notifier).fetchInitial(),
              child: const Text('إعادة المحاولة', style: TextStyle(fontFamily: 'Alexandria')),
            ),
          ],
        ),
      );
    }

    if (state.notifications.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_active_outlined,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'لا توجد إشعارات جديدة',
                  style: const TextStyle(
                    fontFamily: 'Alexandria',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ).copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
                const SizedBox(height: 8),
                Text(
                  'سنعلمك عند توفر وظائف تناسب تخصصك',
                  style: TextStyle(
                    fontFamily: 'Alexandria',
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      itemCount: state.notifications.length + (state.isFetchingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.notifications.length) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final notif = state.notifications[index];
        return _NotificationTile(
          notif: notif,
          onTap: () {
            ref.read(notificationsProvider.notifier).markAsRead(notif.job.id);
            context.push('/job-details', extra: notif.job);
          },
        );
      },
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel notif;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.notif,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final title = notif.job.getLocalizedTitle('ar');
    final company = notif.job.company;
    final time = timeago.format(notif.job.postedAt, locale: 'ar');
    final String companyInitial = company.isNotEmpty ? company.substring(0, 1).toUpperCase() : 'C';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notif.isUnread
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.05)
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: notif.isUnread
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
              : Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
        boxShadow: [
          if (notif.isUnread)
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Company Icon
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
                        Theme.of(context).colorScheme.primary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    companyInitial,
                    style: TextStyle(
                      fontFamily: 'Alexandria',
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              company,
                              style: const TextStyle(
                                fontFamily: 'Alexandria',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ).copyWith(color: Theme.of(context).colorScheme.primary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (notif.isUnread)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'وظيفة جديدة: $title',
                        style: TextStyle(
                          fontFamily: 'Alexandria',
                          fontSize: 15,
                          fontWeight: notif.isUnread ? FontWeight.w800 : FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            time,
                            style: TextStyle(
                              fontFamily: 'Alexandria',
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
