import 'package:flutter/material.dart';
import '../config/diary_transition_config.dart';

/// Wrapper widget para transiciones de diarios que coordina
/// el slide del HomeScreen hacia la izquierda y el fade de las cards
class DiaryTransitionWrapper extends StatefulWidget {
  final Widget child;
  final bool isTransitioning;
  final VoidCallback? onTransitionComplete;
  final Duration? transitionDuration;

  const DiaryTransitionWrapper({
    super.key,
    required this.child,
    this.isTransitioning = false,
    this.onTransitionComplete,
    this.transitionDuration,
  });

  @override
  State<DiaryTransitionWrapper> createState() => _DiaryTransitionWrapperState();
}

class _DiaryTransitionWrapperState extends State<DiaryTransitionWrapper>
    with TickerProviderStateMixin {
  late AnimationController _homeSlideController;
  late AnimationController _cardsFadeController;
  late AnimationController _depthController;
  
  late Animation<Offset> _homeSlideAnimation;
  late Animation<double> _cardsFadeAnimation;
  late Animation<double> _depthScaleAnimation;
  late Animation<double> _depthOffsetAnimation;

  @override
  void initState() {
    super.initState();
    
    // Controller para el slide del HomeScreen
    _homeSlideController = AnimationController(
      duration: widget.transitionDuration ?? DiaryTransitionConfig.homeSlideDuration,
      vsync: this,
    );
    
    // Controller para el fade de las cards
    _cardsFadeController = AnimationController(
      duration: DiaryTransitionConfig.cardsFadeDuration,
      vsync: this,
    );
    
    // Controller para efectos de profundidad
    _depthController = AnimationController(
      duration: DiaryTransitionConfig.depthAnimationDuration,
      vsync: this,
    );
    
    // Animación de slide del HomeScreen hacia la izquierda
    _homeSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: DiaryTransitionEffectsConfig.homeSlideLeft,
    ).animate(CurvedAnimation(
      parent: _homeSlideController,
      curve: DiaryTransitionConfig.homeSlideCurve,
    ));
    
    // Animación de fade de las cards
    _cardsFadeAnimation = Tween<double>(
      begin: DiaryTransitionConfig.cardsFadeStart,
      end: DiaryTransitionConfig.cardsFadeEnd,
    ).animate(CurvedAnimation(
      parent: _cardsFadeController,
      curve: DiaryTransitionConfig.cardsFadeCurve,
    ));
    
    // Animación de escala para profundidad
    _depthScaleAnimation = Tween<double>(
      begin: 1.0,
      end: DiaryTransitionConfig.depthScaleFactor,
    ).animate(CurvedAnimation(
      parent: _depthController,
      curve: DiaryTransitionConfig.depthScaleCurve,
    ));
    
    // Animación de offset para profundidad
    _depthOffsetAnimation = Tween<double>(
      begin: 0.0,
      end: DiaryTransitionConfig.maxDepthOffset,
    ).animate(CurvedAnimation(
      parent: _depthController,
      curve: DiaryTransitionConfig.depthScaleCurve,
    ));
  }

  @override
  void didUpdateWidget(DiaryTransitionWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isTransitioning && !oldWidget.isTransitioning) {
      _startDiaryTransition();
    } else if (!widget.isTransitioning && oldWidget.isTransitioning) {
      _reverseDiaryTransition();
    }
  }

  @override
  void dispose() {
    _homeSlideController.dispose();
    _cardsFadeController.dispose();
    _depthController.dispose();
    super.dispose();
  }

  void _startDiaryTransition() {
    // Secuencia de animaciones para transición a diarios
    Future.delayed(DiaryTransitionConfig.cardsFadeDelay, () {
      _cardsFadeController.forward();
    });
    
    Future.delayed(DiaryTransitionConfig.homeSlideDelay, () {
      _homeSlideController.forward();
      _depthController.forward();
    });
    
    // Notificar cuando la transición esté completa
    Future.delayed(DiaryTransitionConfig.totalTransitionDuration, () {
      widget.onTransitionComplete?.call();
    });
  }

  void _reverseDiaryTransition() {
    // Secuencia de animaciones para regreso desde diarios
    _depthController.reverse();
    _homeSlideController.reverse();
    
    Future.delayed(DiaryTransitionConfig.homeSlideDuration, () {
      _cardsFadeController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _homeSlideController,
        _cardsFadeController,
        _depthController,
      ]),
      builder: (context, child) {
        return Transform.translate(
          offset: _homeSlideAnimation.value,
          child: Transform.scale(
            scale: _depthScaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(
                      DiaryTransitionConfig.transitionShadowOpacity * 
                      _depthController.value,
                    ),
                    blurRadius: DiaryTransitionConfig.transitionShadowBlur,
                    offset: DiaryTransitionConfig.transitionShadowOffset,
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

/// Widget para envolver las cards de emociones durante la transición
class EmotionCardsTransitionWrapper extends StatelessWidget {
  final Widget child;
  final bool isTransitioning;
  final Duration? transitionDuration;

  const EmotionCardsTransitionWrapper({
    super.key,
    required this.child,
    this.isTransitioning = false,
    this.transitionDuration,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isTransitioning ? DiaryTransitionConfig.cardsFadeEnd : DiaryTransitionConfig.cardsFadeStart,
      duration: transitionDuration ?? DiaryTransitionConfig.cardsFadeDuration,
      curve: DiaryTransitionConfig.cardsFadeCurve,
      child: AnimatedScale(
        scale: isTransitioning ? 0.95 : 1.0,
        duration: transitionDuration ?? DiaryTransitionConfig.cardsFadeDuration,
        curve: DiaryTransitionConfig.cardsFadeCurve,
        child: child,
      ),
    );
  }
}

/// Widget para coordinar la transición completa de diarios
class DiaryTransitionCoordinator extends StatefulWidget {
  final Widget homeScreen;
  final Widget diaryScreen;
  final bool showDiary;
  final VoidCallback? onTransitionComplete;
  final Duration? transitionDuration;

  const DiaryTransitionCoordinator({
    super.key,
    required this.homeScreen,
    required this.diaryScreen,
    required this.showDiary,
    this.onTransitionComplete,
    this.transitionDuration,
  });

  @override
  State<DiaryTransitionCoordinator> createState() => _DiaryTransitionCoordinatorState();
}

class _DiaryTransitionCoordinatorState extends State<DiaryTransitionCoordinator>
    with TickerProviderStateMixin {
  late AnimationController _overallController;
  late Animation<double> _overallAnimation;
  
  bool _isTransitioning = false;

  @override
  void initState() {
    super.initState();
    
    _overallController = AnimationController(
      duration: widget.transitionDuration ?? DiaryTransitionConfig.totalTransitionDuration,
      vsync: this,
    );
    
    _overallAnimation = CurvedAnimation(
      parent: _overallController,
      curve: DiaryTransitionConfig.diaryCurve,
    );
    
    if (widget.showDiary) {
      _startTransition();
    }
  }

  @override
  void didUpdateWidget(DiaryTransitionCoordinator oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.showDiary && !oldWidget.showDiary) {
      _startTransition();
    } else if (!widget.showDiary && oldWidget.showDiary) {
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
        // HomeScreen con transición
        DiaryTransitionWrapper(
          isTransitioning: _isTransitioning,
          transitionDuration: widget.transitionDuration,
          onTransitionComplete: widget.onTransitionComplete,
          child: widget.homeScreen,
        ),
        
        // DiaryScreen que aparece durante la transición
        if (_isTransitioning)
          AnimatedBuilder(
            animation: _overallAnimation,
            builder: (context, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: DiaryTransitionConfig.diarySlideOffset,
                  end: Offset.zero,
                ).animate(_overallAnimation),
                child: FadeTransition(
                  opacity: _overallAnimation,
                  child: ScaleTransition(
                    scale: Tween<double>(
                      begin: DiaryTransitionConfig.diaryScaleStart,
                      end: DiaryTransitionConfig.diaryScaleEnd,
                    ).animate(_overallAnimation),
                    child: widget.diaryScreen,
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

/// Widget para crear un efecto de profundidad durante la transición
class DepthTransitionEffect extends StatelessWidget {
  final Widget child;
  final bool isActive;
  final Duration? duration;

  const DepthTransitionEffect({
    super.key,
    required this.child,
    this.isActive = false,
    this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration ?? DiaryTransitionConfig.depthAnimationDuration,
      curve: DiaryTransitionConfig.depthScaleCurve,
      transform: isActive 
          ? (Matrix4.identity()
            ..setEntry(3, 2, 0.001) // Perspectiva
            ..translate(0.0, DiaryTransitionConfig.maxDepthOffset)
            ..scale(DiaryTransitionConfig.maxDepthScale))
          : Matrix4.identity(),
      child: AnimatedContainer(
        duration: duration ?? DiaryTransitionConfig.depthAnimationDuration,
        curve: DiaryTransitionConfig.depthScaleCurve,
        decoration: BoxDecoration(
          boxShadow: isActive ? [
            BoxShadow(
              color: Colors.black.withOpacity(DiaryTransitionConfig.depthShadowOpacity),
              blurRadius: DiaryTransitionConfig.depthShadowBlur,
              offset: DiaryTransitionConfig.depthShadowOffset,
              spreadRadius: 0,
            ),
          ] : null,
        ),
        child: child,
      ),
    );
  }
}
