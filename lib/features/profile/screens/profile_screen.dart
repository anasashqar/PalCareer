import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palcareer/l10n/generated/app_localizations.dart';

import '../../../../core/providers/settings_provider.dart';
import '../../../../core/utils/app_toast.dart';
import '../../auth/providers/auth_provider.dart';
import '../../onboarding/providers/onboarding_provider.dart';
import '../../../../shared/services/firestore_service.dart';
import '../../../../core/constants/firestore_keys.dart';
import '../../../../core/providers/taxonomy_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch auth notifier so profile screen triggers rebuild on login/out
    ref.watch(authNotifierProvider);

    final l10n = AppLocalizations.of(context)!;
    final pushEnabled = ref.watch(pushNotificationsProvider);
    final currentLocale = ref.watch(localeProvider);

    final authUser = FirebaseAuth.instance.currentUser;
    final String? currentDisplayName = authUser?.displayName;
    final String userNameState = ref.watch(userNameProvider);
    final String userName = userNameState != 'مستخدم تجريبي' 
        ? userNameState 
        : (currentDisplayName ?? 'مستخدم تجريبي');
    final String? photoUrl = authUser?.photoURL;

    final obState = ref.watch(onboardingProvider);
    final taxonomyAsync = ref.watch(taxonomyProvider);

    void showEditProfileSheet() {
      final nameController = TextEditingController(text: userName);
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'تحديث البيانات',
                    style: GoogleFonts.cairo(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Name Field
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'الاسم الكامل',
                      prefixIcon: Icon(
                        Icons.person_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      labelStyle: GoogleFonts.cairo(color: Theme.of(context).colorScheme.outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'لتغيير تخصصك واهتماماتك الوظيفية بدقة عالية، يرجى الاستعانة بمرشد المسار المهني',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cairo(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(ctx);
                            context.push('/onboarding');
                          },
                          icon: const Icon(Icons.tune_rounded, size: 18),
                          label: Text('إعادة ضبط المسار المهني', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (nameController.text.isNotEmpty) {
                          ref.read(userNameProvider.notifier).state = nameController.text;
                          await authUser?.updateDisplayName(nameController.text);
                          
                          if (authUser != null) {
                            try {
                              await ref.read(firestoreServiceProvider).updateDocument(
                                FirestoreKeys.usersContent,
                                authUser.uid,
                                {'name': nameController.text}, // Update Firestore sync
                              );
                            } catch (_) {
                              // Ignore if document not fully constructed yet
                            }
                          }
                        }

                        if (ctx.mounted) {
                          Navigator.pop(ctx);
                          // Interactive Feedback!
                          if (context.mounted) {
                            AppToast.showSuccess(
                              context,
                              'تم حفظ وتحديث ملفك الشخصي بنجاح 🚀',
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'حفظ التغييرات',
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    final String? sectorLocalized = obState.selectedSector != null && taxonomyAsync.hasValue && taxonomyAsync.value!.sectors.isNotEmpty
        ? taxonomyAsync.value!.sectors
            .firstWhere((s) => s.id == obState.selectedSector,
                orElse: () => taxonomyAsync.value!.sectors.first)
            .getLocalizedName(currentLocale.languageCode)
        : null;

    final String? levelLocalized = obState.academicLevel == 'student'
        ? (currentLocale.languageCode == 'ar' ? 'طالب' : 'Student')
        : (obState.academicLevel == 'graduate'
            ? (currentLocale.languageCode == 'ar' ? 'خريج جديد' : 'Fresh Graduate')
            : null);

    final subtitle = levelLocalized != null && sectorLocalized != null
        ? '$levelLocalized في $sectorLocalized'
        : 'مكتشف وظائف فلسطين';

    return Scaffold(
      backgroundColor:
          Theme.of(context).colorScheme.surfaceContainerLowest, // Lighter, cleaner background
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
                        color: Theme.of(context).colorScheme.primary,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: photoUrl != null && photoUrl.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: photoUrl,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const CircularProgressIndicator(color: Colors.white),
                                errorWidget: (context, url, error) => _buildFallbackAvatar(context, userName),
                              )
                            : _buildFallbackAvatar(context, userName),
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
                            color: Theme.of(context).colorScheme.surface,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outlineVariant.withValues(
                                alpha: 0.2,
                              ),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.edit_rounded,
                            color: Theme.of(context).colorScheme.primary,
                            size: 18,
                          ),
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
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    subtitle,
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: showEditProfileSheet,
                  icon: const Icon(Icons.tune_rounded, size: 20),
                  label: Text(
                    'تعديل التوجه والبيانات',
                    style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer.withValues(
                      alpha: 0.3,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
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
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),

            // Grouped Settings Cluster (Modern iOS / Material 3 style)
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.03),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
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
                          activeThumbColor: Colors.white,
                          activeTrackColor: Theme.of(context).colorScheme.primary,
                          inactiveTrackColor: Theme.of(context).colorScheme.surfaceContainerLow,
                          inactiveThumbColor: Theme.of(context).colorScheme.onSurfaceVariant,
                          onChanged: (val) async {
                            if (val == true) {
                              bool? granted = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  title: Row(
                                    children: [
                                      Icon(
                                        Icons.notifications_active_rounded,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'السماح بالإشعارات؟',
                                        style: GoogleFonts.cairo(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  content: Text(
                                    'يرغب تطبيق PalCareer في إرسال إشعارات لتنبيهك بالفرص الوظيفية فور توافرها.',
                                    style: GoogleFonts.cairo(fontSize: 14),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(ctx, false),
                                      child: Text(
                                        'رفض',
                                        style: GoogleFonts.cairo(
                                          color: Theme.of(context).colorScheme.error,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context).colorScheme.primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: Text(
                                        'سماح',
                                        style: GoogleFonts.cairo(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              if (granted == true) {
                                ref.read(pushNotificationsProvider.notifier).setEnabled(true);
                                if (context.mounted) {
                                  AppToast.showSuccess(
                                    context,
                                    'تم تفعيل الإشعارات بنجاح 🎉',
                                  );
                                }
                              }
                            } else {
                              ref.read(pushNotificationsProvider.notifier).setEnabled(false);
                            }
                          },
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      indent: 64,
                      endIndent: 20,
                      color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.15),
                    ),
                    _SettingsItemLine(
                      icon: Icons.language_rounded,
                      title:
                          "تغيير اللغة (${currentLocale.languageCode == 'ar' ? 'English' : 'عربي'})",
                      iconColor: Theme.of(context).colorScheme.secondary,
                      onTap: () {
                        final isAr = currentLocale.languageCode == 'ar';
                        final newLocale = Locale(isAr ? 'en' : 'ar');
                        ref.read(localeProvider.notifier).setLocale(newLocale);
                        context.setLocale(newLocale);
                        AppToast.showInfo(
                          context,
                          'تم طلاء التطبيق بلغة جديدة 🌍',
                        );
                      },
                    ),
                    Divider(
                      height: 1,
                      indent: 64,
                      endIndent: 20,
                      color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.15),
                    ),
                    _SettingsItemLine(
                      icon: Icons.info_outline_rounded,
                      title: l10n.aboutApp,
                      iconColor: Theme.of(context).colorScheme.primary,
                      onTap: () {
                        showAboutDialog(
                          context: context,
                          applicationName: 'PalCareer\nوظائف فلسطين',
                          applicationVersion: '1.0.0+1',
                          applicationIcon: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Icon(
                              Icons.work_rounded,
                              color: Theme.of(context).colorScheme.primary,
                              size: 40,
                            ),
                          ),
                          applicationLegalese:
                              '© 2026 PalCareer Team.\nتم التطوير من أجل مساعدة الشباب الفلسطيني في إيجاد فرص عمل بكفاءة وسهولة.',
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
                try {
                  // Forcibly navigate immediately to stop any rebuild loops
                  context.go('/login');
                  AppToast.showInfo(context, 'تم تسجيل الخروج بنجاح 👋');
                  
                  // Then process the signout blindly in background
                  await ref.read(authNotifierProvider.notifier).signOut();
                } catch (e) {
                  debugPrint('Logout error: $e');
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.errorContainer.withValues(
                  alpha: 0.4,
                ),
                foregroundColor: Theme.of(context).colorScheme.error,
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

  Widget _buildFallbackAvatar(BuildContext context, String userName) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              if (trailing != null)
                trailing!
              else
                Icon(
                  Icons.keyboard_arrow_left_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
