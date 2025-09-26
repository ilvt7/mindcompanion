import 'package:flutter/material.dart';

/// Configuración para transiciones del historial emocional
/// Define duraciones, curvas y parámetros de animación para crear
/// transiciones suaves y coordinadas entre HomeScreen y EmotionalHistoryScreen
class EmotionalHistoryTransitionConfig {
  // ===== DURACIONES DE ANIMACIÓN =====

  /// Duración total de la transición completa
  static const Duration totalTransitionDuration = Duration(milliseconds: 900);

  /// Duración del slide lateral del HomeScreen
  static const Duration homeSlideDuration = Duration(milliseconds: 600);

  /// Duración del slide lateral del EmotionalHistoryScreen
  static const Duration historySlideDuration = Duration(milliseconds: 700);

  /// Duración del fade del calendario
  static const Duration calendarFadeDuration = Duration(milliseconds: 500);

  /// Duración del fade de las entradas
  static const Duration entriesFadeDuration = Duration(milliseconds: 600);

  /// Duración individual de cada entrada
  static const Duration entryIndividualDuration = Duration(milliseconds: 300);

  /// Duración del fade del HomeScreen
  static const Duration homeFadeDuration = Duration(milliseconds: 500);

  // ===== DELAYS Y TIMING =====

  /// Delay antes de iniciar la animación del calendario
  static const Duration calendarStartDelay = Duration(milliseconds: 200);

  /// Delay antes de iniciar las animaciones de entradas
  static const Duration entriesStartDelay = Duration(milliseconds: 400);

  /// Delay escalonado entre cada entrada
  static const Duration entryStaggerDelay = Duration(milliseconds: 80);

  // ===== CURVAS DE ANIMACIÓN =====

  /// Curva para la transición general
  static const Curve overallCurve = Curves.easeInOutCubic;

  /// Curva para el slide lateral del HomeScreen
  static const Curve homeSlideCurve = Curves.easeOutCubic;

  /// Curva para el slide lateral del EmotionalHistoryScreen
  static const Curve historySlideCurve = Curves.easeOutCubic;

  /// Curva para el fade del calendario
  static const Curve calendarFadeCurve = Curves.easeInOut;

  /// Curva para la escala del calendario
  static const Curve calendarScaleCurve = Curves.easeOutCubic;

  /// Curva para el fade de las entradas
  static const Curve entriesFadeCurve = Curves.easeInOut;

  /// Curva para el slide de las entradas
  static const Curve entrySlideCurve = Curves.easeOutCubic;

  /// Curva para el fade de las entradas individuales
  static const Curve entryFadeCurve = Curves.easeOut;

  /// Curva para el fade del HomeScreen
  static const Curve homeFadeCurve = Curves.easeInOut;

  /// Curva para el fade del historial (alias para compatibilidad)
  static const Curve historyFadeCurve = homeFadeCurve;

  // ===== PARÁMETROS DE SLIDE Y MOVIMIENTO =====

  /// Offset del slide lateral del HomeScreen (negativo = hacia la izquierda)
  static const double homeSlideOffset = -0.3;

  /// Offset inicial del slide del EmotionalHistoryScreen
  static const Offset historySlideOffset = Offset(1.0, 0.0);

  /// Offset del slide de las entradas
  static const double entrySlideStart = 20.0;
  static const double entrySlideEnd = 0.0;

  // ===== PARÁMETROS DE ESCALA =====

  /// Escala inicial del calendario
  static const double calendarScaleStart = 0.95;

  /// Escala final del calendario
  static const double calendarScaleEnd = 1.0;

  // ===== PARÁMETROS DE OPACIDAD =====

  /// Opacidad inicial del calendario
  static const double calendarFadeStart = 0.0;

  /// Opacidad final del calendario
  static const double calendarFadeEnd = 1.0;

  /// Opacidad inicial de las entradas
  static const double entryFadeStart = 0.0;

  /// Opacidad final de las entradas
  static const double entryFadeEnd = 1.0;

  /// Opacidad inicial de las entradas (alias para compatibilidad)
  static const double entriesFadeStart = entryFadeStart;

  /// Opacidad final de las entradas (alias para compatibilidad)
  static const double entriesFadeEnd = entryFadeEnd;

  /// Opacidad inicial del HomeScreen
  static const double homeFadeStart = 1.0;

  /// Opacidad final del HomeScreen
  static const double homeFadeEnd = 0.7;

  // ===== CONFIGURACIONES ESPECÍFICAS =====

  /// Configuración para transición rápida del historial
  static const EmotionalHistoryTransitionSettings quickHistory =
      EmotionalHistoryTransitionSettings(
        totalDuration: Duration(milliseconds: 700),
        homeSlideDuration: Duration(milliseconds: 400),
        historySlideDuration: Duration(milliseconds: 500),
        calendarFadeDuration: Duration(milliseconds: 300),
        entriesFadeDuration: Duration(milliseconds: 400),
        entryStaggerDelay: Duration(milliseconds: 60),
      );

  /// Configuración para transición suave del historial
  static const EmotionalHistoryTransitionSettings smoothHistory =
      EmotionalHistoryTransitionSettings(
        totalDuration: Duration(milliseconds: 1100),
        homeSlideDuration: Duration(milliseconds: 700),
        historySlideDuration: Duration(milliseconds: 800),
        calendarFadeDuration: Duration(milliseconds: 600),
        entriesFadeDuration: Duration(milliseconds: 700),
        entryStaggerDelay: Duration(milliseconds: 100),
      );

  /// Configuración para transición dramática del historial
  static const EmotionalHistoryTransitionSettings dramaticHistory =
      EmotionalHistoryTransitionSettings(
        totalDuration: Duration(milliseconds: 1300),
        homeSlideDuration: Duration(milliseconds: 800),
        historySlideDuration: Duration(milliseconds: 900),
        calendarFadeDuration: Duration(milliseconds: 700),
        entriesFadeDuration: Duration(milliseconds: 800),
        entryStaggerDelay: Duration(milliseconds: 120),
      );
}

/// Configuración personalizable para transiciones del historial emocional
class EmotionalHistoryTransitionSettings {
  final Duration totalDuration;
  final Duration homeSlideDuration;
  final Duration historySlideDuration;
  final Duration calendarFadeDuration;
  final Duration entriesFadeDuration;
  final Duration entryStaggerDelay;

  const EmotionalHistoryTransitionSettings({
    required this.totalDuration,
    required this.homeSlideDuration,
    required this.historySlideDuration,
    required this.calendarFadeDuration,
    required this.entriesFadeDuration,
    required this.entryStaggerDelay,
  });
}

/// Configuración para efectos visuales específicos del historial
class EmotionalHistoryVisualEffects {
  /// Configuración para efecto de calendario
  static const CalendarEffectConfig calendar = CalendarEffectConfig(
    scaleIntensity: 0.95,
    fadeIntensity: 0.8,
    shadowRadius: 12.0,
  );

  /// Configuración para efecto de entradas
  static const EntryEffectConfig entries = EntryEffectConfig(
    slideIntensity: 20.0,
    fadeIntensity: 0.9,
    staggerIntensity: 80,
  );

  /// Configuración para efecto de HomeScreen
  static const HomeEffectConfig home = HomeEffectConfig(
    slideIntensity: -0.3,
    fadeIntensity: 0.7,
    shadowIntensity: 0.15,
  );
}

/// Configuración para efectos del calendario
class CalendarEffectConfig {
  final double scaleIntensity;
  final double fadeIntensity;
  final double shadowRadius;

  const CalendarEffectConfig({
    required this.scaleIntensity,
    required this.fadeIntensity,
    required this.shadowRadius,
  });
}

/// Configuración para efectos de las entradas
class EntryEffectConfig {
  final double slideIntensity;
  final double fadeIntensity;
  final int staggerIntensity;

  const EntryEffectConfig({
    required this.slideIntensity,
    required this.fadeIntensity,
    required this.staggerIntensity,
  });
}

/// Configuración para efectos del HomeScreen
class HomeEffectConfig {
  final double slideIntensity;
  final double fadeIntensity;
  final double shadowIntensity;

  const HomeEffectConfig({
    required this.slideIntensity,
    required this.fadeIntensity,
    required this.shadowIntensity,
  });
}

/// Configuración para transiciones de elementos específicos del historial
class EmotionalHistoryElementTransitionConfig {
  /// Transiciones del calendario
  static const ElementConfig calendar = ElementConfig(
    fadeDelay: Duration(milliseconds: 200),
    scaleDelay: Duration(milliseconds: 250),
    fadeCurve: Curves.easeInOut,
    scaleCurve: Curves.easeOutCubic,
  );

  /// Transiciones de filtros
  static const ElementConfig filters = ElementConfig(
    fadeDelay: Duration(milliseconds: 300),
    scaleDelay: Duration(milliseconds: 350),
    fadeCurve: Curves.easeInOut,
    scaleCurve: Curves.easeOutCubic,
  );

  /// Transiciones de entradas recientes
  static const ElementConfig recentEntries = ElementConfig(
    fadeDelay: Duration(milliseconds: 400),
    scaleDelay: Duration(milliseconds: 450),
    fadeCurve: Curves.easeInOut,
    scaleCurve: Curves.easeOutCubic,
  );

  /// Transiciones del mapa de calor
  static const ElementConfig heatmap = ElementConfig(
    fadeDelay: Duration(milliseconds: 500),
    scaleDelay: Duration(milliseconds: 550),
    fadeCurve: Curves.easeInOut,
    scaleCurve: Curves.easeOutCubic,
  );
}

/// Configuración para un elemento específico
class ElementConfig {
  final Duration fadeDelay;
  final Duration scaleDelay;
  final Curve fadeCurve;
  final Curve scaleCurve;

  const ElementConfig({
    required this.fadeDelay,
    required this.scaleDelay,
    required this.fadeCurve,
    required this.scaleCurve,
  });
}

/// Configuración para efectos de profundidad del historial
class EmotionalHistoryDepthEffects {
  /// Efecto de profundidad para el calendario
  static const DepthEffectConfig calendarDepth = DepthEffectConfig(
    shadowBlur: 15.0,
    shadowOffset: Offset(0, 8),
    shadowOpacity: 0.2,
    elevation: 4.0,
  );

  /// Efecto de profundidad para las entradas
  static const DepthEffectConfig entriesDepth = DepthEffectConfig(
    shadowBlur: 12.0,
    shadowOffset: Offset(0, 6),
    shadowOpacity: 0.15,
    elevation: 2.0,
  );

  /// Efecto de profundidad para el HomeScreen
  static const DepthEffectConfig homeDepth = DepthEffectConfig(
    shadowBlur: 20.0,
    shadowOffset: Offset(0, 10),
    shadowOpacity: 0.1,
    elevation: 1.0,
  );
}

/// Configuración para efectos de profundidad
class DepthEffectConfig {
  final double shadowBlur;
  final Offset shadowOffset;
  final double shadowOpacity;
  final double elevation;

  const DepthEffectConfig({
    required this.shadowBlur,
    required this.shadowOffset,
    required this.shadowOpacity,
    required this.elevation,
  });
}
