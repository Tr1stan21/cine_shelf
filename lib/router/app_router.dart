import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cine_shelf/features/account/screens/account_screen.dart';
import 'package:cine_shelf/features/lists/screens/my_lists_screen.dart';
import 'package:cine_shelf/features/auth/screens/login_screen.dart';
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
    routes: <RouteBase>[
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

      // -------- Tabs with persistent state (Fixed BottomNav) --------
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

      // -------- Screens outside the shell (without BottomNav) --------
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
