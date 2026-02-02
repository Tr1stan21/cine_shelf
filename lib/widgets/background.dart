import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Componente reutilizable que actúa como fondo para cualquier pantalla.
///
/// Compuesto por:
/// - Imagen base constante (background.png)
/// - Capa de ruido superpuesta controlada por [noisePercent]
class Background extends StatelessWidget {
  /// Intensidad del ruido en porcentaje (0-100).
  /// - 0: sin ruido visible
  /// - 100: ruido a máxima opacidad
  ///
  /// Se clampea automáticamente al rango [0, 100] para evitar valores inválidos.
  final double noisePercent;

  /// Contenido opcional a renderizar encima del fondo.
  final Widget? child;

  const Background.Background({
    super.key,
    required this.noisePercent,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Clampear noisePercent al rango [0, 100] para garantizar valores válidos
    // sin lanzar excepciones (enfoque defensivo y pragmático).
    final double clampedNoise = noisePercent.clamp(0.0, 100.0);
    final double noiseOpacity = clampedNoise / 100.0;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Imagen base constante
        // Path: assets/images/background.png (asegúrate de que exista en pubspec.yaml)
        Image.asset('assets/images/background.png', fit: BoxFit.cover),

        // Capa de ruido superpuesta
        if (noiseOpacity > 0)
          Opacity(opacity: noiseOpacity, child: const _NoiseOverlay()),

        // Contenido opcional encima del fondo
        if (child != null) child!,
      ],
    );
  }
}

/// Widget interno que genera una capa de ruido visual mediante CustomPainter.
class _NoiseOverlay extends StatelessWidget {
  const _NoiseOverlay();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _NoisePainter(),
      child: const SizedBox.expand(),
    );
  }
}

/// Painter que dibuja un patrón de ruido visual.
///
/// Genera píxeles aleatorios distribuidos uniformemente para simular
/// ruido granulado tipo película cinematográfica.
class _NoisePainter extends CustomPainter {
  _NoisePainter() : _random = math.Random(42); // Seed fijo para consistencia

  final math.Random _random;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Densidad de partículas de ruido (ajustar para balance entre rendimiento y calidad)
    const double noiseDensity = 0.3; // 30% de píxeles con ruido
    final int particleCount = (size.width * size.height * noiseDensity / 4)
        .toInt();

    for (int i = 0; i < particleCount; i++) {
      final double x = _random.nextDouble() * size.width;
      final double y = _random.nextDouble() * size.height;

      // Variación aleatoria de luminosidad (blanco/negro para ruido monocromático)
      final int brightness = _random.nextInt(256);
      paint.color = Color.fromARGB(
        _random.nextInt(100) +
            50, // Alpha variable (50-150) para textura variada
        brightness,
        brightness,
        brightness,
      );

      // Dibujar partícula de ruido (cuadrado pequeño)
      canvas.drawRect(Rect.fromLTWH(x, y, 2, 2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
