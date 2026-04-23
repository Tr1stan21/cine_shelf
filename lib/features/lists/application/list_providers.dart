import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cine_shelf/features/auth/application/auth_providers.dart';
import 'package:cine_shelf/features/lists/data/list_repository.dart';
import 'package:cine_shelf/features/lists/domain/list_ids.dart';

/// Provides ListRepository instance with Firestore dependency.
final listRepositoryProvider = Provider<ListRepository>((ref) {
  return ListRepository(ref.watch(firebaseFirestoreProvider));
});

/// Stream provider for count of watched movies.
///
/// Returns:
/// - Real-time count from Firestore when user is authenticated
/// - Zero when user is not authenticated or during auth loading/error
final watchedCountProvider = StreamProvider.autoDispose<int>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (user) {
      if (user == null) {
        return Stream<int>.value(0);
      }

      return ref
          .watch(listRepositoryProvider)
          .watchListCount(uid: user.uid, listId: watchedListId);
    },
    loading: () => Stream<int>.value(0),
    error: (error, stackTrace) {
      debugPrint('WATCHED COUNT PROVIDER AUTH ERROR: $error\n$stackTrace');
      return Stream<int>.value(0);
    },
  );
});

/// Stream provider for count of movies in watchlist.
///
/// Returns:
/// - Real-time count from Firestore when user is authenticated
/// - Zero when user is not authenticated or during auth loading/error
final watchlistCountProvider = StreamProvider.autoDispose<int>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (user) {
      if (user == null) {
        return Stream<int>.value(0);
      }

      return ref
          .watch(listRepositoryProvider)
          .watchListCount(uid: user.uid, listId: watchlistListId);
    },
    loading: () => Stream<int>.value(0),
    error: (error, stackTrace) {
      debugPrint('WATCHLIST COUNT PROVIDER AUTH ERROR: $error\n$stackTrace');
      return Stream<int>.value(0);
    },
  );
});

/// Stream provider for count of favorite movies.
///
/// Returns:
/// - Real-time count from Firestore when user is authenticated
/// - Zero when user is not authenticated or during auth loading/error
final favoritesCountProvider = StreamProvider.autoDispose<int>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (user) {
      if (user == null) {
        return Stream<int>.value(0);
      }

      return ref
          .watch(listRepositoryProvider)
          .watchListCount(uid: user.uid, listId: favoritesListId);
    },
    loading: () => Stream<int>.value(0),
    error: (error, stackTrace) {
      debugPrint('FAVORITES COUNT PROVIDER AUTH ERROR: $error\n$stackTrace');
      return Stream<int>.value(0);
    },
  );
});

// ---------------------------------------------------------------------------
// Membership providers — used by MovieDetailsScreen to reflect button state
// ---------------------------------------------------------------------------

/// Emits [true] when [movieId] exists in the given [listId] for the current user.
///
/// Parametrized by a record `({String listId, int movieId})` so a single
/// family covers all three lists without code duplication.
final movieInListProvider = StreamProvider.autoDispose
    .family<bool, ({String listId, int movieId})>((ref, params) {
      final authState = ref.watch(authStateProvider);

      return authState.when(
        data: (user) {
          if (user == null) return Stream<bool>.value(false);
          return ref
              .watch(listRepositoryProvider)
              .watchMovieInList(
                uid: user.uid,
                listId: params.listId,
                movieId: params.movieId,
              );
        },
        loading: () => Stream<bool>.value(false),
        error: (error, stackTrace) {
          debugPrint('MOVIE IN LIST PROVIDER ERROR: $error\n$stackTrace');
          return Stream<bool>.value(false);
        },
      );
    });
