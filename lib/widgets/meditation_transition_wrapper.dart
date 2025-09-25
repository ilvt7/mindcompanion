import 'package:flutter/material.dart';
import '../config/meditation_transition_config.dart';

/// Wrapper widget para transiciones de meditaciones que coordina
/// el zoom-out del HomeScreen y las animaciones secuenciales de las tarjetas
class MeditationTransitionWrapper extends StatefulWidget {
  final Widget child;
  final bool isTransitioning;
  final VoidCallback? onTransitionComplete;
  final Duration? transitionDuration;

  const MeditationTransitionWrapper({
    super.key,
    required this.child,
    this.isTransitioning = false,
    this.onTransitionComplete,
    this.transitionDuration,
  });

  @override
  State<MeditationTransitionWrapper> createState() => _MeditationTransitionWrapperState();
}

class _MeditationTransitionWrapperState extends State<MeditationTransitionWrapper>
    with TickerProviderStateMixin {
  late AnimationController _homeZoomController;
  late AnimationController _depthController;
  
  late Animation<double> _homeZoomAnimation;
  late Animation<double> _depthScaleAnimation;
  late Animation<double> _depthOffsetAnimation;

  @override
  void initState() {
    super.initState();
    
    // Controller para el zoom del HomeScreen
    _homeZoomController = AnimationController(
      duration: widget.transitionDuration ?? MeditationTransitionConfig.homeZoomDuration,
      vsync: this,
    );
    
    // Controller para efectos de profundidad
    _depthController = AnimationController(
      duration: MeditationTransitionConfig.depthAnimationDuration,
      vsync: this,
    );
    
    // Animación de zoom del HomeScreen
    _homeZoomAnimation = Tween<double>(
      begin: MeditationTransitionConfig.homeZoomStart,
      end: MeditationTransitionConfig.homeZoomEnd,
    ).animate(CurvedAnimation(
      parent: _homeZoomController,
      curve: MeditationTransitionConfig.homeZoomCurve,
    ));
    
    // Animación de escala para profundidad
    _depthScaleAnimation = Tween<double>(
      begin: 1.0,
      end: MeditationTransitionConfig.maxDepthScale,
    ).animate(CurvedAnimation(
      parent: _depthController,
      curve: MeditationTransitionConfig.depthScaleCurve,
    ));
    
    // Animación de offset para profundidad
    _depthOffsetAnimation = Tween<double>(
      begin: 0.0,
      end: MeditationTransitionConfig.maxDepthOffset,
    ).animate(CurvedAnimation(
      parent: _depthController,
      curve: MeditationTransitionConfig.depthScaleCurve,
    ));
  }

  @override
  void didUpdateWidget(MeditationTransitionWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isTransitioning && !oldWidget.isTransitioning) {
      _startMeditationTransition();
    } else if (!widget.isTransitioning && oldWidget.isTransitioning) {
      _reverseMeditationTransition();
    }
  }

  @override
  void dispose() {
    _homeZoomController.dispose();
    _depthController.dispose();
    super.dispose();
  }

  void _startMeditationTransition() {
    // Secuencia de animaciones para transición a meditaciones
    Future.delayed(MeditationTransitionConfig.homeZoomDelay, () {
      _homeZoomController.forward();
      _depthController.forward();
    });
    
    // Notificar cuando la transición esté completa
    Future.delayed(MeditationTransitionConfig.totalTransitionDuration, () {
      widget.onTransitionComplete?.call();
    });
  }

  void _reverseMeditationTransition() {
    // Secuencia de animaciones para regreso desde meditaciones
    _depthController.reverse();
    _homeZoomController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _homeZoomController,
        _depthController,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _homeZoomAnimation.value,
          child: Transform.translate(
            offset: Offset(0, _depthOffsetAnimation.value),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(
                      MeditationTransitionConfig.transitionShadowOpacity * 
                      _depthController.value,
                    ),
                    blurRadius: MeditationTransitionConfig.transitionShadowBlur,
                    offset: MeditationTransitionConfig.transitionShadowOffset,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: child,
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}

/// Widget para envolver las tarjetas de meditaciones con animaciones secuenciales
class MeditationCardsSequentialWrapper extends StatefulWidget {
  final List<Widget> children;
  final bool isTransitioning;
  final Duration? transitionDuration;

  const MeditationCardsSequentialWrapper({
    super.key,
    required this.children,
    this.isTransitioning = false,
    this.transitionDuration,
  });

  @override
  State<MeditationCardsSequentialWrapper> createState() => _MeditationCardsSequentialWrapperState();
}

class _MeditationCardsSequentialWrapperState extends State<MeditationCardsSequentialWrapper>
    with TickerProviderStateMixin {
  late List<AnimationController> _cardControllers;
  late List<Animation<double>> _cardSlideAnimations;
  late List<Animation<double>> _cardFadeAnimations;
  late List<Animation<double>> _cardScaleAnimations;

  @override
  void initState() {
    super.initState();
    
    _cardControllers = List.generate(
      widget.children.length,
      (index) => AnimationController(
        duration: MeditationTransitionConfig.cardIndividualDuration,
        vsync: this,
      ),
    );
    
    _cardSlideAnimations = _cardControllers.map((controller) {
      return Tween<double>(
        begin: MeditationTransitionConfig.cardSlideOffset.dy,
        end: MeditationTransitionConfig.cardSlideEnd,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: MeditationTransitionConfig.cardIndividualCurve,
      ));
    }).toList();
    
    _cardFadeAnimations = _cardControllers.map((controller) {
      return Tween<double>(
        begin: MeditationTransitionConfig.cardOpacityStart,
        end: MeditationTransitionConfig.cardOpacityEnd,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: MeditationTransitionConfig.cardFadeCurve,
      ));
    }).toList();
    
    _cardScaleAnimations = _cardControllers.map((controller) {
      return Tween<double>(
        begin: MeditationTransitionConfig.cardScaleStart,
        end: MeditationTransitionConfig.cardScaleEnd,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: MeditationTransitionConfig.cardIndividualCurve,
      ));
    }).toList();
    
    if (widget.isTransitioning) {
      _startSequentialAnimations();
    }
  }

  @override
  void didUpdateWidget(MeditationCardsSequentialWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isTransitioning && !oldWidget.isTransitioning) {
      _startSequentialAnimations();
    } else if (!widget.isTransitioning && oldWidget.isTransitioning) {
      _reverseSequentialAnimations();
    }
  }

  @override
  void dispose() {
    for (final controller in _cardControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startSequentialAnimations() {
    // Iniciar animaciones secuenciales con delays escalonados
    for (int i = 0; i < _cardControllers.length; i++) {
      Future.delayed(
        MeditationTransitionConfig.cardsStartDelay + 
        (Duration(milliseconds: i * MeditationTransitionConfig.cardStaggerDelay.inMilliseconds)),
        () {
          if (mounted) {
            _cardControllers[i].forward();
          }
        },
      );
    }
  }

  void _reverseSequentialAnimations() {
    // Revertir animaciones en orden inverso
    for (int i = _cardControllers.length - 1; i >= 0; i--) {
      Future.delayed(
        Duration(milliseconds: (_cardControllers.length - 1 - i) * 
        MeditationTransitionConfig.cardStaggerDelay.inMilliseconds),
        () {
          if (mounted) {
            _cardControllers[i].reverse();
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
          animation: _cardControllers[index],
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _cardSlideAnimations[index].value),
              child: Opacity(
                opacity: _cardFadeAnimations[index].value,
                child: Transform.scale(
                  scale: _cardScaleAnimations[index].value,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                            MeditationTransitionConfig.cardShadowOpacity * 
                            _cardControllers[index].value,
                          ),
                          blurRadius: MeditationTransitionConfig.cardShadowBlur,
                          offset: MeditationTransitionConfig.cardShadowOffset,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: child,
                  ),
                ),
              ),
            );
          },
          child: widget.children[index],
        ),
      ),
    );
  }
}

/// Widget para coordinar la transición completa de meditaciones
class MeditationTransitionCoordinator extends StatefulWidget {
  final Widget homeScreen;
  final Widget meditationScreen;
  final bool showMeditation;
  final VoidCallback? onTransitionComplete;
  final Duration? transitionDuration;

  const MeditationTransitionCoordinator({
    super.key,
    required this.homeScreen,
    required this.meditationScreen,
    required this.showMeditation,
    this.onTransitionComplete,
    this.transitionDuration,
  });

  @override
  State<MeditationTransitionCoordinator> createState() => _MeditationTransitionCoordinatorState();
}

class _MeditationTransitionCoordinatorState extends State<MeditationTransitionCoordinator>
    with TickerProviderStateMixin {
  late AnimationController _overallController;
  late Animation<double> _overallAnimation;
  
  bool _isTransitioning = false;

  @override
  void initState() {
    super.initState();
    
    _overallController = AnimationController(
      duration: widget.transitionDuration ?? MeditationTransitionConfig.totalTransitionDuration,
      vsync: this,
    );
    
    _overallAnimation = CurvedAnimation(
      parent: _overallController,
      curve: MeditationTransitionConfig.meditationCurve,
    );
    
    if (widget.showMeditation) {
      _startTransition();
    }
  }

  @override
  void didUpdateWidget(MeditationTransitionCoordinator oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.showMeditation && !oldWidget.showMeditation) {
      _startTransition();
    } else if (!widget.showMeditation && oldWidget.showMeditation) {
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
        // HomeScreen con transición de zoom
        MeditationTransitionWrapper(
          isTransitioning: _isTransitioning,
          transitionDuration: widget.transitionDuration,
          onTransitionComplete: widget.onTransitionComplete,
          child: widget.homeScreen,
        ),
        
        // MeditationScreen que aparece durante la transición
        if (_isTransitioning)
          AnimatedBuilder(
            animation: _overallAnimation,
            builder: (context, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: MeditationTransitionConfig.meditationSlideOffset,
                  end: Offset.zero,
                ).animate(_overallAnimation),
                child: FadeTransition(
                  opacity: _overallAnimation,
                  child: ScaleTransition(
                    scale: Tween<double>(
                      begin: MeditationTransitionConfig.meditationScaleStart,
                      end: MeditationTransitionConfig.meditationScaleEnd,
                    ).animate(_overallAnimation),
                    child: child,
                  ),
                ),
              );
            },
            child: widget.meditationScreen,
          ),
      ],
    );
  }
}

/// Widget para crear un efecto de zoom durante la transición
class ZoomTransitionEffect extends StatelessWidget {
  final Widget child;
  final bool isActive;
  final Duration? duration;
  final double zoomLevel;

  const ZoomTransitionEffect({
    super.key,
    required this.child,
    this.isActive = false,
    this.duration,
    this.zoomLevel = 0.92,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration ?? MeditationTransitionConfig.zoomAnimationDuration,
      curve: MeditationTransitionConfig.zoomAnimationCurve,
      transform: isActive 
          ? (Matrix4.identity()
            ..setEntry(3, 2, 0.001) // Perspectiva
            ..scale(zoomLevel))
          : Matrix4.identity(),
      child: AnimatedContainer(
        duration: duration ?? MeditationTransitionConfig.zoomAnimationDuration,
        curve: MeditationTransitionConfig.zoomAnimationCurve,
        decoration: BoxDecoration(
          boxShadow: isActive ? [
            BoxShadow(
              color: Colors.black.withOpacity(MeditationTransitionConfig.zoomShadowOpacity),
              blurRadius: MeditationTransitionConfig.zoomShadowBlur,
              offset: MeditationTransitionConfig.zoomShadowOffset,
              spreadRadius: 0,
            ),
          ] : null,
        ),
        child: child,
      ),
    );
  }
}

/// Widget para crear un efecto de profundidad con zoom
class DepthZoomEffect extends StatelessWidget {
  final Widget child;
  final bool isActive;
  final Duration? duration;
  final double zoomLevel;
  final double depthOffset;

  const DepthZoomEffect({
    super.key,
    required this.child,
    this.isActive = false,
    this.duration,
    this.zoomLevel = 0.92,
    this.depthOffset = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration ?? MeditationTransitionConfig.zoomAnimationDuration,
      curve: MeditationTransitionConfig.zoomAnimationCurve,
      transform: isActive 
          ? (Matrix4.identity()
            ..setEntry(3, 2, 0.001) // Perspectiva
            ..translate(0.0, depthOffset)
            ..scale(zoomLevel))
          : Matrix4.identity(),
      child: AnimatedContainer(
        duration: duration ?? MeditationTransitionConfig.zoomAnimationDuration,
        curve: MeditationTransitionConfig.zoomAnimationCurve,
        decoration: BoxDecoration(
          boxShadow: isActive ? [
            BoxShadow(
              color: Colors.black.withOpacity(MeditationTransitionConfig.zoomShadowOpacity),
              blurRadius: MeditationTransitionConfig.zoomShadowBlur,
              offset: MeditationTransitionConfig.zoomShadowOffset,
              spreadRadius: 0,
            ),
          ] : null,
        ),
        child: child,
      ),
    );
  }
}
