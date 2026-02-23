import 'movies_repository.dart';
import '../models/movie_poster.dart';
import '../mappers/movie_poster_dto_mapper.dart';
import '../mappers/movie_detail_dto_mapper.dart';
import 'tmdb_remote_data_source.dart';
import '../models/tmdb/list_category.dart';
import '../models/movie_detail.dart';
import '../models/paginated_movies.dart';

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

  /// Fetches a flat list of movies for the given category.
  ///
  /// Each poster DTO is mapped to [MoviePoster] app model.
  /// Does not include pagination metadata.
  @override
  Future<List<MoviePoster>> getMovies(
    ListCategory category, {
    int page = 1,
  }) async {
    final dto = await _remote.getMovies(category, page: page);
    return dto.results.map((e) => e.toAppModel()).toList();
  }

  /// Fetches paginated movies with metadata for infinite scroll.
  ///
  /// Returns [PaginatedMoviesPage] containing the movie list and pagination info.
  @override
  Future<PaginatedMoviesPage> getMoviesPage(
    ListCategory category, {
    int page = 1,
  }) async {
    final dto = await _remote.getMovies(category, page: page);
    return PaginatedMoviesPage(
      page: dto.page,
      totalPages: dto.totalPages,
      movies: dto.results.map((e) => e.toAppModel()).toList(),
    );
  }

  /// Fetches detailed information for a specific movie.
  ///
  /// Maps the TMDB detail DTO to the app-layer domain model.
  @override
  Future<MovieDetail> getMovieDetail(int movieId) async {
    final dto = await _remote.getMovieDetail(movieId);
    return dto.toMovieDetail();
  }
}
