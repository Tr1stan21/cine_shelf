import '../../models/list_category.dart';
import '../../../models/paginated_movies.dart';
import '../../models/movie_discovery_query.dart';

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

}
