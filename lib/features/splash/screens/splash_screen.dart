import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cine_shelf/shared/config/constants.dart';
import 'package:cine_shelf/shared/widgets/background.dart';
import 'package:cine_shelf/features/auth/application/auth_providers.dart';
import 'package:cine_shelf/features/lists/application/list_providers.dart';

/// Splash screen - Loading screen shown during app initialization and after login.
///
/// Displays logo and loading indicator for minimum duration (UX),
/// then navigates based on auth state once determined.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _hasNavigated = false;
  bool _minDelayComplete = false;

  @override
  void initState() {
    super.initState();
    // Minimum display time for splash (better UX)
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => _minDelayComplete = true);
        _attemptNavigation();
      }
    });
  }

  void _attemptNavigation() {
    if (_hasNavigated || !_minDelayComplete) return;

    final authState = ref.read(authStateProvider);

    authState.whenData((user) {
      if (_hasNavigated || !mounted) return;
      _hasNavigated = true;

      if (user != null) {
        // PRECARGA: Dispara carga de datos sin bloquear navegación
        _preloadUserData();
        context.go('/home');
      } else {
        context.go('/login');
      }
    });
  }

  void _preloadUserData() {
    // Lectura imperativa (no reactiva) que inicia carga en background
    ref.read(currentUserProvider.future).ignore();
    ref.read(watchedCountProvider.future).ignore();
    ref.read(watchlistCountProvider.future).ignore();
    ref.read(favoritesCountProvider.future).ignore();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to auth state changes to trigger navigation
    ref.listen<AsyncValue<Object?>>(authStateProvider, (_, __) {
      _attemptNavigation();
    });

    return Background(
      child: Align(
        alignment: const Alignment(0, -0.3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppConstants.logoPath, height: 100),
            const SizedBox(height: 24),
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD4AF6A)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
