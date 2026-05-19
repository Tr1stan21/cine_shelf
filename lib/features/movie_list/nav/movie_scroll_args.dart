import 'package:cine_shelf/shared/data/movies/models/movie_query_params.dart';
import 'package:cine_shelf/shared/models/movie_poster.dart';

/// Arguments for MovieListScreen.
///
/// Encapsulates data needed to display a filtered or categorized list of movies.
/// [query] is optional: when provided, the screen enables infinite scroll;
/// when null the list is static (backwards-compatible behaviour).
class MovieListArgs {
  const MovieListArgs({
    required this.title,
    required this.items,
    required this.totalPages,
    this.query,
  });

  final String title;
  final List<MoviePoster> items;
  final int totalPages;

  /// When present, the screen supports infinite scroll using this query.
  final MovieQueryParams? query;
}
