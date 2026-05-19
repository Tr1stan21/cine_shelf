import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/paginated_movies.dart';
import '../models/movie_query_params.dart';
import '../data/movies_providers.dart';

/// Parametrized FutureProvider for fetching paginated movies by discovery query.
///
/// **How it works:**
/// - Single declaration covers category and genre discovery queries.
/// - Riverpod keeps an independent cache entry per [MovieQueryParams].
/// - With autoDispose, cached entries are released when no listeners remain.
///
/// **Parameters:**
/// - [MovieQueryParams]: Composite key containing discovery query + region.
///
/// **Usage:**
/// ```dart
/// final query = MovieQueryParams(
///   category: ListCategory.popular,
///   region: 'US',
/// ).normalized();
///
/// final popularMovies = ref.watch(moviesProvider(query));
/// ```
final moviesProvider = FutureProvider.autoDispose
    .family<PaginatedMoviesPage, MovieQueryParams>((ref, query) {
      return ref
          .watch(moviesRepositoryProvider)
          .getMoviesPageByQuery(query.discoveryQuery, region: query.region);
    });
