import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cine_shelf/core/database/database_provider.dart';
import 'movie_cache_datasource.dart';

/// Provides a singleton [MovieCacheLocalDataSource] instance.
///
/// **Dependencies:**
/// - [appDatabaseProvider]: Injected Drift database instance
///
/// **Lifecycle:**
/// - Created once on first access
/// - Reused throughout app lifetime
///
/// **Usage:**
/// ```dart
/// final movieCache = ref.watch(movieCacheLocalDataSourceProvider);
/// final cached = await movieCache.getMovieDetail(movieId);
/// ```
final movieCacheLocalDataSourceProvider =
    Provider<MovieCacheLocalDataSource>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return MovieCacheLocalDataSource(db);
});
