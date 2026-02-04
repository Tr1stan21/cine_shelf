import 'package:cine_shelf/widgets/separator.dart';
import 'package:flutter/material.dart';
import 'package:cine_shelf/widgets/background.dart';
import 'package:cine_shelf/widgets/search_bar.dart';
import 'package:cine_shelf/widgets/movie_section.dart';
import 'package:cine_shelf/models/movie_item.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MovieItem> latestMovies = [
      MovieItem(
        title: 'Batman',
        imageUrl:
            'https://img.freepik.com/foto-gratis/abstracto-lujo-plano-borroso-gris-negro-gradiente-utilizado-como-pared-estudio-fondo-mostrar-sus-productos_1258-101806.jpg?t=st=1770232643~exp=1770236243~hmac=3609abae0072ff030394bdd554e53da3857969388a5dd856fd5c3608302051a1',
        id: 'movie_1',
      ),
      MovieItem(
        title: 'Evil Dead',
        imageUrl:
            'https://img.freepik.com/foto-gratis/abstracto-lujo-plano-borroso-gris-negro-gradiente-utilizado-como-pared-estudio-fondo-mostrar-sus-productos_1258-101806.jpg?t=st=1770232643~exp=1770236243~hmac=3609abae0072ff030394bdd554e53da3857969388a5dd856fd5c3608302051a1',
        id: 'movie_2',
      ),
      MovieItem(
        title: 'Dune',
        imageUrl:
            'https://img.freepik.com/foto-gratis/abstracto-lujo-plano-borroso-gris-negro-gradiente-utilizado-como-pared-estudio-fondo-mostrar-sus-productos_1258-101806.jpg?t=st=1770232643~exp=1770236243~hmac=3609abae0072ff030394bdd554e53da3857969388a5dd856fd5c3608302051a1',
        id: 'movie_3',
      ),
      MovieItem(
        title: 'Dune',
        imageUrl:
            'https://img.freepik.com/foto-gratis/abstracto-lujo-plano-borroso-gris-negro-gradiente-utilizado-como-pared-estudio-fondo-mostrar-sus-productos_1258-101806.jpg?t=st=1770232643~exp=1770236243~hmac=3609abae0072ff030394bdd554e53da3857969388a5dd856fd5c3608302051a1',
        id: 'movie_3',
      ),
      MovieItem(
        title: 'Dune',
        imageUrl:
            'https://img.freepik.com/foto-gratis/abstracto-lujo-plano-borroso-gris-negro-gradiente-utilizado-como-pared-estudio-fondo-mostrar-sus-productos_1258-101806.jpg?t=st=1770232643~exp=1770236243~hmac=3609abae0072ff030394bdd554e53da3857969388a5dd856fd5c3608302051a1',
        id: 'movie_3',
      ),
      MovieItem(
        title: 'Dune',
        imageUrl:
            'https://img.freepik.com/foto-gratis/abstracto-lujo-plano-borroso-gris-negro-gradiente-utilizado-como-pared-estudio-fondo-mostrar-sus-productos_1258-101806.jpg?t=st=1770232643~exp=1770236243~hmac=3609abae0072ff030394bdd554e53da3857969388a5dd856fd5c3608302051a1',
        id: 'movie_3',
      ),
      MovieItem(
        title: 'Dune',
        imageUrl:
            'https://img.freepik.com/foto-gratis/abstracto-lujo-plano-borroso-gris-negro-gradiente-utilizado-como-pared-estudio-fondo-mostrar-sus-productos_1258-101806.jpg?t=st=1770232643~exp=1770236243~hmac=3609abae0072ff030394bdd554e53da3857969388a5dd856fd5c3608302051a1',
        id: 'movie_3',
      ),
    ];

    final List<MovieItem> topRatedMovies = [
      MovieItem(
        title: 'Inception',
        imageUrl:
            'https://img.freepik.com/foto-gratis/abstracto-lujo-plano-borroso-gris-negro-gradiente-utilizado-como-pared-estudio-fondo-mostrar-sus-productos_1258-101806.jpg?t=st=1770232643~exp=1770236243~hmac=3609abae0072ff030394bdd554e53da3857969388a5dd856fd5c3608302051a1',
        id: 'movie_4',
      ),
      MovieItem(
        title: 'Interstellar',
        imageUrl:
            'https://img.freepik.com/foto-gratis/abstracto-lujo-plano-borroso-gris-negro-gradiente-utilizado-como-pared-estudio-fondo-mostrar-sus-productos_1258-101806.jpg?t=st=1770232643~exp=1770236243~hmac=3609abae0072ff030394bdd554e53da3857969388a5dd856fd5c3608302051a1',
        id: 'movie_5',
      ),
      MovieItem(
        title: 'The Dark Knight',
        imageUrl:
            'https://img.freepik.com/foto-gratis/abstracto-lujo-plano-borroso-gris-negro-gradiente-utilizado-como-pared-estudio-fondo-mostrar-sus-productos_1258-101806.jpg?t=st=1770232643~exp=1770236243~hmac=3609abae0072ff030394bdd554e53da3857969388a5dd856fd5c3608302051a1',
        id: 'movie_6',
      ),
    ];

    final List<MovieItem> popularMovies = [
      MovieItem(
        title: 'John Wick 4',
        imageUrl:
            'https://img.freepik.com/foto-gratis/abstracto-lujo-plano-borroso-gris-negro-gradiente-utilizado-como-pared-estudio-fondo-mostrar-sus-productos_1258-101806.jpg?t=st=1770232643~exp=1770236243~hmac=3609abae0072ff030394bdd554e53da3857969388a5dd856fd5c3608302051a1',
        id: 'movie_7',
      ),
      MovieItem(
        title: 'Avatar 2',
        imageUrl:
            'https://img.freepik.com/foto-gratis/abstracto-lujo-plano-borroso-gris-negro-gradiente-utilizado-como-pared-estudio-fondo-mostrar-sus-productos_1258-101806.jpg?t=st=1770232643~exp=1770236243~hmac=3609abae0072ff030394bdd554e53da3857969388a5dd856fd5c3608302051a1',
        id: 'movie_8',
      ),
      MovieItem(
        title: 'Spider-Man',
        imageUrl:
            'https://img.freepik.com/foto-gratis/abstracto-lujo-plano-borroso-gris-negro-gradiente-utilizado-como-pared-estudio-fondo-mostrar-sus-productos_1258-101806.jpg?t=st=1770232643~exp=1770236243~hmac=3609abae0072ff030394bdd554e53da3857969388a5dd856fd5c3608302051a1',
        id: 'movie_9',
      ),
    ];

    return Background(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/logo/logo_extracted.png', height: 100),
            SizedBox(height: 20),
            CineSearchBar(onChanged: (v) {}, onSubmitted: (v) {}),
            //Secciones
            MovieListSection(title: 'Últimos Estrenos', items: latestMovies),
            GlowSeparator(),
            MovieListSection(title: 'Más Valoradas', items: topRatedMovies),
            GlowSeparator(),
            MovieListSection(title: 'Populares', items: popularMovies),
          ],
        ),
      ),
    );
  }
}
