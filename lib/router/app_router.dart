import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cine_shelf/router/auth_state_notifier.dart';
import 'package:cine_shelf/features/account/screens/account_screen.dart';
import 'package:cine_shelf/features/lists/screens/my_lists_screen.dart';
import 'package:cine_shelf/features/auth/screens/login_screen.dart';
import 'package:cine_shelf/features/auth/screens/sign_up_screen.dart';
import 'package:cine_shelf/features/home/screens/home_screen.dart';
import 'package:cine_shelf/features/movies/screens/movie_details_screen.dart';
import 'package:cine_shelf/features/movies/screens/movie_list_screen.dart';
import 'package:cine_shelf/features/splash/screens/splash_screen.dart';
import 'package:cine_shelf/features/movies/models/movie.dart';
import 'package:cine_shelf/shared/widgets/nav_shell.dart';

/// Arguments for MovieListScreen
///
/// Encapsulates data needed to display a filtered or categorized list of movies.
class MovieListArgs {
  const MovieListArgs({required this.title, required this.items});

  final String title;
  final List<Movie> items;
}

/// Arguments for MovieDetailsScreen
///
/// Carries movie identifier for detail screen navigation.
class MovieDetailsArgs {
  const MovieDetailsArgs({this.movieId});

  final String? movieId;
}

/// Central routing configuration for the CineShelf application.
///
/// Manages all navigation routes using GoRouter with:
/// - Authentication-based route protection and redirection
/// - StatefulShellRoute for persistent bottom navigation tabs
/// - Separate navigator keys for proper navigation stack management
/// - Integration with Riverpod auth state for reactive navigation
///
/// Route structure:
/// - `/` - Splash screen (initial route, handles auth-based navigation)
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

  /// Cached reference to auth state notifier for redirect callback access.
  ///
  /// Stored statically because GoRouter redirect callbacks cannot directly reference
  /// Riverpod providers. Updated each time createRouter is called.
  static AuthStateNotifier? _authNotifier;

  /// Creates GoRouter instance configured with auth-based redirect logic.
  ///
  /// The router reacts to auth state changes via [refreshListenable],
  /// triggering redirect logic whenever authentication status changes.
  ///
  /// Parameters:
  /// - [authNotifier]: Listenable that notifies when auth state changes
  ///
  /// Returns configured GoRouter instance ready for MaterialApp.router
  static GoRouter createRouter(AuthStateNotifier authNotifier) {
    _authNotifier = authNotifier;

    return GoRouter(
      navigatorKey: _rootKey,
      initialLocation: '/',
      refreshListenable: authNotifier,
      redirect: _handleRedirect,
      routes: <RouteBase>[
        /// Entry point - SplashScreen handles auth-based navigation
        GoRoute(path: '/', builder: (context, state) => const SplashScreen()),

        /// Auth screens - only accessible when not authenticated
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/sign-up',
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
                  path: '/home',
                  pageBuilder: (context, state) =>
                      const NoTransitionPage(child: HomeScreen()),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _myListsTabKey,
              routes: <RouteBase>[
                GoRoute(
                  path: '/mylists',
                  pageBuilder: (context, state) =>
                      const NoTransitionPage(child: MyListsScreen()),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _accountTabKey,
              routes: <RouteBase>[
                GoRoute(
                  path: '/account',
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
          path: '/movies',
          builder: (context, state) {
            final args = state.extra as MovieListArgs?;
            return MovieListScreen(
              title: args?.title ?? 'Movies',
              items: args?.items ?? const <Movie>[],
            );
          },
        ),
        GoRoute(
          parentNavigatorKey: _rootKey,
          path: '/movies/details',
          builder: (context, state) {
            final args = state.extra as MovieDetailsArgs?;
            return MovieDetailsScreen(movieId: args?.movieId);
          },
        ),
      ],
    );
  }

  /// Implements authentication-based route protection and redirection.
  ///
  /// Redirect logic:
  /// 1. Splash screen (`/`) always allowed - handles its own navigation timing and loading
  /// 2. If auth not initialized, redirects all routes to splash for proper initialization
  /// 3. Protected app routes require authentication - redirects to `/login` if not authenticated
  /// 4. Auth screens (`/login`, `/sign-up`) redirect to `/home` if already authenticated
  /// 5. All other routes proceed without redirection
  ///
  /// Returns the route to redirect to, or `null` to allow navigation to proceed.
  static String? _handleRedirect(BuildContext context, GoRouterState state) {
    final location = state.matchedLocation;
    final authNotifier = _authNotifier;

    // Allow splash to display and handle its own navigation timing
    if (location == '/') {
      return null;
    }

    // If auth not initialized yet, force to splash for loading
    if (authNotifier == null || !authNotifier.isInitialized) {
      return '/';
    }

    final isLoggedIn = authNotifier.isAuthenticated;

    // Protect app routes - redirect unauthenticated users to login
    final isProtectedRoute =
        location.startsWith('/home') ||
        location.startsWith('/mylists') ||
        location.startsWith('/account') ||
        location.startsWith('/movies');

    if (isProtectedRoute && !isLoggedIn) {
      return '/login';
    }

    // Block auth screens for authenticated users
    if (isLoggedIn && (location == '/login' || location == '/sign-up')) {
      return '/home';
    }

    // Allow all other navigation
    return null;
  }
}
