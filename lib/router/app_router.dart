import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cine_shelf/features/account/account_screen.dart';
import 'package:cine_shelf/features/lists/my_lists_screen.dart';
import 'package:cine_shelf/features/auth/login_screen.dart';
import 'package:cine_shelf/features/home/home_screen.dart';
import 'package:cine_shelf/features/movies/movie_details_screen.dart';
import 'package:cine_shelf/features/movies/movie_list_screen.dart';
import 'package:cine_shelf/features/splash/splash_screen.dart';
import 'package:cine_shelf/models/movie_item.dart';

// Importa tu ShellScaffold que monta BackgroundBody + BottomNav
import 'package:cine_shelf/core/widgets/nav_shell.dart';

/// Argumentos para MovieListScreen
class MovieListArgs {
  const MovieListArgs({required this.title, required this.items});

  final String title;
  final List<MovieItem> items;
}

/// Argumentos para MovieDetailsScreen
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

      // -------- Tabs con estado persistente (BottomNav fija) --------
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
                    const NoTransitionPage(child: MyLists()),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _accountTabKey,
            routes: <RouteBase>[
              GoRoute(
                path: '/account',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: Account()),
              ),
            ],
          ),
        ],
      ),

      // -------- Pantallas fuera del shell (sin BottomNav) --------
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/movies',
        builder: (context, state) {
          final args = state.extra as MovieListArgs?;
          return MovieListScreen(
            title: args?.title ?? 'Películas',
            items: args?.items ?? const <MovieItem>[],
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
