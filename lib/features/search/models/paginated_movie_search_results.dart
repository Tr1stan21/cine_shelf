import 'movie_search_result.dart';

class PaginatedMovieSearchResults {
  const PaginatedMovieSearchResults({
    required this.page,
    required this.totalPages,
    required this.results,
  });

  final int page;
  final int totalPages;
  final List<MovieSearchResult> results;
}
