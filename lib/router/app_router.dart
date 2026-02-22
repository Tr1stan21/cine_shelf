import 'package:cine_shelf/features/movies/models/movie_list_args.dart';
import 'package:cine_shelf/features/movies/models/movie_details_args.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cine_shelf/router/auth_state_notifier.dart';
import 'package:cine_shelf/router/splash_gate_notifier.dart';
import 'package:cine_shelf/router/route_paths.dart';
import 'package:cine_shelf/features/auth/application/auth_providers.dart';
import 'package:cine_shelf/features/account/screens/account_screen.dart';
import 'package:cine_shelf/features/lists/screens/my_lists_screen.dart';
import 'package:cine_shelf/features/auth/screens/login_screen.dart';
import 'package:cine_shelf/features/auth/screens/sign_up_screen.dart';
import 'package:cine_shelf/features/home/screens/home_screen.dart';
import 'package:cine_shelf/features/movies/screens/movie_details_screen.dart';
import 'package:cine_shelf/features/movies/screens/movie_list_screen.dart';
import 'package:cine_shelf/features/splash/screens/splash_screen.dart';
import 'package:cine_shelf/features/movies/models/movie_poster.dart';
import 'package:cine_shelf/router/shell.dart';

/// Central routing configuration for the CineShelf application.
///
/// Manages all navigation routes using GoRouter with:
/// - Authentication-based route protection and redirection
/// - StatefulShellRoute for persistent bottom navigation tabs
/// - Separate navigator keys for proper navigation stack management
/// - Integration with Riverpod auth state for reactive navigation
///
/// Route structure:
/// - `/` - Splash screen (initial route, router decides redirect)
/// - `/login`, `/sign-up` - Authentication screens (blocked when authenticated)
/// - `/home`, `/mylists`, `/account` - Tab-based protected routes
/// - `/movies`, `/movies/details` - Full-screen protected routes
class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> _rootKey = GlobalKey<NavigatorState>(
    debugLabel: 'root',
  );

  static final GlobalKey<NavigatorState> _homeTabKey =
      GlobalKey<NavigatorState>(debugLabel: 'homeTab');
  static final GlobalKey<NavigatorState> _myListsTabKey =
      GlobalKey<NavigatorState>(debugLabel: 'myListsTab');
  static final GlobalKey<NavigatorState> _accountTabKey =
      GlobalKey<NavigatorState>(debugLabel: 'accountTab');

  /// Creates GoRouter instance configured with auth-based redirect logic.
  ///
  /// The router reacts to auth state changes via [refreshListenable],
  /// triggering redirect logic whenever authentication status changes.
  ///
  /// Parameters:
  /// - [authNotifier]: Listenable that notifies when auth state changes
  /// - [splashGate]: Listenable that controls splash gating
  ///
  /// Returns configured GoRouter instance ready for MaterialApp.router
  static GoRouter createRouter({
    required AuthStateNotifier authNotifier,
    required SplashGateNotifier splashGate,
    required Listenable refreshListenable,
  }) {
    return GoRouter(
      navigatorKey: _rootKey,
      initialLocation: RoutePaths.splash,
      refreshListenable: refreshListenable,
      redirect: (context, state) =>
          _handleRedirect(state, authNotifier, splashGate),
      routes: <RouteBase>[
        /// Entry point - SplashScreen is visual-only
        GoRoute(
          path: RoutePaths.splash,
          builder: (context, state) => const SplashScreen(),
        ),

        /// Auth screens - only accessible when not authenticated
        GoRoute(
          path: RoutePaths.login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: RoutePaths.signUp,
          builder: (context, state) => const SignUpScreen(),
        ),

        /// App shell with bottom navigation tabs
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return NavShell(navigationShell: navigationShell);
          },
          branches: <StatefulShellBranch>[
            StatefulShellBranch(
              navigatorKey: _homeTabKey,
              routes: <RouteBase>[
                GoRoute(
                  path: RoutePaths.home,
                  pageBuilder: (context, state) =>
                      const NoTransitionPage(child: HomeScreen()),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _myListsTabKey,
              routes: <RouteBase>[
                GoRoute(
                  path: RoutePaths.myLists,
                  pageBuilder: (context, state) =>
                      const NoTransitionPage(child: MyListsScreen()),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _accountTabKey,
              routes: <RouteBase>[
                GoRoute(
                  path: RoutePaths.account,
                  pageBuilder: (context, state) =>
                      const NoTransitionPage(child: AccountScreen()),
                ),
              ],
            ),
          ],
        ),

        /// Movie screens - only accessible when authenticated
        GoRoute(
          parentNavigatorKey: _rootKey,
          path: RoutePaths.movies,
          builder: (context, state) {
            final args = state.extra as MovieListArgs?;
            return MovieListScreen(
              title: args?.title ?? 'Movies',
              items: args?.items ?? const <MoviePoster>[],
            );
          },
        ),
        GoRoute(
          parentNavigatorKey: _rootKey,
          path: RoutePaths.movieDetails,
          builder: (context, state) {
            final args = state.extra as MovieDetailsArgs?;
            return MovieDetailsScreen(movie: args!.movie);
          },
        ),
      ],
    );
  }

  /// Implements authentication-based route protection and redirection.
  ///
  /// Redirect logic:
  /// 1. If auth not initialized, redirects all routes to splash for proper initialization
  /// 2. When initialized, `/` redirects to `/home` or `/login` when splash gate opens
  /// 3. Protected app routes require authentication - redirects to `/login` if not authenticated
  /// 4. Auth screens (`/login`, `/sign-up`) redirect to `/home` if already authenticated
  /// 5. All other routes proceed without redirection
  ///
  /// Returns the route to redirect to, or `null` to allow navigation to proceed.
  static String? _handleRedirect(
    GoRouterState state,
    AuthStateNotifier authNotifier,
    SplashGateNotifier splashGate,
  ) {
    final location = state.matchedLocation;
    String? destination;

    // If auth not initialized yet, force to splash for loading.
    if (!authNotifier.isInitialized) {
      destination = RoutePaths.splash;
    } else if (location == RoutePaths.splash) {
      if (!splashGate.isReady) {
        return null;
      }

      destination = authNotifier.isAuthenticated
          ? RoutePaths.home
          : RoutePaths.login;
    } else {
      final isProtectedRoute = RoutePaths.isProtectedRoute(location);

      if (isProtectedRoute && !authNotifier.isAuthenticated) {
        destination = RoutePaths.login;
      }

      if (authNotifier.isAuthenticated &&
          RoutePaths.authRoutes.contains(location)) {
        destination = RoutePaths.home;
      }
    }

    if (destination == null || destination == location) {
      return null;
    }

    return destination;
  }
}

class _RedirectState {
  const _RedirectState({
    required this.isAuthenticated,
    required this.isGateOpen,
    required this.isInitialized,
  });

  final bool isAuthenticated;
  final bool isGateOpen;
  final bool isInitialized;

  factory _RedirectState.from(
    AuthStateNotifier authNotifier,
    SplashGateNotifier splashGate,
  ) {
    return _RedirectState(
      isAuthenticated: authNotifier.isAuthenticated,
      isGateOpen: splashGate.isReady,
      isInitialized: authNotifier.isInitialized,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _RedirectState &&
        other.isAuthenticated == isAuthenticated &&
        other.isGateOpen == isGateOpen &&
        other.isInitialized == isInitialized;
  }

  @override
  int get hashCode => Object.hash(isAuthenticated, isGateOpen, isInitialized);
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.read(authStateNotifierProvider);
  final splashGate = ref.read(splashGateNotifierProvider);
  final refreshNotifier = ValueNotifier<int>(0);
  var lastState = _RedirectState.from(authNotifier, splashGate);

  void bumpIfNeeded() {
    final nextState = _RedirectState.from(authNotifier, splashGate);
    if (nextState == lastState) {
      return;
    }

    lastState = nextState;
    refreshNotifier.value++;
  }

  // Listen to auth state changes directly from authStateProvider (single source of truth).
  // This ensures the router reacts to authentication updates consistently with the rest of the app.
  // authStateNotifier self-synchronizes with this same stream, so its getters reflect current state.
  ref.listen<AsyncValue<User?>>(authStateProvider, (previous, next) {
    bumpIfNeeded();
  });

  // Listen to sign-out flag to redirect immediately before auth stream updates.
  ref.listen<bool>(signOutInProgressProvider, (previous, next) {
    bumpIfNeeded();
  });

  // Also listen to splashGate completion changes
  splashGate.addListener(bumpIfNeeded);

  ref.onDispose(() {
    splashGate.removeListener(bumpIfNeeded);
    refreshNotifier.dispose();
  });

  return AppRouter.createRouter(
    authNotifier: authNotifier,
    splashGate: splashGate,
    refreshListenable: refreshNotifier,
  );
});
