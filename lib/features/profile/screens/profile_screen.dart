import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palcareer/l10n/generated/app_localizations.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../../../core/utils/app_toast.dart';
import '../../auth/providers/auth_provider.dart';
import '../../onboarding/providers/onboarding_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final pushEnabled = ref.watch(pushNotificationsProvider);
    final currentLocale = ref.watch(localeProvider);
    final userName = ref.watch(userNameProvider);
    final obState = ref.watch(onboardingProvider);

    void showEditProfileSheet() {
      final nameController = TextEditingController(text: userName);
      String? tempLevel = obState.academicLevel;
      String? tempSector = obState.selectedSector;
      
      final isAr = currentLocale.languageCode == 'ar';
      
      final List<String> levels = [
        isAr ? 'طالب' : 'Student',
        isAr ? 'خريج جديد' : 'Fresh Graduate',
      ];
      final List<String> sectors = [
        'تقنية المعلومات', 'هندسة', 'إدارة أعمال', 'محاسبة', 'تعليم', 'طب وصحة', 'أخرى'
      ];

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.outlineVariant.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "تحديث البيانات",
                    style: GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.onSurface),
                  ),
                  const SizedBox(height: 32),
                  // Name Field
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "الاسم الكامل",
                      prefixIcon: const Icon(Icons.person_rounded, color: AppColors.primary),
                      labelStyle: GoogleFonts.cairo(color: AppColors.outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: AppColors.primary, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Academic Level
                  DropdownButtonFormField<String>(
                    value: tempLevel != null && levels.contains(tempLevel) ? tempLevel : null,
                    decoration: InputDecoration(
                      labelText: "المستوى الأكاديمي",
                      prefixIcon: const Icon(Icons.school_rounded, color: AppColors.secondary),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    items: levels.map((l) => DropdownMenuItem(value: l, child: Text(l, style: GoogleFonts.cairo()))).toList(),
                    onChanged: (val) => tempLevel = val,
                  ),
                  const SizedBox(height: 20),
                  // Sector
                  DropdownButtonFormField<String>(
                    value: tempSector != null && sectors.contains(tempSector) ? tempSector : null,
                    decoration: InputDecoration(
                      labelText: "مجال الاهتمام (التوجه)",
                      prefixIcon: const Icon(Icons.workspaces_rounded, color: AppColors.primary),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    items: sectors.map((s) => DropdownMenuItem(value: s, child: Text(s, style: GoogleFonts.cairo()))).toList(),
                    onChanged: (val) => tempSector = val,
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        if (nameController.text.isNotEmpty) {
                          ref.read(userNameProvider.notifier).state = nameController.text;
                        }
                        if (tempSector != null) ref.read(onboardingProvider.notifier).setSector(tempSector!);
                        if (tempLevel != null) ref.read(onboardingProvider.notifier).setAcademicLevel(tempLevel!);
                        
                        Navigator.pop(ctx);
                        
                        // Interactive Feedback!
                        AppToast.showSuccess(context, "تم حفظ وتحديث ملفك الشخصي بنجاح 🚀");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Text("حفظ التغييرات", style: GoogleFonts.cairo(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    final subtitle = obState.academicLevel != null && obState.selectedSector != null 
        ? '${obState.academicLevel} في ${obState.selectedSector}'
        : 'مكتشف وظائف فلسطين';

    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest, // Lighter, cleaner background
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          physics: const BouncingScrollPhysics(),
          children: [
            // Centered Modern User Header
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 24, offset: const Offset(0, 10))
                        ]
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        userName.isNotEmpty ? userName.substring(0, 1) : 'م',
                        style: GoogleFonts.cairo(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: showEditProfileSheet,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
                            boxShadow: [
                               BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 4))
                            ]
                          ),
                          child: const Icon(Icons.edit_rounded, color: AppColors.primary, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  userName,
                  style: GoogleFonts.cairo(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.secondary.withValues(alpha: 0.2)),
                  ),
                  child: Text(
                    subtitle,
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: showEditProfileSheet,
                  icon: const Icon(Icons.tune_rounded, size: 20),
                  label: Text("تعديل التوجه والبيانات", style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    backgroundColor: AppColors.primaryContainer.withValues(alpha: 0.3),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 48),

            Text(
              l10n.settingsTitle,
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),

            // Grouped Settings Cluster (Modern iOS / Material 3 style)
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
                boxShadow: [
                   BoxShadow(color: AppColors.onSurface.withValues(alpha: 0.03), blurRadius: 20, offset: const Offset(0, 10))
                ]
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Column(
                  children: [
                    _SettingsItemLine(
                      icon: Icons.notifications_active_rounded,
                      title: l10n.pushNotificationsToggle,
                      iconColor: const Color(0xFFE5A93C),
                      trailing: Transform.scale(
                        scale: 0.85,
                        child: Switch(
                          value: pushEnabled,
                          activeColor: Colors.white,
                          activeTrackColor: AppColors.primary,
                          inactiveTrackColor: AppColors.surfaceContainerLow,
                          inactiveThumbColor: AppColors.onSurfaceVariant,
                          onChanged: (val) async {
                            if (val == true) {
                              bool? granted = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                  title: Row(
                                    children: [
                                      const Icon(Icons.notifications_active_rounded, color: AppColors.primary),
                                      const SizedBox(width: 8),
                                      Text("السماح بالإشعارات؟", style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  content: Text(
                                    "يرغب تطبيق PalCareer في إرسال إشعارات لتنبيهك بالفرص الوظيفية فور توافرها.",
                                    style: GoogleFonts.cairo(fontSize: 14),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, false),
                                      child: Text("رفض", style: GoogleFonts.cairo(color: AppColors.error)),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: Text("سماح", style: GoogleFonts.cairo(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              );
                              
                              if (granted == true) {
                                ref.read(pushNotificationsProvider.notifier).state = true;
                                if (context.mounted) {
                                  AppToast.showSuccess(context, 'تم تفعيل الإشعارات بنجاح 🎉');
                                }
                              }
                            } else {
                              ref.read(pushNotificationsProvider.notifier).state = false;
                            }
                          },
                        ),
                      ),
                    ),
                    Divider(height: 1, indent: 64, endIndent: 20, color: AppColors.outlineVariant.withValues(alpha: 0.15)),
                    _SettingsItemLine(
                      icon: Icons.language_rounded,
                      title: "تغيير اللغة (${currentLocale.languageCode == 'ar' ? 'English' : 'عربي'})",
                      iconColor: AppColors.secondary,
                      onTap: () {
                        final isAr = currentLocale.languageCode == 'ar';
                        ref.read(localeProvider.notifier).state = Locale(isAr ? 'en' : 'ar');
                        AppToast.showInfo(context, 'تم طلاء التطبيق بلغة جديدة 🌍');
                      },
                    ),
                    Divider(height: 1, indent: 64, endIndent: 20, color: AppColors.outlineVariant.withValues(alpha: 0.15)),
                    _SettingsItemLine(
                      icon: Icons.info_outline_rounded,
                      title: l10n.aboutApp,
                      iconColor: AppColors.primary,
                      onTap: () {
                        showAboutDialog(
                          context: context,
                          applicationName: 'PalCareer\nوظائف فلسطين',
                          applicationVersion: '1.0.0+1',
                          applicationIcon: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16)
                            ),
                            padding: const EdgeInsets.all(16),
                            child: const Icon(Icons.work_rounded, color: AppColors.primary, size: 40)
                          ),
                          applicationLegalese: '© 2026 PalCareer Team.\nتم التطوير من أجل مساعدة الشباب الفلسطيني في إيجاد فرص عمل بكفاءة وسهولة.',
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 48),

            // Logout Button
            TextButton(
              onPressed: () async {
                await ref.read(authNotifierProvider.notifier).signOut();
                if (context.mounted) {
                  context.go('/login');
                  AppToast.showInfo(context, 'تم تسجيل الخروج بنجاح 👋');
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: AppColors.errorContainer.withValues(alpha: 0.4),
                foregroundColor: AppColors.error,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.logout_rounded, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    l10n.logoutBtn,
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _SettingsItemLine extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsItemLine({
    required this.icon,
    required this.title,
    required this.iconColor,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
              if (trailing != null) 
                trailing!
              else
                const Icon(Icons.keyboard_arrow_left_rounded, color: AppColors.onSurfaceVariant, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
