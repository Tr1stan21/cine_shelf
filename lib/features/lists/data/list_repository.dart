import 'package:cloud_firestore/cloud_firestore.dart';
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
}
