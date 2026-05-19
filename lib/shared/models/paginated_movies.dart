import 'movie_poster.dart';

class PaginatedMoviesPage {
  const PaginatedMoviesPage({
    required this.page,
    required this.totalPages,
    required this.movies,
  });

  final int page;
  final int totalPages;
  final List<MoviePoster> movies;
}
