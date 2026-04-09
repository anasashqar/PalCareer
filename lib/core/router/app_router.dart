import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/jobs/screens/jobs_feed_screen.dart';
import '../../features/jobs/screens/job_details_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/bookmarks/screens/bookmarks_screen.dart';
import 'main_scaffold_view.dart';
import '../../shared/models/job_model.dart';

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  RouterNotifier(this._ref) {
    _ref.listen<AuthState>(
      authNotifierProvider,
      (_, _) => notifyListeners(),
    );
  }
}

final rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = RouterNotifier(ref);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: notifier,
    redirect: (context, state) {
      final isAuth = ref.read(authNotifierProvider).isAuthenticated;
      final isSplash = state.matchedLocation == '/';
      final isLogin = state.matchedLocation == '/login';

      if (isSplash) return null; // Let splash decide
      
      if (!isAuth && !isLogin) return '/login';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScaffoldView(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const JobsFeedScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/bookmarks',
                builder: (context, state) => const BookmarksScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/job-details',
        builder: (context, state) {
          final job = state.extra as JobModel?;
          final jobId = state.uri.queryParameters['id'];
          if (job != null) {
            return JobDetailsScreen(job: job);
          } else if (jobId != null) {
            return _JobLoaderWrapper(jobId: jobId);
          }
          return const Scaffold(body: Center(child: Text('Not found')));
        },
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],
  );
});

class _JobLoaderWrapper extends StatelessWidget {
  final String jobId;
  const _JobLoaderWrapper({required this.jobId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<JobModel?>(
      future: _fetchJob(jobId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('...'), backgroundColor: Colors.transparent),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(backgroundColor: Colors.transparent),
            body: Center(child: Text('Could not load job: ${snapshot.error ?? 'Not found'}')),
          );
        }
        return JobDetailsScreen(job: snapshot.data!);
      },
    );
  }

  Future<JobModel?> _fetchJob(String id) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('jobs').doc(id).get();
      if (doc.exists) {
        return JobModel.fromMap(doc.data()!, doc.id);
      }
    } catch (e) {
      debugPrint('Error fetching job: $e');
    }
    return null;
  }
}
