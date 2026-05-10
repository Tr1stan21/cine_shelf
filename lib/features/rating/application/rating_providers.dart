import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cine_shelf/features/auth/application/auth_providers.dart';
import 'package:cine_shelf/features/rating/data/rating_repository.dart';
import 'package:cine_shelf/features/rating/data/rating_repository_impl.dart';

final ratingRepositoryProvider = Provider<RatingRepository>((ref) {
  return FirestoreRatingRepository(ref.watch(firebaseFirestoreProvider));
});

final ratingStreamProvider = StreamProvider.autoDispose.family<double?, int>((
  ref,
  movieId,
) {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (user) {
      if (user == null) return Stream<double?>.value(null);

      return _watchRatingSafely(
        ref.watch(ratingRepositoryProvider),
        uid: user.uid,
        movieId: movieId,
      );
    },
    loading: () => Stream<double?>.value(null),
    error: (error, stackTrace) {
      debugPrint('RATING AUTH PROVIDER ERROR: $error\n$stackTrace');
      return Stream<double?>.value(null);
    },
  );
});

Stream<double?> _watchRatingSafely(
  RatingRepository repository, {
  required String uid,
  required int movieId,
}) async* {
  try {
    yield* repository.watchRating(uid: uid, movieId: movieId);
  } catch (error, stackTrace) {
    debugPrint('MOVIE RATING PROVIDER ERROR: $error\n$stackTrace');
    yield null;
  }
}

class RatingNotifier extends Notifier<AsyncValue<double?>> {
  RatingNotifier(this._movieId);

  final int _movieId;

  @override
  AsyncValue<double?> build() {
    return ref.watch(ratingStreamProvider(_movieId));
  }

  void setOptimistic(double? stars) {
    state = AsyncData(stars);
  }

  void rollback(AsyncValue<double?> previous) {
    state = previous;
  }
}

final movieRatingProvider = NotifierProvider.autoDispose
    .family<RatingNotifier, AsyncValue<double?>, int>(RatingNotifier.new);
