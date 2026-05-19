import 'list_category.dart';

/// Discriminated query used to discover movie lists from TMDB.
///
/// A query can target either a predefined TMDB category endpoint
/// (e.g. popular, top_rated) or discover-by-genre.
class MovieDiscoveryQuery {
  /// Query variant for `/movie/{category}` endpoints.
  const MovieDiscoveryQuery.category(ListCategory this.category)
    : genreId = null;

  /// Query variant for `/discover/movie?with_genres={genreId}`.
  const MovieDiscoveryQuery.genre(int this.genreId)
    : assert(genreId > 0, 'Genre id must be positive.'),
      category = null;

  final ListCategory? category;
  final int? genreId;

  bool get isCategory => category != null;
  bool get isGenre => genreId != null;

  @override
  bool operator ==(Object other) {
    return other is MovieDiscoveryQuery &&
        other.category == category &&
        other.genreId == genreId;
  }

  @override
  int get hashCode => Object.hash(category, genreId);
}
