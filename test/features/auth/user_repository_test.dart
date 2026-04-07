import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cine_shelf/features/auth/data/user_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

void main() {
  group('UserRepository', () {
    late MockFirebaseFirestore firestore;
    late MockCollectionReference collection;
    late MockDocumentReference docRef;
    late UserRepository repository;

    setUp(() {
      firestore = MockFirebaseFirestore();
      collection = MockCollectionReference();
      docRef = MockDocumentReference();
      repository = UserRepository(firestore);

      when(() => firestore.collection('user')).thenReturn(collection);
      when(() => collection.doc(any())).thenReturn(docRef);
    });

    group('createUserDocument', () {
      test('writes normalized email and trimmed username', () async {
        when(() => docRef.set(any())).thenAnswer((_) async {});

        await repository.createUserDocument(
          uid: 'uid-1',
          username: '  Javi  ',
          email: '  JAVI@EXAMPLE.COM  ',
        );

        final captured =
            verify(() => docRef.set(captureAny())).captured.single
                as Map<String, dynamic>;

        expect(captured['username'], 'Javi');
        expect(captured['email'], 'javi@example.com');
      });

      test('rethrows when write fails', () async {
        when(() => docRef.set(any())).thenThrow(Exception('write-failed'));

        expect(
          () => repository.createUserDocument(
            uid: 'uid-2',
            username: 'Ana',
            email: 'ana@example.com',
          ),
          throwsException,
        );
      });
    });

    group('getUserDocument', () {
      test('returns UserModel when document exists with valid data', () async {
        final snapshot = MockDocumentSnapshot();

        when(() => docRef.get()).thenAnswer((_) async => snapshot);
        when(() => snapshot.exists).thenReturn(true);
        when(() => snapshot.data()).thenReturn({
          'username': 'Marta',
          'email': 'marta@example.com',
          'createdAt': Timestamp.fromDate(DateTime(2026, 4, 6)),
        });

        final result = await repository.getUserDocument('uid-3');

        expect(result, isNotNull);
        expect(result!.uid, 'uid-3');
        expect(result.username, 'Marta');
      });

      test('returns null when document does not exist', () async {
        final snapshot = MockDocumentSnapshot();

        when(() => docRef.get()).thenAnswer((_) async => snapshot);
        when(() => snapshot.exists).thenReturn(false);

        final result = await repository.getUserDocument('uid-4');

        expect(result, isNull);
      });

      test('returns null when mapping throws', () async {
        final snapshot = MockDocumentSnapshot();

        when(() => docRef.get()).thenAnswer((_) async => snapshot);
        when(() => snapshot.exists).thenReturn(true);
        when(() => snapshot.data()).thenReturn({
          'username': 'Marta',
          'email': 'marta@example.com',
          'createdAt': 'invalid-type',
        });

        final result = await repository.getUserDocument('uid-5');

        expect(result, isNull);
      });
    });
  });
}
