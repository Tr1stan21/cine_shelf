import '../models/movie_poster.dart';
import '../models/tmdb/list_category.dart';
import '../models/movie_detail.dart';
import '../models/paginated_movies.dart';
import '../models/movie_discovery_query.dart';

abstract class MoviesRepository {
  Future<List<MoviePoster>> getMovies(
    ListCategory category, {
    int page = 1,
    String region = 'US',
  });

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

  Future<MovieDetail> getMovieDetail(int movieId);
}
