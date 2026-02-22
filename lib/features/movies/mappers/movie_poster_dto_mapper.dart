import '../models/movie_poster.dart';
import '../models/tmdb/category_movies_dto.dart';

extension MoviePosterDtoMapper on MoviePosterDto {
  MoviePoster toAppModel() {
    return MoviePoster(id: id, posterPath: posterPath);
  }
}
