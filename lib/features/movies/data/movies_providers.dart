import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tmdb_providers.dart';
import 'movies_repository_impl.dart';
import 'movies_repository.dart';

/// Provider for the movies repository.
///
/// **Dependencies:**
/// - Reads from [tmdbRemoteDataSourceProvider] for API access
///
/// **How it works:**
/// - Single instance per app (Provider, not FutureProvider)
/// - Lazily created on first use
/// - Wraps the remote data source with DTO-to-model mapping logic
///
/// **Data Flow:**
/// - TMDB API (Dio) → Response Parsing (Dio's fromJson) → DTOs
/// - DTOs → Mappers (extension methods) → App models
/// - App models → Returned to providers/notifiers
///
/// **Usage:**
/// ```dart
/// final repo = ref.watch(moviesRepositoryProvider);
/// final movies = await repo.getMoviesPage(ListCategory.popular);
/// final detail = await repo.getMovieDetail(movieId);
/// ```
final moviesRepositoryProvider = Provider<MoviesRepository>((ref) {
  final remote = ref.watch(tmdbRemoteDataSourceProvider);
  return MoviesRepositoryImpl(remote);
});
