import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/paginated_movies.dart';
import '../models/tmdb/list_category.dart';
import '../data/movies_providers.dart';

/// Provider parametrizado por [MovieCategory].
///
/// Una sola declaración cubre todas las categorías.
/// Riverpod gestiona una instancia independiente por categoría
/// y la mantiene en caché mientras haya listeners activos.
///
/// Uso:
/// ```dart
/// ref.watch(moviesProvider(MovieCategory.popular))
/// ref.watch(moviesProvider(MovieCategory.topRated))
/// ```
final moviesProvider = FutureProvider.family<PaginatedMoviesPage, ListCategory>(
  (ref, category) {
    return ref.watch(moviesRepositoryProvider).getMoviesPage(category);
  },
);
