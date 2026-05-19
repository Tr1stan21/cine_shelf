import 'package:dio/dio.dart';
import '../dto/tmdb/category_movies_dto.dart';
import '../dto/tmdb/list_category.dart';
import '../../../../../features/movie_detail/data/dto/movie_detail_dto.dart';
import '../../../../../features/search/data/dto/search_movies_dto.dart';
import '../../models/movie_discovery_query.dart';

/// Remote data source for TMDB API integration.
///
/// Handles all HTTP requests to The Movie Database (TMDB) API endpoints,
/// transforming JSON responses into typed DTOs.
///
/// The [Dio] HTTP client is injected for testability and lifecycle control.
/// All requests use pre-configured base URL, headers, and error handling from the Dio provider.
///
/// **Request Flow:**
/// - client (Dio with Bearer token) → TMDB API → JSON response → fromJson() factory → DTO
///
/// **Error Handling:**
/// - DioException is not caught here; propagation allows repository to handle per-use-case logic
/// - Consider adding error mapping if specific TMDB error codes need special handling
class TmdbRemoteDataSource {
  static const String _fixedLanguage = 'en-US';

  final Dio _dio;

  /// Creates a TmdbRemoteDataSource with the provided Dio HTTP client.
  ///
  /// Parameters:
  /// - [_dio]: Configured Dio instance with TMDB base URL and authentication headers
  TmdbRemoteDataSource(this._dio);

  /// Fetches paginated movies for a given category from TMDB.
  ///
  /// Calls GET `/movie/{category}` with optional pagination.
  ///
  /// Parameters:
  /// - [category]: Movie category (e.g., popular, top_rated, upcoming)
  /// - [page]: Page number for pagination (default: 1)
  ///
  /// Returns:
  /// - [CategoryMoviesDto] containing page info and list of movie posters
  ///
  /// Throws:
  /// - [DioException] on network errors, rate limiting, or invalid responses
  Future<CategoryMoviesDto> getMovies(
    ListCategory category, {
    int page = 1,
    String region = 'US',
  }) async {
    final response = await _dio.get(
      '/movie/${category.path}',
      queryParameters: {
        'page': page,
        'region': region.toUpperCase(),
        'language': _fixedLanguage,
      },
    );
    return CategoryMoviesDto.fromJson(response.data as Map<String, dynamic>);
  }

  /// Fetches paginated movies from TMDB discover endpoint filtered by genre.
  ///
  /// Calls GET `/discover/movie` with `with_genres={genreId}`.
  Future<CategoryMoviesDto> getMoviesByGenre(
    int genreId, {
    int page = 1,
    String region = 'US',
  }) async {
    final response = await _dio.get(
      '/discover/movie',
      queryParameters: {
        'with_genres': genreId,
        'page': page,
        'region': region.toUpperCase(),
        'language': _fixedLanguage,
      },
    );
    return CategoryMoviesDto.fromJson(response.data as Map<String, dynamic>);
  }

  /// Resolves category or genre discovery query to the corresponding TMDB call.
  Future<CategoryMoviesDto> getMoviesByDiscoveryQuery(
    MovieDiscoveryQuery query, {
    int page = 1,
    String region = 'US',
  }) {
    if (query.category != null) {
      return getMovies(query.category!, page: page, region: region);
    }
    return getMoviesByGenre(query.genreId!, page: page, region: region);
  }

  /// Searches movies by title using TMDB `/search/movie`.
  Future<SearchMoviesDto> searchMovies({
    required String query,
    int page = 1,
    String region = 'US',
  }) async {
    final response = await _dio.get(
      '/search/movie',
      queryParameters: {
        'query': query,
        'page': page,
        'include_adult': false,
        'region': region.toUpperCase(),
        'language': _fixedLanguage,
      },
    );
    return SearchMoviesDto.fromJson(response.data as Map<String, dynamic>);
  }

  /// Fetches detailed information for a specific movie.
  ///
  /// Calls GET `/movie/{movie_id}` which returns the complete movie detail with:
  /// - Full metadata (title, overview, release date)
  /// - Pre-resolved genre objects (not just IDs; TMDB enriches this endpoint)
  /// - Additional fields like runtime, budget, revenue (if available)
  ///
  /// Parameters:
  /// - [movieId]: The TMDB movie ID
  ///
  /// Returns:
  /// - [MovieDetailDto] with complete movie information
  ///
  /// Throws:
  /// - [DioException] if the movie is not found (404) or on network errors
  Future<MovieDetailDto> getMovieDetail(int movieId) async {
    final response = await _dio.get(
      '/movie/$movieId',
      queryParameters: {'language': _fixedLanguage},
    );
    return MovieDetailDto.fromJson(response.data as Map<String, dynamic>);
  }
}
