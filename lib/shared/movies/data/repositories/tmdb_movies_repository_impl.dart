import 'movies_repository.dart';
import '../mappers/movie_poster_mapper.dart';
import '../sources/tmdb_movies_source.dart';
import '../../models/list_category.dart';
import '../../../models/paginated_movies.dart';
import '../../models/movie_discovery_query.dart';

/// Implementation of the movies repository using TMDB as the remote data source.
///
/// This is the data layer that bridges:
/// - Remote TMDB API (via [TmdbRemoteDataSource])
/// - Domain models ([MoviePoster], [MovieDetail])
/// - Presentation layer (via [MoviesRepository] interface)
///
/// **Data Flow:**
/// - TMDB API returns JSON → parsed to DTOs → mapped to app models → returned to providers
///
/// All methods are synchronous wrappers; caching and retry logic are handled by providers.
class MoviesRepositoryImpl implements MoviesRepository {
  final TmdbRemoteDataSource _remote;

  /// Creates a MoviesRepositoryImpl with the TMDB remote data source.
  ///
  /// Parameters:
  /// - [_remote]: TmdbRemoteDataSource for API calls
  MoviesRepositoryImpl(this._remote);

  /// Fetches paginated movies with metadata for infinite scroll.
  ///
  /// Returns [PaginatedMoviesPage] containing the movie list and pagination info.
  @override
  Future<PaginatedMoviesPage> getMoviesPage(
    ListCategory category, {
    int page = 1,
    String region = 'US',
  }) async {
    return getMoviesPageByQuery(
      MovieDiscoveryQuery.category(category),
      page: page,
      region: region,
    );
  }

  @override
  Future<PaginatedMoviesPage> getMoviesPageByQuery(
    MovieDiscoveryQuery query, {
    int page = 1,
    String region = 'US',
  }) async {
    final dto = await _remote.getMoviesByDiscoveryQuery(
      query,
      page: page,
      region: region,
    );
    return PaginatedMoviesPage(
      page: dto.page,
      totalPages: dto.totalPages,
      movies: dto.results.map((e) => e.toAppModel()).toList(),
    );
  }
}
