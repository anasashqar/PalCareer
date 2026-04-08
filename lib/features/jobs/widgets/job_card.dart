import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lucide_icons/lucide_icons.dart';
import 'package:palcareer/l10n/generated/app_localizations.dart';

import '../../../../shared/models/job_model.dart';
import '../../bookmarks/providers/bookmarks_provider.dart';

IconData? getJobIcon(String title) {
  final t = title.toLowerCase();
  if (t.contains('flutter') || t.contains('react') || t.contains('developer') || t.contains('software') || t.contains('backend') || t.contains('frontend') || t.contains('fullstack') || t.contains('engineer') || t.contains('programmer') || t.contains('مطور') || t.contains('مبرمج') || t.contains('هندسة') || t.contains('مهندس') || t.contains('برمجة')) {
    return LucideIcons.code;
  }
  if (t.contains('design') || t.contains('ui') || t.contains('ux') || t.contains('graphic') || t.contains('art') || t.contains('مصمم') || t.contains('تصميم')) {
    return LucideIcons.penTool;
  }
  if (t.contains('data') || t.contains('analyst') || t.contains('analytics') || t.contains('database') || t.contains('machine learning') || t.contains('بيانات') || t.contains('محلل') || t.contains('ذكاء')) {
    return LucideIcons.database;
  }
  if (t.contains('market') || t.contains('sales') || t.contains('seo') || t.contains('social') || t.contains('تسويق') || t.contains('مبيعات')) {
    return LucideIcons.megaphone;
  }
  if (t.contains('manag') || t.contains('product') || t.contains('project') || t.contains('director') || t.contains('مدير') || t.contains('إدارة') || t.contains('ادارة')) {
    return LucideIcons.briefcase;
  }
  if (t.contains('hr') || t.contains('human') || t.contains('recruit') || t.contains('talent') || t.contains('موارد') || t.contains('توظيف') || t.contains('بشرية')) {
    return LucideIcons.users;
  }
  if (t.contains('finance') || t.contains('account') || t.contains('audit') || t.contains('bank') || t.contains('محاسب') || t.contains('مالية')) {
    return LucideIcons.calculator;
  }
  if (t.contains('support') || t.contains('customer') || t.contains('service') || t.contains('دعم') || t.contains('عملاء')) {
    return LucideIcons.headphones;
  }
  if (t.contains('teacher') || t.contains('education') || t.contains('tutor') || t.contains('مدرس') || t.contains('معلم') || t.contains('تعليم')) {
    return LucideIcons.graduationCap;
  }
  if (t.contains('health') || t.contains('medic') || t.contains('nurse') || t.contains('doctor') || t.contains('طبيب') || t.contains('ممرض') || t.contains('صحة') || t.contains('طب')) {
    return LucideIcons.stethoscope;
  }
  if (t.contains('security') || t.contains('cyber') || t.contains('guard') || t.contains('أمن') || t.contains('حماية')) {
    return LucideIcons.shield;
  }
  if (t.contains('write') || t.contains('content') || t.contains('copy') || t.contains('كاتب') || t.contains('محتوى') || t.contains('تحرير')) {
    return LucideIcons.fileText;
  }
  if (t.contains('video') || t.contains('media') || t.contains('فيديو') || t.contains('ميديا') || t.contains('تصوير')) {
    return LucideIcons.video;
  }
  return null;
}

class JobCardWidget extends StatefulWidget {
  final JobModel job;
  final VoidCallback onTap;

  const JobCardWidget({super.key, required this.job, required this.onTap});

  @override
  State<JobCardWidget> createState() => _JobCardWidgetState();
}

class _JobCardWidgetState extends State<JobCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context)!;

    final expiresAt = widget.job.expiresAt;
    final now = DateTime.now();
    bool isNew = widget.job.isNew;

    int daysUntilExpiry = expiresAt.difference(now).inDays;
    bool isExpired = expiresAt.isBefore(now);
    final isUrgent = (!isExpired && daysUntilExpiry <= 3 && !isNew);

    // Get first letter of company for logo placeholder
    final companyInitial = widget.job.company.isNotEmpty
        ? widget.job.company.substring(0, 1).toUpperCase()
        : 'C';

    // Dynamic avatar styling
    final bgColors = [
      const Color(0xFFE3F2FD), // Light Blue
      const Color(0xFFF3E5F5), // Light Purple
      const Color(0xFFE8F5E9), // Light Green
      const Color(0xFFFFF3E0), // Light Orange
      const Color(0xFFFFEBEE), // Light Red
      const Color(0xFFE0F7FA), // Light Cyan
      const Color(0xFFFFF8E1), // Light Amber
      const Color(0xFFECEFF1), // Light Blue Grey
    ];
    final fgColors = [
      const Color(0xFF1976D2),
      const Color(0xFF7B1FA2),
      const Color(0xFF388E3C),
      const Color(0xFFF57C00),
      const Color(0xFFD32F2F),
      const Color(0xFF0097A7),
      const Color(0xFFFFA000),
      const Color(0xFF455A64),
    ];
    
    int colorIndex = widget.job.company.hashCode.abs() % bgColors.length;
    final avatarBgColor = bgColors[colorIndex];
    final avatarFgColor = fgColors[colorIndex];

    // Attempt to map an icon from the title
    final titleString = '${widget.job.title['en'] ?? ''} ${widget.job.title['ar'] ?? ''}';
    final jobIcon = getJobIcon(titleString);

    return GestureDetector(
      onTapDown: (_) => _animController.forward(),
      onTapUp: (_) {
        _animController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _animController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            margin: const EdgeInsets.only(bottom: 10, left: 16, right: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.outlineVariant.withValues(alpha: 0.1),
                width: 1.0,
              ),
              boxShadow: _animController.isAnimating
                  ? []
                  : [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.03),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: child,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Company / Category Avatar
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: avatarBgColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: avatarFgColor.withValues(alpha: 0.1),
                    ),
                  ),
                  child: jobIcon != null
                      ? Icon(jobIcon, color: avatarFgColor, size: 24)
                      : Text(
                          companyInitial,
                          style: TextStyle(
                            fontFamily: 'Alexandria',
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: avatarFgColor,
                          ),
                        ),
                ),
                const SizedBox(width: 12),
                // Title and Company Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.job.getLocalizedTitle(langCode),
                        style: TextStyle(
                          fontFamily: 'Alexandria',
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).colorScheme.onSurface,
                          height: 1.25,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.job.company} • ${widget.job.getLocalizedLocation(langCode)}',
                        style: TextStyle(
                          fontFamily: 'Alexandria',
                          fontSize: 13,
                          fontWeight: isUrgent ? FontWeight.bold : FontWeight.w600,
                          color: isUrgent ? const Color(0xFFD32F2F) : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Save/Bookmark Icon
                const SizedBox(width: 8),
                Consumer(
                  builder: (context, ref, _) {
                    final isSaved = ref
                        .watch(bookmarksProvider)
                        .contains(widget.job.id);
                    return GestureDetector(
                      onTap: () {
                        ref
                            .read(bookmarksProvider.notifier)
                            .toggleBookmark(widget.job.id);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          isSaved
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                          color: isSaved
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).colorScheme.outline,
                          size: 24,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Footer: Tags & New Badge
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      _MetadataChip(
                        label: widget.job.getLocalizedJobType(langCode),
                      ),
                      _MetadataChip(label: widget.job.level),
                    ],
                  ),
                ),
                if (widget.job.isNew)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9), // Light green
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.auto_awesome,
                          size: 12,
                          color: Color(0xFF2E7D32),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.newBadge,
                          style: const TextStyle(
                            fontFamily: 'Alexandria',
                            color: Color(0xFF2E7D32),
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isExpired ? Icons.error_outline : Icons.timer_outlined,
                        size: 12,
                        color: isExpired
                            ? Theme.of(context).colorScheme.error
                            : (isUrgent
                                  ? const Color(0xFFD32F2F)
                                  : Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isExpired
                            ? (langCode == 'ar' ? 'انتهى التقديم' : 'Expired')
                            : (langCode == 'ar'
                                  ? 'ينتهي بعد $daysUntilExpiry يوم'
                                  : 'Expires in ${daysUntilExpiry}d'),
                        style: TextStyle(
                          fontFamily: 'Alexandria',
                          fontSize: 11,
                          fontWeight: isUrgent ? FontWeight.bold : FontWeight.w600,
                          color: isExpired
                              ? Theme.of(context).colorScheme.error
                              : (isUrgent ? const Color(0xFFD32F2F) : Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetadataChip extends StatelessWidget {
  final String label;

  const _MetadataChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Alexandria',
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ).copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    );
  }
}
