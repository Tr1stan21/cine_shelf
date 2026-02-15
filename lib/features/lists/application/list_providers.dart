import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cine_shelf/features/auth/application/auth_providers.dart';
import 'package:cine_shelf/features/lists/data/list_repository.dart';

/// Firestore list identifiers for system-provided lists.
const String _watchedListId = 'watched';
const String _watchlistListId = 'watchlist';
const String _favoritesListId = 'favorites';

/// Provides ListRepository instance with Firestore dependency.
final listRepositoryProvider = Provider<ListRepository>((ref) {
  return ListRepository(ref.watch(firebaseFirestoreProvider));
});

/// Stream provider for count of watched movies.
///
/// Returns:
/// - Real-time count from Firestore when user is authenticated
/// - Zero when user is not authenticated or during auth loading/error
///
/// Provider is kept alive to maintain subscription across widget rebuilds.
final watchedCountProvider = StreamProvider<int>((ref) {
  final authState = ref.watch(authStateProvider);

  ref.keepAlive();

  return authState.when(
    data: (user) {
      if (user == null) {
        return Stream<int>.value(0);
      }

      return ref
          .watch(listRepositoryProvider)
          .watchListCount(uid: user.uid, listId: _watchedListId);
    },
    loading: () => Stream<int>.value(0),
    error: (_, __) => Stream<int>.value(0),
  );
});

/// Stream provider for count of movies in watchlist.
///
/// Returns:
/// - Real-time count from Firestore when user is authenticated
/// - Zero when user is not authenticated or during auth loading/error
///
/// Provider is kept alive to maintain subscription across widget rebuilds.
final watchlistCountProvider = StreamProvider<int>((ref) {
  final authState = ref.watch(authStateProvider);

  ref.keepAlive();

  return authState.when(
    data: (user) {
      if (user == null) {
        return Stream<int>.value(0);
      }

      return ref
          .watch(listRepositoryProvider)
          .watchListCount(uid: user.uid, listId: _watchlistListId);
    },
    loading: () => Stream<int>.value(0),
    error: (_, __) => Stream<int>.value(0),
  );
});

/// Stream provider for count of favorite movies.
///
/// Returns:
/// - Real-time count from Firestore when user is authenticated
/// - Zero when user is not authenticated or during auth loading/error
///
/// Provider is kept alive to maintain subscription across widget rebuilds.
final favoritesCountProvider = StreamProvider<int>((ref) {
  final authState = ref.watch(authStateProvider);

  ref.keepAlive();

  return authState.when(
    data: (user) {
      if (user == null) {
        return Stream<int>.value(0);
      }

      return ref
          .watch(listRepositoryProvider)
          .watchListCount(uid: user.uid, listId: _favoritesListId);
    },
    loading: () => Stream<int>.value(0),
    error: (_, __) => Stream<int>.value(0),
  );
});
