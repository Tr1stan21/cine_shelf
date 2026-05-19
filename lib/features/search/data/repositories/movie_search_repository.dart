import '../../models/paginated_movie_search_results.dart';

abstract class MovieSearchRepository {
  Future<PaginatedMovieSearchResults> searchMovies({
    required String query,
    int page = 1,
    String region = 'US',
  });
}
