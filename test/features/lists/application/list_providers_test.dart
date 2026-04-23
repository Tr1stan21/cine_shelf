import 'package:cine_shelf/features/auth/application/auth_providers.dart';
import 'package:cine_shelf/features/lists/application/list_providers.dart';
import 'package:cine_shelf/features/lists/data/list_repository.dart';
import 'package:cine_shelf/features/lists/domain/list_ids.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class MockUser extends Mock implements User {
  @override
  String get uid => 'test-uid';
}

class MockListRepository extends Mock implements ListRepository {}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Builds a [ProviderContainer] with [authStateProvider] and
/// [listRepositoryProvider] overridden.
ProviderContainer _container({
  required AsyncValue<User?> authState,
  required MockListRepository repo,
}) {
  return ProviderContainer(
    overrides: [
      authStateProvider.overrideWith((ref) {
        return switch (authState) {
          AsyncData(:final value) => Stream.value(value),
          AsyncError(:final error, :final stackTrace) => Stream.error(
            error,
            stackTrace,
          ),
          _ => const Stream.empty(),
        };
      }),
      listRepositoryProvider.overrideWithValue(repo),
    ],
  );
}

/// Reads the first resolved value from an [autoDispose] [StreamProvider<int>].
///
/// `container.read(provider.future)` alone releases the subscription
/// immediately, causing autoDispose to tear down the provider before the
/// future resolves. Keeping a listener alive prevents premature disposal.
Future<int> _readCount(
  ProviderContainer container,
  StreamProvider<int> provider,
) async {
  final sub = container.listen(provider, (_, __) {});
  try {
    return await container.read(provider.future);
  } finally {
    sub.close();
  }
}

/// Reads the first resolved bool from a [movieInListProvider] family instance.
Future<bool> _readInList(
  ProviderContainer container,
  ({String listId, int movieId}) params,
) async {
  final provider = movieInListProvider(params);
  final sub = container.listen(provider, (_, __) {});
  try {
    return await container.read(provider.future);
  } finally {
    sub.close();
  }
}

void main() {
  late MockUser user;
  late MockListRepository repo;

  setUp(() {
    user = MockUser();
    repo = MockListRepository();
  });

  // -------------------------------------------------------------------------
  // Count providers
  // -------------------------------------------------------------------------

  group('watchedCountProvider', () {
    test(
      'emits real count from repository when user is authenticated',
      () async {
        when(
          () => repo.watchListCount(uid: 'test-uid', listId: watchedListId),
        ).thenAnswer((_) => Stream.value(5));

        final container = _container(authState: AsyncData(user), repo: repo);
        addTearDown(container.dispose);

        expect(await _readCount(container, watchedCountProvider), 5);
      },
    );

    test('emits 0 when user is null (signed out)', () async {
      final container = _container(
        authState: const AsyncData(null),
        repo: repo,
      );
      addTearDown(container.dispose);

      expect(await _readCount(container, watchedCountProvider), 0);
      verifyNever(
        () => repo.watchListCount(
          uid: any(named: 'uid'),
          listId: any(named: 'listId'),
        ),
      );
    });

    test('emits 0 on auth error without calling repository', () async {
      final container = _container(
        authState: AsyncError(Exception('auth-error'), StackTrace.empty),
        repo: repo,
      );
      addTearDown(container.dispose);

      expect(await _readCount(container, watchedCountProvider), 0);
      verifyNever(
        () => repo.watchListCount(
          uid: any(named: 'uid'),
          listId: any(named: 'listId'),
        ),
      );
    });
  });

  group('watchlistCountProvider', () {
    test('queries watchlistListId constant', () async {
      when(
        () => repo.watchListCount(uid: 'test-uid', listId: watchlistListId),
      ).thenAnswer((_) => Stream.value(2));

      final container = _container(authState: AsyncData(user), repo: repo);
      addTearDown(container.dispose);

      expect(await _readCount(container, watchlistCountProvider), 2);
    });
  });

  group('favoritesCountProvider', () {
    test('queries favoritesListId constant', () async {
      when(
        () => repo.watchListCount(uid: 'test-uid', listId: favoritesListId),
      ).thenAnswer((_) => Stream.value(7));

      final container = _container(authState: AsyncData(user), repo: repo);
      addTearDown(container.dispose);

      expect(await _readCount(container, favoritesCountProvider), 7);
    });
  });

  // -------------------------------------------------------------------------
  // movieInListProvider
  // -------------------------------------------------------------------------

  group('movieInListProvider', () {
    const params = (listId: 'favorites', movieId: 550);

    test('emits true when repository reports movie exists in list', () async {
      when(
        () => repo.watchMovieInList(
          uid: 'test-uid',
          listId: 'favorites',
          movieId: 550,
        ),
      ).thenAnswer((_) => Stream.value(true));

      final container = _container(authState: AsyncData(user), repo: repo);
      addTearDown(container.dispose);

      expect(await _readInList(container, params), isTrue);
    });

    test(
      'emits false when repository reports movie absent from list',
      () async {
        when(
          () => repo.watchMovieInList(
            uid: 'test-uid',
            listId: 'favorites',
            movieId: 550,
          ),
        ).thenAnswer((_) => Stream.value(false));

        final container = _container(authState: AsyncData(user), repo: repo);
        addTearDown(container.dispose);

        expect(await _readInList(container, params), isFalse);
      },
    );

    test('emits false when user is null without querying repository', () async {
      final container = _container(
        authState: const AsyncData(null),
        repo: repo,
      );
      addTearDown(container.dispose);

      expect(await _readInList(container, params), isFalse);
      verifyNever(
        () => repo.watchMovieInList(
          uid: any(named: 'uid'),
          listId: any(named: 'listId'),
          movieId: any(named: 'movieId'),
        ),
      );
    });

    test('emits false on auth error without querying repository', () async {
      final container = _container(
        authState: AsyncError(Exception('auth-error'), StackTrace.empty),
        repo: repo,
      );
      addTearDown(container.dispose);

      expect(await _readInList(container, params), isFalse);
      verifyNever(
        () => repo.watchMovieInList(
          uid: any(named: 'uid'),
          listId: any(named: 'listId'),
          movieId: any(named: 'movieId'),
        ),
      );
    });

    test('different movieId params produce independent values', () async {
      const params2 = (listId: 'favorites', movieId: 999);

      when(
        () => repo.watchMovieInList(
          uid: 'test-uid',
          listId: 'favorites',
          movieId: 550,
        ),
      ).thenAnswer((_) => Stream.value(true));

      when(
        () => repo.watchMovieInList(
          uid: 'test-uid',
          listId: 'favorites',
          movieId: 999,
        ),
      ).thenAnswer((_) => Stream.value(false));

      final container = _container(authState: AsyncData(user), repo: repo);
      addTearDown(container.dispose);

      expect(await _readInList(container, params), isTrue);
      expect(await _readInList(container, params2), isFalse);
    });
  });
}
