import '../dto/tmdb/list_category.dart';
import '../../../../../features/movie_detail/models/movie_detail.dart';
import '../../models/paginated_movies.dart';
import '../../models/movie_discovery_query.dart';
import '../../../../../features/search/models/paginated_movie_search_results.dart';

abstract class MoviesRepository {
  Future<PaginatedMoviesPage> getMoviesPage(
    ListCategory category, {
    int page = 1,
    String region = 'US',
  });

  /// Unified paginated discovery by category or genre query.
  Future<PaginatedMoviesPage> getMoviesPageByQuery(
    MovieDiscoveryQuery query, {
    int page = 1,
    String region = 'US',
  });

  Future<PaginatedMovieSearchResults> searchMovies({
    required String query,
    int page = 1,
    String region = 'US',
  });

  Future<MovieDetail> getMovieDetail(int movieId);
}
