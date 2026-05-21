import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cine_shelf/core/database/database_provider.dart';
import 'rating_cache_datasource.dart';

/// Provides a singleton [RatingCacheLocalDataSource] instance.
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
/// final ratingCache = ref.watch(ratingCacheLocalDataSourceProvider);
/// await ratingCache.cacheRating(uid: uid, movieId: movieId, stars: 4.5);
/// final cached = await ratingCache.getRating(uid: uid, movieId: movieId);
/// ```
final ratingCacheLocalDataSourceProvider = Provider<RatingCacheLocalDataSource>(
  (ref) {
    final db = ref.watch(appDatabaseProvider);
    return RatingCacheLocalDataSource(db);
  },
);
