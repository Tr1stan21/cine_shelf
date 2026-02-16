import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cine_shelf/shared/config/theme.dart';
import 'package:cine_shelf/router/app_router.dart';
import 'package:cine_shelf/router/auth_state_notifier.dart';
import 'package:cine_shelf/router/splash_gate_notifier.dart';
import 'package:cine_shelf/features/auth/application/auth_providers.dart';

/// Main entry point of the CineShelf application
///
/// Configures the MaterialApp with theme, router, and global settings.
/// Uses ConsumerWidget to access auth state notifier for router reactivity.
class App extends ConsumerStatefulWidget {
  const App({super.key});

  static const String _appTitle = 'CineShelf';

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  static const Duration _splashMinDelay = Duration(milliseconds: 800);
  bool _hasInitializedAuth = false;
  bool _wasAuthenticated = false;

  void _handleAuthChange(AsyncValue<User?> next) {
    final authData = next.asData;
    if (authData == null) {
      return;
    }

    final user = authData.value;
    final isAuthenticated = user != null;
    final splashGate = ref.read(splashGateNotifierProvider);

    if (!_hasInitializedAuth) {
      _hasInitializedAuth = true;
      splashGate.runGate(minDelay: _splashMinDelay);
      _wasAuthenticated = isAuthenticated;
      return;
    }

    if (!_wasAuthenticated && isAuthenticated) {
      splashGate.runGate(minDelay: _splashMinDelay);
    }

    _wasAuthenticated = isAuthenticated;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<User?>>(authStateProvider, (previous, next) {
      _handleAuthChange(next);
    });

    final authNotifier = ref.watch(authStateNotifierProvider);
    final splashGate = ref.watch(splashGateNotifierProvider);
    final router = AppRouter.createRouter(authNotifier, splashGate);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: App._appTitle,
      theme: buildCineTheme(),
      routerConfig: router,
    );
  }
}
