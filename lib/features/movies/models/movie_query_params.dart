import 'tmdb/list_category.dart';

/// Immutable key for movie list queries.
///
/// Riverpod provider families use this object as a composite cache key
/// to isolate results by both category and region.
class MovieQueryParams {
  const MovieQueryParams({required this.category, required this.region})
    : assert(region.length == 2, 'Region must be an ISO-3166 alpha-2 code.');

  final ListCategory category;
  final String region;

  /// Returns a normalized copy using uppercase region code.
  MovieQueryParams normalized() {
    return MovieQueryParams(category: category, region: region.toUpperCase());
  }

  @override
  bool operator ==(Object other) {
    return other is MovieQueryParams &&
        other.category == category &&
        other.region == region;
  }

  @override
  int get hashCode => Object.hash(category, region);
}
