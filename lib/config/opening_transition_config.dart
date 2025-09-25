import 'package:flutter/material.dart';

/// Configuración específica para transiciones de apertura de la app
class OpeningTransitionConfig {
  // Duración de las animaciones de apertura
  static const Duration illustrationEntrance = Duration(milliseconds: 1200);
  static const Duration buttonsEntrance = Duration(milliseconds: 600);
  static const Duration backgroundTransition = Duration(milliseconds: 800);
  static const Duration homeScreenTransition = Duration(milliseconds: 1000);
  static const Duration totalOpeningSequence = Duration(milliseconds: 2000);

  // Curvas de animación para apertura
  static const Curve entranceCurve = Curves.easeOutCubic;
  static const Curve transitionCurve = Curves.easeInOutCubic;
  static const Curve exitCurve = Curves.easeInCubic;

  // Configuración de efectos visuales
  static const double maxBlurRadius = 20.0;
  static const double minBackgroundOpacity = 0.3;
  static const double maxButtonScale = 1.1;
  static const double minButtonOpacity = 0.0;

  // Configuración de timing para secuencias
  static const Duration illustrationDelay = Duration(milliseconds: 300);
  static const Duration buttonsDelay = Duration(milliseconds: 800);
  static const Duration backgroundDelay = Duration(milliseconds: 0);
  static const Duration homeScreenDelay = Duration(milliseconds: 800);

  // Configuración de transiciones de pantalla
  static const Duration homeScreenSlideDuration = Duration(milliseconds: 1200);
  static const Duration homeScreenReverseDuration = Duration(milliseconds: 800);
  static const Offset homeScreenSlideOffset = Offset(0, 1.0);
  static const double homeScreenScaleStart = 0.95;

  // Configuración de efectos de blur
  static const double blurSigmaX = 20.0;
  static const double blurSigmaY = 20.0;
  static const Duration blurDuration = Duration(milliseconds: 800);

  // Configuración de fade de fondo
  static const double backgroundFadeStart = 1.0;
  static const double backgroundFadeEnd = 0.3;
  static const Duration backgroundFadeDuration = Duration(milliseconds: 800);

  // Configuración de animaciones de botones
  static const Duration buttonScaleDuration = Duration(milliseconds: 600);
  static const Duration buttonFadeDuration = Duration(milliseconds: 600);
  static const Curve buttonScaleCurve = Curves.easeInOutCubic;
  static const Curve buttonFadeCurve = Curves.easeInOutCubic;

  // Configuración de ilustración
  static const Duration illustrationFadeDuration = Duration(milliseconds: 1200);
  static const Duration illustrationSlideDuration = Duration(
    milliseconds: 1200,
  );
  static const Offset illustrationSlideOffset = Offset(0, 0.3);
  static const Curve illustrationCurve = Curves.easeOutCubic;

  // Configuración de overlay de HomeScreen
  static const Duration overlayFadeDuration = Duration(milliseconds: 1000);
  static const Duration overlaySlideDuration = Duration(milliseconds: 1000);
  static const Curve overlayCurve = Curves.easeOutCubic;

  // Configuración de colores de transición
  static const Color welcomeBackgroundStart = Color(0xFF87CEEB);
  static const Color welcomeBackgroundEnd = Color(0xFFE6E6FA);
  static const Color homeScreenBackground = Color(0xFFFFFFFF);
  static const Color homeScreenIconColor = Color(0xFF87CEEB);
  static const Color homeScreenTextColor = Color(0xFF2D3748);
  static const Color homeScreenSubtextColor = Color(0xFF718096);

  // Configuración de sombras y efectos
  static const double welcomeShadowBlur = 20.0;
  static const Offset welcomeShadowOffset = Offset(0, 10);
  static const double welcomeShadowSpread = 0.0;
  static const double welcomeShadowOpacity = 0.1;

  // Configuración de bordes y espaciado
  static const double welcomeBorderRadius = 60.0;
  static const double welcomeBorderWidth = 2.0;
  static const double welcomeIconSize = 60.0;
  static const double welcomeContainerSize = 120.0;

  // Configuración de tipografía
  static const String welcomeFontFamily = 'Segoe UI';
  static const double welcomeTitleSize = 32.0;
  static const double welcomeSubtitleSize = 18.0;
  static const double welcomeButtonTextSize = 18.0;
  static const double welcomePrivacyTextSize = 16.0;

  // Configuración de botones
  static const double welcomeButtonHeight = 56.0;
  static const double welcomeButtonBorderRadius = 16.0;
  static const double welcomeButtonSpacing = 16.0;
  static const double welcomeButtonElevation = 0.0;

  // Configuración de espaciado general
  static const double welcomePadding = 24.0;
  static const double welcomeSpacing = 40.0;
  static const double welcomeSmallSpacing = 16.0;
  static const double welcomeLargeSpacing = 60.0;
}

/// Configuración para efectos de transición específicos
class TransitionEffectsConfig {
  // Efectos de blur
  static const double lightBlur = 5.0;
  static const double mediumBlur = 10.0;
  static const double heavyBlur = 20.0;

  // Efectos de escala
  static const double subtleScale = 0.95;
  static const double normalScale = 1.0;
  static const double emphasisScale = 1.1;
  static const double bounceScale = 1.2;

  // Efectos de opacidad
  static const double invisible = 0.0;
  static const double subtle = 0.3;
  static const double visible = 0.7;
  static const double full = 1.0;

  // Efectos de offset
  static const Offset slideUp = Offset(0, -0.3);
  static const Offset slideDown = Offset(0, 0.3);
  static const Offset slideLeft = Offset(-0.3, 0);
  static const Offset slideRight = Offset(0.3, 0);
  static const Offset slideFromBottom = Offset(0, 1.0);
  static const Offset slideFromTop = Offset(0, -1.0);
}

/// Configuración para secuencias de animación
class AnimationSequenceConfig {
  // Secuencia de entrada
  static const List<Map<String, dynamic>> entranceSequence = [
    {
      'name': 'illustration',
      'delay': Duration(milliseconds: 300),
      'duration': Duration(milliseconds: 1200),
      'type': 'fade_slide',
    },
    {
      'name': 'buttons',
      'delay': Duration(milliseconds: 800),
      'duration': Duration(milliseconds: 600),
      'type': 'scale_fade',
    },
  ];

  // Secuencia de transición
  static const List<Map<String, dynamic>> transitionSequence = [
    {
      'name': 'background',
      'delay': Duration(milliseconds: 0),
      'duration': Duration(milliseconds: 800),
      'type': 'blur_fade',
    },
    {
      'name': 'home_screen',
      'delay': Duration(milliseconds: 800),
      'duration': Duration(milliseconds: 1000),
      'type': 'slide_fade_scale',
    },
  ];

  // Secuencia completa de apertura
  static const List<Map<String, dynamic>> completeSequence = [
    {
      'name': 'illustration_entrance',
      'delay': Duration(milliseconds: 300),
      'duration': Duration(milliseconds: 1200),
      'type': 'fade_slide',
    },
    {
      'name': 'buttons_entrance',
      'delay': Duration(milliseconds: 800),
      'duration': Duration(milliseconds: 600),
      'type': 'scale_fade',
    },
    {
      'name': 'background_transition',
      'delay': Duration(milliseconds: 0),
      'duration': Duration(milliseconds: 800),
      'type': 'blur_fade',
    },
    {
      'name': 'home_screen_transition',
      'delay': Duration(milliseconds: 800),
      'duration': Duration(milliseconds: 1000),
      'type': 'slide_fade_scale',
    },
  ];
}
