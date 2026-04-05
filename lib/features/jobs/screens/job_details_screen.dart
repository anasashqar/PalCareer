import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:palcareer/l10n/generated/app_localizations.dart';

import '../../../../shared/models/job_model.dart';
import '../../../../core/theme/app_colors.dart';

class JobDetailsScreen extends StatelessWidget {
  final JobModel job;

  const JobDetailsScreen({super.key, required this.job});

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(job.applyUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch ${job.applyUrl}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final langCode = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: AppColors.surface,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface.withOpacity(0.8),
              shape: BoxShape.circle,
              boxShadow: [
                 BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
              ]
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onSurface, size: 22),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(top: 100, bottom: 120),
            physics: const BouncingScrollPhysics(),
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(28),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: AppColors.outlineVariant.withOpacity(0.3), width: 1.5),
                  boxShadow: [
                    BoxShadow(color: AppColors.primary.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 8))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.getLocalizedTitle(langCode),
                      style: GoogleFonts.cairo(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.business_rounded, size: 18, color: AppColors.primary),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          job.company,
                          style: GoogleFonts.cairo(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _MetaPill(icon: Icons.location_on_rounded, label: job.getLocalizedLocation(langCode)),
                        ...job.types.map((t) => _MetaPill(icon: Icons.access_time_rounded, label: t)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),
              
              // Requirements
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  l10n.jobRequirements,
                  style: GoogleFonts.cairo(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ...job.getLocalizedRequirements(langCode).map((req) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check_rounded, size: 14, color: AppColors.secondary),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            req,
                            style: GoogleFonts.cairo(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurfaceVariant,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),

              const SizedBox(height: 36),

              // Responsibilities
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  l10n.jobResponsibilities,
                  style: GoogleFonts.cairo(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ...job.getLocalizedResponsibilities(langCode).map((res) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.keyboard_arrow_left_rounded, size: 14, color: AppColors.primary),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            res,
                            style: GoogleFonts.cairo(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurfaceVariant,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),

          // Floating Apply Button
          Positioned(
            left: 24,
            right: 24,
            bottom: 32,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: ElevatedButton(
                onPressed: _launchUrl,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.applyNowBtn,
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.send_rounded, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.cairo(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
