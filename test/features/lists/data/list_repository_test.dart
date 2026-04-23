import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cine_shelf/features/lists/data/list_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

class MockQuery extends Mock implements Query<Map<String, dynamic>> {}

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Wires up the standard Firestore path chain:
/// firestore → 'user' → uid → 'list' → listId → 'movies'
/// and returns the mocked movies [CollectionReference].
MockCollectionReference _wireFirestorePath(
  MockFirebaseFirestore firestore, {
  required String uid,
  required String listId,
}) {
  final userCol = MockCollectionReference();
  final userDoc = MockDocumentReference();
  final listCol = MockCollectionReference();
  final listDoc = MockDocumentReference();
  final moviesCol = MockCollectionReference();

  when(() => firestore.collection('user')).thenReturn(userCol);
  when(() => userCol.doc(uid)).thenReturn(userDoc);
  when(() => userDoc.collection('list')).thenReturn(listCol);
  when(() => listCol.doc(listId)).thenReturn(listDoc);
  when(() => listDoc.collection('movies')).thenReturn(moviesCol);

  return moviesCol;
}

void main() {
  setUpAll(() {
    // Required by mocktail for any() matchers on non-nullable types.
    registerFallbackValue(<String, dynamic>{});
  });

  group('ListRepository', () {
    late MockFirebaseFirestore firestore;
    late ListRepository repository;

    setUp(() {
      firestore = MockFirebaseFirestore();
      repository = ListRepository(firestore);
    });

    // -----------------------------------------------------------------------
    // watchListCount
    // -----------------------------------------------------------------------

    group('watchListCount', () {
      test('emits snapshot.size from the movies subcollection', () {
        const uid = 'user-1';
        const listId = 'watchlist';

        final moviesCol = _wireFirestorePath(
          firestore,
          uid: uid,
          listId: listId,
        );
        final querySnapshot = MockQuerySnapshot();

        when(
          () => moviesCol.snapshots(),
        ).thenAnswer((_) => Stream.value(querySnapshot));
        when(() => querySnapshot.size).thenReturn(3);

        expect(repository.watchListCount(uid: uid, listId: listId), emits(3));
      });

      test('emits 0 when the subcollection is empty', () {
        const uid = 'user-2';
        const listId = 'favorites';

        final moviesCol = _wireFirestorePath(
          firestore,
          uid: uid,
          listId: listId,
        );
        final querySnapshot = MockQuerySnapshot();

        when(
          () => moviesCol.snapshots(),
        ).thenAnswer((_) => Stream.value(querySnapshot));
        when(() => querySnapshot.size).thenReturn(0);

        expect(repository.watchListCount(uid: uid, listId: listId), emits(0));
      });
    });

    // -----------------------------------------------------------------------
    // addMovieToList
    // -----------------------------------------------------------------------

    group('addMovieToList', () {
      test(
        'calls set() on the correct document with expected fields',
        () async {
          const uid = 'user-1';
          const listId = 'favorites';
          const movieId = 550;
          const posterPath = '/poster.jpg';

          final moviesCol = _wireFirestorePath(
            firestore,
            uid: uid,
            listId: listId,
          );
          final docRef = MockDocumentReference();

          when(() => moviesCol.doc('550')).thenReturn(docRef);
          when(() => docRef.set(any())).thenAnswer((_) async {});

          await repository.addMovieToList(
            uid: uid,
            listId: listId,
            movieId: movieId,
            posterPath: posterPath,
          );

          final captured =
              verify(() => docRef.set(captureAny())).captured.single
                  as Map<String, dynamic>;

          expect(captured['movieId'], movieId);
          expect(captured['posterPath'], posterPath);
          expect(captured['addedAt'], isA<FieldValue>());
        },
      );

      test('stores null posterPath when movie has no poster', () async {
        const uid = 'user-1';
        const listId = 'watchlist';
        const movieId = 99;

        final moviesCol = _wireFirestorePath(
          firestore,
          uid: uid,
          listId: listId,
        );
        final docRef = MockDocumentReference();

        when(() => moviesCol.doc('99')).thenReturn(docRef);
        when(() => docRef.set(any())).thenAnswer((_) async {});

        await repository.addMovieToList(
          uid: uid,
          listId: listId,
          movieId: movieId,
          posterPath: null,
        );

        final captured =
            verify(() => docRef.set(captureAny())).captured.single
                as Map<String, dynamic>;

        expect(captured['posterPath'], isNull);
      });

      test('propagates Firestore exceptions to the caller', () {
        const uid = 'user-1';
        const listId = 'watched';
        const movieId = 1;

        final moviesCol = _wireFirestorePath(
          firestore,
          uid: uid,
          listId: listId,
        );
        final docRef = MockDocumentReference();

        when(() => moviesCol.doc('1')).thenReturn(docRef);
        when(() => docRef.set(any())).thenThrow(Exception('write-failed'));

        expect(
          () => repository.addMovieToList(
            uid: uid,
            listId: listId,
            movieId: movieId,
            posterPath: '/p.jpg',
          ),
          throwsException,
        );
      });
    });

    // -----------------------------------------------------------------------
    // removeMovieFromList
    // -----------------------------------------------------------------------

    group('removeMovieFromList', () {
      test(
        'calls delete() on the document keyed by movieId.toString()',
        () async {
          const uid = 'user-1';
          const listId = 'favorites';
          const movieId = 550;

          final moviesCol = _wireFirestorePath(
            firestore,
            uid: uid,
            listId: listId,
          );
          final docRef = MockDocumentReference();

          when(() => moviesCol.doc('550')).thenReturn(docRef);
          when(() => docRef.delete()).thenAnswer((_) async {});

          await repository.removeMovieFromList(
            uid: uid,
            listId: listId,
            movieId: movieId,
          );

          verify(() => docRef.delete()).called(1);
        },
      );

      test('propagates Firestore exceptions to the caller', () {
        const uid = 'user-1';
        const listId = 'watched';
        const movieId = 7;

        final moviesCol = _wireFirestorePath(
          firestore,
          uid: uid,
          listId: listId,
        );
        final docRef = MockDocumentReference();

        when(() => moviesCol.doc('7')).thenReturn(docRef);
        when(() => docRef.delete()).thenThrow(Exception('delete-failed'));

        expect(
          () => repository.removeMovieFromList(
            uid: uid,
            listId: listId,
            movieId: movieId,
          ),
          throwsException,
        );
      });
    });

    // -----------------------------------------------------------------------
    // watchMovieInList
    // -----------------------------------------------------------------------

    group('watchMovieInList', () {
      test('emits true when the document exists', () {
        const uid = 'user-1';
        const listId = 'watchlist';
        const movieId = 550;

        final moviesCol = _wireFirestorePath(
          firestore,
          uid: uid,
          listId: listId,
        );
        final docRef = MockDocumentReference();
        final docSnapshot = MockDocumentSnapshot();

        when(() => moviesCol.doc('550')).thenReturn(docRef);
        when(
          () => docRef.snapshots(),
        ).thenAnswer((_) => Stream.value(docSnapshot));
        when(() => docSnapshot.exists).thenReturn(true);

        expect(
          repository.watchMovieInList(
            uid: uid,
            listId: listId,
            movieId: movieId,
          ),
          emits(true),
        );
      });

      test('emits false when the document does not exist', () {
        const uid = 'user-1';
        const listId = 'favorites';
        const movieId = 123;

        final moviesCol = _wireFirestorePath(
          firestore,
          uid: uid,
          listId: listId,
        );
        final docRef = MockDocumentReference();
        final docSnapshot = MockDocumentSnapshot();

        when(() => moviesCol.doc('123')).thenReturn(docRef);
        when(
          () => docRef.snapshots(),
        ).thenAnswer((_) => Stream.value(docSnapshot));
        when(() => docSnapshot.exists).thenReturn(false);

        expect(
          repository.watchMovieInList(
            uid: uid,
            listId: listId,
            movieId: movieId,
          ),
          emits(false),
        );
      });

      test('emits multiple values as document existence changes', () {
        const uid = 'user-1';
        const listId = 'watched';
        const movieId = 42;

        final moviesCol = _wireFirestorePath(
          firestore,
          uid: uid,
          listId: listId,
        );
        final docRef = MockDocumentReference();
        final snap1 = MockDocumentSnapshot();
        final snap2 = MockDocumentSnapshot();

        when(() => moviesCol.doc('42')).thenReturn(docRef);
        when(() => snap1.exists).thenReturn(false);
        when(() => snap2.exists).thenReturn(true);
        when(
          () => docRef.snapshots(),
        ).thenAnswer((_) => Stream.fromIterable([snap1, snap2]));

        expect(
          repository.watchMovieInList(
            uid: uid,
            listId: listId,
            movieId: movieId,
          ),
          emitsInOrder([false, true]),
        );
      });
    });

    // -----------------------------------------------------------------------
    // getListMovies
    // -----------------------------------------------------------------------

    group('getListMovies', () {
      test('returns empty list when subcollection has no documents', () async {
        const uid = 'user-1';
        const listId = 'watchlist';

        final moviesCol = _wireFirestorePath(
          firestore,
          uid: uid,
          listId: listId,
        );
        final query = MockQuery();
        final querySnapshot = MockQuerySnapshot();

        when(() => moviesCol.orderBy('addedAt')).thenReturn(query);
        when(() => query.get()).thenAnswer((_) async => querySnapshot);
        when(() => querySnapshot.docs).thenReturn([]);

        final result = await repository.getListMovies(uid: uid, listId: listId);

        expect(result, isEmpty);
      });

      test(
        'maps Firestore documents to MoviePoster list with correct fields',
        () async {
          const uid = 'user-1';
          const listId = 'favorites';

          final moviesCol = _wireFirestorePath(
            firestore,
            uid: uid,
            listId: listId,
          );
          final query = MockQuery();
          final querySnapshot = MockQuerySnapshot();
          final doc1 = MockQueryDocumentSnapshot();
          final doc2 = MockQueryDocumentSnapshot();

          when(() => moviesCol.orderBy('addedAt')).thenReturn(query);
          when(() => query.get()).thenAnswer((_) async => querySnapshot);
          when(() => querySnapshot.docs).thenReturn([doc1, doc2]);
          when(() => doc1['movieId']).thenReturn(100);
          when(() => doc1['posterPath']).thenReturn('/a.jpg');
          when(() => doc2['movieId']).thenReturn(200);
          when(() => doc2['posterPath']).thenReturn(null);

          final result = await repository.getListMovies(
            uid: uid,
            listId: listId,
          );

          expect(result.length, 2);
          expect(result[0].id, 100);
          expect(result[0].posterPath, '/a.jpg');
          expect(result[1].id, 200);
          expect(result[1].posterPath, isNull);
        },
      );

      test(
        'casts num movieId to int and calls orderBy addedAt before get()',
        () async {
          const uid = 'user-1';
          const listId = 'watched';

          final moviesCol = _wireFirestorePath(
            firestore,
            uid: uid,
            listId: listId,
          );
          final query = MockQuery();
          final querySnapshot = MockQuerySnapshot();
          final doc = MockQueryDocumentSnapshot();

          when(() => moviesCol.orderBy('addedAt')).thenReturn(query);
          when(() => query.get()).thenAnswer((_) async => querySnapshot);
          when(() => querySnapshot.docs).thenReturn([doc]);
          // Firestore may return num (double) for integer fields.
          when(() => doc['movieId']).thenReturn(550.0);
          when(() => doc['posterPath']).thenReturn('/p.jpg');

          final result = await repository.getListMovies(
            uid: uid,
            listId: listId,
          );

          // orderBy('addedAt') must be called before get().
          verify(() => moviesCol.orderBy('addedAt')).called(1);
          verify(() => query.get()).called(1);
          expect(result.length, 1);
          expect(result[0].id, 550);
        },
      );
    });
  });
}
