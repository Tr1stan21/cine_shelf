import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/config/env.dart';

/// Provider for the configured Dio HTTP client.
///
/// **Base Configuration:**
/// - Base URL: `https://api.themoviedb.org/3` (TMDB API v3)
/// - Default timeout: 30 seconds (Dio default)
/// - Content-Type: JSON
///
/// **Authentication:**
/// - Authorization header: `Bearer {TMDB_READ_TOKEN}`
/// - Token is loaded from [Env.tmdbReadToken] (from environment or .env file)
/// - All requests include this bearer token in Authorization header
///
/// **Response Handling:**
/// - DioException is propagated (not caught here)
/// - Each app layer (repository, data source) handles specific error cases
/// - Consider adding interceptors here if you need:
///   - Rate-limit handling (429 responses)
///   - Retry logic (transient errors)
///   - Request/response logging
///   - Token refresh (if using authentication tokens)
///
/// **SingletonPattern:**
/// This is a singleton Provider (not FutureProvider or autoDispose).
/// The Dio instance is created once and reused for all HTTP calls.
///
/// **Usage:**
/// ```dart
/// // In remote data sources:
/// final dio = ref.watch(dioProvider);
/// final response = await dio.get('/movie/popular');
///
/// // In tests (mock it):
/// final mockDio = MockDio();
/// ref.override(dioProvider, provider.overrideWithValue(mockDio));
/// ```
final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      headers: <String, dynamic>{
        'Authorization': 'Bearer ${Env.tmdbReadToken}',
        'Accept': 'application/json',
      },
    ),
  );
});
