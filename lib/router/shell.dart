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
/// Wraps the [StatefulNavigationShell] provided by GoRouter to add:
/// - Branded background image via [Background].
/// - Consistent padding applied to all tab content.
/// - [BottomNavBar] for tab switching.
/// - [_UserPreloadWatcher] to keep user-related providers alive during the
///   authenticated session (see that class for rationale).
///
/// Used as the builder for [StatefulShellRoute] in [AppRouter].
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

/// Invisible widget that keeps user-related autoDispose providers alive
/// for the duration of the authenticated session.
///
/// **Why this exists:**
/// [currentUserProvider], [watchedCountProvider], [watchlistCountProvider],
/// and [favoritesCountProvider] are all declared as `.autoDispose`. Without
/// an active watcher, Riverpod frees their cache when no widget is watching.
/// This means every tab navigation that mounts [AccountScreen] or [MyListsScreen]
/// would trigger a fresh Firestore read, increasing latency and costs.
///
/// By placing this watcher inside [NavShell] (which lives for the entire
/// authenticated session), all four providers remain subscribed continuously
/// from login until sign-out — even when the screens that display them are
/// not in the widget tree.
///
/// **Memory trade-off:**
/// A few KB of user data are kept in memory for the session lifetime.
/// This is acceptable given the benefit of avoided repeated Firestore reads.
///
/// **Cross-reference:**
/// [currentUserProvider] documents its autoDispose behavior and references
/// this watcher. If either is changed, update both.
class _UserPreloadWatcher extends ConsumerWidget {
  const _UserPreloadWatcher();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          // User is not authenticated — do not watch user providers.
          // They will dispose themselves since nothing is observing them.
          return const SizedBox.shrink();
        }

        // Watching these providers keeps them alive and their Firestore streams
        // open. The return value is intentionally discarded — this widget
        // renders nothing; it exists purely as a keep-alive mechanism.
        ref.watch(currentUserProvider);
        ref.watch(watchedCountProvider);
        ref.watch(watchlistCountProvider);
        ref.watch(favoritesCountProvider);

        return const SizedBox.shrink();
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
