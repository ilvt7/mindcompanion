import 'package:flutter/material.dart';

/// Configuración para transiciones de pantallas de configuración y política
class SettingsTransitionConfig {
  // Duración total de la transición
  static const Duration totalTransitionDuration = Duration(milliseconds: 750);
  
  // Duración de la transición de regreso
  static const Duration reverseTransitionDuration = Duration(milliseconds: 600);
  
  // Configuración del fade-out del HomeScreen
  static const Duration homeFadeOutDuration = Duration(milliseconds: 400);
  static const Curve homeFadeOutCurve = Curves.easeInOut;
  static const double homeFadeOutStart = 1.0;
  static const double homeFadeOutEnd = 0.0;
  
  // Configuración del slide-in del Settings/PrivacyPolicyScreen
  static const Duration settingsSlideInDuration = Duration(milliseconds: 500);
  static const Curve settingsSlideInCurve = Curves.easeOutCubic;
  static const Offset settingsSlideInStart = Offset(0.0, 0.2);
  static const Offset settingsSlideInEnd = Offset.zero;
  
  // Configuración del fade-in del Settings/PrivacyPolicyScreen
  static const Duration settingsFadeInDuration = Duration(milliseconds: 450);
  static const Curve settingsFadeInCurve = Curves.easeOut;
  static const double settingsFadeInStart = 0.0;
  static const double settingsFadeInEnd = 1.0;
  
  // Configuración del micro-bounce del Settings/PrivacyPolicyScreen
  static const Duration settingsBounceDuration = Duration(milliseconds: 600);
  static const Curve settingsBounceCurve = Curves.elasticOut;
  static const double settingsBounceStart = 0.95;
  static const double settingsBounceEnd = 1.0;
  
  // Configuración de la sombra del HomeScreen durante la transición
  static const double homeShadowOpacity = 0.08;
  static const double homeShadowBlurRadius = 15.0;
  static const Offset homeShadowOffset = Offset(0, 8);
  
  // Configuración de elementos internos (texto y botones)
  static const Duration elementsAnimationDuration = Duration(milliseconds: 300);
  static const Curve elementsAnimationCurve = Curves.easeOutBack;
  static const double elementsScaleStart = 0.8;
  static const double elementsScaleEnd = 1.0;
  static const double elementsOpacityStart = 0.0;
  static const double elementsOpacityEnd = 1.0;
  
  // Delays para animaciones secuenciales de elementos
  static const Duration titleDelay = Duration(milliseconds: 150);
  static const Duration subtitleDelay = Duration(milliseconds: 200);
  static const Duration firstButtonDelay = Duration(milliseconds: 250);
  static const Duration secondButtonDelay = Duration(milliseconds: 300);
  static const Duration thirdButtonDelay = Duration(milliseconds: 350);
  static const Duration additionalElementsDelay = Duration(milliseconds: 400);
}

/// Configuraciones predefinidas para diferentes tipos de transiciones
class SettingsTransitionSettings {
  // Transición suave y elegante
  static const SettingsTransitionSettings smooth = SettingsTransitionSettings(
    totalDuration: Duration(milliseconds: 800),
    homeFadeCurve: Curves.easeInOut,
    settingsSlideCurve: Curves.easeOutCubic,
    bounceCurve: Curves.elasticOut,
    elementsCurve: Curves.easeOutBack,
  );
  
  // Transición rápida y directa
  static const SettingsTransitionSettings quick = SettingsTransitionSettings(
    totalDuration: Duration(milliseconds: 500),
    homeFadeCurve: Curves.easeIn,
    settingsSlideCurve: Curves.easeOut,
    bounceCurve: Curves.easeOut,
    elementsCurve: Curves.easeOut,
  );
  
  // Transición dramática con efectos exagerados
  static const SettingsTransitionSettings dramatic = SettingsTransitionSettings(
    totalDuration: Duration(milliseconds: 1000),
    homeFadeCurve: Curves.easeInOutCubic,
    settingsSlideCurve: Curves.easeOutBack,
    bounceCurve: Curves.elasticOut,
    elementsCurve: Curves.bounceOut,
  );
  
  final Duration totalDuration;
  final Curve homeFadeCurve;
  final Curve settingsSlideCurve;
  final Curve bounceCurve;
  final Curve elementsCurve;
  
  const SettingsTransitionSettings({
    required this.totalDuration,
    required this.homeFadeCurve,
    required this.settingsSlideCurve,
    required this.bounceCurve,
    required this.elementsCurve,
  });
}

/// Efectos visuales para la transición de configuración
class SettingsVisualEffects {
  // Efecto de profundidad para el HomeScreen
  static const double depthShadowOpacity = 0.12;
  static const double depthShadowBlurRadius = 20.0;
  static const Offset depthShadowOffset = Offset(0, 12);
  
  // Efecto de desenfoque para el HomeScreen
  static const double blurSigma = 3.0;
  
  // Efecto de escala para el HomeScreen
  static const double homeScaleStart = 1.0;
  static const double homeScaleEnd = 0.98;
  
  // Efecto de rotación sutil para el HomeScreen
  static const double homeRotationStart = 0.0;
  static const double homeRotationEnd = 0.01;
}

/// Configuración de elementos internos de la pantalla de configuración
class SettingsElementsConfig {
  // Configuración del título
  static const Duration titleAnimationDuration = Duration(milliseconds: 400);
  static const Curve titleAnimationCurve = Curves.easeOutBack;
  static const double titleScaleStart = 0.7;
  static const double titleScaleEnd = 1.0;
  static const double titleOpacityStart = 0.0;
  static const double titleOpacityEnd = 1.0;
  
  // Configuración de subtítulos
  static const Duration subtitleAnimationDuration = Duration(milliseconds: 350);
  static const Curve subtitleAnimationCurve = Curves.easeOutBack;
  static const double subtitleScaleStart = 0.8;
  static const double subtitleScaleEnd = 1.0;
  static const double subtitleOpacityStart = 0.0;
  static const double subtitleOpacityEnd = 1.0;
  
  // Configuración de botones
  static const Duration buttonAnimationDuration = Duration(milliseconds: 300);
  static const Curve buttonAnimationCurve = Curves.easeOutBack;
  static const double buttonScaleStart = 0.6;
  static const double buttonScaleEnd = 1.0;
  static const double buttonOpacityStart = 0.0;
  static const double buttonOpacityEnd = 1.0;
  
  // Configuración de switches y otros controles
  static const Duration controlAnimationDuration = Duration(milliseconds: 250);
  static const Curve controlAnimationCurve = Curves.easeOutBack;
  static const double controlScaleStart = 0.8;
  static const double controlScaleEnd = 1.0;
  static const double controlOpacityStart = 0.0;
  static const double controlOpacityEnd = 1.0;
  
  // Delays escalonados para elementos
  static const List<Duration> elementDelays = [
    Duration(milliseconds: 100),  // Título
    Duration(milliseconds: 150),  // Primer subtítulo
    Duration(milliseconds: 200),  // Segundo subtítulo
    Duration(milliseconds: 250),  // Primer botón
    Duration(milliseconds: 300),  // Segundo botón
    Duration(milliseconds: 350),  // Tercer botón
    Duration(milliseconds: 400),  // Primer switch
    Duration(milliseconds: 450),  // Segundo switch
    Duration(milliseconds: 500),  // Otros controles
  ];
}
