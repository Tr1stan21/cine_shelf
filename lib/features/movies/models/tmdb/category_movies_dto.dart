class CategoryMoviesDto {
  final int page;
  final List<MoviePosterDto> results;

  CategoryMoviesDto({required this.page, required this.results});

  factory CategoryMoviesDto.fromJson(Map<String, dynamic> json) {
    final resultsJson = (json['results'] as List<dynamic>? ?? const []);
    return CategoryMoviesDto(
      page: (json['page'] as num?)?.toInt() ?? 1,
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
