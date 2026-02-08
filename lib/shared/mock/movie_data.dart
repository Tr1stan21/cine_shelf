import 'package:cine_shelf/shared/config/constants.dart';
import 'package:cine_shelf/features/movies/models/movie.dart';

/// Class that provides mock movie data for development
///
/// Generates test movie lists in different categories.
/// For temporary use until real API integration.
class MovieData {
  MovieData._();

  static const String posterUrl = AppConstants.urlPlaceholderPoster;

  /// Latest releases (medium list)
  static final List<Movie> medium = List.generate(
    25,
    (i) =>
        Movie(title: 'Latest ${i + 1}', imageUrl: posterUrl, id: 'latest_$i'),
  );

  /// Top rated (small list)
  static final List<Movie> small = List.generate(
    10,
    (i) =>
        Movie(title: 'Top Rated ${i + 1}', imageUrl: posterUrl, id: 'top_$i'),
  );

  /// Popular (large list)
  static final List<Movie> large = List.generate(
    50,
    (i) =>
        Movie(title: 'Popular ${i + 1}', imageUrl: posterUrl, id: 'popular_$i'),
  );
}
