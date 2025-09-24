import 'package:flutter/material.dart';

/// Configuración específica para transiciones de diarios
class DiaryTransitionConfig {
  // Duración de las transiciones de diarios
  static const Duration diaryTransitionDuration = Duration(milliseconds: 800);
  static const Duration diaryReverseDuration = Duration(milliseconds: 600);
  static const Duration cardsFadeDuration = Duration(milliseconds: 400);
  static const Duration homeSlideDuration = Duration(milliseconds: 600);
  
  // Curvas de animación para diarios
  static const Curve diaryCurve = Curves.easeOutCubic;
  static const Curve cardsFadeCurve = Curves.easeInOutCubic;
  static const Curve homeSlideCurve = Curves.easeInOutCubic;
  
  // Configuración de efectos visuales para diarios
  static const double diaryScaleStart = 0.98;
  static const double diaryScaleEnd = 1.0;
  static const double cardsFadeStart = 1.0;
  static const double cardsFadeEnd = 0.3;
  static const double homeSlideOffset = -0.3;
  
  // Configuración de timing para secuencias
  static const Duration cardsFadeDelay = Duration(milliseconds: 100);
  static const Duration homeSlideDelay = Duration(milliseconds: 200);
  static const Duration diaryAppearDelay = Duration(milliseconds: 300);
  
  // Configuración de transiciones de pantalla
  static const Offset diarySlideOffset = Offset(1.0, 0.0);
  static const Offset homeSlideOffsetLeft = Offset(-0.3, 0.0);
  static const Duration totalTransitionDuration = Duration(milliseconds: 800);
  
  // Configuración de efectos de blur y sombra
  static const double transitionBlurRadius = 10.0;
  static const double transitionShadowOpacity = 0.15;
  static const Offset transitionShadowOffset = Offset(0, 8);
  static const double transitionShadowBlur = 20.0;
  
  // Configuración de colores de transición
  static const Color transitionOverlayColor = Color(0x80000000);
  static const Color diaryBackgroundColor = Color(0xFFFFFFFF);
  static const Color homeBackgroundColor = Color(0xFFF8F9FF);
  
  // Configuración de animaciones de cards
  static const Duration cardStaggerDelay = Duration(milliseconds: 50);
  static const int maxCardStaggerCount = 5;
  static const Curve cardStaggerCurve = Curves.easeOutCubic;
  
  // Configuración de efectos de profundidad
  static const double maxDepthOffset = 20.0;
  static const double maxDepthScale = 0.95;
  static const Duration depthAnimationDuration = Duration(milliseconds: 300);
  
  // Configuración de transiciones de texto
  static const Duration textFadeDuration = Duration(milliseconds: 200);
  static const Curve textFadeCurve = Curves.easeInOut;
  static const double textFadeStart = 1.0;
  static const double textFadeEnd = 0.0;
  
  // Configuración de transiciones de iconos
  static const Duration iconScaleDuration = Duration(milliseconds: 150);
  static const Curve iconScaleCurve = Curves.elasticOut;
  static const double iconScaleStart = 1.0;
  static const double iconScaleEnd = 0.8;
  
  // Configuración de transiciones de botones
  static const Duration buttonFadeDuration = Duration(milliseconds: 250);
  static const Curve buttonFadeCurve = Curves.easeInOut;
  static const double buttonFadeStart = 1.0;
  static const double buttonFadeEnd = 0.0;
  
  // Configuración de transiciones de navegación
  static const Duration navigationFadeDuration = Duration(milliseconds: 300);
  static const Curve navigationFadeCurve = Curves.easeInOut;
  static const double navigationFadeStart = 1.0;
  static const double navigationFadeEnd = 0.0;
}

/// Configuración para efectos de transición específicos de diarios
class DiaryTransitionEffectsConfig {
  // Efectos de slide para HomeScreen
  static const Offset homeSlideLeft = Offset(-0.3, 0.0);
  static const Offset homeSlideRight = Offset(0.3, 0.0);
  static const Offset homeSlideUp = Offset(0.0, -0.2);
  static const Offset homeSlideDown = Offset(0.0, 0.2);
  
  // Efectos de slide para DiaryScreen
  static const Offset diarySlideFromRight = Offset(1.0, 0.0);
  static const Offset diarySlideFromLeft = Offset(-1.0, 0.0);
  static const Offset diarySlideFromTop = Offset(0.0, -1.0);
  static const Offset diarySlideFromBottom = Offset(0.0, 1.0);
  
  // Efectos de escala para diarios
  static const double diaryScaleSubtle = 0.98;
  static const double diaryScaleNormal = 1.0;
  static const double diaryScaleEmphasis = 1.02;
  static const double diaryScaleBounce = 1.05;
  
  // Efectos de opacidad para cards
  static const double cardsOpacityFull = 1.0;
  static const double cardsOpacityVisible = 0.7;
  static const double cardsOpacitySubtle = 0.3;
  static const double cardsOpacityInvisible = 0.0;
  
  // Efectos de profundidad para HomeScreen
  static const double homeDepthNormal = 1.0;
  static const double homeDepthSubtle = 0.95;
  static const double homeDepthMedium = 0.9;
  static const double homeDepthDeep = 0.85;
}

/// Configuración para secuencias de animación de diarios
class DiaryAnimationSequenceConfig {
  // Secuencia de transición a diarios
  static const List<Map<String, dynamic>> diaryTransitionSequence = [
    {
      'name': 'cards_fade',
      'delay': Duration(milliseconds: 100),
      'duration': Duration(milliseconds: 400),
      'type': 'fade_out',
      'target': 'emotion_cards',
    },
    {
      'name': 'home_slide',
      'delay': Duration(milliseconds: 200),
      'duration': Duration(milliseconds: 600),
      'type': 'slide_left',
      'target': 'home_screen',
    },
    {
      'name': 'diary_appear',
      'delay': Duration(milliseconds: 300),
      'duration': Duration(milliseconds: 500),
      'type': 'slide_fade_scale',
      'target': 'diary_screen',
    },
  ];
  
  // Secuencia de regreso desde diarios
  static const List<Map<String, dynamic>> diaryReturnSequence = [
    {
      'name': 'diary_exit',
      'delay': Duration(milliseconds: 0),
      'duration': Duration(milliseconds: 400),
      'type': 'slide_fade_scale',
      'target': 'diary_screen',
    },
    {
      'name': 'home_return',
      'delay': Duration(milliseconds: 200),
      'duration': Duration(milliseconds: 500),
      'type': 'slide_right',
      'target': 'home_screen',
    },
    {
      'name': 'cards_return',
      'delay': Duration(milliseconds: 400),
      'duration': Duration(milliseconds: 300),
      'type': 'fade_in',
      'target': 'emotion_cards',
    },
  ];
  
  // Secuencia completa de transición
  static const List<Map<String, dynamic>> completeDiarySequence = [
    {
      'name': 'preparation',
      'delay': Duration(milliseconds: 0),
      'duration': Duration(milliseconds: 100),
      'type': 'setup',
    },
    {
      'name': 'cards_fade_out',
      'delay': Duration(milliseconds: 100),
      'duration': Duration(milliseconds: 400),
      'type': 'fade_out',
    },
    {
      'name': 'home_slide_left',
      'delay': Duration(milliseconds: 200),
      'duration': Duration(milliseconds: 600),
      'type': 'slide_left',
    },
    {
      'name': 'diary_slide_right',
      'delay': Duration(milliseconds: 300),
      'duration': Duration(milliseconds: 500),
      'type': 'slide_fade_scale',
    },
    {
      'name': 'finalization',
      'delay': Duration(milliseconds: 800),
      'duration': Duration(milliseconds: 100),
      'type': 'cleanup',
    },
  ];
}

/// Configuración para efectos de profundidad y perspectiva
class DiaryDepthEffectsConfig {
  // Efectos de profundidad para HomeScreen
  static const double homeMaxDepth = 20.0;
  static const double homeMinDepth = 0.0;
  static const Duration homeDepthDuration = Duration(milliseconds: 600);
  static const Curve homeDepthCurve = Curves.easeInOutCubic;
  
  // Efectos de profundidad para DiaryScreen
  static const double diaryMaxDepth = 0.0;
  static const double diaryMinDepth = -10.0;
  static const Duration diaryDepthDuration = Duration(milliseconds: 500);
  static const Curve diaryDepthCurve = Curves.easeOutCubic;
  
  // Efectos de escala para profundidad
  static const double depthScaleFactor = 0.98;
  static const Duration depthScaleDuration = Duration(milliseconds: 400);
  static const Curve depthScaleCurve = Curves.easeInOutCubic;
  
  // Efectos de sombra para profundidad
  static const double depthShadowBlur = 15.0;
  static const Offset depthShadowOffset = Offset(0, 10);
  static const double depthShadowOpacity = 0.2;
  static const Duration depthShadowDuration = Duration(milliseconds: 500);
}

/// Configuración para transiciones de elementos específicos
class DiaryElementTransitionConfig {
  // Transiciones de cards de emociones
  static const Duration emotionCardFadeDuration = Duration(milliseconds: 300);
  static const Curve emotionCardFadeCurve = Curves.easeInOutCubic;
  static const double emotionCardFadeStart = 1.0;
  static const double emotionCardFadeEnd = 0.3;
  
  // Transiciones de iconos de navegación
  static const Duration navigationIconDuration = Duration(milliseconds: 200);
  static const Curve navigationIconCurve = Curves.easeInOutCubic;
  static const double navigationIconScaleStart = 1.0;
  static const double navigationIconScaleEnd = 0.9;
  
  // Transiciones de texto de navegación
  static const Duration navigationTextDuration = Duration(milliseconds: 250);
  static const Curve navigationTextCurve = Curves.easeInOutCubic;
  static const double navigationTextFadeStart = 1.0;
  static const double navigationTextFadeEnd = 0.0;
  
  // Transiciones de botones de acción
  static const Duration actionButtonDuration = Duration(milliseconds: 200);
  static const Curve actionButtonCurve = Curves.easeInOutCubic;
  static const double actionButtonScaleStart = 1.0;
  static const double actionButtonScaleEnd = 0.95;
}
