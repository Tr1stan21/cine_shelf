import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cine_shelf/core/database/database_provider.dart';
import 'user_local_datasource.dart';

/// Provides a singleton [UserLocalDataSource] instance.
///
/// **Dependencies:**
/// - [appDatabaseProvider]: Injected Drift database instance
///
/// **Lifecycle:**
/// - Created once on first access
/// - Reused throughout app lifetime
///
/// **Usage:**
/// ```dart
/// final userCache = ref.watch(userLocalDataSourceProvider);
/// final cached = await userCache.getUser(uid);
/// ```
final userLocalDataSourceProvider = Provider<UserLocalDataSource>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return UserLocalDataSource(db);
});
