import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cine_shelf/features/auth/application/auth_providers.dart';
import 'package:cine_shelf/features/lists/application/list_providers.dart';

/// Preloads all user-related data and waits for completion.
///
/// Called after successful authentication to ensure user's profile,
/// watched list count, watchlist count, and favorites count are loaded
/// before proceeding with app navigation.
///
/// Parallelizes all loads using [Future.wait] for efficiency.
/// Uses [ref.refresh()] to ensure providers are activated and returns their futures
/// safely, especially important for .autoDispose providers that may be inactive.
///
/// Throws if any load fails (error is propagated from providers).
Future<void> preloadUserData(Ref ref) async {
  await Future.wait([
    ref.refresh(currentUserProvider.future),
    ref.refresh(watchedCountProvider.future),
    ref.refresh(watchlistCountProvider.future),
    ref.refresh(favoritesCountProvider.future),
  ]);
}
