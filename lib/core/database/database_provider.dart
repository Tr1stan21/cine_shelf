import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'drift_database.dart';

/// Provides a singleton [AppDatabase] instance.
///
/// **Lifecycle:**
/// - Instance is created once on first access and reused for the app lifetime.
/// - Database file is persisted in the app's documents directory.
/// - No cleanup on app exit; Drift handles resource management automatically.
///
/// **Usage:**
/// ```dart
/// final db = ref.watch(appDatabaseProvider);
/// final user = await db.usersDao.getUser(uid);
/// ```
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});
