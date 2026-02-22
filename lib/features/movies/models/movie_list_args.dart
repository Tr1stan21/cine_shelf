import 'package:cine_shelf/features/movies/models/movie_poster.dart';
import 'package:cine_shelf/features/movies/models/tmdb/list_category.dart';

/// Arguments for MovieListScreen.
///
/// Encapsulates data needed to display a filtered or categorized list of movies.
/// [category] is optional: when provided, the screen enables infinite scroll;
/// when null the list is static (backwards-compatible behaviour).
class MovieListArgs {
  const MovieListArgs({
    required this.title,
    required this.items,
    required this.totalPages,
    this.category,
  });

  final String title;
  final List<MoviePoster> items;
  final int totalPages;

  /// When present, the screen will support infinite scroll using this category.
  final ListCategory? category;
}
