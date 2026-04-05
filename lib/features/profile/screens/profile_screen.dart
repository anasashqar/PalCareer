import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palcareer/l10n/generated/app_localizations.dart';

import '../../../../core/theme/app_colors.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          physics: const BouncingScrollPhysics(),
          children: [
            // User Header Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: AppColors.outlineVariant.withOpacity(0.3), width: 1.5),
                boxShadow: [
                  BoxShadow(color: AppColors.primary.withOpacity(0.04), blurRadius: 24, offset: const Offset(0, 10))
                ]
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                         BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4))
                      ]
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'م', // Initial for Arabic name
                      style: GoogleFonts.cairo(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'مؤمن الفلسطيني', // Mock Arabic User Name
                          style: GoogleFonts.cairo(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'طالب هندسة حاسوب', // Mock bio
                          style: GoogleFonts.cairo(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            Text(
              l10n.settingsTitle,
              style: GoogleFonts.cairo(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 16),

            // Settings Items
            _SettingsItem(
              icon: Icons.notifications_active_rounded,
              title: l10n.pushNotificationsToggle,
              iconColor: const Color(0xFFE5A93C),
              trailing: Switch(
                value: true, // Mock value
                activeColor: Colors.white,
                activeTrackColor: AppColors.primary,
                inactiveTrackColor: AppColors.surfaceContainerLow,
                inactiveThumbColor: AppColors.onSurfaceVariant,
                onChanged: (val) {},
              ),
            ),
            const SizedBox(height: 12),
            _SettingsItem(
              icon: Icons.language_rounded,
              title: "تغيير اللغة (Language)",
              iconColor: AppColors.secondary,
              onTap: () {}, // For future implementation
            ),
            const SizedBox(height: 12),
            _SettingsItem(
              icon: Icons.info_outline_rounded,
              title: l10n.aboutApp,
              iconColor: AppColors.primary,
              onTap: () {},
            ),
            const SizedBox(height: 48),

            // Logout Button
            TextButton(
              onPressed: () => context.go('/login'),
              style: TextButton.styleFrom(
                backgroundColor: AppColors.errorContainer.withOpacity(0.5),
                foregroundColor: AppColors.error,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
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
            const SizedBox(height: 120), // Padding for the floating bottom nav
          ],
        ),
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.iconColor,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.2)),
        boxShadow: [
           BoxShadow(color: AppColors.onSurface.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
        ]
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
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
                  const Icon(Icons.keyboard_arrow_left_rounded, color: AppColors.onSurfaceVariant, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
