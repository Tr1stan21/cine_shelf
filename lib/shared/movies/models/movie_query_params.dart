import 'list_category.dart';
import 'movie_discovery_query.dart';

/// Immutable key for movie list queries.
///
/// Riverpod provider families use this object as a composite cache key
/// to isolate results by both discovery query and region.
class MovieQueryParams {
  /// Backward-compatible constructor for category-based queries.
  MovieQueryParams({required ListCategory category, required this.region})
    : discoveryQuery = MovieDiscoveryQuery.category(category),
      assert(region.length == 2, 'Region must be an ISO-3166 alpha-2 code.');

  /// Constructor for any supported discovery query (category or genre).
  MovieQueryParams.discovery({
    required this.discoveryQuery,
    required this.region,
  }) : assert(region.length == 2, 'Region must be an ISO-3166 alpha-2 code.');

  MovieDiscoveryQuery discoveryQuery;
  final String region;

  /// Legacy getter kept while category-only call sites are migrated.
  ///
  /// Throws when called for non-category queries.
  ListCategory get category {
    final value = discoveryQuery.category;
    if (value == null) {
      throw StateError('This query does not target a movie category.');
    }
    return value;
  }

  /// Returns genre ID when the query targets discover-by-genre.
  int? get genreId => discoveryQuery.genreId;

  /// Returns a normalized copy using uppercase region code.
  MovieQueryParams normalized() {
    return MovieQueryParams.discovery(
      discoveryQuery: discoveryQuery,
      region: region.toUpperCase(),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MovieQueryParams &&
        other.discoveryQuery == discoveryQuery &&
        other.region == region;
  }

  @override
  int get hashCode => Object.hash(discoveryQuery, region);
}
