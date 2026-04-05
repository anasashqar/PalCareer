import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palcareer/l10n/generated/app_localizations.dart';

import '../../../../core/theme/app_colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Mock data based directly on the provided user image
    final List<Map<String, dynamic>> mockNotifications = [
      {
        'title': 'مطور أندرويد أول (Senior)',
        'company': 'شركة جوال (Jawwal)',
        'location': 'رام الله',
        'time': 'منذ ساعة',
        'isNew': true,
        'isUnread': true,
        'isExpired': false,
        'type': null,
      },
      {
        'title': 'مهندس برمجيات (Android SDK)',
        'company': 'عسل للتكنولوجيا (Asal Technologies)',
        'location': 'روابي',
        'time': 'منذ 3 ساعات',
        'isNew': false,
        'isUnread': false,
        'isExpired': false,
        'type': 'دوام كامل',
      },
      {
        'title': 'مطور تطبيقات جوال (Flutter)',
        'company': 'شركة حضارة',
        'location': 'غزة - عن بُعد',
        'time': 'منذ 6 ساعات',
        'isNew': false,
        'isUnread': false,
        'isExpired': false,
        'type': null,
      },
      {
        'title': 'مطور أندرويد متدرب',
        'company': 'ستارت أب بال (StartUp Pal)',
        'location': 'القدس',
        'time': 'منذ يوم واحد',
        'isNew': false,
        'isUnread': false,
        'isExpired': true, // This enables the expired disabled view
        'type': null,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.surface, // Apply the light tinted background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.onSurface),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        physics: const BouncingScrollPhysics(),
        children: [
          // Screen Header
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.notificationsTitle,
                  style: GoogleFonts.cairo(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.notificationsSubtitle,
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          // Notifications List
          ...mockNotifications.map((notif) => _NotificationCard(
                title: notif['title'],
                company: notif['company'],
                location: notif['location'],
                time: notif['time'],
                type: notif['type'],
                isNew: notif['isNew'],
                isUnread: notif['isUnread'],
                isExpired: notif['isExpired'],
              )),
              
          const SizedBox(height: 100), // Bottom spacing for navigation bar
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final String title;
  final String company;
  final String location;
  final String time;
  final String? type;
  final bool isNew;
  final bool isUnread;
  final bool isExpired;

  const _NotificationCard({
    required this.title,
    required this.company,
    required this.location,
    required this.time,
    this.type,
    required this.isNew,
    required this.isUnread,
    required this.isExpired,
  });

  @override
  Widget build(BuildContext context) {
    final Widget cardContent = Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Unread Line Indicator (Green edge)
              if (isUnread && !isExpired)
                Container(
                  width: 5,
                  color: AppColors.secondary, // Greenish color in The Civic Curator
                ),
              
              // Main content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text Column (Left/Center in RTL)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title & New Badge Row
                            Row(
                              children: [
                                if (isNew && !isExpired)
                                  Container(
                                    margin: const EdgeInsets.only(left: 12),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.secondary.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      AppLocalizations.of(context)!.newBadge,
                                      style: GoogleFonts.cairo(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.secondary,
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                Expanded(
                                  child: Text(
                                    title,
                                    style: GoogleFonts.cairo(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: isExpired ? AppColors.onSurfaceVariant : AppColors.onSurface,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            
                            // Company and Location
                            Text(
                              '$company • $location',
                              style: GoogleFonts.cairo(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            
                            const SizedBox(height: 12),
                            
                            // Bottom Metadata (Time and Type)
                            Row(
                              children: [
                                const Icon(Icons.access_time_rounded, size: 14, color: AppColors.outline),
                                const SizedBox(width: 4),
                                Text(
                                  time,
                                  style: GoogleFonts.cairo(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.outline,
                                  ),
                                ),
                                if (type != null) ...[
                                  const SizedBox(width: 12),
                                  const Icon(Icons.work_outline_rounded, size: 14, color: AppColors.outline),
                                  const SizedBox(width: 4),
                                  Text(
                                    type!,
                                    style: GoogleFonts.cairo(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.outline,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // Company Logo Box (Right)
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          isExpired ? Icons.business_rounded : Icons.code_rounded, // Mock icons
                          color: isExpired ? AppColors.outlineVariant : AppColors.primary,
                          size: 26,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Apply Expired State Styling (Faded and unclickable)
    if (isExpired) {
      return Opacity(
        opacity: 0.5,
        child: cardContent,
        // Notice no GestureDetector is wrapped here, so it is unclickable.
      );
    }

    // Normal Clickable Card
    return GestureDetector(
      onTap: () {
        // In the future: context.push('/job-details', extra: jobModel)
      },
      child: cardContent,
    );
  }
}
