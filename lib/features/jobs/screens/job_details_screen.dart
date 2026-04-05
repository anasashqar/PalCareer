import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:palcareer/l10n/generated/app_localizations.dart';

import '../../../../shared/models/job_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../onboarding/providers/onboarding_provider.dart';
import '../../bookmarks/providers/bookmarks_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

class JobDetailsScreen extends ConsumerWidget {
  final JobModel job;

  const JobDetailsScreen({super.key, required this.job});

  Future<void> _launchUrl(BuildContext context, WidgetRef ref, {required bool isWhatsApp}) async {
    final langCode = Localizations.localeOf(context).languageCode;
    
    // Get user onboarding data
    final obState = ref.read(onboardingProvider);
    
    String urlString = job.applyUrl;
    
    // If WhatsApp is explicitly requested, or if the url is empty/already wa.me
    if (isWhatsApp || urlString.isEmpty || urlString.contains('wa.me')) {
      final String greeting = langCode == 'ar' 
        ? 'مرحباً، أود التقدم لوظيفة (${job.getLocalizedTitle('ar')}) المعروضة عبر *تطبيق PalCareer*. 🚀'
        : 'Hello, I would like to apply for (${job.getLocalizedTitle('en')}) posted via *PalCareer app*. 🚀';

      final String myDataTitle = langCode == 'ar' ? '\n\nبياناتي المُسجلة:' : '\n\nMy Registered Data:';
      
      final String name = langCode == 'ar' ? '- الاسم: مستخدم تجريبي' : '- Name: Demo User';
      final String sector = langCode == 'ar' ? '- التخصص/المجال: ${obState.selectedSector ?? "غير محدد"}' : '- Field: ${obState.selectedSector ?? "Not specified"}';
      final String level = langCode == 'ar' ? '- المستوى: ${obState.academicLevel ?? "غير محدد"}' : '- Level: ${obState.academicLevel ?? "Not specified"}';
      
      final String message = '$greeting$myDataTitle\n$name\n$sector\n$level\n';
      final encodedMessage = Uri.encodeComponent(message);
      
      urlString = 'https://wa.me/970599000000?text=$encodedMessage';
    }

    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('لا يمكن فتح الرابط، تأكد من وجود متصفح أو واتساب.', style: GoogleFonts.cairo())),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ: $e', style: GoogleFonts.cairo())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final langCode = Localizations.localeOf(context).languageCode;
    
    // Add translation string for Description for now if not available
    final String descriptionLabel = langCode == 'ar' ? 'وصف الوظيفة' : 'Job Description';

    return Scaffold(
      backgroundColor: AppColors.surface,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.share_rounded, color: AppColors.onSurface, size: 22),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: job.applyUrl));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('تم نسخ رابط الوظيفة بنجاح 🎉', style: GoogleFonts.cairo()),
                        backgroundColor: AppColors.primary,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                Consumer(
                  builder: (context, ref, _) {
                    final isSaved = ref.watch(bookmarksProvider).contains(job.id);
                    return IconButton(
                      icon: Icon(
                        isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded, 
                        color: isSaved ? AppColors.secondary : AppColors.onSurface, 
                        size: 24,
                      ),
                      onPressed: () {
                        ref.read(bookmarksProvider.notifier).toggleBookmark(job.id);
                      },
                    );
                  },
                ),
              ],
            ),
          )
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context, ref, l10n, langCode),
      body: ListView(
        padding: const EdgeInsets.only(top: 100, bottom: 40),
        physics: const BouncingScrollPhysics(),
        children: [
          // Header Card matching design
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: AppColors.primary.withValues(alpha: 0.03), blurRadius: 20, offset: const Offset(0, 8))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Center aligned for top part
              children: [
                // Logo Box
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.inbox_rounded, color: AppColors.primary, size: 36), // Dropbox-like icon
                  ),
                ),
                const SizedBox(height: 20),
                
                Text(
                  job.getLocalizedTitle(langCode),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                
                if (job.isNew)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      l10n.newBadge,
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                
                const SizedBox(height: 12),
                
                Text(
                  job.company,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Pills Row (Location, Type, Time)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    _MetaPill(icon: Icons.location_on_rounded, label: job.getLocalizedLocation(langCode)),
                    if (job.types.isNotEmpty)
                      _MetaPill(icon: Icons.access_time_rounded, label: job.types.first), // Just showing first type as per UI mockup maybe
                    // Optional: Showing posted string like 'نشر منذ يومين' (mocking the time string for now)
                    _MetaPill(icon: Icons.calendar_today_rounded, label: 'منذ يومين'),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Job Description Section
          if (job.getLocalizedDescription(langCode).isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildSectionTitle(descriptionLabel, AppColors.primary),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                job.getLocalizedDescription(langCode),
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceVariant,
                  height: 1.8,
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
          
          // Requirements
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildSectionTitle(l10n.jobRequirements, AppColors.secondary),
          ),
          const SizedBox(height: 16),
          ...job.getLocalizedRequirements(langCode).map((req) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      decoration: const BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(2),
                      child: const Icon(Icons.check_rounded, size: 14, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        req,
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurfaceVariant,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              )),

          const SizedBox(height: 32),

          // Responsibilities
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildSectionTitle(l10n.jobResponsibilities, AppColors.error), 
          ),
          const SizedBox(height: 16),
          ...job.getLocalizedResponsibilities(langCode).map((res) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildResponsibilityCard(res),
              )),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context, WidgetRef ref, AppLocalizations l10n, String langCode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.onSurface.withValues(alpha: 0.05), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          )
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // WhatsApp Helper Button (Secondary Styling)
            Expanded(
              flex: 4,
              child: ElevatedButton(
                onPressed: () => _launchUrl(context, ref, isWhatsApp: true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366).withValues(alpha: 0.1),
                  foregroundColor: const Color(0xFF25D366),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Color(0xFF25D366), width: 1.5),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.chat_rounded, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      langCode == 'ar' ? 'بمساعدتنا' : 'Via Us',
                      style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Original Apply Button (Primary Styling)
            Expanded(
              flex: 6,
              child: ElevatedButton(
                onPressed: () => _launchUrl(context, ref, isWhatsApp: false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shadowColor: AppColors.primary.withValues(alpha: 0.4),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.send_rounded, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      l10n.applyNowBtn,
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color barColor) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 22,
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.cairo(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildResponsibilityCard(String responsibility) {
    final parts = responsibility.split(':');
    final title = parts[0];
    final subtitle = parts.length > 1 ? parts[1].trim() : '';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: GoogleFonts.cairo(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceVariant,
                height: 1.6,
              ),
            ),
          ]
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.cairo(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
