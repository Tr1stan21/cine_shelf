import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/movie_detail.dart';
import '../data/movies_providers.dart';

/// Provider parametrizado por el id TMDB de la película.
///
/// Riverpod cachea el resultado por id mientras haya listeners activos.
/// Al salir del detalle (.autoDispose) se libera automáticamente.
///
/// Uso:
/// ```dart
/// ref.watch(movieDetailProvider(movie.id))
/// ```
final movieDetailProvider = FutureProvider.autoDispose.family<MovieDetail, int>(
  (ref, movieId) {
    return ref.watch(moviesRepositoryProvider).getMovieDetail(movieId);
  },
);
