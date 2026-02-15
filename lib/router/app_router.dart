import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
class MovieListArgs {
  const MovieListArgs({required this.title, required this.items});

  final String title;
  final List<Movie> items;
}

/// Arguments for MovieDetailsScreen
class MovieDetailsArgs {
  const MovieDetailsArgs({this.movieId});

  final String? movieId;
}

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

  static final GoRouter router = GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/',
    redirect: _handleRedirect,
    routes: <RouteBase>[
      /// Entry point - SplashScreen handles auth-based navigation
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),

      /// Auth screens - only accessible when not authenticated
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
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

  /// Redirect logic for route protection.
  /// - SplashScreen (/) handles initial auth-based navigation
  /// - Protects app routes when not authenticated
  /// - Prevents access to auth screens when authenticated
  static String? _handleRedirect(BuildContext context, GoRouterState state) {
    final location = state.matchedLocation;
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;

    // Allow splash to load and handle initial navigation
    if (location == '/') {
      return null;
    }

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
