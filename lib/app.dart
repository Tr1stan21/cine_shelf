import 'package:flutter/material.dart';

import 'package:cine_shelf/shared/config/theme.dart';
import 'package:cine_shelf/router/app_router.dart';

/// Main entry point of the CineShelf application
///
/// Configures the MaterialApp with theme, router, and global settings.
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
