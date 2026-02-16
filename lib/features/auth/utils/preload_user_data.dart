import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cine_shelf/features/auth/application/auth_providers.dart';
import 'package:cine_shelf/features/lists/application/list_providers.dart';

/// Triggers a best-effort preload of user-related data.
void preloadUserData(WidgetRef ref) {
  ref.read(currentUserProvider.future).ignore();
  ref.read(watchedCountProvider.future).ignore();
  ref.read(watchlistCountProvider.future).ignore();
  ref.read(favoritesCountProvider.future).ignore();
}
