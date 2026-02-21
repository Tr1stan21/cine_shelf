import 'package:cine_shelf/features/movies/models/movie_poster.dart';

/// Arguments for MovieListScreen
///
/// Encapsulates data needed to display a filtered or categorized list of movies.
class MovieListArgs {
  const MovieListArgs({required this.title, required this.items});

  final String title;
  final List<MoviePoster> items;
}
