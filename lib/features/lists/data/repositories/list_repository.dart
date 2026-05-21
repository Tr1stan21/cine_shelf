import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:cine_shelf/features/lists/models/user_custom_list.dart';
import 'package:cine_shelf/shared/models/movie_poster.dart';

/// Repository for managing user's movie lists in Firestore.
///
/// Handles data operations for user's collections:
/// - Watched movies
/// - Watchlist
/// - Favorites
/// - Custom lists
///
/// Data structure: `/user/{uid}/list/{listId}/movies/{movieId}`
class ListRepository {
  ListRepository(this._firestore);

  final FirebaseFirestore _firestore;

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
  Stream<int> watchListCount({required String uid, required String listId}) {
    return _moviesCol(uid, listId).snapshots().map((snapshot) => snapshot.size);
  }

  /// Adds a movie to the given list. Overwrites if already present.
  Future<void> addMovieToList({
    required String uid,
    required String listId,
    required int movieId,
    required String? posterPath,
  }) {
    return _moviesCol(uid, listId).doc(movieId.toString()).set({
      'movieId': movieId,
      'posterPath': posterPath,
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Removes a movie from the given list. No-op if the document does not exist.
  Future<void> removeMovieFromList({
    required String uid,
    required String listId,
    required int movieId,
  }) {
    return _moviesCol(uid, listId).doc(movieId.toString()).delete();
  }

  /// Emits [true] when the movie document exists in the list, [false] otherwise.
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

  /// One-shot fetch of movie posters stored in a list, ordered by insertion
  /// time (ascending). Used for navigation — does not maintain an open stream.
  Future<List<MoviePoster>> getListMovies({
    required String uid,
    required String listId,
  }) async {
    final snapshot = await _moviesCol(uid, listId).orderBy('addedAt').get();
    return snapshot.docs
        .map(
          (doc) => MoviePoster(
            id: (doc['movieId'] as num).toInt(),
            posterPath: doc['posterPath'] as String?,
          ),
        )
        .toList();
  }

  /// Returns a reactive stream of all custom lists for a user, ordered by createdAt ascending.
  ///
  /// Filters for documents where `type == 'custom'`. Returns an empty list if no custom
  /// lists exist or on error.
  Stream<List<UserCustomList>> watchCustomLists({required String uid}) {
    // Try to delegate ordering to Firestore. If the remote query fails
    // (e.g., missing index or server-side error), fall back to the
    // unordered query and sort on the client to avoid returning no data.
    final baseQuery = _firestore
        .collection('user')
        .doc(uid)
        .collection('list')
        .where('type', isEqualTo: 'custom');

    Stream<List<UserCustomList>> mapSnapshot(
      QuerySnapshot<Map<String, dynamic>> snap,
    ) {
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
      return Stream<List<UserCustomList>>.value(lists);
    }

    // First attempt: ask Firestore to order by createdAt.
    final orderedQuery = baseQuery.orderBy('createdAt');

    // Use an async* stream to catch synchronous stream errors and provide a
    // fallback to the unordered query when needed.
    return (() async* {
      try {
        await for (final snap in orderedQuery.snapshots()) {
          yield* mapSnapshot(snap);
        }
      } catch (error, stackTrace) {
        debugPrint(
          'watchCustomLists ordered query failed: $error\n$stackTrace',
        );
        // Fallback: subscribe to base query without ordering and sort client-side.
        await for (final snap in baseQuery.snapshots()) {
          yield* mapSnapshot(snap);
        }
      }
    })();
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

    await listRef.set({
      'name': name.trim(),
      'type': 'custom',
      'iconName': iconName,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return listRef.id;
  }

  /// Deletes a custom list and its movies subcollection.
  ///
  /// Verifies the list document exists and that its type is 'custom'
  /// before removing any documents.
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

    while (true) {
      final moviesSnapshot = await listRef
          .collection('movies')
          .limit(500)
          .get();

      if (moviesSnapshot.docs.isEmpty) {
        break;
      }

      final batch = _firestore.batch();
      for (final doc in moviesSnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }

    await listRef.delete();
  }
}
