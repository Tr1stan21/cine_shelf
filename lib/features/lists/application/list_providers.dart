import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cine_shelf/features/auth/application/auth_providers.dart';
import 'package:cine_shelf/features/lists/data/repositories/list_repository.dart';
import 'package:cine_shelf/features/lists/models/user_custom_list.dart';

/// Provides ListRepository instance with Firestore dependency.
final listRepositoryProvider = Provider<ListRepository>((ref) {
  return ListRepository(ref.watch(firebaseFirestoreProvider));
});

/// Stream provider for count of movies in lists.
///
/// Returns:
/// - Real-time count from Firestore when user is authenticated
/// - Zero when user is not authenticated or during auth loading/error
final listCountProvider = StreamProvider.autoDispose.family<int, String>((
  ref,
  listId,
) {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (user) {
      if (user == null) {
        return Stream<int>.value(0);
      }

      return ref
          .watch(listRepositoryProvider)
          .watchListCount(uid: user.uid, listId: listId);
    },
    loading: () => Stream<int>.value(0),
    error: (error, stackTrace) {
      debugPrint('LIST COUNT PROVIDER ERROR: $error\n$stackTrace');
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

// ---------------------------------------------------------------------------
// Custom lists provider
// ---------------------------------------------------------------------------

/// Streams all custom lists for [uid], ordered by createdAt ascending.
///
/// Returns:
/// - Real-time list of [UserCustomList] when [uid] is the authenticated user
/// - Empty list when unauthenticated, mismatched, loading, or on error
final customListsProvider = StreamProvider.autoDispose
    .family<List<UserCustomList>, String>((ref, uid) {
      final authState = ref.watch(authStateProvider);

      return authState.when(
        data: (user) {
          if (user == null || user.uid != uid) {
            return Stream<List<UserCustomList>>.value([]);
          }

          return _emptyOnCustomListsError(
            ref.watch(listRepositoryProvider).watchCustomLists(uid: uid),
          );
        },
        loading: () => Stream<List<UserCustomList>>.value([]),
        error: (error, stackTrace) {
          debugPrint('CUSTOM LISTS AUTH ERROR: $error\n$stackTrace');
          return Stream<List<UserCustomList>>.value([]);
        },
      );
    });

Stream<List<UserCustomList>> _emptyOnCustomListsError(
  Stream<List<UserCustomList>> source,
) async* {
  try {
    await for (final lists in source) {
      yield lists;
    }
  } catch (error, stackTrace) {
    debugPrint('CUSTOM LISTS PROVIDER ERROR: $error\n$stackTrace');
    yield <UserCustomList>[];
  }
}
