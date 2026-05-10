import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cine_shelf/features/auth/application/auth_providers.dart';
import 'package:cine_shelf/features/rating/data/rating_repository.dart';
import 'package:cine_shelf/features/rating/data/rating_repository_impl.dart';

/// Provides the [RatingRepository] implementation backed by Firestore.
final ratingRepositoryProvider = Provider<RatingRepository>((ref) {
  return FirestoreRatingRepository(ref.watch(firebaseFirestoreProvider));
});

/// Reactive stream of the current user's rating for a given movie.
///
/// Emits [null] when the movie has not been rated yet, or when the user
/// is not authenticated. Emits the stored star value otherwise.
///
/// Parametrized by TMDB movie ID.
final movieRatingProvider = StreamProvider.autoDispose.family<double?, int>((
  ref,
  movieId,
) {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(null);
      return _watchRatingSafely(
        ref.watch(ratingRepositoryProvider),
        uid: user.uid,
        movieId: movieId,
      );
    },
    loading: () => Stream.value(null),
    error: (error, stackTrace) {
      debugPrint('MOVIE RATING PROVIDER ERROR: $error\n$stackTrace');
      return Stream.value(null);
    },
  );
});

/// Wraps the repository stream to swallow errors without crashing the UI.
///
/// Yields [null] on error so the widget degrades gracefully to an empty
/// star state rather than propagating the error up to the screen.
Stream<double?> _watchRatingSafely(
  RatingRepository repository, {
  required String uid,
  required int movieId,
}) async* {
  try {
    yield* repository.watchRating(uid: uid, movieId: movieId);
  } catch (error, stackTrace) {
    debugPrint('RATING STREAM ERROR: $error\n$stackTrace');
    yield null;
  }
}
