import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:palcareer/l10n/generated/app_localizations.dart';

class MainScaffoldView extends StatelessWidget {
  final Widget child;

  const MainScaffoldView({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    int currentIndex = 0;
    if (location.startsWith('/profile')) {
      currentIndex = 1;
    }

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 24,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            if (index == 0) {
              context.go('/home');
            } else if (index == 1) {
              context.go('/profile');
            }
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.work_outline),
              selectedIcon: const Icon(Icons.work),
              label: l10n.homeTab,
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline),
              selectedIcon: const Icon(Icons.person),
              label: l10n.profileTab,
            ),
          ],
        ),
      ),
    );
  }
}
