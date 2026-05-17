/// Data Transfer Object for TMDB paginated movie list response.
///
/// Represents the paginated response from TMDB's `/movie/{category}` endpoints
/// (e.g., `/movie/popular`, `/movie/top_rated`).
///
/// **Response Structure:**
/// - `page`: Current page number in the paginated result set
/// - `total_pages`: Total number of pages available
/// - `results`: Array of movies on this page with minimal info (id, poster_path)
///
/// Used by [TmdbRemoteDataSource] for infinite scroll pagination.
class CategoryMoviesDto {
  /// Current page number in the paginated result set.
  final int page;

  /// Total number of pages available for this category.
  final int totalPages;

  /// Movie posters on the current page.
  final List<MoviePosterDto> results;

  /// Creates a CategoryMoviesDto with pagination metadata and results.
  CategoryMoviesDto({
    required this.page,
    required this.totalPages,
    required this.results,
  });

  factory CategoryMoviesDto.fromJson(Map<String, dynamic> json) {
    final resultsJson = (json['results'] as List<dynamic>? ?? const []);
    return CategoryMoviesDto(
      page: (json['page'] as num?)?.toInt() ?? 1,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 1,
      results: resultsJson
          .map((e) => MoviePosterDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Data Transfer Object for a single movie entry within a TMDB paginated list.
///
/// Contains only the minimal fields returned by TMDB category endpoints
/// (`/movie/popular`, `/movie/top_rated`, etc.) — sufficient to render
/// a poster grid without requesting full movie details.
///
/// Full details are fetched separately via [TmdbRemoteDataSource.getMovieDetail]
/// when the user navigates to the movie detail screen.
///
/// Mapped to the app-layer model [MoviePoster] via [MoviePosterDtoMapper.toAppModel].
class MoviePosterDto {
  /// Unique TMDB identifier for this movie.
  final int id;

  /// Relative path to the movie poster on the TMDB CDN (e.g., `"/kXDOSHduP9T.jpg"`).
  ///
  /// `null` when TMDB has no poster image for this movie.
  /// Combine with [AppConstants.tmdbPosterUrl] to build the full URL.
  final String? posterPath;

  /// Creates a [MoviePosterDto] with the given ID and optional poster path.
  MoviePosterDto({required this.id, required this.posterPath});

  /// Deserializes a [MoviePosterDto] from a TMDB JSON result item.
  factory MoviePosterDto.fromJson(Map<String, dynamic> json) {
    return MoviePosterDto(
      id: (json['id'] as num).toInt(),
      posterPath: json['poster_path'] as String?,
    );
  }
}
