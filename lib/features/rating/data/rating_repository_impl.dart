import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'local/rating_cache_datasource.dart';
import 'local/rating_cache_mapper.dart';
import 'rating_repository.dart';

class FirestoreRatingRepository implements RatingRepository {
  /// Creates a [FirestoreRatingRepository] with Firestore and cache dependencies.
  ///
  /// **Parameters:**
  /// - [_firestore]: Firebase Firestore instance for remote operations
  /// - [_ratingCacheDataSource]: Local Drift datasource for offline caching
  FirestoreRatingRepository(this._firestore, this._ratingCacheDataSource);

  final FirebaseFirestore _firestore;
  final RatingCacheLocalDataSource _ratingCacheDataSource;

  CollectionReference<Map<String, dynamic>> _ratingsCol(String uid) =>
      _firestore.collection('user').doc(uid).collection('movieRating');

  @override
  Stream<double?> watchRating({required String uid, required int movieId}) {
    // ATTEMPT REMOTE stream with proper fallback to cache on error
    return (() async* {
      try {
        await for (final snap in _ratingsCol(
          uid,
        ).doc(movieId.toString()).snapshots()) {
          if (!snap.exists) {
            yield null;
            continue;
          }

          final data = snap.data();
          final starsRaw = data?['stars'];
          if (starsRaw is! num) {
            yield null;
            continue;
          }

          final result = starsRaw.toDouble();

          // Extract updatedAt safely (Firestore Timestamp -> DateTime)
          DateTime? updatedAt;
          final updatedRaw = data?['updatedAt'];
          if (updatedRaw is Timestamp) {
            updatedAt = updatedRaw.toDate();
          } else if (updatedRaw is DateTime) {
            updatedAt = updatedRaw;
          }

          // CACHE successfully fetched rating in background
          unawaited(
            _ratingCacheDataSource.cacheRating(
              uid: uid,
              movieId: movieId,
              stars: result,
              updatedAt: updatedAt,
            ),
          );

          yield result;
        }
      } catch (e) {
        debugPrint(
          'RATING STREAM REMOTE ERROR for ($uid, $movieId): $e\nFalling back to cache',
        );
        yield* _watchRatingFromCache(uid, movieId);
      }
    })();
  }

  /// Local cache stream fallback for watchRating.
  ///
  /// Emits the cached rating value once, then completes.
  /// Used when Firestore stream fails.
  Stream<double?> _watchRatingFromCache(String uid, int movieId) async* {
    try {
      final cached = await _ratingCacheDataSource.getRating(
        uid: uid,
        movieId: movieId,
      );
      if (cached != null) {
        debugPrint(
          'RATING CACHE HIT: returning cached value for ($uid, $movieId)',
        );
        yield cached.toAppModel();
      } else {
        debugPrint('RATING CACHE MISS: no cached value for ($uid, $movieId)');
        yield null;
      }
    } catch (e, st) {
      debugPrint('ERROR reading rating from cache ($uid, $movieId): $e\n$st');
      yield null;
    }
  }

  @override
  Future<void> setRating({
    required String uid,
    required int movieId,
    required double stars,
  }) async {
    // OPTIMISTIC WRITE: Cache locally first (synchronous)
    await _ratingCacheDataSource.cacheRating(
      uid: uid,
      movieId: movieId,
      stars: stars,
    );

    // BACKGROUND SYNC: Persist to Firestore (async, fire & forget)
    unawaited(_syncRatingToFirebase(uid, movieId, stars));
  }

  /// Background task to sync rating to Firestore.
  ///
  /// **Behavior:**
  /// - Persists to Firestore
  /// - Logs on failure, never rethrows
  /// - Local cache persists even if remote sync fails
  ///
  /// **Parameters:**
  /// - [uid]: User ID
  /// - [movieId]: TMDB movie ID
  /// - [stars]: Rating value to persist
  Future<void> _syncRatingToFirebase(
    String uid,
    int movieId,
    double stars,
  ) async {
    try {
      await _ratingsCol(uid).doc(movieId.toString()).set({
        'stars': stars,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e, st) {
      debugPrint(
        'ERROR syncing rating to Firestore ($uid, $movieId): $e\n$st\nLocal cache persists.',
      );
    }
  }

  @override
  Future<void> deleteRating({required String uid, required int movieId}) async {
    // OPTIMISTIC DELETE: Remove from cache immediately
    await _ratingCacheDataSource.deleteRating(uid: uid, movieId: movieId);

    // BACKGROUND SYNC: Delete from Firestore (async, fire & forget)
    unawaited(_deleteRatingFromFirebase(uid, movieId));
  }

  /// Background task to delete rating from Firestore.
  ///
  /// **Behavior:**
  /// - Deletes from Firestore
  /// - Logs on failure, never rethrows
  /// - Local cache deletion persists even if remote delete fails
  ///
  /// **Parameters:**
  /// - [uid]: User ID
  /// - [movieId]: TMDB movie ID
  Future<void> _deleteRatingFromFirebase(String uid, int movieId) async {
    try {
      await _ratingsCol(uid).doc(movieId.toString()).delete();
    } catch (e, st) {
      debugPrint(
        'ERROR deleting rating from Firestore ($uid, $movieId): $e\n$st\nLocal cache deletion persists.',
      );
    }
  }
}
