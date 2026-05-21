import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';

import 'package:cine_shelf/core/database/drift_database.dart';
import 'package:cine_shelf/shared/models/movie_poster.dart';

/// Local data source for managing list-movie relationships using Drift.
///
/// Provides CRUD operations for the junction table [ListMovieRelationsTable]
/// and cached movie data [CachedMoviesTable]. Handles both movie data storage
/// and the relationships between lists and movies.
///
/// **Responsibility:**
/// - Store/retrieve movies cached from lists
/// - Manage relationships between lists and movies (N:N without duplication)
/// - Query movies by list using JOIN operations
/// - No remote calls; only local operations
/// - Silent error handling
///
/// **Usage:**
/// ```dart
/// final movieCache = ListMovieLocalDataSource(db);
/// await movieCache.addMovieToList(uid, listId, movieId);
/// final movies = await movieCache.getMoviePostersByList(uid, listId);
/// ```
class ListMovieLocalDataSource {
  /// Creates a [ListMovieLocalDataSource] with the provided [AppDatabase] instance.
  ListMovieLocalDataSource(this._db);

  final AppDatabase _db;

  /// Adds a movie to a list or updates if already present.
  ///
  /// **Behavior:**
  /// - Creates/updates the relationship in [ListMovieRelationsTable]
  /// - Does NOT store movie details here (done separately via [_cacheMovieIfNeeded])
  /// - Silently handles duplicates (UNIQUE constraint ignores)
  /// - Silent on error
  ///
  /// **Parameters:**
  /// - [uid]: User ID
  /// - [listId]: List ID
  /// - [movieId]: Movie ID (TMDB)
  Future<void> addMovieToList({
    required String uid,
    required String listId,
    required int movieId,
  }) async {
    try {
      await _db.into(_db.listMovieRelationsTable).insertOnConflictUpdate(
        ListMovieRelationsTableCompanion(
          uid: Value(uid),
          listId: Value(listId),
          movieId: Value(movieId),
          addedAt: Value(DateTime.now()),
          cachedAt: Value(DateTime.now()),
        ),
      );
    } catch (e, st) {
      debugPrint('ERROR adding movie to list: $e\n$st');
    }
  }

  /// Caches basic movie metadata so list posters can be retrieved offline.
  Future<void> cacheMoviePoster({
    required int movieId,
    required String? posterPath,
  }) async {
    try {
      final existing = await (_db.select(_db.cachedMoviesTable)
            ..where((m) => m.movieId.equals(movieId)))
          .getSingleOrNull();

      if (existing != null) {
        await (_db.update(_db.cachedMoviesTable)
              ..where((m) => m.movieId.equals(movieId)))
            .write(CachedMoviesTableCompanion(
              posterPath: Value(posterPath),
              cachedAt: Value(DateTime.now()),
            ));
        return;
      }

      await _db.into(_db.cachedMoviesTable).insert(
        CachedMoviesData(
          movieId: movieId,
          title: '',
          posterPath: posterPath,
          overview: null,
          releaseDate: null,
          genresJson: null,
          cachedAt: DateTime.now(),
        ),
      );
    } catch (e, st) {
      debugPrint('ERROR caching movie poster: $e\n$st');
    }
  }

  /// Caches a batch of movie posters in the shared movie cache.
  Future<void> cacheMovies(List<MoviePoster> movies) async {
    try {
      if (movies.isEmpty) return;

      final movieIds = movies.map((movie) => movie.id).toList();
      final existingRows = await (_db.select(_db.cachedMoviesTable)
            ..where((m) => m.movieId.isIn(movieIds)))
          .get();
      final existingIds = existingRows.map((row) => row.movieId).toSet();

      final inserts = movies
          .where((movie) => !existingIds.contains(movie.id))
          .map((movie) => CachedMoviesData(
                movieId: movie.id,
                title: '',
                posterPath: movie.posterPath,
                overview: null,
                releaseDate: null,
                genresJson: null,
                cachedAt: DateTime.now(),
              ))
          .toList();

      if (inserts.isNotEmpty) {
        await _db.batch((batch) {
          batch.insertAll(_db.cachedMoviesTable, inserts);
        });
      }

      for (final movie in movies.where((movie) => existingIds.contains(movie.id))) {
        await (_db.update(_db.cachedMoviesTable)
              ..where((m) => m.movieId.equals(movie.id)))
            .write(CachedMoviesTableCompanion(
              posterPath: Value(movie.posterPath),
              cachedAt: Value(DateTime.now()),
            ));
      }
    } catch (e, st) {
      debugPrint('ERROR caching movies: $e\n$st');
    }
  }

  /// Retrieves cached movie posters for a list (JOIN with cached_movies).
  ///
  /// **Returns:**
  /// - List of [MoviePoster] with data from cached_movies
  /// - Empty list if no movies found or on error
  ///
  /// **Behavior:**
  /// - Joins [ListMovieRelationsTable] with [CachedMoviesTable]
  /// - Returns only basic data: movieId and posterPath
  /// - Does NOT include title, overview, etc. (use getMovieDetails separately)
  ///
  /// **Error handling:** Catches exceptions silently; returns empty list.
  ///
  /// **Parameters:**
  /// - [uid]: User ID
  /// - [listId]: List ID
  Future<List<MoviePoster>> getMoviePostersByList({
    required String uid,
    required String listId,
  }) async {
    try {
      // Query: SELECT movieId, posterPath FROM cached_movies
      // WHERE movieId IN (SELECT movieId FROM list_movie_relations
      //                   WHERE uid=X AND listId=Y)
      final movieIds = await getMovieIds(uid, listId);

      if (movieIds.isEmpty) {
        return [];
      }

      final movies = await (_db.select(_db.cachedMoviesTable)
            ..where((m) => m.movieId.isIn(movieIds)))
          .get();

      return movies
          .map((m) => MoviePoster(id: m.movieId, posterPath: m.posterPath))
          .toList();
    } catch (e, st) {
      debugPrint('ERROR retrieving cached movie posters: $e\n$st');
      return [];
    }
  }

  /// Retrieves movie IDs for a list (without full movie details).
  ///
  /// **Returns:**
  /// - List of movie IDs (ints)
  /// - Empty list if none found or on error
  ///
  /// **Usage:**
  /// Helper method for JOIN queries. Not typically called directly.
  ///
  /// **Parameters:**
  /// - [uid]: User ID
  /// - [listId]: List ID
  Future<List<int>> getMovieIds(String uid, String listId) async {
    try {
      final relations = await (_db.select(_db.listMovieRelationsTable)
            ..where((r) => r.uid.equals(uid) & r.listId.equals(listId)))
          .get();

      return relations.map((r) => r.movieId).toList();
    } catch (e, st) {
      debugPrint('ERROR retrieving movie IDs: $e\n$st');
      return [];
    }
  }

  /// Deletes all movies from a list.
  ///
  /// **Behavior:**
  /// - Removes relationships from [ListMovieRelationsTable]
  /// - Does NOT delete from [CachedMoviesTable] (may be in other lists)
  /// - Silent on error
  ///
  /// **Parameters:**
  /// - [uid]: User ID
  /// - [listId]: List ID
  Future<void> clearListMovies(String uid, String listId) async {
    try {
      await (_db.delete(_db.listMovieRelationsTable)
            ..where((r) => r.uid.equals(uid) & r.listId.equals(listId)))
          .go();
    } catch (e, st) {
      debugPrint('ERROR clearing list movies: $e\n$st');
    }
  }

  /// Deletes all relationships for a user (used on sign-out).
  ///
  /// **Parameters:**
  /// - [uid]: User ID
  Future<void> clearByUid(String uid) async {
    try {
      await (_db.delete(_db.listMovieRelationsTable)
            ..where((r) => r.uid.equals(uid)))
          .go();
    } catch (e, st) {
      debugPrint('ERROR clearing user movie relations: $e\n$st');
    }
  }

  /// Deletes all cached relationships (global reset).
  ///
  /// **Used for:** Testing.
  /// **Silent on error.**
  Future<void> clearAll() async {
    try {
      await _db.delete(_db.listMovieRelationsTable).go();
    } catch (e, st) {
      debugPrint('ERROR clearing all movie relations: $e\n$st');
    }
  }
}
