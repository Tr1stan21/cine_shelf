import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cine_shelf/shared/widgets/cine_snack_bar.dart';

import 'rating_providers.dart';

/// Provides the singleton [RatingController] instance.
final ratingControllerProvider = Provider<RatingController>((ref) {
  return RatingController(ref);
});

/// Handles user rating writes delegating to [RatingRepository].
///
/// The UI updates reactively via the [movieRatingProvider] stream once
/// Firestore confirms the write — no separate optimistic state is needed
/// because the Firestore real-time listener responds fast enough to be
/// indistinguishable from a local update.
class RatingController {
  RatingController(this._ref);

  final Ref _ref;

  /// Persists [stars] for [movieId] belonging to [uid].
  ///
  /// Shows a [SnackBar] on failure. [context] is used only for that error
  /// message and is guarded with [BuildContext.mounted] before use.
  Future<void> setRating({
    required BuildContext context,
    required String uid,
    required int movieId,
    required double stars,
  }) async {
    try {
      await _ref
          .read(ratingRepositoryProvider)
          .setRating(uid: uid, movieId: movieId, stars: stars);
    } catch (error, stackTrace) {
      debugPrint('RATING WRITE ERROR: $error\n$stackTrace');

      if (!context.mounted) return;
      showCineSnackBar(
        context,
        'Could not update the rating. Please try again.',
      );
    }
  }
}
