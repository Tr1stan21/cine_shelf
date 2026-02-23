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
import 'package:cine_shelf/features/credits/screens/credits.dart';
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

        /// Movie list screen — passes initialItems and optional category for
        /// infinite scroll support.
        GoRoute(
          parentNavigatorKey: _rootKey,
          path: RoutePaths.movies,
          builder: (context, state) {
            final args = state.extra as MovieListArgs?;
            return MovieListScreen(
              title: args?.title ?? 'Movies',
              initialItems: args?.items ?? const <MoviePoster>[],
              totalPages: args?.totalPages ?? 1,
              category: args?.category,
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

        GoRoute(
          parentNavigatorKey: _rootKey,
          path: RoutePaths.credits,
          builder: (context, state) => const CreditsScreen(),
        ),
      ],
    );
  }

  /// Implements authentication-based route protection and redirection.
  ///
  /// Redirect logic:
  /// 1. If auth not initialized, redirects all routes to splash.
  /// 2. When initialized, `/` redirects to `/home` or `/login` when splash gate opens.
  /// 3. Protected routes require authentication - redirects to `/login` if not.
  /// 4. Auth screens redirect to `/home` when already authenticated.
  /// 5. All other routes proceed without redirection.
  static String? _handleRedirect(
    GoRouterState state,
    AuthStateNotifier authNotifier,
    SplashGateNotifier splashGate,
  ) {
    final location = state.matchedLocation;
    String? destination;

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

/// Immutable snapshot of the three boolean states that drive GoRouter's
/// redirect logic.
///
/// Used by [goRouterProvider] to deduplicate [refreshListenable] notifications.
/// The [goRouterProvider] only increments the refresh counter when at least one
/// of these values changes — preventing redundant router evaluations triggered
/// by unrelated Riverpod state updates that happen to call [bumpIfNeeded].
///
/// Equality is implemented by comparing all three fields, so a bump is skipped
/// when auth state emits but the effective redirect outcome would be identical
/// (e.g., multiple `data` emissions with the same authenticated user).
class _RedirectState {
  const _RedirectState({
    required this.isAuthenticated,
    required this.isGateOpen,
    required this.isInitialized,
  });

  /// Whether a user is currently authenticated and not in the process of
  /// signing out. Derived from [AuthStateNotifier.isAuthenticated].
  final bool isAuthenticated;

  /// Whether the splash gate has completed its minimum delay and data
  /// preloading. Derived from [SplashGateNotifier.isReady].
  final bool isGateOpen;

  /// Whether the auth stream has emitted at least one value, meaning the
  /// initial auth state is known. Derived from [AuthStateNotifier.isInitialized].
  final bool isInitialized;

  /// Constructs a [_RedirectState] snapshot from the current state of
  /// [authNotifier] and [splashGate].
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

  /// Two [_RedirectState] instances are equal when all three fields match,
  /// meaning the router redirect outcome would be identical and no refresh
  /// notification is needed.
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

/// Provider for the application's [GoRouter] instance.
///
/// **What it exposes:**
/// A fully configured [GoRouter] that reacts to changes in authentication
/// state, sign-out progress, and splash gate readiness.
///
/// **Dependencies:**
/// - [authStateNotifierProvider]: Subscribes to auth and sign-out state.
/// - [splashGateNotifierProvider]: Subscribes to splash gate readiness.
/// - [authStateProvider]: Listens for Firebase auth stream changes.
/// - [signOutInProgressProvider]: Listens for sign-out flag changes.
///
/// **Deduplication strategy:**
/// Rather than passing [AuthStateNotifier] or [SplashGateNotifier] directly
/// as `refreshListenable` (which would trigger a redirect evaluation on every
/// `notifyListeners` call regardless of outcome), this provider uses a
/// [ValueNotifier<int>] counter that is only incremented when the
/// [_RedirectState] snapshot actually changes. This avoids redundant redirect
/// evaluations during rapid successive state emissions.
///
/// **Lifecycle:**
/// This is a non-autoDispose provider. The router lives for the entire app
/// session. Listeners added to [splashGate] are explicitly removed in
/// [ref.onDispose] to prevent memory leaks.
final goRouterProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.read(authStateNotifierProvider);
  final splashGate = ref.read(splashGateNotifierProvider);

  // A simple integer counter used as the refresh listenable.
  // GoRouter re-evaluates its redirect logic whenever this value changes.
  // We only increment it when the effective redirect state actually changes
  // (see _RedirectState) to avoid redundant evaluations.
  final refreshNotifier = ValueNotifier<int>(0);
  var lastState = _RedirectState.from(authNotifier, splashGate);

  /// Compares the current [_RedirectState] to the last known state and
  /// increments [refreshNotifier] only if something changed.
  void bumpIfNeeded() {
    final nextState = _RedirectState.from(authNotifier, splashGate);
    if (nextState == lastState) {
      return;
    }
    lastState = nextState;
    refreshNotifier.value++;
  }

  // Listen to Firebase auth stream changes via Riverpod.
  ref.listen<AsyncValue<User?>>(authStateProvider, (previous, next) {
    bumpIfNeeded();
  });

  // Listen to the sign-out flag so the router redirects immediately when
  // sign-out starts, before the auth stream emits null.
  ref.listen<bool>(signOutInProgressProvider, (previous, next) {
    bumpIfNeeded();
  });

  // Listen to splash gate readiness (ChangeNotifier, not a Riverpod provider).
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
