import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/day/presentation/day_detail_screen.dart';
import '../features/life_map/presentation/life_map_screen.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/today/presentation/today_screen.dart';
import '../features/week/presentation/week_detail_screen.dart';
import '../shared/providers/database_provider.dart';
import '../shared/widgets/main_shell.dart';

/// Стабильный listenable — GoRouter не пересоздаётся при каждом async-событии.
final _routerRefreshProvider = Provider<ValueNotifier<int>>((ref) {
  final notifier = ValueNotifier(0);
  ref.listen(onboardingCompletedProvider, (_, __) => notifier.value++);
  ref.onDispose(notifier.dispose);
  return notifier;
});

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ref.watch(_routerRefreshProvider);

  return GoRouter(
    refreshListenable: refresh,
    initialLocation: '/today',
    redirect: (context, state) {
      final completed = ref.read(onboardingCompletedProvider).maybeWhen(
            data: (value) => value,
            orElse: () => null,
          );
      if (completed == null) return null;

      final isOnboarding = state.matchedLocation == '/onboarding';
      if (!completed && !isOnboarding) return '/onboarding';
      if (completed && isOnboarding) return '/today';
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/today',
                builder: (context, state) => const TodayScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/life',
                builder: (context, state) => const LifeMapScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/week/:weekIndex',
        builder: (context, state) {
          final weekIndex = int.parse(state.pathParameters['weekIndex']!);
          return WeekDetailScreen(weekIndex: weekIndex);
        },
      ),
      GoRoute(
        path: '/day/:date',
        builder: (context, state) {
          final date = state.pathParameters['date']!;
          return DayDetailScreen(dateKey: date);
        },
      ),
    ],
  );
});
