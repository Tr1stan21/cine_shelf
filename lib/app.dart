import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cine_shelf/shared/config/theme.dart';
import 'package:cine_shelf/router/app_router.dart';
import 'package:cine_shelf/router/auth_state_notifier.dart';

/// Main entry point of the CineShelf application
///
/// Configures the MaterialApp with theme, router, and global settings.
/// Uses ConsumerWidget to access auth state notifier for router reactivity.
class App extends ConsumerWidget {
  const App({super.key});

  static const String _appTitle = 'CineShelf';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authStateNotifierProvider);
    final router = AppRouter.createRouter(authNotifier);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: _appTitle,
      theme: buildCineTheme(),
      routerConfig: router,
    );
  }
}
