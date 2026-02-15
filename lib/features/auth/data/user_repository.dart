import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Data model representing a user's profile stored in Firestore.
///
/// Contains user account information synchronized with Firebase Authentication.
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

  /// Deserializes UserModel from Firestore document snapshot.
  ///
  /// Provides defaults for missing fields to handle legacy data gracefully:
  /// - `username`: defaults to 'User'
  /// - `email`: defaults to empty string
  ///
  /// Requires `createdAt` timestamp to be present.
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

/// Repository for managing user profile documents in Firestore.
///
/// Handles:
/// - User profile creation (cooperates with Cloud Functions)
/// - Fetching user profile data
///
/// User documents are stored in the `/user/{uid}` collection.
class UserRepository {
  UserRepository(this._firestore);

  final FirebaseFirestore _firestore;

  /// Creates user profile document in Firestore with Cloud Function enrichment.
  ///
  /// Process:
  /// 1. Writes minimal placeholder document to `/user/{uid}`
  /// 2. Cloud Function (onDocumentCreated trigger) automatically enriches the document
  ///    with `createdAt` timestamp and any other server-side data
  ///
  /// This ensures consistent server timestamps and allows backend validation.
  ///
  /// Throws exception if Firestore write fails.
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

  /// Fetches user profile document from Firestore.
  ///
  /// Returns:
  /// - [UserModel] if document exists and is valid
  /// - `null` if document doesn't exist or error occurs
  ///
  /// Errors are logged but not rethrown to avoid breaking app flow.
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
