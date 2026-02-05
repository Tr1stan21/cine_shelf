import 'package:cine_shelf/models/movie_item.dart';

class MovieData {
  static const String posterUrl =
      'https://img.freepik.com/foto-gratis/abstracto-lujo-plano-borroso-gris-negro-gradiente-utilizado-como-pared-estudio-fondo-mostrar-sus-productos_1258-101806.jpg?t=st=1770232643~exp=1770236243~hmac=3609abae0072ff030394bdd554e53da3857969388a5dd856fd5c3608302051a1';

  static final List<MovieItem> s = List.generate(
    10,
    (i) => MovieItem(
      title: 'Latest ${i + 1}',
      imageUrl: posterUrl,
      id: 'latest_$i',
    ),
  );

  static final List<MovieItem> m = List.generate(
    25,
    (i) => MovieItem(
      title: 'Top Rated ${i + 1}',
      imageUrl: posterUrl,
      id: 'top_$i',
    ),
  );

  static final List<MovieItem> l = List.generate(
    50,
    (i) => MovieItem(
      title: 'Popular ${i + 1}',
      imageUrl: posterUrl,
      id: 'popular_$i',
    ),
  );
}
