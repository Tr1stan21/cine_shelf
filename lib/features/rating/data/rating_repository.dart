abstract class RatingRepository {
  Stream<double?> watchRating({required String uid, required int movieId});

  Future<void> setRating({
    required String uid,
    required int movieId,
    required double stars,
  });

  Future<void> deleteRating({required String uid, required int movieId});
}
