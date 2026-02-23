import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/movie_detail.dart';
import '../data/movies_providers.dart';

/// Parametrized FutureProvider for fetching movie details by TMDB ID.
///
/// **How it works:**
/// - Parametrized by movie ID (each ID gets its own cached instance)
/// - With .autoDispose: cache is cleared when no one is watching
/// - Riverpod maintains independent cache per ID while listeners exist
///
/// **AutoDispose behavior:**
/// - When the details screen closes, all listeners unsubscribe
/// - Riverpod automatically frees the cached data
/// - Next navigation to the same movie re-fetches fresh data (or re-caches if listeners return)
/// - Prevents memory leaks and stale caches
///
/// **Parameters:**
/// - int: The TMDB movie ID
///
/// **Usage:**
/// ```dart
/// final movieDetail = ref.watch(movieDetailProvider(movieId));
/// movieDetail.when(
///   data: (movie) => MovieDetailsScreen(movie: movie),
///   loading: () => const LoadingWidget(),
///   error: (err, stack) => ErrorWidget(error: err),
/// );
/// ```
final movieDetailProvider = FutureProvider.autoDispose.family<MovieDetail, int>(
  (ref, movieId) {
    return ref.watch(moviesRepositoryProvider).getMovieDetail(movieId);
  },
);
