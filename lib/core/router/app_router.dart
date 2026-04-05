
import 'package:go_router/go_router.dart';
import '../../features/auth/views/splash_view.dart';
import '../../features/auth/views/login_view.dart';

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
  ],
);
