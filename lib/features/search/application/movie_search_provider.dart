import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cine_shelf/shared/data/movies/data/movies_providers.dart';
import 'package:cine_shelf/features/search/models/paginated_movie_search_results.dart';

class MovieSearchQuery {
  const MovieSearchQuery({
    required this.query,
    required this.region,
    this.page = 1,
  });

  final String query;
  final String region;
  final int page;

  MovieSearchQuery normalized() {
    return MovieSearchQuery(
      query: query.trim(),
      region: region.toUpperCase(),
      page: page,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MovieSearchQuery &&
        other.query == query &&
        other.region == region &&
        other.page == page;
  }

  @override
  int get hashCode => Object.hash(query, region, page);
}

final movieSearchProvider = FutureProvider.autoDispose
    .family<PaginatedMovieSearchResults, MovieSearchQuery>((ref, params) {
      final query = params.normalized();
      return ref
          .watch(moviesRepositoryProvider)
          .searchMovies(
            query: query.query,
            page: query.page,
            region: query.region,
          );
    });
