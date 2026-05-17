/// Lightweight movie representation for search result rows.
///
/// Keeps the title and release date that are needed by search UI while still
/// being convertible to [MoviePoster] when navigating to details.
class MovieSearchResult {
  const MovieSearchResult({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.releaseDate,
  });

  final int id;
  final String title;
  final String? posterPath;
  final String? releaseDate;

  String? get year {
    final value = releaseDate;
    if (value == null || value.length < 4) {
      return null;
    }
    return value.substring(0, 4);
  }
}
