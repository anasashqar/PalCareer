import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation1;
  late final Animation<Offset> _slideAnimation1;
  late final Animation<double> _fadeAnimation2;
  late final Animation<Offset> _slideAnimation2;
  late final Animation<double> _fadeAnimation3;
  late final Animation<Offset> _slideAnimation3;

  @override
  void initState() {
    super.initState();
    // Staggered Animations Setup
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.0, 0.4, curve: Curves.easeOut)),
    );
    _slideAnimation1 = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.0, 0.4, curve: Curves.easeOutCubic)),
    );

    _fadeAnimation2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.2, 0.6, curve: Curves.easeOut)),
    );
    _slideAnimation2 = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.2, 0.6, curve: Curves.easeOutCubic)),
    );

    _fadeAnimation3 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.4, 0.8, curve: Curves.easeOut)),
    );
    _slideAnimation3 = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.4, 0.8, curve: Curves.easeOutCubic)),
    );

    // Initial delay then start animation
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next.isAuthenticated) {
        context.go('/onboarding'); // or '/home' depending on if it's first login
      }
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              next.error!, 
              style: GoogleFonts.cairo(),
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLow,
      body: SafeArea(
        child: Stack(
          children: [
            // Subtle abstract glass background hint in the corner
            Positioned(
              top: -80,
              right: -50,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondary.withOpacity(0.04),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 80),
                  
                  // App Logo Focus
                  SlideTransition(
                    position: _slideAnimation1,
                    child: FadeTransition(
                      opacity: _fadeAnimation1,
                      child: Align(
                        alignment: Directionality.of(context) == TextDirection.rtl ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              )
                            ],
                          ),
                          child: const Icon(
                            Icons.work_outline_rounded,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Headline Text
                  SlideTransition(
                    position: _slideAnimation2,
                    child: FadeTransition(
                      opacity: _fadeAnimation2,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'مرحباً بك في\n',
                              style: GoogleFonts.cairo(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                                color: AppColors.onSurface,
                              ),
                            ),
                            TextSpan(
                              text: 'PalCareer',
                              style: GoogleFonts.manrope(
                                fontSize: 44,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Subtitle
                  SlideTransition(
                    position: _slideAnimation2,
                    child: FadeTransition(
                      opacity: _fadeAnimation2,
                      child: Text(
                        'اكتشف الوظائف التي تناسب مسارك المهني\nبذكاء وسهولة.',
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          color: AppColors.onSurfaceVariant,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ),
                  
                  const Spacer(),

                  // Google Sign In Button 
                  SlideTransition(
                    position: _slideAnimation3,
                    child: FadeTransition(
                      opacity: _fadeAnimation3,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.0),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.onSurface.withOpacity(0.08),
                              blurRadius: 30,
                              spreadRadius: -5,
                              offset: const Offset(0, 15),
                            )
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: authState.isLoading
                              ? null
                              : () {
                                  ref.read(authNotifierProvider.notifier).signInWithGoogle();
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.surfaceContainerLowest,
                            foregroundColor: AppColors.onSurface,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 22),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                              side: BorderSide(
                                color: AppColors.outlineVariant.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                          ),
                          child: authState.isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primary,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.g_mobiledata_rounded, size: 36, color: AppColors.primary),
                                    const SizedBox(width: 12),
                                    Text(
                                      'المتابعة باستخدام Google',
                                      style: GoogleFonts.cairo(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Footer text
                  SlideTransition(
                    position: _slideAnimation3,
                    child: FadeTransition(
                      opacity: _fadeAnimation3,
                      child: Text(
                        'بتسجيلك أنت ترافق على شروطنا وسياسة الخصوصية.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          color: AppColors.onSurfaceVariant.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
