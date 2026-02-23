import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/paginated_movies.dart';
import '../models/tmdb/list_category.dart';
import '../data/movies_providers.dart';

/// Parametrized FutureProvider for fetching paginated movies by category.
///
/// **How it works:**
/// - Single declaration covers all categories (popular, top_rated, upcoming, etc.)
/// - Riverpod maintains a separate cached instance per category
/// - Caching is automatic while listeners are active
/// - Cache invalidates when all listeners unsubscribe
///
/// **Parameters:**
/// - [ListCategory]: The movie category to fetch
///
/// **Caching behavior:**
/// - First call: fetches from TMDB via repository
/// - Subsequent calls with same category: returns cached result (if listeners exist)
/// - Auto-invalidation: cache cleared when no listeners remain
///
/// **Usage:**
/// ```dart
/// // Watch popular movies (automatic refresh on rebuild if cache expired)
/// final popularMovies = ref.watch(moviesProvider(ListCategory.popular));
/// // Handle AsyncValue
/// popularMovies.when(
///   data: (page) => MovieGrid(movies: page.movies),
///   loading: () => const LoadingWidget(),
///   error: (err, stack) => ErrorWidget(error: err),
/// );
/// ```
final moviesProvider = FutureProvider.family<PaginatedMoviesPage, ListCategory>(
  (ref, category) {
    return ref.watch(moviesRepositoryProvider).getMoviesPage(category);
  },
);
