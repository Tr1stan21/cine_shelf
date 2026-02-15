import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final String email;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.createdAt,
  });

  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    String uid,
  ) {
    final data = doc.data()!;
    return UserModel(
      uid: uid,
      username: data['username'] ?? 'User',
      email: data['email'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}

class UserRepository {
  UserRepository(this._firestore);

  final FirebaseFirestore _firestore;

  /// Create user document via Cloud Function trigger
  /// 1. Writes placeholder to /user/{uid}
  /// 2. Cloud Function (onDocumentCreated) auto-enriches the document
  Future<void> createUserDocument({
    required String uid,
    required String username,
    required String email,
  }) async {
    try {
      // Write minimal doc with email (triggers Cloud Function)
      await _firestore.collection('user').doc(uid).set({
        'email': email.trim().toLowerCase(),
        'username': username.trim(),
      });
    } catch (e) {
      debugPrint('Error creating user document: $e');
      rethrow;
    }
  }

  Future<UserModel?> getUserDocument(String uid) async {
    try {
      final doc = await _firestore.collection('user').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc, uid);
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching user document: $e');
      return null;
    }
  }
}
