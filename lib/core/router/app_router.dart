import 'package:go_router/go_router.dart';
import '../../features/auth/views/splash_view.dart';
import '../../features/auth/views/login_view.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/jobs/screens/jobs_feed_screen.dart';
import '../../features/jobs/screens/job_details_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import 'main_scaffold_view.dart';
import '../../shared/models/job_model.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginView(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const MainScaffoldView(child: JobsFeedScreen()),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const MainScaffoldView(child: ProfileScreen()),
    ),
    GoRoute(
      path: '/job-details',
      builder: (context, state) {
        final job = state.extra as JobModel;
        return JobDetailsScreen(job: job);
      },
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
  ],
);
