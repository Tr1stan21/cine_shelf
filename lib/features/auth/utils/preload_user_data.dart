import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cine_shelf/features/auth/application/auth_providers.dart';
import 'package:cine_shelf/features/lists/application/list_providers.dart';

/// Preloads user-related data and waits for completion.
Future<void> preloadUserData(Ref ref) async {
  await Future.wait([
    ref.read(currentUserProvider.future),
    ref.read(watchedCountProvider.future),
    ref.read(watchlistCountProvider.future),
    ref.read(favoritesCountProvider.future),
  ]);
}
