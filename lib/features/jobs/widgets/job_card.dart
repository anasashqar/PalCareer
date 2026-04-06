import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palcareer/l10n/generated/app_localizations.dart';

import '../../../../shared/models/job_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../bookmarks/providers/bookmarks_provider.dart';

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
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.outlineVariant.withValues(alpha: 0.1),
                width: 1.0,
              ),
              boxShadow: _animController.isAnimating
                  ? []
                  : [
                      BoxShadow(
                        color: AppColors.onSurface.withValues(alpha: 0.03),
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
                // Company Logo Placeholder
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.05),
                    ),
                  ),
                  child: Text(
                    companyInitial,
                    style: GoogleFonts.cairo(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
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
                        style: GoogleFonts.cairo(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.onSurface,
                          height: 1.25,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.job.company} • ${widget.job.getLocalizedLocation(langCode)}',
                        style: GoogleFonts.cairo(
                          color: isUrgent
                              ? const Color(0xFFD32F2F)
                              : AppColors.onSurfaceVariant,
                          fontWeight: isUrgent
                              ? FontWeight.bold
                              : FontWeight.w600,
                          fontSize: 13,
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
                              ? AppColors.secondary
                              : AppColors.outline,
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
                          style: GoogleFonts.cairo(
                            color: const Color(0xFF2E7D32),
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
                            ? AppColors.error
                            : (isUrgent
                                  ? const Color(0xFFD32F2F)
                                  : AppColors.onSurfaceVariant),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isExpired
                            ? (langCode == 'ar' ? 'انتهى التقديم' : 'Expired')
                            : (langCode == 'ar'
                                  ? 'ينتهي بعد $daysUntilExpiry يوم'
                                  : 'Expires in ${daysUntilExpiry}d'),
                        style: GoogleFonts.cairo(
                          color: isExpired
                              ? AppColors.error
                              : (isUrgent
                                    ? const Color(0xFFD32F2F)
                                    : AppColors.onSurfaceVariant),
                          fontWeight: isUrgent
                              ? FontWeight.bold
                              : FontWeight.w600,
                          fontSize: 11,
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
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.cairo(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurfaceVariant,
        ),
      ),
    );
  }
}
