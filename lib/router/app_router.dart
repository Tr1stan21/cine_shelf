import 'package:go_router/go_router.dart';

import 'package:cine_shelf/features/auth/login_screen.dart';
import 'package:cine_shelf/features/home/home_screen.dart';
import 'package:cine_shelf/features/movies/movie_details_screen.dart';
import 'package:cine_shelf/features/movies/movie_list_screen.dart';
import 'package:cine_shelf/features/splash/splash_screen.dart';
import 'package:cine_shelf/models/movie_item.dart';

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

/// Router centralizado de la aplicación usando GoRouter
///
/// Maneja todas las rutas y navegación de forma centralizada,
/// evitando acoplamientos directos entre pantallas.
class AppRouter {
  // Private constructor para evitar instanciación
  AppRouter._();

  /// Configuración de GoRouter
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/movies',
        builder: (context, state) {
          final args = state.extra as MovieListArgs?;
          return MovieListScreen(
            title: args?.title ?? 'Películas',
            items: args?.items ?? [],
          );
        },
      ),
      GoRoute(
        path: '/movies/details',
        builder: (context, state) {
          final args = state.extra as MovieDetailsArgs?;
          return MovieDetailsScreen(movieId: args?.movieId);
        },
      ),
    ],
  );
}
