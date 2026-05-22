import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';

import 'package:cine_shelf/core/database/drift_database.dart';
import 'package:cine_shelf/features/lists/models/user_custom_list.dart';

/// Local data source for caching user lists using Drift.
///
/// Provides CRUD operations for user lists (base + custom) stored in the
/// [UserListsTable]. Data is populated when lists are loaded from Firestore
/// while online. Cleared on sign-out.
///
/// **Responsibility:**
/// - Store/retrieve lists in local SQLite database (Drift)
/// - No remote calls; only local operations
/// - Silent error handling (log and return null/empty on failure)
///
/// **Usage:**
/// ```dart
/// final listCache = ListLocalDataSource(ref.watch(appDatabaseProvider));
/// await listCache.cacheLists(lists, uid);
/// final cached = await listCache.getLists(uid);
/// ```
class ListLocalDataSource {
  /// Creates a [ListLocalDataSource] with the provided [AppDatabase] instance.
  ListLocalDataSource(this._db);

  final AppDatabase _db;

  /// Caches (inserts or replaces) a single list.
  ///
  /// **Behavior:**
  /// - If list already cached: replaces entire document (upsert)
  /// - If list not cached: inserts new row
  /// - Silent on error: catches and logs, does not rethrow
  ///
  /// **Parameters:**
  /// - [list]: [UserCustomList] to cache
  /// - [uid]: User ID that owns the list
  Future<void> cacheList(UserCustomList list, String uid) async {
    try {
      await _db
          .into(_db.userListsTable)
          .insertOnConflictUpdate(
            UserListsTableCompanion(
              listId: Value(list.id),
              uid: Value(uid),
              name: Value(list.name),
              type: const Value('custom'),
              iconName: Value(list.iconName),
              createdAt: list.createdAt != null
                  ? Value(list.createdAt)
                  : const Value(null),
              updatedAt: list.updatedAt != null
                  ? Value(list.updatedAt)
                  : const Value(null),
              cachedAt: Value(DateTime.now()),
            ),
          );
    } catch (e, st) {
      debugPrint('ERROR caching list: $e\n$st');
    }
  }

  /// Caches (inserts or replaces) multiple lists at once.
  ///
  /// **Behavior:**
  /// - Upserts all lists (replaces if exists)
  /// - Atomic operation (all or nothing)
  /// - Silent on error
  ///
  /// **Usage:**
  /// Fire-and-forget from [ListRepository.watchCustomLists]:
  /// ```dart
  /// unawaited(_listLocalDataSource.cacheLists(lists, uid));
  /// ```
  ///
  /// **Parameters:**
  /// - [lists]: List of [UserCustomList] to cache
  /// - [uid]: User ID that owns the lists
  Future<void> cacheLists(List<UserCustomList> lists, String uid) async {
    try {
      final companions = lists
          .map(
            (list) => UserListsTableCompanion(
              listId: Value(list.id),
              uid: Value(uid),
              name: Value(list.name),
              type: const Value('custom'),
              iconName: Value(list.iconName),
              createdAt: list.createdAt != null
                  ? Value(list.createdAt)
                  : const Value(null),
              updatedAt: list.updatedAt != null
                  ? Value(list.updatedAt)
                  : const Value(null),
              cachedAt: Value(DateTime.now()),
            ),
          )
          .toList();

      await _db.batch((batch) {
        batch.insertAllOnConflictUpdate(_db.userListsTable, companions);
      });
    } catch (e, st) {
      debugPrint('ERROR caching lists: $e\n$st');
    }
  }

  /// Retrieves all cached lists for a user (base + custom).
  ///
  /// **Returns:**
  /// - List of [UserListLocalEntity] (empty list if none found)
  /// - Empty list on error
  ///
  /// **Error handling:** Catches exceptions silently; returns empty list.
  ///
  /// **Parameters:**
  /// - [uid]: User ID to retrieve lists for
  Future<List<UserListLocalEntity>> getLists(String uid) async {
    try {
      return await (_db.select(
        _db.userListsTable,
      )..where((list) => list.uid.equals(uid))).get();
    } catch (e, st) {
      debugPrint('ERROR retrieving cached lists: $e\n$st');
      return [];
    }
  }

  /// Deletes all cached lists for a user.
  ///
  /// **Behavior:**
  /// - Deletes all rows matching [uid]
  /// - No-op if user has no cached lists
  /// - Silent on error
  ///
  /// **Usage:**
  /// Called from [AuthController.signOut] to clean up local data.
  ///
  /// **Parameters:**
  /// - [uid]: User ID to delete lists for
  Future<void> clearLists(String uid) async {
    try {
      await (_db.delete(
        _db.userListsTable,
      )..where((list) => list.uid.equals(uid))).go();
    } catch (e, st) {
      debugPrint('ERROR clearing cached lists: $e\n$st');
    }
  }

  /// Deletes all cached lists (global reset).
  ///
  /// **Used for:** Testing or global cache reset.
  /// **Silent on error.**
  Future<void> clearAllLists() async {
    try {
      await _db.delete(_db.userListsTable).go();
    } catch (e, st) {
      debugPrint('ERROR clearing all cached lists: $e\n$st');
    }
  }

  Future<void> deleteList(String uid, String listId) async {
    try {
      await (_db.delete(
        _db.userListsTable,
      )..where((l) => l.uid.equals(uid) & l.listId.equals(listId))).go();
    } catch (e, st) {
      debugPrint('ERROR deleting cached list: $e\n$st');
    }
  }

  /// Replaces all cached lists for a user atomically.
  /// Deletes all existing rows for [uid] and inserts [lists].
  /// Safe to call with an empty list — it will clear the cache.
  Future<void> replaceAllLists(List<UserCustomList> lists, String uid) async {
    try {
      await _db.transaction(() async {
        await (_db.delete(
          _db.userListsTable,
        )..where((l) => l.uid.equals(uid))).go();

        if (lists.isEmpty) return;

        final companions = lists
            .map(
              (list) => UserListsTableCompanion(
                listId: Value(list.id),
                uid: Value(uid),
                name: Value(list.name),
                type: const Value('custom'),
                iconName: Value(list.iconName),
                createdAt: list.createdAt != null
                    ? Value(list.createdAt)
                    : const Value(null),
                updatedAt: list.updatedAt != null
                    ? Value(list.updatedAt)
                    : const Value(null),
                cachedAt: Value(DateTime.now()),
              ),
            )
            .toList();

        await _db.batch((batch) {
          batch.insertAllOnConflictUpdate(_db.userListsTable, companions);
        });
      });
    } catch (e, st) {
      debugPrint('ERROR replacing cached lists: $e\n$st');
    }
  }
}
