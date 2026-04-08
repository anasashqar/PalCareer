import 'package:flutter/material.dart';


import '../theme/app_colors.dart';

class AppToast {
  static void showSuccess(BuildContext context, String message) {
    _showToast(
      context,
      message,
      Icons.check_circle_rounded,
      Theme.of(context).colorScheme.secondary,
    );
  }

  static void showInfo(BuildContext context, String message) {
    _showToast(
      context,
      message,
      Icons.info_rounded,
      Theme.of(context).colorScheme.primary,
    );
  }

  static void showError(BuildContext context, String message) {
    _showToast(
      context,
      message,
      Icons.error_rounded,
      Theme.of(context).colorScheme.error,
    );
  }

  static void _showToast(
    BuildContext context,
    String message,
    IconData icon,
    Color color,
  ) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(
          bottom: 24,
          left: 24,
          right: 24,
        ), // Above bottom nav
        duration: const Duration(seconds: 3),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors
                .surface, // Solid background so text underneath doesn't bleed through
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    fontFamily: 'Alexandria',
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
