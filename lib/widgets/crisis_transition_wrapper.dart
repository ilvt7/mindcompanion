import 'package:flutter/material.dart';
import 'dart:ui';
import '../config/crisis_transition_config.dart';

/// Wrapper widget para transiciones de modo crisis que coordina
/// el slide hacia arriba del HomeScreen con blur y las animaciones de bounce secuencial de los botones
class CrisisTransitionWrapper extends StatefulWidget {
  final Widget child;
  final bool isTransitioning;
  final VoidCallback? onTransitionComplete;
  final Duration? transitionDuration;

  const CrisisTransitionWrapper({
    super.key,
    required this.child,
    this.isTransitioning = false,
    this.onTransitionComplete,
    this.transitionDuration,
  });

  @override
  State<CrisisTransitionWrapper> createState() =>
      _CrisisTransitionWrapperState();
}

class _CrisisTransitionWrapperState extends State<CrisisTransitionWrapper>
    with TickerProviderStateMixin {
  late AnimationController _homeSlideUpController;
  late AnimationController _blurController;
  late AnimationController _depthController;

  late Animation<Offset> _homeSlideUpAnimation;
  late Animation<double> _blurAnimation;
  late Animation<double> _depthScaleAnimation;
  late Animation<double> _depthOffsetAnimation;

  @override
  void initState() {
    super.initState();

    // Controller para el slide hacia arriba del HomeScreen
    _homeSlideUpController = AnimationController(
      duration:
          widget.transitionDuration ??
          CrisisTransitionConfig.homeSlideUpDuration,
      vsync: this,
    );

    // Controller para efectos de blur
    _blurController = AnimationController(
      duration: CrisisTransitionConfig.blurAnimationDuration,
      vsync: this,
    );

    // Controller para efectos de profundidad
    _depthController = AnimationController(
      duration: CrisisTransitionConfig.depthAnimationDuration,
      vsync: this,
    );

    // Animación de slide hacia arriba del HomeScreen
    _homeSlideUpAnimation =
        Tween<Offset>(
          begin: Offset.zero,
          end: Offset(0, CrisisTransitionConfig.homeSlideUpOffset),
        ).animate(
          CurvedAnimation(
            parent: _homeSlideUpController,
            curve: CrisisTransitionConfig.homeSlideUpCurve,
          ),
        );

    // Animación de blur para el HomeScreen
    _blurAnimation =
        Tween<double>(
          begin: CrisisTransitionConfig.minBlurRadius,
          end: CrisisTransitionConfig.maxBlurRadius,
        ).animate(
          CurvedAnimation(
            parent: _blurController,
            curve: CrisisTransitionConfig.blurAnimationCurve,
          ),
        );

    // Animación de escala para profundidad
    _depthScaleAnimation =
        Tween<double>(
          begin: 1.0,
          end: CrisisTransitionConfig.maxDepthScale,
        ).animate(
          CurvedAnimation(
            parent: _depthController,
            curve: CrisisTransitionConfig.depthScaleCurve,
          ),
        );

    // Animación de offset para profundidad
    _depthOffsetAnimation =
        Tween<double>(
          begin: 0.0,
          end: CrisisTransitionConfig.maxDepthOffset,
        ).animate(
          CurvedAnimation(
            parent: _depthController,
            curve: CrisisTransitionConfig.depthScaleCurve,
          ),
        );
  }

  @override
  void didUpdateWidget(CrisisTransitionWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isTransitioning && !oldWidget.isTransitioning) {
      _startCrisisTransition();
    } else if (!widget.isTransitioning && oldWidget.isTransitioning) {
      _reverseCrisisTransition();
    }
  }

  @override
  void dispose() {
    _homeSlideUpController.dispose();
    _blurController.dispose();
    _depthController.dispose();
    super.dispose();
  }

  void _startCrisisTransition() {
    // Secuencia de animaciones para transición a modo crisis
    Future.delayed(CrisisTransitionConfig.homeSlideUpDelay, () {
      _homeSlideUpController.forward();
      _blurController.forward();
      _depthController.forward();
    });

    // Notificar cuando la transición esté completa
    Future.delayed(CrisisTransitionConfig.totalTransitionDuration, () {
      widget.onTransitionComplete?.call();
    });
  }

  void _reverseCrisisTransition() {
    // Secuencia de animaciones para regreso desde modo crisis
    _depthController.reverse();
    _blurController.reverse();
    _homeSlideUpController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _homeSlideUpController,
        _blurController,
        _depthController,
      ]),
      builder: (context, child) {
        return Transform.translate(
          offset: _homeSlideUpAnimation.value,
          child: Transform.scale(
            scale: _depthScaleAnimation.value,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: _blurAnimation.value,
                sigmaY: _blurAnimation.value,
              ),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(
                        CrisisTransitionConfig.transitionShadowOpacity *
                            _depthController.value,
                      ),
                      blurRadius: CrisisTransitionConfig.transitionShadowBlur,
                      offset: CrisisTransitionConfig.transitionShadowOffset,
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
      child: widget.child,
    );
  }
}

/// Widget para envolver los botones de crisis con animaciones de bounce secuencial
class CrisisButtonsSequentialWrapper extends StatefulWidget {
  final List<Widget> children;
  final bool isTransitioning;
  final Duration? transitionDuration;

  const CrisisButtonsSequentialWrapper({
    super.key,
    required this.children,
    this.isTransitioning = false,
    this.transitionDuration,
  });

  @override
  State<CrisisButtonsSequentialWrapper> createState() =>
      _CrisisButtonsSequentialWrapperState();
}

class _CrisisButtonsSequentialWrapperState
    extends State<CrisisButtonsSequentialWrapper>
    with TickerProviderStateMixin {
  late List<AnimationController> _buttonControllers;
  late List<Animation<double>> _buttonBounceAnimations;
  late List<Animation<double>> _buttonFadeAnimations;
  late List<Animation<double>> _buttonScaleAnimations;

  @override
  void initState() {
    super.initState();

    _buttonControllers = List.generate(
      widget.children.length,
      (index) => AnimationController(
        duration: CrisisTransitionConfig.buttonIndividualDuration,
        vsync: this,
      ),
    );

    _buttonBounceAnimations = _buttonControllers.map((controller) {
      return Tween<double>(
        begin: CrisisTransitionConfig.buttonBounceStart,
        end: CrisisTransitionConfig.buttonBounceEnd,
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: CrisisTransitionConfig.buttonIndividualCurve,
        ),
      );
    }).toList();

    _buttonFadeAnimations = _buttonControllers.map((controller) {
      return Tween<double>(
        begin: CrisisTransitionConfig.buttonOpacityStart,
        end: CrisisTransitionConfig.buttonOpacityEnd,
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: CrisisTransitionConfig.buttonFadeCurve,
        ),
      );
    }).toList();

    _buttonScaleAnimations = _buttonControllers.map((controller) {
      return Tween<double>(
        begin: CrisisTransitionConfig.buttonBounceStart,
        end: CrisisTransitionConfig.buttonBounceEnd,
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: CrisisTransitionConfig.buttonIndividualCurve,
        ),
      );
    }).toList();

    if (widget.isTransitioning) {
      _startSequentialAnimations();
    }
  }

  @override
  void didUpdateWidget(CrisisButtonsSequentialWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isTransitioning && !oldWidget.isTransitioning) {
      _startSequentialAnimations();
    } else if (!widget.isTransitioning && oldWidget.isTransitioning) {
      _reverseSequentialAnimations();
    }
  }

  @override
  void dispose() {
    for (final controller in _buttonControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startSequentialAnimations() {
    // Iniciar animaciones secuenciales con delays escalonados
    for (int i = 0; i < _buttonControllers.length; i++) {
      Future.delayed(
        CrisisTransitionConfig.buttonsStartDelay +
            (Duration(
              milliseconds:
                  i * CrisisTransitionConfig.buttonStaggerDelay.inMilliseconds,
            )),
        () {
          if (mounted) {
            _buttonControllers[i].forward();
          }
        },
      );
    }
  }

  void _reverseSequentialAnimations() {
    // Revertir animaciones en orden inverso
    for (int i = _buttonControllers.length - 1; i >= 0; i--) {
      Future.delayed(
        Duration(
          milliseconds:
              (_buttonControllers.length - 1 - i) *
              CrisisTransitionConfig.buttonStaggerDelay.inMilliseconds,
        ),
        () {
          if (mounted) {
            _buttonControllers[i].reverse();
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
          animation: _buttonControllers[index],
          builder: (context, child) {
            return Transform.scale(
              scale: _buttonBounceAnimations[index].value,
              child: Opacity(
                opacity: _buttonFadeAnimations[index].value,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(
                          CrisisTransitionConfig.buttonShadowOpacity *
                              _buttonControllers[index].value,
                        ),
                        blurRadius: CrisisTransitionConfig.buttonShadowBlur,
                        offset: CrisisTransitionConfig.buttonShadowOffset,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: child,
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

/// Widget para coordinar la transición completa de modo crisis
class CrisisTransitionCoordinator extends StatefulWidget {
  final Widget homeScreen;
  final Widget crisisScreen;
  final bool showCrisis;
  final VoidCallback? onTransitionComplete;
  final Duration? transitionDuration;

  const CrisisTransitionCoordinator({
    super.key,
    required this.homeScreen,
    required this.crisisScreen,
    required this.showCrisis,
    this.onTransitionComplete,
    this.transitionDuration,
  });

  @override
  State<CrisisTransitionCoordinator> createState() =>
      _CrisisTransitionCoordinatorState();
}

class _CrisisTransitionCoordinatorState
    extends State<CrisisTransitionCoordinator>
    with TickerProviderStateMixin {
  late AnimationController _overallController;
  late Animation<double> _overallAnimation;

  bool _isTransitioning = false;

  @override
  void initState() {
    super.initState();

    _overallController = AnimationController(
      duration:
          widget.transitionDuration ??
          CrisisTransitionConfig.totalTransitionDuration,
      vsync: this,
    );

    _overallAnimation = CurvedAnimation(
      parent: _overallController,
      curve: CrisisTransitionConfig.crisisCurve,
    );

    if (widget.showCrisis) {
      _startTransition();
    }
  }

  @override
  void didUpdateWidget(CrisisTransitionCoordinator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.showCrisis && !oldWidget.showCrisis) {
      _startTransition();
    } else if (!widget.showCrisis && oldWidget.showCrisis) {
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
        // HomeScreen con transición de slide hacia arriba y blur
        CrisisTransitionWrapper(
          isTransitioning: _isTransitioning,
          transitionDuration: widget.transitionDuration,
          onTransitionComplete: widget.onTransitionComplete,
          child: widget.homeScreen,
        ),

        // CrisisModeScreen que aparece durante la transición
        if (_isTransitioning)
          AnimatedBuilder(
            animation: _overallAnimation,
            builder: (context, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: CrisisTransitionConfig.crisisSlideOffset,
                  end: Offset.zero,
                ).animate(_overallAnimation),
                child: FadeTransition(
                  opacity: _overallAnimation,
                  child: ScaleTransition(
                    scale: Tween<double>(
                      begin: CrisisTransitionConfig.crisisScaleStart,
                      end: CrisisTransitionConfig.crisisScaleEnd,
                    ).animate(_overallAnimation),
                    child: child,
                  ),
                ),
              );
            },
            child: widget.crisisScreen,
          ),
      ],
    );
  }
}

/// Widget para crear un efecto de blur durante la transición
class BlurTransitionEffect extends StatelessWidget {
  final Widget child;
  final bool isActive;
  final Duration? duration;
  final double blurRadius;

  const BlurTransitionEffect({
    super.key,
    required this.child,
    this.isActive = false,
    this.duration,
    this.blurRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration ?? CrisisTransitionConfig.blurAnimationDuration,
      curve: CrisisTransitionConfig.blurAnimationCurve,
      child: isActive
          ? ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: blurRadius,
                sigmaY: blurRadius,
              ),
              child: child,
            )
          : child,
    );
  }
}

/// Widget para crear un efecto de profundidad con slide
class DepthSlideEffect extends StatelessWidget {
  final Widget child;
  final bool isActive;
  final Duration? duration;
  final double slideOffset;
  final double depthScale;

  const DepthSlideEffect({
    super.key,
    required this.child,
    this.isActive = false,
    this.duration,
    this.slideOffset = -0.25,
    this.depthScale = 0.95,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration ?? CrisisTransitionConfig.homeSlideUpDuration,
      curve: CrisisTransitionConfig.homeSlideUpCurve,
      transform: isActive
          ? (Matrix4.identity()
              ..translate(0.0, slideOffset)
              ..scale(depthScale))
          : Matrix4.identity(),
      child: AnimatedContainer(
        duration: duration ?? CrisisTransitionConfig.homeSlideUpDuration,
        curve: CrisisTransitionConfig.homeSlideUpCurve,
        decoration: BoxDecoration(
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(
                      CrisisTransitionConfig.depthShadowOpacity,
                    ),
                    blurRadius: CrisisTransitionConfig.depthShadowBlur,
                    offset: CrisisTransitionConfig.depthShadowOffset,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: child,
      ),
    );
  }
}

/// Widget para crear un efecto de emergencia con pulso
class EmergencyPulseEffect extends StatefulWidget {
  final Widget child;
  final bool isActive;
  final Duration? duration;

  const EmergencyPulseEffect({
    super.key,
    required this.child,
    this.isActive = false,
    this.duration,
  });

  @override
  State<EmergencyPulseEffect> createState() => _EmergencyPulseEffectState();
}

class _EmergencyPulseEffectState extends State<EmergencyPulseEffect>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: CrisisTransitionConfig.emergencyPulseDuration,
      vsync: this,
    );

    _pulseAnimation =
        Tween<double>(
          begin: CrisisTransitionConfig.emergencyPulseStart,
          end: CrisisTransitionConfig.emergencyPulseEnd,
        ).animate(
          CurvedAnimation(
            parent: _pulseController,
            curve: CrisisTransitionConfig.emergencyPulseCurve,
          ),
        );

    if (widget.isActive) {
      _startPulse();
    }
  }

  @override
  void didUpdateWidget(EmergencyPulseEffect oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isActive && !oldWidget.isActive) {
      _startPulse();
    } else if (!widget.isActive && oldWidget.isActive) {
      _stopPulse();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _startPulse() {
    _pulseController.repeat(reverse: true);
  }

  void _stopPulse() {
    _pulseController.stop();
    _pulseController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(scale: _pulseAnimation.value, child: child);
      },
      child: widget.child,
    );
  }
}
