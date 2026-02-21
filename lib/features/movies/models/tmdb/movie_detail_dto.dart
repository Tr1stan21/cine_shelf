import 'genres_dto.dart';

/// DTO para la respuesta del endpoint GET /movie/{movie_id}
///
/// TMDB retorna el detalle completo de una película, incluyendo
/// los géneros como objetos con id y nombre, no solo como IDs.
class MovieDetailDto {
  final int id;
  final String title;
  final String? posterPath;
  final String overview;
  final String releaseDate;
  final List<GenreDto> genres;

  MovieDetailDto({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.releaseDate,
    required this.genres,
  });

  factory MovieDetailDto.fromJson(Map<String, dynamic> json) {
    return MovieDetailDto(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      posterPath: json['poster_path'] as String?,
      overview: json['overview'] as String? ?? '',
      releaseDate: json['release_date'] as String? ?? '',
      genres:
          (json['genres'] as List<dynamic>?)
              ?.map((e) => GenreDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}
