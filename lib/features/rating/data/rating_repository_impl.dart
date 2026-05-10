import 'package:cloud_firestore/cloud_firestore.dart';

import 'rating_repository.dart';

class FirestoreRatingRepository implements RatingRepository {
  FirestoreRatingRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _ratingsCol(String uid) =>
      _firestore.collection('user').doc(uid).collection('movieRating');

  @override
  Stream<double?> watchRating({required String uid, required int movieId}) {
    return _ratingsCol(uid).doc(movieId.toString()).snapshots().map((snap) {
      if (!snap.exists) return null;

      final stars = snap.data()?['stars'];
      if (stars is! num) return null;

      return stars.toDouble();
    });
  }

  @override
  Future<void> setRating({
    required String uid,
    required int movieId,
    required double stars,
  }) {
    return _ratingsCol(uid).doc(movieId.toString()).set({
      'stars': stars,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> deleteRating({required String uid, required int movieId}) {
    return _ratingsCol(uid).doc(movieId.toString()).delete();
  }
}
