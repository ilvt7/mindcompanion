import 'package:flutter/material.dart';
import '../config/settings_transition_config.dart';

/// Wrapper para elementos de texto con animación de micro-bounce
class AnimatedTextWrapper extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final double scaleStart;
  final double scaleEnd;
  final double opacityStart;
  final double opacityEnd;

  const AnimatedTextWrapper({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOutBack,
    this.scaleStart = 0.8,
    this.scaleEnd = 1.0,
    this.opacityStart = 0.0,
    this.opacityEnd = 1.0,
  });

  @override
  State<AnimatedTextWrapper> createState() => _AnimatedTextWrapperState();
}

class _AnimatedTextWrapperState extends State<AnimatedTextWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: widget.scaleStart,
      end: widget.scaleEnd,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _opacityAnimation = Tween<double>(
      begin: widget.opacityStart,
      end: widget.opacityEnd,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    // Iniciar animación con delay
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// Wrapper para botones con animación de micro-bounce
class AnimatedButtonWrapper extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final double scaleStart;
  final double scaleEnd;
  final double opacityStart;
  final double opacityEnd;

  const AnimatedButtonWrapper({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOutBack,
    this.scaleStart = 0.6,
    this.scaleEnd = 1.0,
    this.opacityStart = 0.0,
    this.opacityEnd = 1.0,
  });

  @override
  State<AnimatedButtonWrapper> createState() => _AnimatedButtonWrapperState();
}

class _AnimatedButtonWrapperState extends State<AnimatedButtonWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: widget.scaleStart,
      end: widget.scaleEnd,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _opacityAnimation = Tween<double>(
      begin: widget.opacityStart,
      end: widget.opacityEnd,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    // Iniciar animación con delay
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// Wrapper para switches y controles con animación
class AnimatedControlWrapper extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final double scaleStart;
  final double scaleEnd;
  final double opacityStart;
  final double opacityEnd;

  const AnimatedControlWrapper({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.easeOutBack,
    this.scaleStart = 0.8,
    this.scaleEnd = 1.0,
    this.opacityStart = 0.0,
    this.opacityEnd = 1.0,
  });

  @override
  State<AnimatedControlWrapper> createState() => _AnimatedControlWrapperState();
}

class _AnimatedControlWrapperState extends State<AnimatedControlWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: widget.scaleStart,
      end: widget.scaleEnd,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _opacityAnimation = Tween<double>(
      begin: widget.opacityStart,
      end: widget.opacityEnd,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    // Iniciar animación con delay
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// Wrapper principal para pantallas de configuración con animaciones secuenciales
class SettingsScreenWrapper extends StatefulWidget {
  final Widget child;
  final SettingsTransitionSettings settings;

  const SettingsScreenWrapper({
    super.key,
    required this.child,
    this.settings = SettingsTransitionSettings.smooth,
  });

  @override
  State<SettingsScreenWrapper> createState() => _SettingsScreenWrapperState();
}

class _SettingsScreenWrapperState extends State<SettingsScreenWrapper>
    with TickerProviderStateMixin {
  late AnimationController _titleController;
  late AnimationController _subtitleController;
  late AnimationController _buttonsController;
  late AnimationController _controlsController;

  late Animation<double> _titleScale;
  late Animation<double> _titleOpacity;
  late Animation<double> _subtitleScale;
  late Animation<double> _subtitleOpacity;
  late Animation<double> _buttonsScale;
  late Animation<double> _buttonsOpacity;
  late Animation<double> _controlsScale;
  late Animation<double> _controlsOpacity;

  @override
  void initState() {
    super.initState();
    
    _titleController = AnimationController(
      duration: SettingsElementsConfig.titleAnimationDuration,
      vsync: this,
    );
    
    _subtitleController = AnimationController(
      duration: SettingsElementsConfig.subtitleAnimationDuration,
      vsync: this,
    );
    
    _buttonsController = AnimationController(
      duration: SettingsElementsConfig.buttonAnimationDuration,
      vsync: this,
    );
    
    _controlsController = AnimationController(
      duration: SettingsElementsConfig.controlAnimationDuration,
      vsync: this,
    );

    // Configurar animaciones
    _titleScale = Tween<double>(
      begin: SettingsElementsConfig.titleScaleStart,
      end: SettingsElementsConfig.titleScaleEnd,
    ).animate(CurvedAnimation(
      parent: _titleController,
      curve: widget.settings.elementsCurve,
    ));

    _titleOpacity = Tween<double>(
      begin: SettingsElementsConfig.titleOpacityStart,
      end: SettingsElementsConfig.titleOpacityEnd,
    ).animate(CurvedAnimation(
      parent: _titleController,
      curve: widget.settings.elementsCurve,
    ));

    _subtitleScale = Tween<double>(
      begin: SettingsElementsConfig.subtitleScaleStart,
      end: SettingsElementsConfig.subtitleScaleEnd,
    ).animate(CurvedAnimation(
      parent: _subtitleController,
      curve: widget.settings.elementsCurve,
    ));

    _subtitleOpacity = Tween<double>(
      begin: SettingsElementsConfig.subtitleOpacityStart,
      end: SettingsElementsConfig.subtitleOpacityEnd,
    ).animate(CurvedAnimation(
      parent: _subtitleController,
      curve: widget.settings.elementsCurve,
    ));

    _buttonsScale = Tween<double>(
      begin: SettingsElementsConfig.buttonScaleStart,
      end: SettingsElementsConfig.buttonScaleEnd,
    ).animate(CurvedAnimation(
      parent: _buttonsController,
      curve: widget.settings.elementsCurve,
    ));

    _buttonsOpacity = Tween<double>(
      begin: SettingsElementsConfig.buttonOpacityStart,
      end: SettingsElementsConfig.buttonOpacityEnd,
    ).animate(CurvedAnimation(
      parent: _buttonsController,
      curve: widget.settings.elementsCurve,
    ));

    _controlsScale = Tween<double>(
      begin: SettingsElementsConfig.controlScaleStart,
      end: SettingsElementsConfig.controlScaleEnd,
    ).animate(CurvedAnimation(
      parent: _controlsController,
      curve: widget.settings.elementsCurve,
    ));

    _controlsOpacity = Tween<double>(
      begin: SettingsElementsConfig.controlOpacityStart,
      end: SettingsElementsConfig.controlOpacityEnd,
    ).animate(CurvedAnimation(
      parent: _controlsController,
      curve: widget.settings.elementsCurve,
    ));

    _startSequentialAnimations();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _buttonsController.dispose();
    _controlsController.dispose();
    super.dispose();
  }

  void _startSequentialAnimations() {
    // Título
    Future.delayed(SettingsElementsConfig.elementDelays[0], () {
      if (mounted) _titleController.forward();
    });

    // Subtítulos
    Future.delayed(SettingsElementsConfig.elementDelays[1], () {
      if (mounted) _subtitleController.forward();
    });

    // Botones
    Future.delayed(SettingsElementsConfig.elementDelays[3], () {
      if (mounted) _buttonsController.forward();
    });

    // Controles
    Future.delayed(SettingsElementsConfig.elementDelays[8], () {
      if (mounted) _controlsController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Coordinador principal para la transición de configuración
class SettingsTransitionCoordinator extends StatelessWidget {
  final Widget homeScreen;
  final Widget settingsScreen;
  final SettingsTransitionSettings settings;

  const SettingsTransitionCoordinator({
    super.key,
    required this.homeScreen,
    required this.settingsScreen,
    this.settings = SettingsTransitionSettings.smooth,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // HomeScreen con fade-out
        homeScreen,
        
        // SettingsScreen con fade-in desde abajo y micro-bounce
        settingsScreen,
      ],
    );
  }
}
