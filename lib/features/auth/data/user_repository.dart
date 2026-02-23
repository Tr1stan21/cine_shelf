import 'package:cine_shelf/features/auth/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Repository for managing user profile documents in Firestore.
///
/// Handles:
/// - User profile creation (cooperates with Cloud Functions)
/// - Fetching user profile data
///
/// User documents are stored in the `/user/{uid}` collection.
///
/// **Error handling strategy:**
/// The two methods in this repository intentionally differ in error behavior:
/// - [createUserDocument] **rethrows** exceptions so [AuthController] can
///   trigger a rollback (delete the Firebase Auth account) when profile
///   creation fails. Swallowing the error here would leave an orphaned auth
///   account with no Firestore document.
/// - [getUserDocument] **swallows** exceptions and returns `null` because a
///   missing profile on read is a recoverable situation — the UI can show a
///   fallback state without breaking the session.
///
/// **Dependency Injection for Testability:**
/// The [FirebaseFirestore] instance is injected via constructor, allowing:
/// - Easy mocking in unit tests without Firebase initialization.
/// - Decoupling from Firebase SDK specifics.
class UserRepository {
  /// Creates a [UserRepository] with the provided [FirebaseFirestore] instance.
  UserRepository(this._firestore);

  final FirebaseFirestore _firestore;

  /// Creates a user profile document in Firestore with Cloud Function enrichment.
  ///
  /// **Process:**
  /// 1. Writes a minimal document `{email, username}` to `/user/{uid}`.
  /// 2. The `bootstrapUser` Cloud Function (triggered by `onDocumentCreated`)
  ///    enriches the document with `createdAt`, `updatedAt`, and the three
  ///    default lists (`favorites`, `watched`, `watchlist`) as subcollections.
  ///
  /// **Important — Race condition awareness:**
  /// The Cloud Function runs asynchronously after this write returns. If the
  /// user document is read immediately after creation (e.g., in [getUserDocument]),
  /// the `createdAt` field may not yet be present. [UserModel.fromFirestore]
  /// will throw if `createdAt` is missing. The splash gate's [preloadUserData]
  /// call introduces enough delay for the function to complete in practice,
  /// but this is not guaranteed.
  ///
  /// **Error behavior:** Rethrows any exception so [AuthController] can
  /// perform a compensating delete of the Firebase Auth account.
  ///
  /// Parameters:
  /// - [uid]: User ID from Firebase Authentication.
  /// - [username]: Display name for the user.
  /// - [email]: User's email address (trimmed and lowercased before writing).
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

      // Rethrow intentionally: AuthController needs this error to roll back
      // the Firebase Auth account and prevent orphaned auth records.
      rethrow;
    }
  }

  /// Fetches the user profile document from Firestore.
  ///
  /// Returns:
  /// - [UserModel] if the document exists and contains a valid `createdAt` timestamp.
  /// - `null` if the document does not exist or any error occurs.
  ///
  /// **Error behavior:** Errors are logged but not rethrown. A missing profile
  /// on read is a recoverable condition — the UI shows fallback values
  /// ("User" / "No email") without breaking the authenticated session.
  ///
  /// Parameters:
  /// - [uid]: User ID to fetch the profile for.
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
