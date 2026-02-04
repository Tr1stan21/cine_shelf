import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const Background({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo global
          Image.asset('assets/images/background.png', fit: BoxFit.cover),

          SafeArea(
            child: Padding(padding: padding, child: child),
          ),
        ],
      ),
    );
  }
}
