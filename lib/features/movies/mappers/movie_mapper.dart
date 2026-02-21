import '../models/movie_poster.dart';
import '../models/tmdb/popular_movies_dto.dart';

extension MovieSummaryDtoMapper on MovieSummaryDto {
  MoviePoster toAppModel() {
    return MoviePoster(id: id, posterPath: posterPath);
  }
}
