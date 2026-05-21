import 'package:cine_shelf/core/database/drift_database.dart';
import 'package:cine_shelf/features/lists/models/user_custom_list.dart';

/// Extension providing mapping from local cached list entity to app model.
///
/// Converts [UserListLocalEntity] (Drift representation) to [UserCustomList]
/// (app-level data model) for use throughout the app.
///
/// **Usage:**
/// ```dart
/// final localEntity = await listDataSource.getLists(uid);
/// final appModels = localEntity.map((e) => e.toAppModel()).toList();
/// ```
extension UserListLocalEntityMapper on UserListLocalEntity {
  /// Converts [UserListLocalEntity] to [UserCustomList].
  ///
  /// **Mapping:**
  /// - listId → id
  /// - name → name
  /// - iconName → iconName
  /// - createdAt → createdAt
  /// - updatedAt → updatedAt
  ///
  /// **Returns:** [UserCustomList] with cached data
  UserCustomList toAppModel() {
    return UserCustomList(
      id: listId,
      name: name,
      iconName: iconName ?? 'bookmark_outline',
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
