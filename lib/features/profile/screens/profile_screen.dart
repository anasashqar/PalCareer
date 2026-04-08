import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:palcareer/l10n/generated/app_localizations.dart';

import '../../../../core/providers/settings_provider.dart';
import '../../../../core/utils/app_toast.dart';
import '../../auth/providers/auth_provider.dart';
import '../../onboarding/providers/onboarding_provider.dart';
import '../../../../core/providers/taxonomy_provider.dart';
import '../../../../shared/providers/profile_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    final String? sectorLocalized = obState.selectedSector != null && taxonomyAsync.hasValue && taxonomyAsync.value!.sectors.isNotEmpty
        ? taxonomyAsync.value!.sectors
            .firstWhere((s) => s.id == obState.selectedSector, orElse: () => taxonomyAsync.value!.sectors.first)
            .getLocalizedName(currentLocale.languageCode)
        : null;

    final String? levelLocalized = obState.academicLevel == 'student'
        ? (currentLocale.languageCode == 'ar' ? 'طالب' : 'Student')
        : (obState.academicLevel == 'graduate' ? (currentLocale.languageCode == 'ar' ? 'خريج جديد' : 'Fresh Graduate') : null);

    final subtitle = levelLocalized != null && sectorLocalized != null ? '$levelLocalized في $sectorLocalized' : 'مكتشف وظائف فلسطين';

    void showEditProfileSheet() {
      final nameController = TextEditingController(text: userName);
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                    style: TextStyle(fontFamily: 'Alexandria',
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'الاسم الكامل',
                      prefixIcon: Icon(Icons.person_rounded, color: Theme.of(context).colorScheme.primary),
                      labelStyle: TextStyle(fontFamily: 'Alexandria',color: Theme.of(context).colorScheme.outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
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
                          style: TextStyle(fontFamily: 'Alexandria',
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(ctx);
                            context.push('/onboarding');
                          },
                          icon: const Icon(Icons.route_rounded, size: 18),
                          label: const Text('إعادة ضبط المسار المهني', style: TextStyle(fontFamily: 'Alexandria',fontWeight: FontWeight.bold)),
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
                        final newName = nameController.text.trim();
                        if (newName.isNotEmpty) {
                          ref.read(userNameProvider.notifier).state = newName;
                          await ref.read(profileProvider.notifier).updateUserDisplayName(newName);
                        }
                        if (ctx.mounted) {
                          Navigator.pop(ctx);
                          if (context.mounted) {
                            AppToast.showSuccess(context, 'تم حفظ وتحديث ملفك الشخصي بنجاح 🚀');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text('حفظ التغييرات', style: TextStyle(fontFamily: 'Alexandria',fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.tertiary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -20,
                    right: -40,
                    child: Icon(Icons.account_circle, size: 250, color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Hero(
                          tag: 'avatar',
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.15),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: photoUrl != null && photoUrl.isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: photoUrl,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => const CircularProgressIndicator(color: Colors.white),
                                          errorWidget: (context, url, error) => _buildFallbackAvatar(context, userName),
                                        )
                                      : _buildFallbackAvatar(context, userName),
                                ),
                              ),
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: Theme.of(context).colorScheme.surface,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Icon(Icons.edit_rounded, size: 18, color: Theme.of(context).colorScheme.primary),
                                  onPressed: showEditProfileSheet,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          userName,
                          style: const TextStyle(fontFamily: 'Alexandria',
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            subtitle,
                            style: const TextStyle(fontFamily: 'Alexandria',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              transform: Matrix4.translationValues(0.0, -24.0, 0.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLowest,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.settingsTitle,
                      style: TextStyle(fontFamily: 'Alexandria',
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildSettingTile(
                            context: context,
                            icon: Icons.edit_note_rounded,
                            title: 'تعديل التوجه والبيانات',
                            iconBgColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                            iconColor: Theme.of(context).colorScheme.primary,
                            onTap: showEditProfileSheet,
                          ),
                          const Divider(height: 1, indent: 64, endIndent: 24),
                          _buildSettingTile(
                            context: context,
                            icon: Icons.notifications_active_rounded,
                            title: l10n.pushNotificationsToggle,
                            iconBgColor: const Color(0xFFFFF3E0),
                            iconColor: const Color(0xFFF57C00),
                            trailing: Switch(
                              value: pushEnabled,
                              activeThumbColor: Theme.of(context).colorScheme.primary,
                              onChanged: (val) async {
                                if (val) {
                                  bool? granted = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                      title: Row(
                                        children: [
                                          Icon(Icons.notifications_active_rounded, color: Theme.of(context).colorScheme.primary),
                                          const SizedBox(width: 8),
                                          const Text('تفعيل الإشعارات؟', style: TextStyle(fontFamily: 'Alexandria',fontSize: 18, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      content: const Text('يرغب تطبيق PalCareer في إرسال إشعارات لتنبيهك بالفرص الوظيفية فور توافرها.', style: TextStyle(fontFamily: 'Alexandria',fontSize: 14)),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('رفض', style: TextStyle(fontFamily: 'Alexandria',color: Theme.of(context).colorScheme.error))),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(context).colorScheme.primary,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                          ),
                                          onPressed: () => Navigator.pop(ctx, true),
                                          child: const Text('سماح', style: TextStyle(fontFamily: 'Alexandria',)),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (granted == true) {
                                    ref.read(pushNotificationsProvider.notifier).setEnabled(true);
                                    if (context.mounted) AppToast.showSuccess(context, 'تم تفعيل الإشعارات 🎉');
                                  }
                                } else {
                                  ref.read(pushNotificationsProvider.notifier).setEnabled(false);
                                }
                              },
                            ),
                          ),
                          const Divider(height: 1, indent: 64, endIndent: 24),
                          _buildSettingTile(
                            context: context,
                            icon: Icons.language_rounded,
                            title: "تغيير اللغة (${currentLocale.languageCode == 'ar' ? 'English' : 'عربي'})",
                            iconBgColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                            iconColor: Theme.of(context).colorScheme.secondary,
                            onTap: () {
                              final isAr = currentLocale.languageCode == 'ar';
                              final newLocale = Locale(isAr ? 'en' : 'ar');
                              ref.read(localeProvider.notifier).setLocale(newLocale);
                              context.setLocale(newLocale);
                              AppToast.showInfo(context, 'تم طلاء التطبيق بلغة جديدة 🌍');
                            },
                          ),
                          const Divider(height: 1, indent: 64, endIndent: 24),
                          _buildSettingTile(
                            context: context,
                            icon: Icons.info_outline_rounded,
                            title: l10n.aboutApp,
                            iconBgColor: Colors.grey.withValues(alpha: 0.1),
                            iconColor: Colors.grey.shade700,
                            onTap: () {
                              showAboutDialog(
                                context: context,
                                applicationName: 'PalCareer\nوظائف فلسطين',
                                applicationVersion: '1.0.0+1',
                                applicationIcon: Container(
                                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
                                  padding: const EdgeInsets.all(16),
                                  child: Icon(Icons.work_rounded, color: Theme.of(context).colorScheme.primary, size: 40),
                                ),
                                applicationLegalese: '© 2026 PalCareer Team.\nتم التطوير من أجل مساعدة الشباب الفلسطيني في إيجاد فرص عمل بكفاءة وسهولة.',
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.logout_rounded, size: 22),
                        label: Text(l10n.logoutBtn, style: const TextStyle(fontFamily: 'Alexandria',fontSize: 16, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.5),
                          foregroundColor: Theme.of(context).colorScheme.error,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () async {
                          try {
                            context.go('/login');
                            AppToast.showInfo(context, 'تم تسجيل الخروج بنجاح 👋');
                            await ref.read(authNotifierProvider.notifier).signOut();
                          } catch (e) {
                            debugPrint('Logout error: $e');
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackAvatar(BuildContext context, String userName) {
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      alignment: Alignment.center,
      child: Text(
        userName.isNotEmpty ? userName.substring(0, 1) : 'م',
        style: TextStyle(fontFamily: 'Alexandria',
          fontSize: 40,
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color iconBgColor,
    required Color iconColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(fontFamily: 'Alexandria',fontSize: 16, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurface),
      ),
      trailing: trailing ?? Icon(Icons.keyboard_arrow_left_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant),
      onTap: onTap,
    );
  }
}
