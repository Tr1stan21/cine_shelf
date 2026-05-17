import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import 'tmdb_remote_data_source.dart';

/// Provider for the TMDB remote data source.
///
/// **Dependencies:**
/// - Reads from [dioProvider] to get a configured Dio HTTP client
///
/// **How it works:**
/// - Wraps Dio with TMDB-specific API methods
/// - Single instance per app (Provider, not FutureProvider)
/// - Lazily created on first use
///
/// **Dio Configuration (from [dioProvider]):**
/// - Base URL: `https://api.themoviedb.org/3`
/// - Headers: `Authorization: Bearer {TMDB_READ_TOKEN}` (from env)
/// - Content-Type: `application/json`
/// - Error handling: DioException propagation (not caught here)
///
/// **Usage:**
/// ```dart
/// final remote = ref.watch(tmdbRemoteDataSourceProvider);
/// final movies = await remote.getMovies(ListCategory.popular, page: 1);
/// ```
final tmdbRemoteDataSourceProvider = Provider<TmdbRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return TmdbRemoteDataSource(dio);
});
