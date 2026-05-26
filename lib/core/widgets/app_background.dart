import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF8AD4F5), // Azul clarinho do topo
            Color(0xFFE8F1D7), // Verde/Amarelado claro da base
          ],
          stops: [0.0, 0.8], // Controla onde o degradê se mistura
        ),
      ),
      child: child,
    );
  }
}
