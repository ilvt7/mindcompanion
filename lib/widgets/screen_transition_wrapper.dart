import 'package:flutter/material.dart';

/// Wrapper widget que mantiene consistencia visual durante las transiciones
class ScreenTransitionWrapper extends StatelessWidget {
  final Widget child;
  final bool isTransitioning;
  final Duration transitionDuration;

  const ScreenTransitionWrapper({
    super.key,
    required this.child,
    this.isTransitioning = false,
    this.transitionDuration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: transitionDuration,
      curve: Curves.easeInOutCubic,
      decoration: BoxDecoration(
        // Mantener consistencia de colores durante la transición
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF8F9FF), // Very light blue
            Color(0xFFE6E6FA), // Lavender
          ],
        ),
        // Sombras consistentes durante la transición
        boxShadow: isTransitioning
            ? [
                BoxShadow(
                  color: const Color(0xFF87CEEB).withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}

/// Widget para mantener consistencia de sombras durante transiciones
class ConsistentShadowContainer extends StatelessWidget {
  final Widget child;
  final Color shadowColor;
  final double blurRadius;
  final Offset offset;
  final double spreadRadius;

  const ConsistentShadowContainer({
    super.key,
    required this.child,
    this.shadowColor = const Color(0xFF87CEEB),
    this.blurRadius = 20,
    this.offset = const Offset(0, 8),
    this.spreadRadius = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.15),
            blurRadius: blurRadius,
            offset: offset,
            spreadRadius: spreadRadius,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Widget para transiciones suaves de color
class SmoothColorTransition extends StatefulWidget {
  final Widget child;
  final Color startColor;
  final Color endColor;
  final Duration duration;
  final Curve curve;

  const SmoothColorTransition({
    super.key,
    required this.child,
    required this.startColor,
    required this.endColor,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOutCubic,
  });

  @override
  State<SmoothColorTransition> createState() => _SmoothColorTransitionState();
}

class _SmoothColorTransitionState extends State<SmoothColorTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _colorAnimation = ColorTween(
      begin: widget.startColor,
      end: widget.endColor,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(color: _colorAnimation.value),
          child: widget.child,
        );
      },
    );
  }
}

/// Widget para mantener consistencia de bordes redondeados
class ConsistentBorderRadius extends StatelessWidget {
  final Widget child;
  final double radius;
  final Border? border;

  const ConsistentBorderRadius({
    super.key,
    required this.child,
    this.radius = 16.0,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: border,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: child,
      ),
    );
  }
}
