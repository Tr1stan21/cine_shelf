import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cine_shelf/core/database/database_provider.dart';
import 'list_local_datasource.dart';
import 'list_movie_datasource.dart';

/// Provides a singleton [ListLocalDataSource] instance.
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
/// final listCache = ref.watch(listLocalDataSourceProvider);
/// final lists = await listCache.getLists(uid);
/// ```
final listLocalDataSourceProvider = Provider<ListLocalDataSource>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ListLocalDataSource(db);
});

/// Provides a singleton [ListMovieLocalDataSource] instance.
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
/// final movieCache = ref.watch(listMovieLocalDataSourceProvider);
/// final posters = await movieCache.getMoviePostersByList(uid, listId);
/// ```
final listMovieLocalDataSourceProvider =
    Provider<ListMovieLocalDataSource>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ListMovieLocalDataSource(db);
});
