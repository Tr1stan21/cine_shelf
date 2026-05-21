import 'package:cine_shelf/core/database/drift_database.dart';
import 'package:cine_shelf/features/auth/models/user_model.dart';

/// Extension providing mapping from local cached entity to app model.
///
/// Converts [UserLocalEntity] (Drift representation) to [UserModel]
/// (app-level data model) for use throughout the app.
///
/// **Usage:**
/// ```dart
/// final localEntity = await userDataSource.getUser(uid);
/// final appModel = localEntity?.toAppModel();
/// ```
extension UserLocalEntityMapper on UserLocalEntity {
  /// Converts [UserLocalEntity] to [UserModel].
  ///
  /// **Mapping:**
  /// - All fields are directly mapped (1:1)
  /// - No transformations or defaults needed
  ///
  /// **Returns:** [UserModel] with cached data
  UserModel toAppModel() {
    return UserModel(
      uid: uid,
      username: username,
      email: email,
      avatarUrl: avatarUrl,
      createdAt: updatedAt,
    );
  }
}
