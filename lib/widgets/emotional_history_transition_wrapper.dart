import 'package:flutter/material.dart';
import '../config/emotional_history_transition_config.dart';

/// Wrapper widget para transiciones del historial emocional que coordina
/// las animaciones secuenciales del calendario y la lista de entradas
class EmotionalHistoryTransitionWrapper extends StatefulWidget {
  final Widget child;
  final bool isTransitioning;
  final VoidCallback? onTransitionComplete;
  final Duration? transitionDuration;

  const EmotionalHistoryTransitionWrapper({
    super.key,
    required this.child,
    this.isTransitioning = false,
    this.onTransitionComplete,
    this.transitionDuration,
  });

  @override
  State<EmotionalHistoryTransitionWrapper> createState() => _EmotionalHistoryTransitionWrapperState();
}

class _EmotionalHistoryTransitionWrapperState extends State<EmotionalHistoryTransitionWrapper>
    with TickerProviderStateMixin {
  late AnimationController _calendarController;
  late AnimationController _entriesController;
  late AnimationController _overallController;
  
  late Animation<double> _calendarFade;
  late Animation<double> _entriesFade;
  late Animation<double> _overallAnimation;

  @override
  void initState() {
    super.initState();
    
    // Controller para el calendario
    _calendarController = AnimationController(
      duration: widget.transitionDuration ?? EmotionalHistoryTransitionConfig.calendarFadeDuration,
      vsync: this,
    );
    
    // Controller para las entradas
    _entriesController = AnimationController(
      duration: EmotionalHistoryTransitionConfig.entriesFadeDuration,
      vsync: this,
    );
    
    // Controller para la animación general
    _overallController = AnimationController(
      duration: EmotionalHistoryTransitionConfig.totalTransitionDuration,
      vsync: this,
    );
    
    // Animación de fade para el calendario
    _calendarFade = Tween<double>(
      begin: EmotionalHistoryTransitionConfig.calendarFadeStart,
      end: EmotionalHistoryTransitionConfig.calendarFadeEnd,
    ).animate(CurvedAnimation(
      parent: _calendarController,
      curve: EmotionalHistoryTransitionConfig.calendarFadeCurve,
    ));
    
    // Animación de fade para las entradas
    _entriesFade = Tween<double>(
      begin: EmotionalHistoryTransitionConfig.entriesFadeStart,
      end: EmotionalHistoryTransitionConfig.entriesFadeEnd,
    ).animate(CurvedAnimation(
      parent: _entriesController,
      curve: EmotionalHistoryTransitionConfig.entriesFadeCurve,
    ));
    
    // Animación general para coordinar todo
    _overallAnimation = CurvedAnimation(
      parent: _overallController,
      curve: EmotionalHistoryTransitionConfig.overallCurve,
    );
    
    if (widget.isTransitioning) {
      _startSequentialAnimations();
    }
  }

  @override
  void didUpdateWidget(EmotionalHistoryTransitionWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isTransitioning && !oldWidget.isTransitioning) {
      _startSequentialAnimations();
    } else if (!widget.isTransitioning && oldWidget.isTransitioning) {
      _reverseSequentialAnimations();
    }
  }

  @override
  void dispose() {
    _calendarController.dispose();
    _entriesController.dispose();
    _overallController.dispose();
    super.dispose();
  }

  void _startSequentialAnimations() {
    // Secuencia de animaciones secuenciales
    Future.delayed(EmotionalHistoryTransitionConfig.calendarStartDelay, () {
      if (mounted) {
        _calendarController.forward();
      }
    });
    
    Future.delayed(EmotionalHistoryTransitionConfig.entriesStartDelay, () {
      if (mounted) {
        _entriesController.forward();
      }
    });
    
    // Iniciar animación general
    _overallController.forward();
    
    // Notificar cuando la transición esté completa
    Future.delayed(EmotionalHistoryTransitionConfig.totalTransitionDuration, () {
      widget.onTransitionComplete?.call();
    });
  }

  void _reverseSequentialAnimations() {
    // Revertir animaciones en orden inverso
    _entriesController.reverse();
    _calendarController.reverse();
    _overallController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _calendarController,
        _entriesController,
        _overallController,
      ]),
      builder: (context, child) {
        return child!;
      },
      child: widget.child,
    );
  }
}

/// Widget para envolver el calendario con animación de fade-in
class CalendarFadeWrapper extends StatefulWidget {
  final Widget child;
  final bool isTransitioning;
  final Duration? transitionDuration;

  const CalendarFadeWrapper({
    super.key,
    required this.child,
    this.isTransitioning = false,
    this.transitionDuration,
  });

  @override
  State<CalendarFadeWrapper> createState() => _CalendarFadeWrapperState();
}

class _CalendarFadeWrapperState extends State<CalendarFadeWrapper>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: widget.transitionDuration ?? EmotionalHistoryTransitionConfig.calendarFadeDuration,
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: EmotionalHistoryTransitionConfig.calendarFadeStart,
      end: EmotionalHistoryTransitionConfig.calendarFadeEnd,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: EmotionalHistoryTransitionConfig.calendarFadeCurve,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: EmotionalHistoryTransitionConfig.calendarScaleStart,
      end: EmotionalHistoryTransitionConfig.calendarScaleEnd,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: EmotionalHistoryTransitionConfig.calendarScaleCurve,
    ));
    
    if (widget.isTransitioning) {
      _startAnimation();
    }
  }

  @override
  void didUpdateWidget(CalendarFadeWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isTransitioning && !oldWidget.isTransitioning) {
      _startAnimation();
    } else if (!widget.isTransitioning && oldWidget.isTransitioning) {
      _reverseAnimation();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    _controller.forward();
  }

  void _reverseAnimation() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

/// Widget para envolver la lista de entradas con animación de fade-in secuencial
class EntriesFadeWrapper extends StatefulWidget {
  final List<Widget> children;
  final bool isTransitioning;
  final Duration? transitionDuration;

  const EntriesFadeWrapper({
    super.key,
    required this.children,
    this.isTransitioning = false,
    this.transitionDuration,
  });

  @override
  State<EntriesFadeWrapper> createState() => _EntriesFadeWrapperState();
}

class _EntriesFadeWrapperState extends State<EntriesFadeWrapper>
    with TickerProviderStateMixin {
  late List<AnimationController> _entryControllers;
  late List<Animation<double>> _entryFadeAnimations;
  late List<Animation<double>> _entrySlideAnimations;

  @override
  void initState() {
    super.initState();
    
    _entryControllers = List.generate(
      widget.children.length,
      (index) => AnimationController(
        duration: EmotionalHistoryTransitionConfig.entryIndividualDuration,
        vsync: this,
      ),
    );
    
    _entryFadeAnimations = _entryControllers.map((controller) {
      return Tween<double>(
        begin: EmotionalHistoryTransitionConfig.entryFadeStart,
        end: EmotionalHistoryTransitionConfig.entryFadeEnd,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: EmotionalHistoryTransitionConfig.entryFadeCurve,
      ));
    }).toList();
    
    _entrySlideAnimations = _entryControllers.map((controller) {
      return Tween<double>(
        begin: EmotionalHistoryTransitionConfig.entrySlideStart,
        end: EmotionalHistoryTransitionConfig.entrySlideEnd,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: EmotionalHistoryTransitionConfig.entrySlideCurve,
      ));
    }).toList();
    
    if (widget.isTransitioning) {
      _startSequentialAnimations();
    }
  }

  @override
  void didUpdateWidget(EntriesFadeWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isTransitioning && !oldWidget.isTransitioning) {
      _startSequentialAnimations();
    } else if (!widget.isTransitioning && oldWidget.isTransitioning) {
      _reverseSequentialAnimations();
    }
  }

  @override
  void dispose() {
    for (final controller in _entryControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startSequentialAnimations() {
    // Iniciar animaciones secuenciales con delays escalonados
    for (int i = 0; i < _entryControllers.length; i++) {
      Future.delayed(
        EmotionalHistoryTransitionConfig.entriesStartDelay + 
        (Duration(milliseconds: i * EmotionalHistoryTransitionConfig.entryStaggerDelay.inMilliseconds)),
        () {
          if (mounted) {
            _entryControllers[i].forward();
          }
        },
      );
    }
  }

  void _reverseSequentialAnimations() {
    // Revertir animaciones en orden inverso
    for (int i = _entryControllers.length - 1; i >= 0; i--) {
      Future.delayed(
        Duration(milliseconds: (_entryControllers.length - 1 - i) * 
        EmotionalHistoryTransitionConfig.entryStaggerDelay.inMilliseconds),
        () {
          if (mounted) {
            _entryControllers[i].reverse();
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        widget.children.length,
        (index) => AnimatedBuilder(
          animation: _entryControllers[index],
          builder: (context, child) {
            return FadeTransition(
              opacity: _entryFadeAnimations[index],
              child: Transform.translate(
                offset: Offset(0, _entrySlideAnimations[index].value),
                child: child,
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: widget.children[index],
          ),
        ),
      ),
    );
  }
}

/// Widget para coordinar la transición completa del historial emocional
class EmotionalHistoryTransitionCoordinator extends StatefulWidget {
  final Widget homeScreen;
  final Widget emotionalHistoryScreen;
  final bool showEmotionalHistory;
  final VoidCallback? onTransitionComplete;
  final Duration? transitionDuration;

  const EmotionalHistoryTransitionCoordinator({
    super.key,
    required this.homeScreen,
    required this.emotionalHistoryScreen,
    required this.showEmotionalHistory,
    this.onTransitionComplete,
    this.transitionDuration,
  });

  @override
  State<EmotionalHistoryTransitionCoordinator> createState() => _EmotionalHistoryTransitionCoordinatorState();
}

class _EmotionalHistoryTransitionCoordinatorState extends State<EmotionalHistoryTransitionCoordinator>
    with TickerProviderStateMixin {
  late AnimationController _overallController;
  late Animation<double> _overallAnimation;
  
  bool _isTransitioning = false;

  @override
  void initState() {
    super.initState();
    
    _overallController = AnimationController(
      duration: widget.transitionDuration ?? EmotionalHistoryTransitionConfig.totalTransitionDuration,
      vsync: this,
    );
    
    _overallAnimation = CurvedAnimation(
      parent: _overallController,
      curve: EmotionalHistoryTransitionConfig.overallCurve,
    );
    
    if (widget.showEmotionalHistory) {
      _startTransition();
    }
  }

  @override
  void didUpdateWidget(EmotionalHistoryTransitionCoordinator oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.showEmotionalHistory && !oldWidget.showEmotionalHistory) {
      _startTransition();
    } else if (!widget.showEmotionalHistory && oldWidget.showEmotionalHistory) {
      _reverseTransition();
    }
  }

  @override
  void dispose() {
    _overallController.dispose();
    super.dispose();
  }

  void _startTransition() {
    setState(() {
      _isTransitioning = true;
    });
    
    _overallController.forward().then((_) {
      widget.onTransitionComplete?.call();
    });
  }

  void _reverseTransition() {
    _overallController.reverse().then((_) {
      setState(() {
        _isTransitioning = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // HomeScreen con slide lateral hacia la izquierda
        AnimatedBuilder(
          animation: _overallAnimation,
          builder: (context, child) {
            final homeSlideAnimation = Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(-0.3, 0.0),
            ).animate(CurvedAnimation(
              parent: _overallAnimation,
              curve: EmotionalHistoryTransitionConfig.homeSlideCurve,
            ));
            
            final homeFadeAnimation = Tween<double>(
              begin: 1.0,
              end: 0.7,
            ).animate(CurvedAnimation(
              parent: _overallAnimation,
              curve: EmotionalHistoryTransitionConfig.homeFadeCurve,
            ));
            
            return Transform.translate(
              offset: homeSlideAnimation.value,
              child: Opacity(
                opacity: homeFadeAnimation.value,
                child: child,
              ),
            );
          },
          child: widget.homeScreen,
        ),
        
        // EmotionalHistoryScreen con slide lateral desde la derecha
        if (_isTransitioning)
          AnimatedBuilder(
            animation: _overallAnimation,
            builder: (context, child) {
              final historySlideAnimation = Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _overallAnimation,
                curve: EmotionalHistoryTransitionConfig.historySlideCurve,
              ));
              
              final historyFadeAnimation = Tween<double>(
                begin: 0.0,
                end: 1.0,
              ).animate(CurvedAnimation(
                parent: _overallAnimation,
                curve: EmotionalHistoryTransitionConfig.historyFadeCurve,
              ));
              
              return Transform.translate(
                offset: historySlideAnimation.value,
                child: FadeTransition(
                  opacity: historyFadeAnimation,
                  child: child,
                ),
              );
            },
            child: widget.emotionalHistoryScreen,
          ),
      ],
    );
  }
}

/// Widget para crear un efecto de slide lateral suave
class LateralSlideEffect extends StatelessWidget {
  final Widget child;
  final bool isActive;
  final Duration? duration;
  final Offset slideOffset;
  final Curve slideCurve;

  const LateralSlideEffect({
    super.key,
    required this.child,
    this.isActive = false,
    this.duration,
    this.slideOffset = const Offset(-0.3, 0.0),
    this.slideCurve = Curves.easeInOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration ?? EmotionalHistoryTransitionConfig.homeSlideDuration,
      curve: slideCurve,
      transform: isActive 
          ? (Matrix4.identity()..translate(slideOffset.dx, slideOffset.dy))
          : Matrix4.identity(),
      child: child,
    );
  }
}

/// Widget para crear un efecto de fade progresivo
class ProgressiveFadeEffect extends StatelessWidget {
  final Widget child;
  final bool isActive;
  final Duration? duration;
  final double fadeStart;
  final double fadeEnd;
  final Curve fadeCurve;

  const ProgressiveFadeEffect({
    super.key,
    required this.child,
    this.isActive = false,
    this.duration,
    this.fadeStart = 1.0,
    this.fadeEnd = 0.7,
    this.fadeCurve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration ?? EmotionalHistoryTransitionConfig.homeFadeDuration,
      curve: fadeCurve,
      child: Opacity(
        opacity: isActive ? fadeEnd : fadeStart,
        child: child,
      ),
    );
  }
}
