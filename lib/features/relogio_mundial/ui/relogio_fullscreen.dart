import 'dart:math';
import 'package:flutter/material.dart';

class RelogioFullscreen extends StatefulWidget {
  final String hora;

  const RelogioFullscreen({super.key, required this.hora});

  @override
  State<RelogioFullscreen> createState() => _RelogioFullscreenState();
}

class _RelogioFullscreenState extends State<RelogioFullscreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _angleAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Controlador com duração longa para suavidade
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat(reverse: false); // loop contínuo

    // Movimento circular (ângulo de 0 a 2π)
    _angleAnimation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    // Opacidade suave (0.85 a 1)
    _opacityAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutSine,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // Raio do movimento circular
            const double radius = 20;

            final dx = radius * cos(_angleAnimation.value);
            final dy = radius * sin(_angleAnimation.value);

            return Center(
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: Transform.translate(
                  offset: Offset(dx, dy),
                  child: Text(
                    widget.hora,
                    style: const TextStyle(
                      fontFamily: 'Digital', // ou 'RobotoMono', se não baixou fonte ainda
                      fontSize: 120,
                      color: Color.fromARGB(255, 255, 80, 80),
                      fontWeight: FontWeight.w300,
                      letterSpacing: 6,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
