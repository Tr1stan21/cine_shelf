import 'package:cine_shelf/mock/movie_data.dart';
import 'package:cine_shelf/widgets/separator.dart';
import 'package:flutter/material.dart';
import 'package:cine_shelf/widgets/background.dart';
import 'package:cine_shelf/widgets/search_bar.dart';
import 'package:cine_shelf/widgets/movie_section.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Background(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/logo/logo_extracted.png', height: 100),
            SizedBox(height: 20),
            CineSearchBar(onChanged: (v) {}, onSubmitted: (v) {}),
            //Secciones
            MovieListSection(title: 'Últimos Estrenos', items: MovieData.m),
            GlowSeparator(),
            MovieListSection(title: 'Más Valoradas', items: MovieData.s),
            GlowSeparator(),
            MovieListSection(title: 'Populares', items: MovieData.s),
          ],
        ),
      ),
    );
  }
}
