import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:cine_shelf/core/database/drift_database.dart';
import 'package:cine_shelf/features/movie_detail/models/movie_detail.dart';

/// Local data source for caching movie detail data using Drift.
///
/// Provides CRUD operations for cached movie details stored in the
/// [CachedMoviesTable]. Data is populated when movie details are fetched
/// from TMDB while online.
///
/// **Responsibility:**
/// - Store/retrieve full movie details in local SQLite database (Drift)
/// - No remote calls; only local operations
/// - Silent error handling (log and return null on failure)
///
/// **Usage:**
/// ```dart
/// final movieCache = MovieCacheLocalDataSource(ref.watch(appDatabaseProvider));
/// await movieCache.cacheMovieDetail(movieDetail, genresList);
/// final cached = await movieCache.getMovieDetail(movieId);
/// ```
class MovieCacheLocalDataSource {
  /// Creates a [MovieCacheLocalDataSource] with the provided [AppDatabase] instance.
  MovieCacheLocalDataSource(this._db);

  final AppDatabase _db;

  /// Caches (inserts or replaces) a complete movie detail record.
  ///
  /// **Behavior:**
  /// - Stores movie data including title, overview, poster path, release date
  /// - Serializes genre list as JSON
  /// - If movie already cached: replaces entire document (upsert)
  /// - Silent on error: catches and logs, does not rethrow
  ///
  /// **Parameters:**
  /// - [movieDetail]: [MovieDetail] with full app model
  /// - [genresList]: List of genre names to serialize as JSON
  /// - [posterPath]: Relative poster path from TMDB (not full URL)
  /// - [releaseDate]: ISO format date string (e.g., "2023-12-15")
  Future<void> cacheMovieDetail({
    required MovieDetail movieDetail,
    required List<String> genresList,
    required String? posterPath,
    required String? releaseDate,
  }) async {
    try {
      // Serialize genres to JSON
      final genresJson = jsonEncode(
        genresList.map((name) => {'name': name}).toList(),
      );

      await _db
          .into(_db.cachedMoviesTable)
          .insertOnConflictUpdate(
            CachedMoviesData(
              movieId: movieDetail.id,
              title: movieDetail.title,
              posterPath: posterPath,
              overview: movieDetail.overview,
              releaseDate: releaseDate,
              genresJson: genresJson,
              cachedAt: DateTime.now(),
            ),
          );
    } catch (e, st) {
      debugPrint('ERROR caching movie detail: $e\n$st');
    }
  }

  /// Retrieves cached movie detail by TMDB ID.
  ///
  /// **Returns:**
  /// - [CachedMoviesData] if found
  /// - `null` if not found or on error
  ///
  /// **Error handling:** Catches exceptions silently; returns `null`.
  ///
  /// **Parameters:**
  /// - [movieId]: TMDB movie ID
  Future<CachedMoviesData?> getMovieDetail(int movieId) async {
    try {
      return await (_db.select(
        _db.cachedMoviesTable,
      )..where((m) => m.movieId.equals(movieId))).getSingleOrNull();
    } catch (e, st) {
      debugPrint('ERROR retrieving cached movie detail: $e\n$st');
      return null;
    }
  }

  /// Deletes all cached movie details (global reset).
  ///
  /// **Used for:** Testing or global cache reset.
  /// **Silent on error.**
  ///
  /// **Note:** In production, prefer leaving cached movies around as they
  /// may be referenced by multiple lists or screens. Selective deletion
  /// by movieId is not exposed since unused movies are harmless and small.
  Future<void> clearAll() async {
    try {
      await _db.delete(_db.cachedMoviesTable).go();
    } catch (e, st) {
      debugPrint('ERROR clearing all cached movies: $e\n$st');
    }
  }
}
