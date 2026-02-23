/// Enumeration of movie categories available from the TMDB API.
///
/// Each value maps directly to the route segment of a TMDB endpoint:
/// - `popular` → `GET /movie/popular`
/// - `now_playing` → `GET /movie/now_playing`
/// - `upcoming` → `GET /movie/upcoming`
/// - `top_rated` → `GET /movie/top_rated`
///
/// Used as a parameter for [TmdbRemoteDataSource.getMovies] and
/// [PaginatedMoviesNotifier] to request movies in a specific category.
///
/// **Route Mapping:**
/// The [path] property contains the URL segment that replaces `{category}`
/// in the endpoint template.
enum ListCategory {
  /// Currently popular movies (trending now)
  popular('popular'),

  /// Movies currently in theaters
  nowPlaying('now_playing'),

  /// Movies coming to theaters soon
  upcoming('upcoming'),

  /// Highest rated movies of all time
  topRated('top_rated');

  const ListCategory(this.path);

  /// URL segment used in the TMDB API request (e.g., "popular", "now_playing").
  final String path;
}
