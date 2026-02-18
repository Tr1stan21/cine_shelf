import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cine_shelf/shared/config/theme.dart';
import 'package:cine_shelf/router/app_router.dart';
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
    // ✅ CORRECT PATTERN: ref.listen() in build for managing side effects
    //
    // Why this is safe and correct:
    // - Riverpod automatically deduplicates listeners: the callback is registered only once
    //   even if build() is called multiple times (e.g., during hot reload or parent rebuilds)
    // - Listeners are automatically cleaned up when the widget is disposed
    // - This is the idiomatic Riverpod pattern for reacting to state changes
    //
    // When build() runs multiple times:
    // 1. First time: listener is registered
    // 2. Subsequent times: Riverpod detects the same listener, no duplicate is added
    // 3. Disposal: cleaned up automatically by Framework's lifecycle
    //
    // Alternative patterns and their trade-offs:
    // - .select(): Used when you only care about specific fields, not the entire AsyncValue
    //   Not needed here since we handle the entire auth state flow
    // - useEffect() (from flutter_hooks): Would require ConsumerHookWidget wrapper
    //   Unnecessary complexity for this simple side effect
    // - Navigator callback: Similar to ref.listen(), but less declarative
    //
    // Reference: https://riverpod.dev/docs/essentials/side_effects/
    ref.listen<AsyncValue<User?>>(authStateProvider, (previous, next) {
      _handleAuthChange(next);
    });

    final router = ref.read(goRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: App._appTitle,
      theme: buildCineTheme(),
      routerConfig: router,
    );
  }
}
