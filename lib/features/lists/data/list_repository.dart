import 'package:cloud_firestore/cloud_firestore.dart';

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

  /// Returns a reactive stream of movie count for a specific list.
  ///
  /// Monitors the subcollection size under `/user/{uid}/list/{listId}/movies`
  /// and emits updated count whenever movies are added or removed.
  ///
  /// Parameters:
  /// - [uid]: User's unique identifier
  /// - [listId]: List identifier ('watched', 'watchlist', 'favorites', or custom ID)
  Stream<int> watchListCount({required String uid, required String listId}) {
    return _firestore
        .collection('user')
        .doc(uid)
        .collection('list')
        .doc(listId)
        .collection('movies')
        .snapshots()
        .map((snapshot) => snapshot.size);
  }
}
