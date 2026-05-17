import 'genres_dto.dart';

/// Data Transfer Object for TMDB GET /movie/{movie_id} response.
///
/// Represents the complete movie detail returned by the TMDB API.
/// Includes resolved genre objects (not just IDs), which simplifies downstream mapping.
///
/// **Note:** TMDB's `/movie/{id}` endpoint returns genres as full objects with `id` and `name`,
/// unlike other endpoints that return genre IDs only. This is why [genres] is a list of [GenreDto]
/// rather than simple integers.
///
/// This DTO is database-agnostic and should be mapped to domain models ([MovieDetail])
/// before being used in business logic.
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
