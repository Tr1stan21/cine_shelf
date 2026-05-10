import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'rating_providers.dart';

final ratingControllerProvider = Provider<RatingController>((ref) {
  return RatingController(ref);
});

class RatingController {
  RatingController(this.ref);

  final Ref ref;

  Future<void> setRating({
    required BuildContext context,
    required String uid,
    required int movieId,
    required double stars,
  }) async {
    final ratingProvider = movieRatingProvider(movieId);
    final previous = ref.read(ratingProvider);
    final notifier = ref.read(ratingProvider.notifier);

    notifier.setOptimistic(stars);

    try {
      await ref
          .read(ratingRepositoryProvider)
          .setRating(uid: uid, movieId: movieId, stars: stars);
    } catch (error, stackTrace) {
      debugPrint('RATING WRITE ERROR: $error\n$stackTrace');
      notifier.rollback(previous);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not update the rating. Please try again.'),
        ),
      );
    }
  }
}
