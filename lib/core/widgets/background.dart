import 'package:flutter/material.dart';
import 'package:cine_shelf/core/constants.dart';

/// Widget de fondo global para todas las pantallas
///
/// Proporciona un fondo consistente con la imagen de marca
/// y un SafeArea con padding configurable para el contenido.
class Background extends StatelessWidget {
  const Background({
    required this.child,
    this.padding = EdgeInsets.zero,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo global
          Image.asset(AppConstants.background, fit: BoxFit.cover),
          SafeArea(
            child: Padding(padding: padding, child: child),
          ),
        ],
      ),
    );
  }
}
