import 'package:flutter/material.dart';

/// Configuración centralizada para todas las transiciones de la app
class TransitionConfig {
  // Duración de transiciones
  static const Duration fastTransition = Duration(milliseconds: 200);
  static const Duration normalTransition = Duration(milliseconds: 300);
  static const Duration slowTransition = Duration(milliseconds: 400);
  
  // Curvas de animación
  static const Curve mainCurve = Curves.easeInOutCubic;
  static const Curve slideCurve = Curves.easeOutCubic;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve fastCurve = Curves.easeIn;
  
  // Configuración para pantallas principales (slide lateral)
  static const Duration mainScreenTransition = normalTransition;
  static const Curve mainScreenCurve = mainCurve;
  static const Offset mainScreenSlideOffset = Offset(1.0, 0.0);
  
  // Configuración para pantallas secundarias (fade-in desde abajo)
  static const Duration secondaryScreenTransition = Duration(milliseconds: 250);
  static const Curve secondaryScreenCurve = slideCurve;
  static const Offset secondaryScreenSlideOffset = Offset(0.0, 0.3);
  
  // Configuración para WelcomeScreen (fade-in completo)
  static const Duration welcomeTransition = slowTransition;
  static const Curve welcomeCurve = mainCurve;
  static const double welcomeScaleStart = 0.95;
  
  // Configuración para CrisisMode (transición rápida)
  static const Duration crisisTransition = fastTransition;
  static const Curve crisisCurve = fastCurve;
  static const Offset crisisSlideOffset = Offset(0.0, 0.2);
  
  // Configuración para transiciones de elementos internos
  static const Duration elementTransition = Duration(milliseconds: 150);
  static const Curve elementCurve = Curves.easeOut;
  
  // Configuración para transiciones de color
  static const Duration colorTransition = normalTransition;
  static const Curve colorCurve = mainCurve;
  
  // Configuración para transiciones de sombra
  static const Duration shadowTransition = Duration(milliseconds: 200);
  static const Curve shadowCurve = Curves.easeInOut;
  
  // Configuración para transiciones de escala
  static const Duration scaleTransition = Duration(milliseconds: 100);
  static const Curve scaleCurve = Curves.easeInOut;
  
  // Configuración para transiciones de rebote
  static const Duration bounceTransition = Duration(milliseconds: 400);
  
  // Configuración para transiciones de entrada
  static const Duration entranceTransition = Duration(milliseconds: 800);
  static const Curve entranceCurve = slideCurve;
  
  // Configuración para transiciones de salida
  static const Duration exitTransition = Duration(milliseconds: 600);
  static const Curve exitCurve = Curves.easeIn;
}

/// Configuración específica para cada tipo de pantalla
class ScreenTransitionConfig {
  // Pantallas principales - Slide lateral
  static const Map<String, Map<String, dynamic>> mainScreens = {
    'home': {
      'duration': TransitionConfig.mainScreenTransition,
      'curve': TransitionConfig.mainScreenCurve,
      'offset': TransitionConfig.mainScreenSlideOffset,
    },
    'ai-diary': {
      'duration': TransitionConfig.mainScreenTransition,
      'curve': TransitionConfig.mainScreenCurve,
      'offset': TransitionConfig.mainScreenSlideOffset,
    },
    'personal-diary': {
      'duration': TransitionConfig.mainScreenTransition,
      'curve': TransitionConfig.mainScreenCurve,
      'offset': TransitionConfig.mainScreenSlideOffset,
    },
    'meditations': {
      'duration': TransitionConfig.mainScreenTransition,
      'curve': TransitionConfig.mainScreenCurve,
      'offset': TransitionConfig.mainScreenSlideOffset,
    },
    'history': {
      'duration': TransitionConfig.mainScreenTransition,
      'curve': TransitionConfig.mainScreenCurve,
      'offset': TransitionConfig.mainScreenSlideOffset,
    },
  };
  
  // Pantallas secundarias - Fade-in desde abajo
  static const Map<String, Map<String, dynamic>> secondaryScreens = {
    'settings': {
      'duration': TransitionConfig.secondaryScreenTransition,
      'curve': TransitionConfig.secondaryScreenCurve,
      'offset': TransitionConfig.secondaryScreenSlideOffset,
    },
    'privacy-policy': {
      'duration': TransitionConfig.secondaryScreenTransition,
      'curve': TransitionConfig.secondaryScreenCurve,
      'offset': TransitionConfig.secondaryScreenSlideOffset,
    },
  };
  
  // Pantallas especiales
  static const Map<String, Map<String, dynamic>> specialScreens = {
    'welcome': {
      'duration': TransitionConfig.welcomeTransition,
      'curve': TransitionConfig.welcomeCurve,
      'scale': TransitionConfig.welcomeScaleStart,
    },
    'crisis': {
      'duration': TransitionConfig.crisisTransition,
      'curve': TransitionConfig.crisisCurve,
      'offset': TransitionConfig.crisisSlideOffset,
    },
  };
}

/// Configuración para efectos visuales durante transiciones
class VisualTransitionConfig {
  // Colores de transición
  static const Color primaryTransitionColor = Color(0xFF87CEEB);
  static const Color secondaryTransitionColor = Color(0xFFE6E6FA);
  static const Color surfaceTransitionColor = Color(0xFFF8F9FF);
  
  // Opacidades para efectos de transición
  static const double transitionShadowOpacity = 0.1;
  static const double transitionColorOpacity = 0.15;
  static const double transitionBorderOpacity = 0.3;
  
  // Configuración de sombras durante transiciones
  static const double transitionShadowBlur = 20.0;
  static const Offset transitionShadowOffset = Offset(0, 10);
  static const double transitionShadowSpread = 0.0;
  
  // Configuración de bordes redondeados
  static const double defaultBorderRadius = 16.0;
  static const double largeBorderRadius = 20.0;
  static const double smallBorderRadius = 12.0;
  
  // Configuración de espaciado durante transiciones
  static const double transitionPadding = 24.0;
  static const double transitionMargin = 20.0;
  static const double transitionSpacing = 32.0;
}
