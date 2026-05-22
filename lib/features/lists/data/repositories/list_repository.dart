import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

import 'package:cine_shelf/features/lists/data/local/list_local_datasource.dart';
import 'package:cine_shelf/features/lists/data/local/list_local_mapper.dart';
import 'package:cine_shelf/features/lists/data/local/list_movie_datasource.dart';
import 'package:cine_shelf/features/lists/models/user_custom_list.dart';
import 'package:cine_shelf/shared/models/movie_poster.dart';

/// Repository for managing user's movie lists in Firestore with offline cache.
///
/// Handles data operations for user's collections:
/// - Watched movies
/// - Watchlist
/// - Favorites
/// - Custom lists
///
/// Data structure: `/user/{uid}/list/{listId}/movies/{movieId}`
///
/// **Offline Caching Strategy:**
/// - [watchCustomLists]: attempts remote stream, falls back to cached lists
/// - [getListMovies]: attempts remote fetch, falls back to cached movies
/// - [addMovieToList]: optimistic local write + async remote sync
///
/// Both methods implement try-remote-catch-local pattern for offline support.
/// Repository contract for list operations (remote + offline cache).
abstract class ListRepository {
  Stream<int> watchListCount({required String uid, required String listId});

  Future<void> addMovieToList({
    required String uid,
    required String listId,
    required int movieId,
    required String? posterPath,
  });

  Future<void> removeMovieFromList({
    required String uid,
    required String listId,
    required int movieId,
  });

  Stream<bool> watchMovieInList({
    required String uid,
    required String listId,
    required int movieId,
  });

  Future<List<MoviePoster>> getListMovies({
    required String uid,
    required String listId,
  });

  Stream<List<UserCustomList>> watchCustomLists({required String uid});

  Future<String> createCustomList({
    required String uid,
    required String name,
    required String iconName,
  });

  Future<void> deleteCustomList({required String uid, required String listId});
}

class FirestoreListRepository implements ListRepository {
  /// Creates a [ListRepository] with Firestore and local cache dependencies.
  ///
  /// **Parameters:**
  /// - [_firestore]: Firestore instance for remote operations
  /// - [_listLocalDataSource]: Local Drift data source for list caching
  /// - [_listMovieDataSource]: Local Drift data source for movie relationships
  FirestoreListRepository(
    this._firestore,
    this._listLocalDataSource,
    this._listMovieDataSource,
  );

  final FirebaseFirestore _firestore;
  final ListLocalDataSource _listLocalDataSource;
  final ListMovieLocalDataSource _listMovieDataSource;

  CollectionReference<Map<String, dynamic>> _moviesCol(
    String uid,
    String listId,
  ) => _firestore
      .collection('user')
      .doc(uid)
      .collection('list')
      .doc(listId)
      .collection('movies');

  /// Returns a reactive stream of movie count for a specific list.
  @override
  Stream<int> watchListCount({required String uid, required String listId}) {
    return _moviesCol(uid, listId).snapshots().map((snapshot) => snapshot.size);
  }

  /// Adds a movie to the given list with optimistic local caching.
  ///
  /// **Behavior:**
  /// 1. Saves to local cache immediately (optimistic, non-blocking)
  /// 2. Attempts to sync to Firestore in background (async)
  /// 3. If remote sync fails: local cache persists until sync succeeds
  ///
  /// **Parameters:**
  /// - [uid]: User ID
  /// - [listId]: List ID
  /// - [movieId]: TMDB movie ID
  /// - [posterPath]: Movie poster path (for basic caching)
  @override
  Future<void> addMovieToList({
    required String uid,
    required String listId,
    required int movieId,
    required String? posterPath,
  }) async {
    // OPTIMISTIC: save movie metadata and relation locally first
    await _listMovieDataSource.cacheMoviePoster(
      movieId: movieId,
      posterPath: posterPath,
    );
    await _listMovieDataSource.addMovieToList(
      uid: uid,
      listId: listId,
      movieId: movieId,
    );

    // THEN: sync to Firestore (async, fire & forget)
    unawaited(
      _syncMovieToFirebaseInBackground(uid, listId, movieId, posterPath),
    );
  }

  /// Background task to sync movie to Firestore.
  ///
  /// **Behavior:**
  /// - Attempts to write movie to Firestore
  /// - Silent on error (local cache already saved)
  /// - Fire & forget
  ///
  /// **Parameters:**
  /// - [uid]: User ID
  /// - [listId]: List ID
  /// - [movieId]: TMDB movie ID
  /// - [posterPath]: Movie poster path
  Future<void> _syncMovieToFirebaseInBackground(
    String uid,
    String listId,
    int movieId,
    String? posterPath,
  ) async {
    try {
      await _moviesCol(uid, listId).doc(movieId.toString()).set({
        'movieId': movieId,
        'posterPath': posterPath,
        'addedAt': FieldValue.serverTimestamp(),
      });
    } catch (e, st) {
      debugPrint(
        'ERROR syncing movie to Firestore (local cache persists): $e\n$st',
      );
    }
  }

  /// Removes a movie from the given list. No-op if the document does not exist.
  @override
  Future<void> removeMovieFromList({
    required String uid,
    required String listId,
    required int movieId,
  }) {
    return _moviesCol(uid, listId).doc(movieId.toString()).delete();
  }

  /// Emits [true] when the movie document exists in the list, [false] otherwise.
  @override
  Stream<bool> watchMovieInList({
    required String uid,
    required String listId,
    required int movieId,
  }) {
    return _moviesCol(
      uid,
      listId,
    ).doc(movieId.toString()).snapshots().map((snap) => snap.exists);
  }

  /// Fetches movie posters stored in a list with offline fallback.
  ///
  /// **Behavior:**
  /// 1. Attempts to fetch from Firestore (remote)
  /// 2. On success: returns data and caches movies + relationships locally (fire & forget)
  /// 3. On failure: falls back to cached movies from Drift
  ///
  /// **Returns:**
  /// - List<[MoviePoster]> from Firestore (remote) if online
  /// - List<[MoviePoster]> from cache (Drift) if offline
  /// - Empty list if no remote data and no cache available
  ///
  /// **Offline behavior:**
  /// When offline, returns cached movies and relationships if previously loaded.
  /// Users can view their saved movies without internet.
  ///
  /// **Parameters:**
  /// - [uid]: User ID
  /// - [listId]: List ID
  @override
  Future<List<MoviePoster>> getListMovies({
    required String uid,
    required String listId,
  }) async {
    try {
      // ATTEMPT REMOTE
      final snapshot = await _moviesCol(uid, listId).orderBy('addedAt').get();
      final movies = snapshot.docs
          .map(
            (doc) => MoviePoster(
              id: (doc['movieId'] as num).toInt(),
              posterPath: doc['posterPath'] as String?,
            ),
          )
          .toList();

      // CACHE LOCALLY (fire & forget)
      unawaited(_cacheMoviesInBackground(movies, uid, listId));

      return movies;
    } on FirebaseException catch (e) {
      // REMOTE FAILED: try local cache
      debugPrint('LIST MOVIES REMOTE ERROR: $e, attempting cache fallback');

      final cachedPosters = await _listMovieDataSource.getMoviePostersByList(
        uid: uid,
        listId: listId,
      );
      if (cachedPosters.isNotEmpty) {
        debugPrint(
          'LIST MOVIES CACHE HIT: returning ${cachedPosters.length} movies',
        );
        return cachedPosters;
      }

      // Cache miss
      debugPrint('LIST MOVIES CACHE MISS: no cached movies found');
      return [];
    }
  }

  /// Background task to cache movies and their relationships.
  ///
  /// **Behavior:**
  /// - Stores basic movie data in cached_movies (if not already cached)
  /// - Creates relationships in list_movie_relations
  /// - Silent on error (fire & forget)
  ///
  /// **Parameters:**
  /// - [movies]: Movie posters to cache
  /// - [uid]: User ID
  /// - [listId]: List ID
  Future<void> _cacheMoviesInBackground(
    List<MoviePoster> movies,
    String uid,
    String listId,
  ) async {
    try {
      if (movies.isEmpty) return;

      await _listMovieDataSource.cacheMovies(movies);
      for (final movie in movies) {
        await _listMovieDataSource.addMovieToList(
          uid: uid,
          listId: listId,
          movieId: movie.id,
        );
      }
    } catch (e, st) {
      debugPrint('ERROR caching movies in background: $e\n$st');
    }
  }

  /// Returns a reactive stream of all custom lists for a user with offline fallback.
  ///
  /// **Behavior:**
  /// 1. Attempts to open a Firestore stream for custom lists
  /// 2. On success: emits remote data and caches it locally (fire & forget)
  /// 3. On stream error: falls back to cached lists from Drift
  ///
  /// **Returns:**
  /// - Stream of [UserCustomList] ordered by createdAt ascending
  /// - Empty list if no custom lists exist
  /// - Cached data if remote stream fails and cache available
  ///
  /// **Offline behavior:**
  /// When offline, emits cached lists if previously loaded. Users can view
  /// their custom lists without internet as long as they were cached during
  /// a previous online session.
  ///
  /// **Parameters:**
  /// - [uid]: User ID to fetch custom lists for
  @override
  Stream<List<UserCustomList>> watchCustomLists({required String uid}) async* {
    final baseQuery = _firestore
        .collection('user')
        .doc(uid)
        .collection('list')
        .where('type', isEqualTo: 'custom');

    final orderedQuery = baseQuery.orderBy('createdAt');

    List<UserCustomList> mapSnapshot(QuerySnapshot<Map<String, dynamic>> snap) {
      final lists = snap.docs
          .map((doc) => UserCustomList.fromFirestore(doc.id, doc.data()))
          .toList();
      lists.sort((a, b) {
        final aCreatedAt = a.createdAt;
        final bCreatedAt = b.createdAt;
        if (aCreatedAt == null && bCreatedAt == null) return 0;
        if (aCreatedAt == null) return 1;
        if (bCreatedAt == null) return -1;
        return aCreatedAt.compareTo(bCreatedAt);
      });

      unawaited(_listLocalDataSource.replaceAllLists(lists, uid));
      return lists;
    }

    try {
      await for (final snap in orderedQuery.snapshots()) {
        yield mapSnapshot(snap);
      }
    } catch (error, stackTrace) {
      debugPrint(
        'CUSTOM LISTS REMOTE ERROR: $error, attempting cache fallback\n$stackTrace',
      );

      try {
        final cachedLists = await _listLocalDataSource.getLists(uid);
        if (cachedLists.isNotEmpty) {
          debugPrint(
            'CUSTOM LISTS CACHE HIT: returning ${cachedLists.length} lists',
          );
          yield cachedLists.map((e) => e.toAppModel()).toList();
          return;
        }
      } catch (cacheError, cacheStackTrace) {
        debugPrint('CUSTOM LISTS CACHE ERROR: $cacheError\n$cacheStackTrace');
      }

      debugPrint('CUSTOM LISTS CACHE MISS: trying unordered remote query');
      try {
        await for (final snap in baseQuery.snapshots()) {
          yield mapSnapshot(snap);
        }
      } catch (fallbackError, fallbackStackTrace) {
        debugPrint(
          'CUSTOM LISTS FALLBACK QUERY FAILED: $fallbackError\n$fallbackStackTrace',
        );
        yield [];
      }
    }
  }

  /// Creates a new custom list document. Returns the generated listId.
  ///
  /// Sets up the list document with:
  /// - name: trimmed user input (1–30 chars, must contain ≥1 letter)
  /// - type: 'custom'
  /// - iconName: key in listIconCatalog
  /// - createdAt, updatedAt: serverTimestamp
  ///
  /// Firestore security rules validate the input shape and content.
  /// Throws if Firestore write fails (auth, validation, network).
  @override
  Future<String> createCustomList({
    required String uid,
    required String name,
    required String iconName,
  }) async {
    final listRef = _firestore
        .collection('user')
        .doc(uid)
        .collection('list')
        .doc(); // Auto-generate ID

    final now = Timestamp.now();

    await listRef.set({
      'name': name.trim(),
      'type': 'custom',
      'iconName': iconName,
      'createdAt': now,
      'updatedAt': now,
    });

    return listRef.id;
  }

  /// Deletes a custom list and its movies subcollection.
  ///
  /// Verifies the list document exists and that its type is 'custom'
  /// before removing any documents.
  @override
  Future<void> deleteCustomList({
    required String uid,
    required String listId,
  }) async {
    final listRef = _firestore
        .collection('user')
        .doc(uid)
        .collection('list')
        .doc(listId);

    final listSnapshot = await listRef.get();
    if (!listSnapshot.exists) {
      throw StateError('Custom list does not exist.');
    }

    final listData = listSnapshot.data();
    if (listData == null || listData['type'] != 'custom') {
      throw StateError('Only custom lists can be deleted.');
    }

    // Eliminar el documento de la lista primero — el stream emite
    // inmediatamente y la UI la quita. Las películas se borran después
    // en background sin afectar la pantalla.
    await listRef.delete();
    unawaited(_deleteListMoviesInBackground(uid, listId));
    await _listLocalDataSource.deleteList(uid, listId);
  }

  Future<void> _deleteListMoviesInBackground(String uid, String listId) async {
    final listRef = _firestore
        .collection('user')
        .doc(uid)
        .collection('list')
        .doc(listId);

    try {
      while (true) {
        final moviesSnapshot = await listRef
            .collection('movies')
            .limit(500)
            .get();

        if (moviesSnapshot.docs.isEmpty) break;

        final batch = _firestore.batch();
        for (final doc in moviesSnapshot.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();
      }
    } catch (e, st) {
      debugPrint(
        'ERROR deleting movies in background for list $listId: $e\n$st',
      );
    }
  }
}
