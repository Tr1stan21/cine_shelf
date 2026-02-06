import 'package:cine_shelf/widgets/btn_movie_details.dart';
import 'package:flutter/material.dart';

class MovieDetails extends StatelessWidget {
  const MovieDetails({super.key});

  static const _amber = Color(0xFFFFB000);
  static const _topImageUrl =
      'https://img.freepik.com/foto-gratis/abstracto-lujo-plano-borroso-gris-negro-gradiente-utilizado-como-pared-estudio-fondo-mostrar-sus-productos_1258-101806.jpg?t=st=1770232643~exp=1770236243~hmac=3609abae0072ff030394bdd554e53da3857969388a5dd856fd5c3608302051a1';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    const overlap = 26.0;
    final panelHeight = size.height * 0.44;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height - panelHeight + overlap,
              width: double.infinity,
              child: Image.network(_topImageUrl, fit: BoxFit.cover),
            ),
            SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color.fromARGB(255, 42, 28, 20),
                      const Color(0xFA0D0B0A),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 2),
                    const Text(
                      'Blade Runner 2049',
                      style: TextStyle(
                        color: _amber,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '2017',
                            style: TextStyle(
                              color: _amber,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: '  |  Ciencia ficción, Drama, Misterio',
                            style: TextStyle(
                              color: Color(0xFFB7A59A),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Un nuevo blade runner, el oficial K de la policía de\n'
                      'Los Ángeles, descubre un secreto largamente oculto\n'
                      'que tiene el potencial de sumir lo que queda de la\n'
                      'sociedad en el caos.Un nuevo blade runner, el oficial K de la policía de\n'
                      'Los Ángeles, descubre un secreto largamente oculto\n'
                      'que tiene el potencial de sumir lo que queda de la\n'
                      'sociedad en el caos.Un nuevo blade runner, el oficial K de la policía de\n'
                      'Los Ángeles, descubre un secreto largamente oculto\n'
                      'que tiene el potencial de sumir lo que queda de la\n'
                      'sociedad en el caos.',
                      style: TextStyle(
                        color: Color(0xFFD6D1CD),
                        fontSize: 14,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: List.generate(
                        5,
                        (_) => const Padding(
                          padding: EdgeInsets.only(right: 6),
                          child: Icon(Icons.star, size: 22, color: _amber),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Row(
                      children: [
                        Expanded(
                          child: BtnMovieDetails(
                            label: 'Favorito',
                            icon: Icons.favorite,
                            backgroundColor: Color(0xFFB56610),
                            foregroundColor: Colors.white,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: BtnMovieDetails(
                            label: 'Watchlist',
                            icon: Icons.access_time_rounded,
                            outlined: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Row(
                      children: [
                        Expanded(
                          child: BtnMovieDetails(
                            label: 'Visto',
                            icon: Icons.check_rounded,
                            backgroundColor: Color(0xFF7A3E07),
                            foregroundColor: _amber,
                            trailingIcon: Icons.check_rounded,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: BtnMovieDetails(
                            label: 'Lista...',
                            icon: Icons.add,
                            outlined: true,
                            trailingIcon: Icons.chevron_right_rounded,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
