import 'package:flutter/material.dart';

/// Configuración para transiciones de modo crisis
/// Define duraciones, curvas y parámetros de animación para crear
/// transiciones suaves y coordinadas entre HomeScreen y CrisisModeScreen
class CrisisTransitionConfig {
  // ===== DURACIONES DE ANIMACIÓN =====

  /// Duración total de la transición completa
  static const Duration totalTransitionDuration = Duration(milliseconds: 800);

  /// Duración del slide hacia arriba del HomeScreen
  static const Duration homeSlideUpDuration = Duration(milliseconds: 400);

  /// Duración de la animación de blur
  static const Duration blurAnimationDuration = Duration(milliseconds: 300);

  /// Duración de la animación de profundidad
  static const Duration depthAnimationDuration = Duration(milliseconds: 350);

  /// Duración individual de cada botón de crisis
  static const Duration buttonIndividualDuration = Duration(milliseconds: 250);

  /// Duración del efecto de pulso de emergencia
  static const Duration emergencyPulseDuration = Duration(milliseconds: 1200);

  // ===== DELAYS Y TIMING =====

  /// Delay antes de iniciar el slide hacia arriba del HomeScreen
  static const Duration homeSlideUpDelay = Duration(milliseconds: 100);

  /// Delay antes de iniciar las animaciones de botones
  static const Duration buttonsStartDelay = Duration(milliseconds: 200);

  /// Delay escalonado entre cada botón de crisis
  static const Duration buttonStaggerDelay = Duration(milliseconds: 80);

  // ===== CURVAS DE ANIMACIÓN =====

  /// Curva para la transición general de crisis
  static const Curve crisisCurve = Curves.easeInOutCubic;

  /// Curva para el slide hacia arriba del HomeScreen
  static const Curve homeSlideUpCurve = Curves.easeOutCubic;

  /// Curva para la animación de blur
  static const Curve blurAnimationCurve = Curves.easeInOut;

  /// Curva para la escala de profundidad
  static const Curve depthScaleCurve = Curves.easeOutCubic;

  /// Curva para animaciones individuales de botones
  static const Curve buttonIndividualCurve = Curves.elasticOut;

  /// Curva para la opacidad de botones
  static const Curve buttonFadeCurve = Curves.easeInOut;

  /// Curva para el efecto de pulso de emergencia
  static const Curve emergencyPulseCurve = Curves.easeInOut;

  // ===== PARÁMETROS DE SLIDE Y MOVIMIENTO =====

  /// Offset del slide hacia arriba del HomeScreen (negativo = hacia arriba)
  static const double homeSlideUpOffset = -0.15;

  /// Offset inicial del slide de CrisisModeScreen
  static const Offset crisisSlideOffset = Offset(0.0, 0.3);

  // ===== PARÁMETROS DE ESCALA =====

  /// Escala máxima de profundidad para el HomeScreen
  static const double maxDepthScale = 0.95;

  /// Escala inicial del CrisisModeScreen
  static const double crisisScaleStart = 0.8;

  /// Escala final del CrisisModeScreen
  static const double crisisScaleEnd = 1.0;

  /// Escala inicial del bounce de botones
  static const double buttonBounceStart = 0.7;

  /// Escala final del bounce de botones
  static const double buttonBounceEnd = 1.0;

  /// Escala inicial del pulso de emergencia
  static const double emergencyPulseStart = 0.95;

  /// Escala final del pulso de emergencia
  static const double emergencyPulseEnd = 1.05;

  // ===== PARÁMETROS DE BLUR =====

  /// Radio mínimo de blur para el HomeScreen
  static const double minBlurRadius = 0.0;

  /// Radio máximo de blur para el HomeScreen
  static const double maxBlurRadius = 8.0;

  // ===== PARÁMETROS DE OPACIDAD =====

  /// Opacidad inicial de los botones de crisis
  static const double buttonOpacityStart = 0.0;

  /// Opacidad final de los botones de crisis
  static const double buttonOpacityEnd = 1.0;

  // ===== PARÁMETROS DE SOMBRAS =====

  /// Opacidad de la sombra durante la transición
  static const double transitionShadowOpacity = 0.15;

  /// Radio de blur de la sombra de transición
  static const double transitionShadowBlur = 20.0;

  /// Offset de la sombra de transición
  static const Offset transitionShadowOffset = Offset(0, 10);

  /// Opacidad de la sombra de profundidad
  static const double depthShadowOpacity = 0.2;

  /// Radio de blur de la sombra de profundidad
  static const double depthShadowBlur = 15.0;

  /// Offset de la sombra de profundidad
  static const Offset depthShadowOffset = Offset(0, 8);

  /// Opacidad de la sombra de los botones
  static const double buttonShadowOpacity = 0.25;

  /// Radio de blur de la sombra de los botones
  static const double buttonShadowBlur = 12.0;

  /// Offset de la sombra de los botones
  static const Offset buttonShadowOffset = Offset(0, 6);

  // ===== PARÁMETROS DE OFFSET =====

  /// Offset máximo de profundidad
  static const double maxDepthOffset = 0.0;

  // ===== CONFIGURACIONES ESPECÍFICAS =====

  /// Configuración para transición rápida de crisis
  static const CrisisTransitionSettings quickCrisis = CrisisTransitionSettings(
    totalDuration: Duration(milliseconds: 600),
    homeSlideUpDuration: Duration(milliseconds: 300),
    blurDuration: Duration(milliseconds: 200),
    buttonStaggerDelay: Duration(milliseconds: 60),
  );

  /// Configuración para transición suave de crisis
  static const CrisisTransitionSettings smoothCrisis = CrisisTransitionSettings(
    totalDuration: Duration(milliseconds: 1000),
    homeSlideUpDuration: Duration(milliseconds: 500),
    blurDuration: Duration(milliseconds: 400),
    buttonStaggerDelay: Duration(milliseconds: 100),
  );

  /// Configuración para transición dramática de crisis
  static const CrisisTransitionSettings dramaticCrisis =
      CrisisTransitionSettings(
        totalDuration: Duration(milliseconds: 1200),
        homeSlideUpDuration: Duration(milliseconds: 600),
        blurDuration: Duration(milliseconds: 500),
        buttonStaggerDelay: Duration(milliseconds: 120),
      );
}

/// Configuración personalizable para transiciones de crisis
class CrisisTransitionSettings {
  final Duration totalDuration;
  final Duration homeSlideUpDuration;
  final Duration blurDuration;
  final Duration buttonStaggerDelay;

  const CrisisTransitionSettings({
    required this.totalDuration,
    required this.homeSlideUpDuration,
    required this.blurDuration,
    required this.buttonStaggerDelay,
  });
}

/// Configuración para efectos visuales específicos
class CrisisVisualEffects {
  /// Configuración para efecto de emergencia
  static const EmergencyEffectConfig emergency = EmergencyEffectConfig(
    pulseColor: Colors.red,
    pulseIntensity: 0.8,
    glowRadius: 15.0,
  );

  /// Configuración para efecto de calma
  static const EmergencyEffectConfig calm = EmergencyEffectConfig(
    pulseColor: Colors.blue,
    pulseIntensity: 0.4,
    glowRadius: 8.0,
  );

  /// Configuración para efecto de apoyo
  static const EmergencyEffectConfig support = EmergencyEffectConfig(
    pulseColor: Colors.green,
    pulseIntensity: 0.6,
    glowRadius: 12.0,
  );
}

/// Configuración para efectos de emergencia
class EmergencyEffectConfig {
  final Color pulseColor;
  final double pulseIntensity;
  final double glowRadius;

  const EmergencyEffectConfig({
    required this.pulseColor,
    required this.pulseIntensity,
    required this.glowRadius,
  });
}

/// Configuración para transiciones de botones específicos
class CrisisButtonTransitionConfig {
  /// Botón de contacto de emergencia
  static const ButtonConfig emergencyContact = ButtonConfig(
    bounceIntensity: 1.2,
    fadeDelay: Duration(milliseconds: 0),
    scaleCurve: Curves.elasticOut,
  );

  /// Botón de respiración
  static const ButtonConfig breathing = ButtonConfig(
    bounceIntensity: 1.1,
    fadeDelay: Duration(milliseconds: 80),
    scaleCurve: Curves.easeOutCubic,
  );

  /// Botón de ejercicios
  static const ButtonConfig exercises = ButtonConfig(
    bounceIntensity: 1.15,
    fadeDelay: Duration(milliseconds: 160),
    scaleCurve: Curves.easeOutBack,
  );

  /// Botón de recursos
  static const ButtonConfig resources = ButtonConfig(
    bounceIntensity: 1.1,
    fadeDelay: Duration(milliseconds: 240),
    scaleCurve: Curves.easeOutCubic,
  );
}

/// Configuración para un botón específico
class ButtonConfig {
  final double bounceIntensity;
  final Duration fadeDelay;
  final Curve scaleCurve;

  const ButtonConfig({
    required this.bounceIntensity,
    required this.fadeDelay,
    required this.scaleCurve,
  });
}
