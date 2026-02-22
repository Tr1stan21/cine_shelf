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

/// Keeps user-related autoDispose providers alive during authenticated session.
///
/// **Why this exists:**
/// The user data providers (currentUserProvider, watchedCountProvider, etc.)
/// are autoDispose providers that clean up automatically when no longer watched.
/// Without this watcher, they would reload every time AccountScreen mounts/unmounts,
/// causing unnecessary Firestore reads and increased costs.
///
/// **Why this is NOT an anti-pattern here:**
/// 1. These are StreamProviders with active Firestore subscriptions (not one-time fetches)
/// 2. The data is needed across navigation (badges, account screen, etc.)
/// 3. Keeping them alive during the session is more efficient than repeated subscriptions
/// 4. Alternative would be removing autoDispose, but that prevents cleanup on sign-out
///
/// **Trade-off:**
/// - Memory: ~few KB of user data kept in memory (acceptable for session duration)
/// - Network: Prevents repeated Firestore reads (saves costs and improves UX)
/// - Clarity: Yes, this is a side-effect widget, but it's a deliberate caching strategy
///
/// If these providers are needed less frequently, consider:
/// - Removing autoDispose and manually invalidating on sign-out
/// - Converting to regular state management without streams
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

        // Keep these providers alive while user is authenticated
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
