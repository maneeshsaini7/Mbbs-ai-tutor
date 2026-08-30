import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/widgets/app_bottom_nav.dart';
import '../features/ai_tutor/screens/ai_tutor_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/practice/screens/practice_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/subjects/screens/subjects_screen.dart';

/// 5-tab bottom navigation, each tab its own branch with its own back-stack
/// (StatefulShellRoute), so switching tabs never loses scroll position or
/// in-progress state on another tab.
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return _AppShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/subjects',
              builder: (context, state) => const SubjectsScreen(),
              // Phase 4 adds: routes: [GoRoute(path: ':id', ...)]
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/ai-tutor',
              builder: (context, state) => const AiTutorScreen(),
              // Phase 7 adds: routes: [GoRoute(path: 'pdf', ...)]
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/practice',
              builder: (context, state) => const PracticeScreen(),
              // Phases 6/8/9 add: mcq, flashcards, pyq, clinical-case children
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
              // Phase 10 adds: routes: [GoRoute(path: 'planner', ...)]
            ),
          ],
        ),
      ],
    ),
  ],
);

class _AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const _AppShell({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}
