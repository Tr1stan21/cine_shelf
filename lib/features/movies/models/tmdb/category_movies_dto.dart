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

class MoviePosterDto {
  final int id;
  final String? posterPath;

  MoviePosterDto({required this.id, required this.posterPath});

  factory MoviePosterDto.fromJson(Map<String, dynamic> json) {
    return MoviePosterDto(
      id: (json['id'] as num).toInt(),
      posterPath: json['poster_path'] as String?,
    );
  }
}
