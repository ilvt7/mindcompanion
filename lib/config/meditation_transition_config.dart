import 'package:flutter/material.dart';

/// Configuración específica para transiciones de meditaciones
class MeditationTransitionConfig {
  // Duración de las transiciones de meditaciones
  static const Duration meditationTransitionDuration = Duration(milliseconds: 1000);
  static const Duration meditationReverseDuration = Duration(milliseconds: 800);
  static const Duration homeZoomDuration = Duration(milliseconds: 600);
  static const Duration cardsSequentialDuration = Duration(milliseconds: 400);
  
  // Curvas de animación para meditaciones
  static const Curve meditationCurve = Curves.easeOutCubic;
  static const Curve homeZoomCurve = Curves.easeInOutCubic;
  static const Curve cardsSequentialCurve = Curves.easeOutCubic;
  
  // Configuración de efectos visuales para meditaciones
  static const double meditationScaleStart = 0.95;
  static const double meditationScaleEnd = 1.0;
  static const double homeZoomStart = 1.0;
  static const double homeZoomEnd = 0.92;
  static const Offset meditationSlideOffset = Offset(0, 0.5);
  
  // Configuración de timing para secuencias
  static const Duration homeZoomDelay = Duration(milliseconds: 100);
  static const Duration meditationAppearDelay = Duration(milliseconds: 300);
  static const Duration cardsStartDelay = Duration(milliseconds: 500);
  static const Duration cardStaggerDelay = Duration(milliseconds: 100);
  
  // Configuración de transiciones de pantalla
  static const Duration totalTransitionDuration = Duration(milliseconds: 1000);
  static const Duration cardsTotalDuration = Duration(milliseconds: 800);
  
  // Configuración de efectos de zoom y profundidad
  static const double maxZoomOut = 0.92;
  static const double minZoomOut = 0.95;
  static const Duration zoomAnimationDuration = Duration(milliseconds: 600);
  static const Curve zoomAnimationCurve = Curves.easeInOutCubic;
  
  // Configuración de efectos de blur y sombra
  static const double transitionBlurRadius = 8.0;
  static const double transitionShadowOpacity = 0.12;
  static const Offset transitionShadowOffset = Offset(0, 6);
  static const double transitionShadowBlur = 16.0;
  
  // Configuración de colores de transición
  static const Color transitionOverlayColor = Color(0x60000000);
  static const Color meditationBackgroundColor = Color(0xFFFFFFFF);
  static const Color homeBackgroundColor = Color(0xFFF8F9FF);
  
  // Configuración de animaciones de cards
  static const Duration cardSlideDuration = Duration(milliseconds: 400);
  static const Duration cardFadeDuration = Duration(milliseconds: 300);
  static const Curve cardSlideCurve = Curves.easeOutCubic;
  static const Curve cardFadeCurve = Curves.easeInOutCubic;
  
  // Configuración de efectos de profundidad
  static const double maxDepthOffset = 15.0;
  static const double maxDepthScale = 0.97;
  static const Duration depthAnimationDuration = Duration(milliseconds: 400);
  
  // Configuración de transiciones de texto
  static const Duration textFadeDuration = Duration(milliseconds: 250);
  static const Curve textFadeCurve = Curves.easeInOut;
  static const double textFadeStart = 1.0;
  static const double textFadeEnd = 0.0;
  
  // Configuración de transiciones de iconos
  static const Duration iconScaleDuration = Duration(milliseconds: 200);
  static const Curve iconScaleCurve = Curves.elasticOut;
  static const double iconScaleStart = 1.0;
  static const double iconScaleEnd = 0.9;
  
  // Configuración de transiciones de botones
  static const Duration buttonFadeDuration = Duration(milliseconds: 300);
  static const Curve buttonFadeCurve = Curves.easeInOut;
  static const double buttonFadeStart = 1.0;
  static const double buttonFadeEnd = 0.0;
  
  // Configuración de transiciones de navegación
  static const Duration navigationFadeDuration = Duration(milliseconds: 350);
  static const Curve navigationFadeCurve = Curves.easeInOut;
  static const double navigationFadeStart = 1.0;
  static const double navigationFadeEnd = 0.0;
}

/// Configuración para efectos de transición específicos de meditaciones
class MeditationTransitionEffectsConfig {
  // Efectos de zoom para HomeScreen
  static const double homeZoomSubtle = 0.95;
  static const double homeZoomMedium = 0.92;
  static const double homeZoomDeep = 0.88;
  static const double homeZoomNormal = 1.0;
  
  // Efectos de slide para MeditationScreen
  static const Offset meditationSlideFromBottom = Offset(0, 0.5);
  static const Offset meditationSlideFromTop = Offset(0, -0.5);
  static const Offset meditationSlideFromLeft = Offset(-0.5, 0);
  static const Offset meditationSlideFromRight = Offset(0.5, 0);
  
  // Efectos de escala para meditaciones
  static const double meditationScaleSubtle = 0.95;
  static const double meditationScaleNormal = 1.0;
  static const double meditationScaleEmphasis = 1.02;
  static const double meditationScaleBounce = 1.05;
  
  // Efectos de opacidad para elementos
  static const double elementsOpacityFull = 1.0;
  static const double elementsOpacityVisible = 0.8;
  static const double elementsOpacitySubtle = 0.4;
  static const double elementsOpacityInvisible = 0.0;
  
  // Efectos de profundidad para HomeScreen
  static const double homeDepthNormal = 1.0;
  static const double homeDepthSubtle = 0.97;
  static const double homeDepthMedium = 0.94;
  static const double homeDepthDeep = 0.91;
}

/// Configuración para secuencias de animación de meditaciones
class MeditationAnimationSequenceConfig {
  // Secuencia de transición a meditaciones
  static const List<Map<String, dynamic>> meditationTransitionSequence = [
    {
      'name': 'home_zoom',
      'delay': Duration(milliseconds: 100),
      'duration': Duration(milliseconds: 600),
      'type': 'zoom_out',
      'target': 'home_screen',
    },
    {
      'name': 'meditation_appear',
      'delay': Duration(milliseconds: 300),
      'duration': Duration(milliseconds: 500),
      'type': 'fade_slide_scale',
      'target': 'meditation_screen',
    },
    {
      'name': 'cards_sequential',
      'delay': Duration(milliseconds: 500),
      'duration': Duration(milliseconds: 800),
      'type': 'sequential_slide',
      'target': 'meditation_cards',
    },
  ];
  
  // Secuencia de regreso desde meditaciones
  static const List<Map<String, dynamic>> meditationReturnSequence = [
    {
      'name': 'cards_exit',
      'delay': Duration(milliseconds: 0),
      'duration': Duration(milliseconds: 300),
      'type': 'sequential_slide_reverse',
      'target': 'meditation_cards',
    },
    {
      'name': 'meditation_exit',
      'delay': Duration(milliseconds: 200),
      'duration': Duration(milliseconds: 400),
      'type': 'fade_slide_scale_reverse',
      'target': 'meditation_screen',
    },
    {
      'name': 'home_zoom_in',
      'delay': Duration(milliseconds: 400),
      'duration': Duration(milliseconds: 500),
      'type': 'zoom_in',
      'target': 'home_screen',
    },
  ];
  
  // Secuencia completa de transición
  static const List<Map<String, dynamic>> completeMeditationSequence = [
    {
      'name': 'preparation',
      'delay': Duration(milliseconds: 0),
      'duration': Duration(milliseconds: 100),
      'type': 'setup',
    },
    {
      'name': 'home_zoom_out',
      'delay': Duration(milliseconds: 100),
      'duration': Duration(milliseconds: 600),
      'type': 'zoom_out',
    },
    {
      'name': 'meditation_fade_slide',
      'delay': Duration(milliseconds: 300),
      'duration': Duration(milliseconds: 500),
      'type': 'fade_slide_scale',
    },
    {
      'name': 'cards_sequential_entrance',
      'delay': Duration(milliseconds: 500),
      'duration': Duration(milliseconds: 800),
      'type': 'sequential_slide',
    },
    {
      'name': 'finalization',
      'delay': Duration(milliseconds: 1000),
      'duration': Duration(milliseconds: 100),
      'type': 'cleanup',
    },
  ];
}

/// Configuración para efectos de zoom y profundidad
class MeditationZoomEffectsConfig {
  // Efectos de zoom para HomeScreen
  static const double homeMaxZoomOut = 0.92;
  static const double homeMinZoomOut = 0.95;
  static const Duration homeZoomDuration = Duration(milliseconds: 600);
  static const Curve homeZoomCurve = Curves.easeInOutCubic;
  
  // Efectos de zoom para MeditationScreen
  static const double meditationMaxZoomIn = 1.0;
  static const double meditationMinZoomIn = 0.95;
  static const Duration meditationZoomDuration = Duration(milliseconds: 500);
  static const Curve meditationZoomCurve = Curves.easeOutCubic;
  
  // Efectos de escala para zoom
  static const double zoomScaleFactor = 0.97;
  static const Duration zoomScaleDuration = Duration(milliseconds: 500);
  static const Curve zoomScaleCurve = Curves.easeInOutCubic;
  
  // Efectos de sombra para zoom
  static const double zoomShadowBlur = 12.0;
  static const Offset zoomShadowOffset = Offset(0, 8);
  static const double zoomShadowOpacity = 0.18;
  static const Duration zoomShadowDuration = Duration(milliseconds: 600);
}

/// Configuración para transiciones de elementos específicos
class MeditationElementTransitionConfig {
  // Transiciones de cards de meditaciones
  static const Duration meditationCardSlideDuration = Duration(milliseconds: 400);
  static const Curve meditationCardSlideCurve = Curves.easeOutCubic;
  static const Offset meditationCardSlideOffset = Offset(0, 0.3);
  static const double meditationCardSlideEnd = 0.0;
  
  // Transiciones de iconos de meditaciones
  static const Duration meditationIconDuration = Duration(milliseconds: 250);
  static const Curve meditationIconCurve = Curves.easeInOutCubic;
  static const double meditationIconScaleStart = 1.0;
  static const double meditationIconScaleEnd = 0.9;
  
  // Transiciones de texto de meditaciones
  static const Duration meditationTextDuration = Duration(milliseconds: 300);
  static const Curve meditationTextCurve = Curves.easeInOutCubic;
  static const double meditationTextFadeStart = 1.0;
  static const double meditationTextFadeEnd = 0.0;
  
  // Transiciones de botones de meditaciones
  static const Duration meditationButtonDuration = Duration(milliseconds: 250);
  static const Curve meditationButtonCurve = Curves.easeInOutCubic;
  static const double meditationButtonScaleStart = 1.0;
  static const double meditationButtonScaleEnd = 0.95;
}

/// Configuración para animaciones secuenciales de cards
class MeditationCardsSequentialConfig {
  // Configuración de timing para cards secuenciales
  static const Duration cardStaggerDelay = Duration(milliseconds: 100);
  static const Duration cardIndividualDuration = Duration(milliseconds: 400);
  static const Curve cardIndividualCurve = Curves.easeOutCubic;
  
  // Configuración de efectos para cards secuenciales
  static const Offset cardSlideOffset = Offset(0, 0.3);
  static const double cardScaleStart = 0.9;
  static const double cardScaleEnd = 1.0;
  static const double cardOpacityStart = 0.0;
  static const double cardOpacityEnd = 1.0;
  
  // Configuración de profundidad para cards
  static const double cardDepthOffset = 10.0;
  static const double cardDepthScale = 0.98;
  static const Duration cardDepthDuration = Duration(milliseconds: 300);
  
  // Configuración de sombras para cards
  static const double cardShadowBlur = 8.0;
  static const Offset cardShadowOffset = Offset(0, 4);
  static const double cardShadowOpacity = 0.15;
  static const Duration cardShadowDuration = Duration(milliseconds: 400);
}
