import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  UserRepository(this._firestore);

  final FirebaseFirestore _firestore;

  Future<void> createUserDocument({
    required String uid,
    required String username,
    required String email,
  }) async {
    final now = FieldValue.serverTimestamp();

    await _firestore.collection('user').doc(uid).set({
      'username': username.trim(),
      'email': email.trim().toLowerCase(),
      'createdAt': now,
      'updatedAt': now,
    });
  }
}
