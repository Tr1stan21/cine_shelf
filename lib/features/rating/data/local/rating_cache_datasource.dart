import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';

import 'package:cine_shelf/core/database/drift_database.dart';

/// Local Drift datasource for caching user movie ratings.
///
/// Provides CRUD operations for [CachedRatingsTable]:
/// - **Create**: [cacheRating] (upsert: insert or update)
/// - **Read**: [getRating] (single rating) or [getRatings] (all user ratings)
/// - **Delete**: [deleteRating] (single) or [clearByUid] (all for user)
///
/// **Error Handling:** Silent logging with `debugPrint`. All methods catch
/// exceptions and return null/empty on failure, never rethrow. This ensures
/// the cache layer never crashes the app if database operations fail.
///
/// **Dependencies:**
/// - Injected [AppDatabase] instance via constructor
///
/// **Usage (Repository):**
/// ```dart
/// // Cache a rating
/// await datasource.cacheRating(uid, movieId, 4.5);
///
/// // Retrieve from cache
/// final cached = await datasource.getRating(uid, movieId);
/// if (cached != null) {
///   return cached.toAppModel(); // Extension mapper
/// }
/// ```
class RatingCacheLocalDataSource {
  /// Creates a [RatingCacheLocalDataSource] with a Drift database instance.
  ///
  /// **Parameter:**
  /// - [_db]: Drift database instance
  RatingCacheLocalDataSource(this._db);

  final AppDatabase _db;

  /// Caches or updates a movie rating in local Drift database.
  ///
  /// **Parameters:**
  /// - [uid]: User ID
  /// - [movieId]: TMDB movie ID
  /// - [stars]: Rating value (0-5)
  ///
  /// **Behavior:**
  /// - If (uid, movieId) exists: updates the record
  /// - If (uid, movieId) does not exist: inserts a new record
  /// - Sets `cachedAt` to current time
  /// - Sets `updatedAt` to provided value or current time
  ///
  /// **Returns:** void (fire & forget safe)
  ///
  /// **Error Handling:**
  /// - Catches and logs exceptions silently
  /// - Never rethrows
  Future<void> cacheRating({
    required String uid,
    required int movieId,
    required double stars,
    DateTime? updatedAt,
  }) async {
    try {
      final now = DateTime.now();
      await _db.into(_db.cachedRatingsTable).insertOnConflictUpdate(
        CachedRatingsTableCompanion(
          uid: Value(uid),
          movieId: Value(movieId),
          stars: Value(stars),
          updatedAt: Value(updatedAt ?? now),
          cachedAt: Value(now),
        ),
      );
    } catch (e, st) {
      debugPrint('ERROR caching rating ($uid, $movieId): $e\n$st');
    }
  }

  /// Retrieves a single movie rating from local cache.
  ///
  /// **Parameters:**
  /// - [uid]: User ID
  /// - [movieId]: TMDB movie ID
  ///
  /// **Returns:**
  /// - [CachedRatingsData] if found
  /// - null if not found or error occurred
  ///
  /// **Error Handling:**
  /// - Catches and logs exceptions silently
  /// - Returns null on error (not found or DB failure)
  Future<CachedRatingData?> getRating({
    required String uid,
    required int movieId,
  }) async {
    try {
      return await (_db.select(_db.cachedRatingsTable)
        ..where((r) => r.uid.equals(uid) & r.movieId.equals(movieId)))
          .getSingleOrNull();
    } catch (e, st) {
      debugPrint('ERROR reading rating ($uid, $movieId) from cache: $e\n$st');
      return null;
    }
  }

  /// Retrieves all movie ratings for a user from local cache.
  ///
  /// **Parameter:**
  /// - [uid]: User ID
  ///
  /// **Returns:**
  /// - List of [CachedRatingsData] (empty list if none found or error)
  ///
  /// **Error Handling:**
  /// - Catches and logs exceptions silently
  /// - Returns empty list on error
  Future<List<CachedRatingData>> getRatings(String uid) async {
    try {
      return await (_db.select(_db.cachedRatingsTable)
        ..where((r) => r.uid.equals(uid)))
          .get();
    } catch (e, st) {
      debugPrint('ERROR reading ratings for user $uid from cache: $e\n$st');
      return [];
    }
  }

  /// Deletes a single movie rating from local cache.
  ///
  /// **Parameters:**
  /// - [uid]: User ID
  /// - [movieId]: TMDB movie ID
  ///
  /// **Returns:** void (fire & forget safe)
  ///
  /// **Error Handling:**
  /// - Catches and logs exceptions silently
  /// - Never rethrows
  Future<void> deleteRating({
    required String uid,
    required int movieId,
  }) async {
    try {
      await (_db.cachedRatingsTable.delete()
            ..where((r) => r.uid.equals(uid) & r.movieId.equals(movieId)))
          .go();
    } catch (e, st) {
      debugPrint('ERROR deleting rating ($uid, $movieId) from cache: $e\n$st');
    }
  }

  /// Deletes all ratings for a user from local cache.
  ///
  /// **Parameter:**
  /// - [uid]: User ID
  ///
  /// **Returns:** void (fire & forget safe)
  ///
  /// **Error Handling:**
  /// - Catches and logs exceptions silently
  /// - Never rethrows
  ///
  /// **Used for:**
  /// - Sign-out cleanup (cascading delete)
  /// - Testing/reset scenarios
  Future<void> clearByUid(String uid) async {
    try {
      await (_db.cachedRatingsTable.delete()..where((r) => r.uid.equals(uid)))
          .go();
    } catch (e, st) {
      debugPrint('ERROR clearing ratings for user $uid from cache: $e\n$st');
    }
  }

  /// Clears all ratings from the local cache.
  ///
  /// **Returns:** void (fire & forget safe)
  ///
  /// **Error Handling:**
  /// - Catches and logs exceptions silently
  /// - Never rethrows
  ///
  /// **Used for:**
  /// - Testing/reset scenarios
  /// - Full app reset
  Future<void> clearAll() async {
    try {
      await _db.delete(_db.cachedRatingsTable).go();
    } catch (e, st) {
      debugPrint('ERROR clearing all ratings from cache: $e\n$st');
    }
  }
}
