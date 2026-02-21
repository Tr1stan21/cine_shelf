// lib/features/movies/models/movie_detail.dart

/// Modelo de dominio con los datos necesarios para la pantalla de detalle.
///
/// Completamente desacoplado de TMDB: la UI solo conoce este modelo.
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
