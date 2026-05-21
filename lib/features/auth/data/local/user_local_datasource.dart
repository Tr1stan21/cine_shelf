import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';

import 'package:cine_shelf/core/database/drift_database.dart';
import 'package:cine_shelf/features/auth/models/user_model.dart';

/// Local data source for caching user profile data using Drift.
///
/// Provides CRUD operations for the cached user profile stored in the
/// [UsersTable]. Data is populated when the user profile is loaded from
/// Firestore while online. Cleared on sign-out.
///
/// **Responsibility:**
/// - Store/retrieve user profile in local SQLite database (Drift)
/// - No remote calls; only local operations
/// - Silent error handling (log and return null/empty on failure)
///
/// **Usage:**
/// ```dart
/// final userCache = UserLocalDataSource(ref.watch(appDatabaseProvider));
/// await userCache.cacheUser(userModel);
/// final cached = await userCache.getUser('uid123');
/// ```
class UserLocalDataSource {
  /// Creates a [UserLocalDataSource] with the provided [AppDatabase] instance.
  UserLocalDataSource(this._db);

  final AppDatabase _db;

  /// Caches (inserts or replaces) a user profile document.
  ///
  /// **Behavior:**
  /// - If user already cached: replaces entire document (upsert)
  /// - If user not cached: inserts new row
  /// - Silent on error: catches and logs, does not rethrow
  ///
  /// **Usage:**
  /// Fire-and-forget from [UserRepository.getUserDocument]:
  /// ```dart
  /// unawaited(_userLocalDataSource.cacheUser(user));
  /// ```
  ///
  /// Parameters:
  /// - [user]: [UserModel] to cache
  Future<void> cacheUser(UserModel user) async {
    try {
      await _db.into(_db.usersTable).insertOnConflictUpdate(
        UsersTableCompanion(
          uid: Value(user.uid),
          email: Value(user.email),
          username: Value(user.username),
          avatarUrl:
              user.avatarUrl != null ? Value(user.avatarUrl) : const Value(null),
          updatedAt: Value(user.createdAt ?? DateTime.now()),
          cachedAt: Value(DateTime.now()),
        ),
      );
    } catch (e, st) {
      debugPrint('ERROR caching user: $e\n$st');
    }
  }

  /// Retrieves cached user profile by UID.
  ///
  /// **Returns:**
  /// - [UserLocalEntity] if found
  /// - `null` if not found or on error
  ///
  /// **Error handling:** Catches exceptions silently; returns `null`.
  ///
  /// Parameters:
  /// - [uid]: User ID to retrieve
  Future<UserLocalEntity?> getUser(String uid) async {
    try {
      return await (_db.select(_db.usersTable)
            ..where((u) => u.uid.equals(uid)))
          .getSingleOrNull();
    } catch (e, st) {
      debugPrint('ERROR retrieving cached user: $e\n$st');
      return null;
    }
  }

  /// Deletes cached user profile by UID.
  ///
  /// **Behavior:**
  /// - Deletes the row if it exists
  /// - No-op if user not found
  /// - Silent on error: catches and logs
  ///
  /// **Usage:**
  /// Called from [AuthController.signOut] to clean up local data.
  ///
  /// Parameters:
  /// - [uid]: User ID to delete
  Future<void> clearUser(String uid) async {
    try {
      await (_db.delete(_db.usersTable)
            ..where((u) => u.uid.equals(uid)))
          .go();
    } catch (e, st) {
      debugPrint('ERROR clearing cached user: $e\n$st');
    }
  }

  /// Deletes all cached user profiles.
  ///
  /// **Used for:** Testing or global cache reset.
  /// **Silent on error.**
  Future<void> clearAllUsers() async {
    try {
      await _db.delete(_db.usersTable).go();
    } catch (e, st) {
      debugPrint('ERROR clearing all cached users: $e\n$st');
    }
  }
}
