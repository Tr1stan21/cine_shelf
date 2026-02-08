import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cine_shelf/shared/config/constants.dart';
import 'package:cine_shelf/shared/widgets/background.dart';

/// Initial welcome screen of the application
///
/// Displays the CineShelf logo for [_splashDuration]
/// and then automatically navigates to the login screen.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const Duration _splashDuration = Duration(seconds: 1);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(SplashScreen._splashDuration, () {
      if (!mounted) return;
      context.go('/login');
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Center(child: Image.asset(AppConstants.logoPath, height: 300)),
    );
  }
}
