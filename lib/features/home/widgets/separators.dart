import 'package:flutter/material.dart';

/// Separador visual con efecto de brillo dorado/naranja
///
/// Componente decorativo que simula una línea luminosa con gradientes
/// y efectos de glow. Usado para separar secciones de contenido.
class GlowSeparator extends StatelessWidget {
  const GlowSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 72,
      width: double.infinity,
      child: CustomPaint(painter: _GlowSeparatorPainter()),
    );
  }
}

/// Painter personalizado que dibuja el efecto de glow del separador
class _GlowSeparatorPainter extends CustomPainter {
  const _GlowSeparatorPainter();

  // Colores específicos del separador
  static const Color _deep = Color(0xFF4A1E0C);
  static const Color _edge = Color(0xFF7D3410);
  static const Color _amberGlow = Color(0xFFC45A14);
  static const Color _orange = Color(0xFFFF8A22);
  static const Color _goldGlow = Color(0xFFFFC168);
  static const Color _whiteHot = Color(0xFFFFF2D9);

  static const List<double> _wideStops = [
    0.0,
    0.06,
    0.28,
    0.5,
    0.72,
    0.94,
    1.0,
  ];

  static const List<double> _coreStops = [0.0, 0.45, 0.5, 0.55, 1.0];

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    if (width <= 0 || height <= 0) return;

    final centerY = height / 2;
    final center = Offset(width / 2, centerY);

    _drawLineLayer(
      canvas,
      size,
      centerY: centerY,
      strokeWidth: height * 0.22,
      blurSigma: height * 0.34,
      opacity: 0.16,
      colors: const [
        Colors.transparent,
        _deep,
        _edge,
        _amberGlow,
        _edge,
        _deep,
        Colors.transparent,
      ],
      stops: _wideStops,
    );

    _drawLineLayer(
      canvas,
      size,
      centerY: centerY,
      strokeWidth: height * 0.12,
      blurSigma: height * 0.2,
      opacity: 0.32,
      colors: const [
        Colors.transparent,
        _edge,
        _amberGlow,
        _orange,
        _amberGlow,
        _edge,
        Colors.transparent,
      ],
      stops: _wideStops,
    );

    _drawLineLayer(
      canvas,
      size,
      centerY: centerY,
      strokeWidth: height * 0.065,
      blurSigma: height * 0.12,
      opacity: 0.52,
      colors: const [
        Colors.transparent,
        _amberGlow,
        _orange,
        _goldGlow,
        _orange,
        _amberGlow,
        Colors.transparent,
      ],
      stops: _wideStops,
    );

    _drawHotspot(
      canvas,
      center: center,
      width: _cap(width * 0.3, height * 7.0),
      height: height * 0.32,
      blurSigma: height * 0.14,
      opacity: 0.62,
      colors: const [
        Color(0xFFFFF0C8),
        Color(0xFFFFC76E),
        Color(0xFFFF8F2E),
        Colors.transparent,
      ],
      stops: const [0.0, 0.35, 0.65, 1.0],
    );

    _drawLineLayer(
      canvas,
      size,
      centerY: centerY,
      strokeWidth: height * 0.022,
      blurSigma: height * 0.035,
      opacity: 0.92,
      colors: const [
        Colors.transparent,
        _orange,
        _goldGlow,
        _whiteHot,
        _goldGlow,
        _orange,
        Colors.transparent,
      ],
      stops: _wideStops,
      blendMode: BlendMode.plus,
    );

    _drawHotspot(
      canvas,
      center: center,
      width: _cap(width * 0.14, height * 3.0),
      height: height * 0.14,
      blurSigma: height * 0.05,
      opacity: 0.9,
      colors: const [Color(0xFFFFFFFF), Color(0xFFFFE2A0), Colors.transparent],
      stops: const [0.0, 0.62, 1.0],
    );

    _drawLineLayer(
      canvas,
      size,
      centerY: centerY,
      strokeWidth: height * 0.01,
      blurSigma: height * 0.012,
      opacity: 0.78,
      colors: const [
        Colors.transparent,
        _goldGlow,
        _whiteHot,
        _goldGlow,
        Colors.transparent,
      ],
      stops: _coreStops,
      blendMode: BlendMode.plus,
    );
  }

  void _drawLineLayer(
    Canvas canvas,
    Size size, {
    required double centerY,
    required double strokeWidth,
    required double blurSigma,
    required double opacity,
    required List<Color> colors,
    required List<double> stops,
    BlendMode blendMode = BlendMode.srcOver,
  }) {
    final rect = Rect.fromLTWH(
      0,
      centerY - strokeWidth / 2,
      size.width,
      strokeWidth,
    );

    final paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = strokeWidth
      ..blendMode = blendMode
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: _withOpacity(colors, opacity),
        stops: stops,
      ).createShader(rect);

    if (blurSigma > 0) {
      paint.maskFilter = MaskFilter.blur(BlurStyle.normal, blurSigma);
    }

    canvas.drawLine(Offset(0, centerY), Offset(size.width, centerY), paint);
  }

  void _drawHotspot(
    Canvas canvas, {
    required Offset center,
    required double width,
    required double height,
    required double blurSigma,
    required double opacity,
    required List<Color> colors,
    required List<double> stops,
  }) {
    final rect = Rect.fromCenter(center: center, width: width, height: height);
    final paint = Paint()
      ..isAntiAlias = true
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 0.85,
        colors: _withOpacity(colors, opacity),
        stops: stops,
      ).createShader(rect);

    if (blurSigma > 0) {
      paint.maskFilter = MaskFilter.blur(BlurStyle.normal, blurSigma);
    }

    canvas.drawOval(rect, paint);
  }

  List<Color> _withOpacity(List<Color> colors, double opacity) {
    return colors
        .map((color) => color.withValues(alpha: _clamp01(color.a * opacity)))
        .toList(growable: false);
  }

  double _clamp01(double value) {
    if (value <= 0) return 0;
    if (value >= 1) return 1;
    return value;
  }

  double _cap(double value, double max) {
    return value > max ? max : value;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
