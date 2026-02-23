/// Lightweight movie representation for list displays.
///
/// Contains only essential data for rendering movie posters in lists or grids.
/// This is the app-layer model (decoupled from TMDB DTOs).
/// Mapped from [MoviePosterDto] by [MoviePosterDtoMapper.toAppModel].
///
/// **Usage:**
/// - Home screen movie grids
/// - Search results
/// - List infinite scroll
class MoviePoster {
  /// Unique TMDB movie identifier.
  final int id;

  /// Relative path to the movie poster image on TMDB CDN (e.g., "/kXDOSHduP9T").
  /// Null if no poster is available.
  /// To construct a full URL, use [AppConstants.tmdbPosterUrl].
  final String? posterPath;

  /// Creates a MoviePoster with an ID and poster path.
  const MoviePoster({required this.id, required this.posterPath});
}
