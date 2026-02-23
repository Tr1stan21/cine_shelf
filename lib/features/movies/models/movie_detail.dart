/// Domain model containing all data needed for the movie details screen.
///
/// This is the app-layer model, completely decoupled from TMDB's data structure.
/// The UI interacts exclusively with this model; it never sees TMDB DTOs.
///
/// **Mapping Flow:**
/// - [MovieDetailDto] (TMDB response) → [MovieDetailDtoMapper.toMovieDetail] → [MovieDetail]
///
/// **Note:** Fields like [posterUrl] and [year] are normalized during mapping:
/// - `posterPath` is converted to full URL via [AppConstants.tmdbPosterUrl]
/// - `releaseDate` ("2023-03-08") is parsed to extract year
/// - Genre list is mapped from objects to simple strings
class MovieDetail {
  final int id;
  final String title;
  final String posterUrl;
  final String year;
  final List<String> genres;
  final String overview;

  const MovieDetail({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.year,
    required this.genres,
    required this.overview,
  });
}
