/// Data Transfer Object for TMDB `/search/movie` paginated response.
class SearchMoviesDto {
  SearchMoviesDto({
    required this.page,
    required this.totalPages,
    required this.results,
  });

  final int page;
  final int totalPages;
  final List<SearchMovieDto> results;

  factory SearchMoviesDto.fromJson(Map<String, dynamic> json) {
    final resultsJson = json['results'] as List<dynamic>? ?? const [];
    return SearchMoviesDto(
      page: (json['page'] as num?)?.toInt() ?? 1,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 1,
      results: resultsJson
          .map((e) => SearchMovieDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Data Transfer Object for a movie returned by TMDB `/search/movie`.
class SearchMovieDto {
  SearchMovieDto({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.releaseDate,
  });

  final int id;
  final String title;
  final String? posterPath;
  final String? releaseDate;

  factory SearchMovieDto.fromJson(Map<String, dynamic> json) {
    return SearchMovieDto(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? json['original_title'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      releaseDate: json['release_date'] as String?,
    );
  }
}
