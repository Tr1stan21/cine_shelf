import 'package:cine_shelf/shared/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cine_shelf/shared/widgets/background.dart';
import 'package:cine_shelf/shared/widgets/bottom_nav.dart';
import 'package:cine_shelf/features/auth/application/auth_providers.dart';
import 'package:cine_shelf/features/lists/application/list_providers.dart';

/// Navigation shell wrapper for tab-based navigation.
///
/// Wraps the StatefulNavigationShell provided by GoRouter to add:
/// - Branded background
/// - Consistent padding
/// - Bottom navigation bar
///
/// Used as the builder for StatefulShellRoute in AppRouter.
class NavShell extends StatelessWidget {
  const NavShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        padding: const EdgeInsets.all(CineSpacing.md),
        child: Stack(
          fit: StackFit.expand,
          children: [navigationShell, const _UserPreloadWatcher()],
        ),
      ),
      bottomNavigationBar: BottomNavBar(navigationShell: navigationShell),
    );
  }
}

class _UserPreloadWatcher extends ConsumerWidget {
  const _UserPreloadWatcher();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const SizedBox.shrink();
        }

        ref.watch(currentUserProvider);
        ref.watch(watchedCountProvider);
        ref.watch(watchlistCountProvider);
        ref.watch(favoritesCountProvider);

        return const SizedBox.shrink();
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
