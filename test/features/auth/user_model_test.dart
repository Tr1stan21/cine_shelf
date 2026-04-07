import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cine_shelf/features/auth/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

void main() {
  group('UserModel.fromFirestore', () {
    late MockDocumentSnapshot doc;

    setUp(() {
      doc = MockDocumentSnapshot();
    });

    test('maps all fields when snapshot contains full data', () {
      final timestamp = Timestamp.fromDate(DateTime(2026, 4, 6));

      when(() => doc.data()).thenReturn({
        'username': 'javi',
        'email': 'javi@example.com',
        'createdAt': timestamp,
      });

      final model = UserModel.fromFirestore(doc, 'uid-123');

      expect(model.uid, 'uid-123');
      expect(model.username, 'javi');
      expect(model.email, 'javi@example.com');
      expect(model.createdAt, timestamp.toDate());
    });

    test('uses defaults for missing username and email', () {
      when(
        () => doc.data(),
      ).thenReturn({'createdAt': Timestamp.fromDate(DateTime(2026, 1, 1))});

      final model = UserModel.fromFirestore(doc, 'uid-abc');

      expect(model.username, 'User');
      expect(model.email, '');
    });

    test('returns null createdAt when field is missing', () {
      when(
        () => doc.data(),
      ).thenReturn({'username': 'ana', 'email': 'ana@example.com'});

      final model = UserModel.fromFirestore(doc, 'uid-ana');

      expect(model.createdAt, isNull);
    });

    test('returns null createdAt when field is explicitly null', () {
      when(() => doc.data()).thenReturn({
        'username': 'ana',
        'email': 'ana@example.com',
        'createdAt': null,
      });

      final model = UserModel.fromFirestore(doc, 'uid-ana');

      expect(model.createdAt, isNull);
    });
  });
}
