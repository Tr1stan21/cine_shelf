import 'package:cine_shelf/core/constants.dart';
import 'package:cine_shelf/models/movie_item.dart';

/// Clase que provee datos mock de películas para desarrollo
///
/// Genera listas de películas de prueba en diferentes categorías.
/// Para uso temporal hasta la integración con API real.
class MovieData {
  MovieData._();

  static const String posterUrl = AppConstants.urlPlaceholderPoster;

  /// Últimos estrenos (lista mediana)
  static final List<MovieItem> m = List.generate(
    25,
    (i) => MovieItem(
      title: 'Latest ${i + 1}',
      imageUrl: posterUrl,
      id: 'latest_$i',
    ),
  );

  /// Más valoradas (lista pequeña)
  static final List<MovieItem> s = List.generate(
    10,
    (i) => MovieItem(
      title: 'Top Rated ${i + 1}',
      imageUrl: posterUrl,
      id: 'top_$i',
    ),
  );

  /// Populares (lista grande)
  static final List<MovieItem> l = List.generate(
    50,
    (i) => MovieItem(
      title: 'Popular ${i + 1}',
      imageUrl: posterUrl,
      id: 'popular_$i',
    ),
  );
}
