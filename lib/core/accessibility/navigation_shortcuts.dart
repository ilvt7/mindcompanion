import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Global navigation shortcuts and actions
class NavigationShortcuts {
  /// Define all keyboard shortcuts
  static Map<LogicalKeySet, Intent> get shortcuts {
    return {
      // Navigation shortcuts
      LogicalKeySet(LogicalKeyboardKey.keyH): const NavigateIntent('/home'),
      LogicalKeySet(LogicalKeyboardKey.keyD): const NavigateIntent('/ai-diary'),
      LogicalKeySet(LogicalKeyboardKey.keyP): const NavigateIntent('/personal-diary'),
      LogicalKeySet(LogicalKeyboardKey.keyS): const NavigateIntent('/settings'),
      LogicalKeySet(LogicalKeyboardKey.keyC): const NavigateIntent('/crisis'),
      LogicalKeySet(LogicalKeyboardKey.keyM): const NavigateIntent('/meditations'),
      LogicalKeySet(LogicalKeyboardKey.keyE): const NavigateIntent('/emotional-history'),
      
      // Accessibility shortcuts
      LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.keyA): const ToggleAccessibilityIntent(),
      LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.keyT): const ToggleThemeIntent(),
      LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.keyR): const ToggleReduceMotionIntent(),
      
      // Action shortcuts
      LogicalKeySet(LogicalKeyboardKey.escape): const CloseModalIntent(),
      LogicalKeySet(LogicalKeyboardKey.enter): const ConfirmActionIntent(),
      LogicalKeySet(LogicalKeyboardKey.space): const TogglePlayPauseIntent(),
    };
  }
  
  /// Define all actions
  static Map<Type, Action<Intent>> get actions {
    return {
      NavigateIntent: NavigateAction(),
      ToggleAccessibilityIntent: ToggleAccessibilityAction(),
      ToggleThemeIntent: ToggleThemeAction(),
      ToggleReduceMotionIntent: ToggleReduceMotionAction(),
      CloseModalIntent: CloseModalAction(),
      ConfirmActionIntent: ConfirmActionAction(),
      TogglePlayPauseIntent: TogglePlayPauseAction(),
    };
  }
  
  /// Get help text for all shortcuts
  static List<String> get helpTexts {
    return [
      'H - Ir al inicio',
      'D - Diario con IA',
      'P - Diario personal',
      'S - Configuración',
      'C - Modo crisis',
      'M - Meditaciones',
      'E - Historial emocional',
      'Alt+A - Alternar accesibilidad',
      'Alt+T - Alternar tema',
      'Alt+R - Alternar animaciones',
      'Escape - Cerrar modal',
      'Enter - Confirmar acción',
      'Espacio - Reproducir/Pausar',
    ];
  }
}

/// Intent for navigation actions
class NavigateIntent extends Intent {
  final String route;
  
  const NavigateIntent(this.route);
}

/// Intent for toggling accessibility
class ToggleAccessibilityIntent extends Intent {
  const ToggleAccessibilityIntent();
}

/// Intent for toggling theme
class ToggleThemeIntent extends Intent {
  const ToggleThemeIntent();
}

/// Intent for toggling reduce motion
class ToggleReduceMotionIntent extends Intent {
  const ToggleReduceMotionIntent();
}

/// Intent for closing modals
class CloseModalIntent extends Intent {
  const CloseModalIntent();
}

/// Intent for confirming actions
class ConfirmActionIntent extends Intent {
  const ConfirmActionIntent();
}

/// Intent for toggling play/pause
class TogglePlayPauseIntent extends Intent {
  const TogglePlayPauseIntent();
}

/// Action for navigation
class NavigateAction extends Action<NavigateIntent> {
  @override
  Object? invoke(NavigateIntent intent) {
    // This would be implemented with proper navigation service
    // For now, just return null
    return null;
  }
}

/// Action for toggling accessibility
class ToggleAccessibilityAction extends Action<ToggleAccessibilityIntent> {
  @override
  Object? invoke(ToggleAccessibilityIntent intent) {
    // This would be implemented with the appropriate provider
    // For now, just return null
    return null;
  }
}

/// Action for toggling theme
class ToggleThemeAction extends Action<ToggleThemeIntent> {
  @override
  Object? invoke(ToggleThemeIntent intent) {
    // This would be implemented with the appropriate provider
    // For now, just return null
    return null;
  }
}

/// Action for toggling reduce motion
class ToggleReduceMotionAction extends Action<ToggleReduceMotionIntent> {
  @override
  Object? invoke(ToggleReduceMotionIntent intent) {
    // This would be implemented with the appropriate provider
    // For now, just return null
    return null;
  }
}

/// Action for closing modals
class CloseModalAction extends Action<CloseModalIntent> {
  @override
  Object? invoke(CloseModalIntent intent) {
    // This would be implemented with proper navigation service
    // For now, just return null
    return null;
  }
}

/// Action for confirming actions
class ConfirmActionAction extends Action<ConfirmActionIntent> {
  @override
  Object? invoke(ConfirmActionIntent intent) {
    // This would be implemented based on the current context
    // For now, just return null
    return null;
  }
}

/// Action for toggling play/pause
class TogglePlayPauseAction extends Action<TogglePlayPauseIntent> {
  @override
  Object? invoke(TogglePlayPauseIntent intent) {
    // This would be implemented with TTS service
    // For now, just return null
    return null;
  }
}

/// Gesture detector for accessibility gestures
class AccessibilityGestureDetector extends StatelessWidget {
  final Widget child;
  final VoidCallback? onSwipeDown;
  final VoidCallback? onSwipeUp;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;

  const AccessibilityGestureDetector({
    super.key,
    required this.child,
    this.onSwipeDown,
    this.onSwipeUp,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.onDoubleTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanEnd: (details) {
        final velocity = details.velocity.pixelsPerSecond;
        final speed = velocity.distance;
        
        if (speed > 100) { // Minimum speed threshold
          if (velocity.dy > 0 && onSwipeDown != null) {
            onSwipeDown!();
          } else if (velocity.dy < 0 && onSwipeUp != null) {
            onSwipeUp!();
          } else if (velocity.dx > 0 && onSwipeLeft != null) {
            onSwipeLeft!();
          } else if (velocity.dx < 0 && onSwipeRight != null) {
            onSwipeRight!();
          }
        }
      },
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      child: child,
    );
  }
}

/// Widget for showing keyboard shortcuts help
class KeyboardShortcutsHelp extends StatelessWidget {
  const KeyboardShortcutsHelp({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Atajos de Teclado'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: NavigationShortcuts.helpTexts.map((text) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(text),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}
