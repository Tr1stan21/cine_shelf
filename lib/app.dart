import 'package:flutter/material.dart';

import 'package:cine_shelf/config/theme.dart';
import 'package:cine_shelf/router/app_router.dart';

/// Punto de entrada principal de la aplicación CineShelf
///
/// Configura el MaterialApp con theme, router y configuraciones globales.
class App extends StatelessWidget {
  const App({super.key});

  static const String _appTitle = 'CineShelf';

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: _appTitle,
      theme: buildCineTheme(),
      routerConfig: AppRouter.router,
    );
  }
}
