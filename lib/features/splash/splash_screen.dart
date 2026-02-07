import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cine_shelf/core/constants.dart';
import 'package:cine_shelf/core/widgets/background.dart';

/// Pantalla de bienvenida inicial de la aplicación
///
/// Muestra el logo de CineShelf durante [_splashDuration]
/// y luego navega automáticamente a la pantalla de login.
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
