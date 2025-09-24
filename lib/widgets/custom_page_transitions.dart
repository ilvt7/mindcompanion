import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:animations/animations.dart';
import '../config/transition_config.dart';

class CustomPageTransitions {
  // Transiciones para pantallas principales (FadeThroughTransition)
  static PageRouteBuilder<T> slideTransition<T>(Widget page, {bool fromRight = true}) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: TransitionConfig.mainScreenTransition,
      reverseTransitionDuration: TransitionConfig.mainScreenTransition,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
    );
  }

  // Transiciones para pantallas secundarias (FadeThroughTransition)
  static PageRouteBuilder<T> fadeSlideTransition<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: TransitionConfig.secondaryScreenTransition,
      reverseTransitionDuration: TransitionConfig.secondaryScreenTransition,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
    );
  }

  // Transición especial para WelcomeScreen (FadeThroughTransition)
  static PageRouteBuilder<T> welcomeTransition<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: TransitionConfig.welcomeTransition,
      reverseTransitionDuration: TransitionConfig.welcomeTransition,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
    );
  }

  // Transición para crisis mode (fade-in rápido con slide)
  static PageRouteBuilder<T> crisisTransition<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: TransitionConfig.crisisTransition,
      reverseTransitionDuration: TransitionConfig.crisisTransition,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: TransitionConfig.crisisCurve,
        ));
        
        final slideAnimation = Tween<Offset>(
          begin: TransitionConfig.crisisSlideOffset,
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: TransitionConfig.crisisCurve,
        ));
        
        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: child,
          ),
        );
      },
    );
  }

  // Transición especial de apertura de la app (WelcomeScreen a HomeScreen) - FadeThroughTransition
  static PageRouteBuilder<T> appOpeningTransition<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 1200),
      reverseTransitionDuration: const Duration(milliseconds: 800),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
    );
  }

  // Transición especial para diarios (FadeThroughTransition)
  static PageRouteBuilder<T> diaryTransition<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 800),
      reverseTransitionDuration: const Duration(milliseconds: 600),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
    );
  }

  // Transición especial para meditaciones (FadeThroughTransition)
  static PageRouteBuilder<T> meditationTransition<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 1000),
      reverseTransitionDuration: const Duration(milliseconds: 800),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
    );
  }

  // Transición especial para modo crisis (FadeThroughTransition)
  static PageRouteBuilder<T> crisisModeTransition<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 900),
      reverseTransitionDuration: const Duration(milliseconds: 700),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
    );
  }

  // Nueva transición: FadeThroughTransition para AI Diary, Personal Diary y History
  static PageRouteBuilder<T> slideLeftTransition<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 800),
      reverseTransitionDuration: const Duration(milliseconds: 600),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
    );
  }

  // Nueva transición: FadeThroughTransition para Meditation
  static PageRouteBuilder<T> fadeInTransition<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 600),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
    );
  }

  // Nueva transición: FadeThroughTransition para Crisis Mode
  static PageRouteBuilder<T> fadeInZoomTransition<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 700),
      reverseTransitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
    );
  }

  // Nueva transición: FadeThroughTransition para Settings
  static PageRouteBuilder<T> slideUpTransition<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 600),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
    );
  }

  // Transición personalizada con FadeThroughTransition por defecto
  static PageRouteBuilder<T> customTransition<T>(
    Widget page, {
    Duration? duration,
    Curve? curve,
    Offset? slideOffset,
    double? scaleStart,
    bool useFade = true,
    bool useSlide = false,
    bool useScale = false,
  }) {
    final transitionDuration = duration ?? TransitionConfig.normalTransition;
    
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: transitionDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Por defecto usar FadeThroughTransition, pero permitir transiciones personalizadas
        if (useSlide || useScale) {
          Widget transitionChild = child;
          
          // Aplicar escala si está habilitada
          if (useScale && scaleStart != null) {
            final scaleAnimation = Tween<double>(
              begin: scaleStart,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: curve ?? TransitionConfig.mainCurve,
            ));
            
            transitionChild = ScaleTransition(
              scale: scaleAnimation,
              child: transitionChild,
            );
          }
          
          // Aplicar slide si está habilitado
          if (useSlide && slideOffset != null) {
            final slideAnimation = Tween<Offset>(
              begin: slideOffset,
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: curve ?? TransitionConfig.mainCurve,
            ));
            
            transitionChild = SlideTransition(
              position: slideAnimation,
              child: transitionChild,
            );
          }
          
          // Aplicar fade si está habilitado
          if (useFade) {
            final fadeAnimation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: curve ?? TransitionConfig.mainCurve,
            ));
            
            transitionChild = FadeTransition(
              opacity: fadeAnimation,
              child: transitionChild,
            );
          }
          
          return transitionChild;
        } else {
          // Usar FadeThroughTransition por defecto
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        }
      },
    );
  }

  /// Transición específica para modo crisis con efectos coordinados
  /// Incluye slide hacia arriba del HomeScreen con blur y animaciones secuenciales
  static PageRouteBuilder<T> crisisModeCoordinatedTransition<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 800),
      reverseTransitionDuration: const Duration(milliseconds: 600),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return Stack(
          children: [
            // HomeScreen con efecto de slide hacia arriba y blur
            AnimatedBuilder(
              animation: animation,
              builder: (context, homeChild) {
                final homeSlideAnimation = Tween<Offset>(
                  begin: Offset.zero,
                  end: const Offset(0, -0.15),
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                ));
                
                final homeBlurAnimation = Tween<double>(
                  begin: 0.0,
                  end: 8.0,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                ));
                
                final homeScaleAnimation = Tween<double>(
                  begin: 1.0,
                  end: 0.95,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                ));
                
                return Transform.translate(
                  offset: homeSlideAnimation.value,
                  child: Transform.scale(
                    scale: homeScaleAnimation.value,
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(
                        sigmaX: homeBlurAnimation.value,
                        sigmaY: homeBlurAnimation.value,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                0.15 * animation.value,
                              ),
                              blurRadius: 20.0,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: homeChild,
                      ),
                    ),
                  ),
                );
              },
              child: const SizedBox.shrink(), // Placeholder para HomeScreen
            ),
            
            // CrisisModeScreen con fade-in y slide desde abajo
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.3),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOutCubic,
              )),
              child: FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(
                    begin: 0.8,
                    end: 1.0,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  )),
                  child: child,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Transición específica para historial emocional con efectos coordinados
  /// HomeScreen slide lateral hacia la izquierda, EmotionalHistoryScreen slide desde la derecha
  static PageRouteBuilder<T> emotionalHistoryTransition<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 900),
      reverseTransitionDuration: const Duration(milliseconds: 700),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return Stack(
          children: [
            // HomeScreen con slide lateral hacia la izquierda y fade
            AnimatedBuilder(
              animation: animation,
              builder: (context, homeChild) {
                final homeSlideAnimation = Tween<Offset>(
                  begin: Offset.zero,
                  end: const Offset(-0.3, 0.0),
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                ));

                final homeFadeAnimation = Tween<double>(
                  begin: 1.0,
                  end: 0.7,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                ));

                return Transform.translate(
                  offset: homeSlideAnimation.value,
                  child: Opacity(
                    opacity: homeFadeAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              0.1 * animation.value,
                            ),
                            blurRadius: 20.0,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: homeChild,
                    ),
                  ),
                );
              },
              child: const SizedBox.shrink(), // Placeholder para HomeScreen
            ),

            // EmotionalHistoryScreen con slide lateral desde la derecha y fade-in
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(
                    begin: 0.98,
                    end: 1.0,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  )),
                  child: child,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Transición específica para pantallas de configuración y política
  /// HomeScreen fade-out, Settings/PrivacyPolicyScreen fade-in desde abajo con micro-bounce
  static PageRouteBuilder<T> settingsTransition<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 750),
      reverseTransitionDuration: const Duration(milliseconds: 600),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return Stack(
          children: [
            // HomeScreen con fade-out
            AnimatedBuilder(
              animation: animation,
              builder: (context, homeChild) {
                final homeFadeAnimation = Tween<double>(
                  begin: 1.0,
                  end: 0.0,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                ));

                return Opacity(
                  opacity: homeFadeAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                            0.08 * (1.0 - animation.value),
                          ),
                          blurRadius: 15.0,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: homeChild,
                  ),
                );
              },
              child: const SizedBox.shrink(), // Placeholder para HomeScreen
            ),

            // Settings/PrivacyPolicyScreen con fade-in desde abajo y micro-bounce
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.2),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(
                    begin: 0.95,
                    end: 1.0,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.elasticOut,
                  )),
                  child: child,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Clase helper para navegación con transiciones personalizadas
class CustomNavigator {
  // Navegar a pantallas principales con slide
  static Future<T?> pushMainScreen<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed(
      context,
      routeName,
      arguments: arguments,
    );
  }

  // Navegar a pantallas secundarias con fade-slide
  static Future<T?> pushSecondaryScreen<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed(
      context,
      routeName,
      arguments: arguments,
    );
  }

  // Navegar a crisis mode con transición rápida
  static Future<T?> pushCrisisScreen<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed(
      context,
      routeName,
      arguments: arguments,
    );
  }

  // Navegar a welcome con transición especial
  static Future<T?> pushWelcomeScreen<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed(
      context,
      routeName,
      arguments: arguments,
    );
  }

  // Navegar con transición de apertura de la app
  static Future<T?> pushWithAppOpeningTransition<T extends Object?>(
    BuildContext context,
    Widget page,
  ) {
    final route = CustomPageTransitions.appOpeningTransition(page);
    return Navigator.push(context, route as Route<T>);
  }

  // Navegar a diarios con transición especial
  static Future<T?> pushDiaryScreen<T extends Object?>(
    BuildContext context,
    Widget page,
  ) {
    final route = CustomPageTransitions.diaryTransition(page);
    return Navigator.push(context, route as Route<T>);
  }

  // Navegar a meditaciones con transición especial
  static Future<T?> pushMeditationScreen<T extends Object?>(
    BuildContext context,
    Widget page,
  ) {
    final route = CustomPageTransitions.meditationTransition(page);
    return Navigator.push(context, route as Route<T>);
  }

  // Navegar a modo crisis con transición especial
  static Future<T?> pushCrisisModeScreen<T extends Object?>(
    BuildContext context,
    Widget page,
  ) {
    final route = CustomPageTransitions.crisisModeTransition(page);
    return Navigator.push(context, route as Route<T>);
  }

  // Navegar a modo crisis con transición coordinada (HomeScreen slide arriba + blur)
  static Future<T?> pushCrisisModeCoordinated<T extends Object?>(
    BuildContext context,
    Widget page,
  ) {
    final route = CustomPageTransitions.crisisModeCoordinatedTransition(page);
    return Navigator.push(context, route as Route<T>);
  }

  // Navegar a historial emocional con transición coordinada (HomeScreen slide izquierda)
  static Future<T?> pushEmotionalHistoryCoordinated<T extends Object?>(
    BuildContext context,
    Widget page,
  ) {
    final route = CustomPageTransitions.emotionalHistoryTransition(page);
    return Navigator.push(context, route as Route<T>);
  }

  // Navegar a pantallas de configuración con transición especial (HomeScreen fade-out, Settings fade-in desde abajo)
  static Future<T?> pushSettingsScreen<T extends Object?>(
    BuildContext context,
    Widget page,
  ) {
    final route = CustomPageTransitions.settingsTransition(page);
    return Navigator.push(context, route as Route<T>);
  }

  // Navegar con transición personalizada
  static Future<T?> pushWithCustomTransition<T extends Object?>(
    BuildContext context,
    Widget page, {
    Duration? duration,
    Curve? curve,
    Offset? slideOffset,
    double? scaleStart,
    bool useFade = true,
    bool useSlide = false,
    bool useScale = false,
  }) {
    final route = CustomPageTransitions.customTransition(
      page,
      duration: duration,
      curve: curve,
      slideOffset: slideOffset,
      scaleStart: scaleStart,
      useFade: useFade,
      useSlide: useSlide,
      useScale: useScale,
    );
    
    return Navigator.push(context, route as Route<T>);
  }
}
