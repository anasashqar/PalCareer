import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palcareer/l10n/generated/app_localizations.dart';

import '../../../../core/theme/app_colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Mock data based directly on the provided user image mapped into standard textual sentences
    final List<Map<String, dynamic>> mockNotifications = [
      {
        'title': 'مطور أندرويد أول (Senior)',
        'company': 'شركة جوال (Jawwal)',
        'time': 'منذ ساعة',
        'isUnread': true,
      },
      {
        'title': 'مهندس برمجيات (Android SDK)',
        'company': 'عسل للتكنولوجيا (Asal Technologies)',
        'time': 'منذ 3 ساعات',
        'isUnread': false,
      },
      {
        'title': 'مطور تطبيقات جوال (Flutter)',
        'company': 'شركة حضارة',
        'time': 'منذ 6 ساعات',
        'isUnread': false,
      },
      {
        'title': 'مطور أندرويد متدرب',
        'company': 'ستارت أب بال (StartUp Pal)',
        'time': 'منذ يوم واحد',
        'isUnread': false,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.surface, // Flat clean background
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          l10n.notificationsTitle,
          style: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.onSurface,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: AppColors.outlineVariant.withValues(alpha: 0.2),
            height: 1.0,
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: mockNotifications.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          thickness: 1,
          color: AppColors.outlineVariant.withValues(alpha: 0.15),
        ),
        itemBuilder: (context, index) {
          final notif = mockNotifications[index];
          return _NotificationTile(
            title: notif['title'],
            company: notif['company'],
            time: notif['time'],
            isUnread: notif['isUnread'],
          );
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final String title;
  final String company;
  final String time;
  final bool isUnread;

  const _NotificationTile({
    required this.title,
    required this.company,
    required this.time,
    required this.isUnread,
  });

  @override
  Widget build(BuildContext context) {
    // Generate a simple first letter for the logo
    final String companyInitial = company.isNotEmpty
        ? company.substring(0, 1).toUpperCase()
        : 'C';

    return InkWell(
      onTap: () {
        // Handle navigation to job details
      },
      child: Container(
        color: isUnread
            ? AppColors.secondary.withValues(alpha: 0.08)
            : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Circular Avatar for company
            CircleAvatar(
              radius: 26,
              backgroundColor: AppColors.primaryContainer.withValues(
                alpha: 0.4,
              ),
              child: Text(
                companyInitial,
                style: GoogleFonts.cairo(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        color: AppColors.onSurface,
                        height: 1.5,
                      ),
                      children: [
                        const TextSpan(text: 'نشرت '),
                        TextSpan(
                          text: company,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        const TextSpan(text: ' وظيفة جديدة قد تناسبك: '),
                        TextSpan(
                          text: title,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    time,
                    style: GoogleFonts.cairo(
                      fontSize: 13,
                      color: isUnread
                          ? AppColors.primary
                          : AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Unread Dot Indicator
            if (isUnread)
              Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(top: 8),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
