import 'package:cine_shelf/shared/config/constants.dart';
import '../models/movie_detail.dart';
import '../models/tmdb/movie_detail_dto.dart';

extension MovieDetailDtoMapper on MovieDetailDto {
  /// Convierte el DTO del endpoint /movie/{id} en modelo de dominio.
  ///
  /// Los géneros ya vienen resueltos como objetos, no necesitamos el mapa externo.
  MovieDetail toMovieDetail() {
    return MovieDetail(
      id: id,
      title: title,
      posterUrl: AppConstants.tmdbPosterUrl(posterPath),
      // releaseDate viene como "2023-03-08" → tomamos solo el año
      year: releaseDate.length >= 4 ? releaseDate.substring(0, 4) : releaseDate,
      genres: genres.map((g) => g.name).toList(),
      overview: overview,
    );
  }
}
