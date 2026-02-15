import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cine_shelf/shared/config/constants.dart';
import 'package:cine_shelf/shared/widgets/background.dart';
import 'package:cine_shelf/features/auth/application/auth_providers.dart';

/// Splash screen - Entry point that determines navigation based on auth state.
///
/// Uses ref.watch() within build() to listen to auth state changes.
/// Navigates to either:
/// - /login if not authenticated
/// - /home if authenticated
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _hasNavigated = false;

  @override
  Widget build(BuildContext context) {
    // Store router reference to use outside async context
    final router = GoRouter.of(context);

    // Watch auth state - this triggers rebuild on changes
    // ref.listen() must be called within build()
    ref.listen<AsyncValue<Object?>>(authStateProvider, (previous, next) {
      // Only handle data state
      next.whenData((user) {
        // Prevent multiple navigation attempts
        if (_hasNavigated) return;
        _hasNavigated = true;

        // Small delay for better UX (show splash briefly)
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!mounted) return;

          final isLoggedIn = user != null;
          if (isLoggedIn) {
            router.go('/home');
          } else {
            router.go('/login');
          }
        });
      });
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
