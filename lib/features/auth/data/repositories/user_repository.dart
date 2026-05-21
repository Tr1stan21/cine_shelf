import 'package:cine_shelf/features/auth/data/local/user_cache_mapper.dart';
import 'package:cine_shelf/features/auth/data/local/user_local_datasource.dart';
import 'package:cine_shelf/features/auth/models/profile_update.dart';
import 'package:cine_shelf/features/auth/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

/// Repository contract for user profile operations (remote + cache).
abstract class UserRepository {
  Future<void> createUserDocument({
    required String uid,
    required String username,
    required String email,
  });

  Future<UserModel?> getUserDocument(String uid);

  Future<void> updateEditableProfile({
    required String uid,
    required ProfileUpdate update,
  });
}

/// Repository for managing user profile documents in Firestore with local cache.
///
/// Handles:
/// - User profile creation (cooperates with Cloud Functions)
/// - Fetching user profile data (with offline fallback to local cache)
///
/// User documents are stored in the `/user/{uid}` collection.
///
/// **Offline Caching Strategy:**
/// [getUserDocument] implements a try-remote-catch-local pattern:
/// 1. Attempts to fetch from Firestore (remote)
/// 2. On success: returns data and caches it locally (fire & forget)
/// 3. On failure: falls back to local Drift cache
/// 4. Returns null only if no remote data and no cache available
///
/// **Error handling strategy:**
/// The two methods in this repository intentionally differ in error behavior:
/// - [createUserDocument] **rethrows** exceptions so [AuthController] can
///   trigger a rollback (delete the Firebase Auth account) when profile
///   creation fails. Swallowing the error here would leave an orphaned auth
///   account with no Firestore document.
/// - [getUserDocument] **swallows** exceptions and falls back to cache
///   because a missing profile on read is a recoverable situation — the UI
///   can show fallback or cached state without breaking the session.
///
/// **Dependency Injection for Testability:**
/// Both [FirebaseFirestore] and [UserLocalDataSource] are injected via
/// constructor, allowing easy mocking in tests.
class FirestoreUserRepository implements UserRepository {
  /// Creates a [FirestoreUserRepository] with the provided dependencies.
  ///
  /// **Parameters:**
  /// - [_firestore]: Firestore instance for remote operations
  /// - [_userLocalDataSource]: Local Drift data source for offline fallback
  FirestoreUserRepository(this._firestore, this._userLocalDataSource);

  final FirebaseFirestore _firestore;
  final UserLocalDataSource _userLocalDataSource;

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
  /// now tolerates this and returns `createdAt` as null until bootstrap
  /// enrichment completes.
  ///
  /// **Error behavior:** Rethrows any exception so [AuthController] can
  /// perform a compensating delete of the Firebase Auth account.
  ///
  /// Parameters:
  /// - [uid]: User ID from Firebase Authentication.
  /// - [username]: Display name for the user.
  /// - [email]: User's email address (trimmed and lowercased before writing).
  @override
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

  /// Fetches the user profile document with fallback to local cache.
  ///
  /// **Behavior:**
  /// 1. Attempts to fetch from Firestore (remote source)
  /// 2. On success: Returns [UserModel] and caches it locally (fire & forget)
  /// 3. On failure: Falls back to local cache (Drift)
  /// 4. If no cache available: Returns `null`
  ///
  /// **Returns:**
  /// - [UserModel] from Firestore (remote) if online
  /// - [UserModel] from cache (Drift) if offline
  /// - `null` if no remote data and no cache available
  ///
  /// **Offline behavior:**
  /// When offline, returns cached data if previously loaded. Users can view
  /// their profile without internet as long as it was cached during a
  /// previous online session.
  ///
  /// Parameters:
  /// - [uid]: User ID to fetch the profile for
  @override
  Future<UserModel?> getUserDocument(String uid) async {
    try {
      // ATTEMPT REMOTE
      final doc = await _firestore.collection('user').doc(uid).get();
      if (doc.exists) {
        final user = UserModel.fromFirestore(doc, uid);

        // CACHE LOCALLY (fire & forget, non-blocking)
        unawaited(_userLocalDataSource.cacheUser(user));

        return user;
      }
      return null;
    } on FirebaseException catch (e) {
      // REMOTE FAILED: try local cache
      debugPrint('USER REMOTE ERROR: $e, attempting cache fallback');

      final cachedEntity = await _userLocalDataSource.getUser(uid);
      if (cachedEntity != null) {
        debugPrint('USER CACHE HIT: returning cached data');
        return cachedEntity.toAppModel();
      }

      // No cache available
      debugPrint('USER CACHE MISS: no cached user found');
      return null;
    }
  }

  /// Updates only the editable profile fields on `/user/{uid}`.
  ///
  /// Ownership of the user aggregate stays in this repository. Binary avatar
  /// upload remains outside of Firestore and is handled by the account Storage
  /// repository before its final URL is persisted here.
  @override
  Future<void> updateEditableProfile({
    required String uid,
    required ProfileUpdate update,
  }) async {
    final data = update.toFirestoreUpdate();
    if (data.isEmpty) return;

    data['updatedAt'] = FieldValue.serverTimestamp();
    await _firestore.collection('user').doc(uid).update(data);
  }
}
