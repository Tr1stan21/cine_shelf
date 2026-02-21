class PopularMoviesDto {
  final int page;
  final List<MovieSummaryDto> results;

  PopularMoviesDto({required this.page, required this.results});

  factory PopularMoviesDto.fromJson(Map<String, dynamic> json) {
    final resultsJson = (json['results'] as List<dynamic>? ?? const []);
    return PopularMoviesDto(
      page: (json['page'] as num?)?.toInt() ?? 1,
      results: resultsJson
          .map((e) => MovieSummaryDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class MovieSummaryDto {
  final int id;
  final String posterPath;

  MovieSummaryDto({required this.id, required this.posterPath});

  factory MovieSummaryDto.fromJson(Map<String, dynamic> json) {
    return MovieSummaryDto(
      id: (json['id'] as num).toInt(),
      posterPath: json['poster_path'] as String,
    );
  }
}
