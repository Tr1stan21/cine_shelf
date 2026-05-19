import 'package:cine_shelf/shared/data/movies/data/dto/tmdb/movie_poster_dto.dart';

import '../../../models/movie_poster.dart';

/// Extension that maps TMDB DTO to domain model.
///
/// **Mapping:** [MoviePosterDto] (TMDB response) → [MoviePoster] (app model)
///
/// Filters out unnecessary TMDB fields (only keeping id and posterPath).
/// This extension is used in pagination flows to convert TMDB responses into
/// app-layer models before UI rendering.
extension MoviePosterDtoMapper on MoviePosterDto {
  /// Converts a TMDB movie poster DTO to the app-layer domain model.
  ///
  /// Returns:
  /// - [MoviePoster] with id and optional posterPath preserved
  MoviePoster toAppModel() {
    return MoviePoster(id: id, posterPath: posterPath);
  }
}
