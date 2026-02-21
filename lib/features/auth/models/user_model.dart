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
