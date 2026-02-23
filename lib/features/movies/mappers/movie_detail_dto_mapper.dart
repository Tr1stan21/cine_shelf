import 'package:cine_shelf/shared/config/constants.dart';
import '../models/movie_detail.dart';
import '../models/tmdb/movie_detail_dto.dart';

/// Extension that maps TMDB detail response to domain model.
///
/// **Mapping:** [MovieDetailDto] (TMDB API response) → [MovieDetail] (app model)
///
/// Handles data normalization:
/// - Constructs full poster URL from relative path via [AppConstants.tmdbPosterUrl]
/// - Extracts year from ISO date string ("2024-03-08" → "2024")
/// - Transforms genre objects to simple name strings
///
/// This mapping occurs before UI rendering, ensuring the presentation layer
/// never sees raw TMDB response structures.
extension MovieDetailDtoMapper on MovieDetailDto {
  /// Converts a TMDB movie detail DTO to the app-layer domain model.
  ///
  /// Returns:
  /// - [MovieDetail] with normalized fields ready for UI rendering
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
