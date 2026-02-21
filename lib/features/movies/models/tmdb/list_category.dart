/// Categorías de películas disponibles en TMDB.
///
/// Cada valor mapea directamente al segmento de ruta del endpoint:
/// `GET /movie/{category}` → e.g. `/movie/popular`
enum ListCategory {
  popular('popular'),
  nowPlaying('now_playing'),
  upcoming('upcoming'),
  topRated('top_rated');

  const ListCategory(this.path);

  /// Segmento de ruta usado en la llamada a TMDB.
  final String path;
}
