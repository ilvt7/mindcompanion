# Transiciones de Configuración - MindCompanion

## Descripción

Este módulo implementa transiciones personalizadas para pantallas de configuración y política en la aplicación MindCompanion. Las transiciones incluyen efectos coordinados entre el HomeScreen y las pantallas de configuración, con animaciones secuenciales para elementos internos.

## Características

### Transición Principal
- **HomeScreen**: Fade-out suave con efecto de sombra
- **Settings/PrivacyPolicyScreen**: Fade-in desde abajo con micro-bounce
- **Duración**: 750ms (configurable)
- **Curvas**: Personalizables para diferentes tipos de transición

### Animaciones de Elementos Internos
- **Títulos**: Fade-in con escala y micro-bounce
- **Subtítulos**: Animación escalonada con delay
- **Botones**: Aparecen secuencialmente con efecto de rebote
- **Controles**: Switches y otros elementos con animación suave

## Archivos del Sistema

### 1. Configuración (`lib/config/settings_transition_config.dart`)
- `SettingsTransitionConfig`: Parámetros de animación
- `SettingsTransitionSettings`: Configuraciones predefinidas
- `SettingsVisualEffects`: Efectos visuales adicionales
- `SettingsElementsConfig`: Configuración de elementos internos

### 2. Wrapper Widgets (`lib/widgets/settings_transition_wrapper.dart`)
- `AnimatedTextWrapper`: Para títulos y subtítulos
- `AnimatedButtonWrapper`: Para botones y acciones
- `AnimatedControlWrapper`: Para switches y controles
- `SettingsScreenWrapper`: Wrapper principal de pantalla
- `SettingsTransitionCoordinator`: Coordinador de transición

### 3. Transiciones (`lib/widgets/custom_page_transitions.dart`)
- `settingsTransition`: Transición principal de configuración
- `pushSettingsScreen`: Método de navegación personalizado

### 4. Ejemplos (`lib/examples/settings_transition_example.dart`)
- `SettingsTransitionExample`: Demostración completa
- `SimpleSettingsTransitionExample`: Ejemplo básico

## Uso

### Navegación Básica
```dart
// Usar el método personalizado
CustomNavigator.pushSettingsScreen(
  context,
  const SettingsScreen(),
);

// O navegar por nombre de ruta (usa transición automáticamente)
Navigator.pushNamed(context, '/settings');
```

### Wrapper de Elementos
```dart
// Título con animación
AnimatedTextWrapper(
  delay: SettingsElementsConfig.titleDelay,
  child: const Text(
    'Configuración',
    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
  ),
);

// Botón con animación
AnimatedButtonWrapper(
  delay: SettingsElementsConfig.firstButtonDelay,
  child: ElevatedButton(
    onPressed: () {},
    child: const Text('Guardar'),
  ),
);

// Control con animación
AnimatedControlWrapper(
  delay: SettingsElementsConfig.additionalElementsDelay,
  child: Switch(
    value: true,
    onChanged: (value) {},
  ),
);
```

### Configuraciones Predefinidas
```dart
// Transición suave y elegante
SettingsScreenWrapper(
  settings: SettingsTransitionSettings.smooth,
  child: const SettingsScreen(),
);

// Transición rápida y directa
SettingsScreenWrapper(
  settings: SettingsTransitionSettings.quick,
  child: const SettingsScreen(),
);

// Transición dramática con efectos exagerados
SettingsScreenWrapper(
  settings: SettingsTransitionSettings.dramatic,
  child: const SettingsScreen(),
);
```

## Configuración Personalizada

### Parámetros de Animación
```dart
class CustomSettingsConfig {
  static const Duration totalDuration = Duration(milliseconds: 1000);
  static const Curve homeFadeCurve = Curves.easeInOutCubic;
  static const Curve settingsSlideCurve = Curves.easeOutBack;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve elementsCurve = Curves.bounceOut;
}

final customSettings = SettingsTransitionSettings(
  totalDuration: CustomSettingsConfig.totalDuration,
  homeFadeCurve: CustomSettingsConfig.homeFadeCurve,
  settingsSlideCurve: CustomSettingsConfig.settingsSlideCurve,
  bounceCurve: CustomSettingsConfig.bounceCurve,
  elementsCurve: CustomSettingsConfig.elementsCurve,
);
```

### Delays Personalizados
```dart
// Configurar delays personalizados para elementos
const customDelays = [
  Duration(milliseconds: 50),   // Título
  Duration(milliseconds: 100),  // Subtítulo
  Duration(milliseconds: 150),  // Primer botón
  Duration(milliseconds: 200),  // Segundo botón
  Duration(milliseconds: 250),  // Controles
];

// Usar en los wrappers
AnimatedTextWrapper(
  delay: customDelays[0],
  child: const Text('Título'),
);
```

## Integración con Navegación

### Rutas Automáticas
Las siguientes rutas usan automáticamente la transición de configuración:
- `/settings` → `SettingsScreen`
- `/privacy-policy` → `PrivacyPolicyScreen`

### Rutas de Demostración
- `/settings-transition-demo` → `SettingsTransitionExample`

## Personalización Avanzada

### Efectos Visuales Adicionales
```dart
// Añadir efectos de profundidad
Container(
  decoration: BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(
          SettingsVisualEffects.depthShadowOpacity,
        ),
        blurRadius: SettingsVisualEffects.depthShadowBlurRadius,
        offset: SettingsVisualEffects.depthShadowOffset,
      ),
    ],
  ),
  child: child,
);

// Añadir efectos de desenfoque
ImageFiltered(
  imageFilter: ImageFilter.blur(
    sigmaX: SettingsVisualEffects.blurSigma,
    sigmaY: SettingsVisualEffects.blurSigma,
  ),
  child: child,
);
```

### Animaciones de Escala y Rotación
```dart
// Efectos de escala para HomeScreen
Transform.scale(
  scale: Tween<double>(
    begin: SettingsVisualEffects.homeScaleStart,
    end: SettingsVisualEffects.homeScaleEnd,
  ).animate(animation),
  child: homeScreen,
);

// Efectos de rotación sutil
Transform.rotate(
  angle: Tween<double>(
    begin: SettingsVisualEffects.homeRotationStart,
    end: SettingsVisualEffects.homeRotationEnd,
  ).animate(animation),
  child: homeScreen,
);
```

## Consideraciones de Rendimiento

### Optimizaciones
- **TickerProvider**: Uso correcto de `SingleTickerProviderStateMixin`
- **Dispose**: Limpieza adecuada de `AnimationController`s
- **Mounted Check**: Verificación de estado antes de animar
- **Curvas Eficientes**: Uso de curvas optimizadas para rendimiento

### Monitoreo
```dart
// Verificar rendimiento de animaciones
void _monitorPerformance() {
  final stopwatch = Stopwatch()..start();
  
  _controller.forward().then((_) {
    stopwatch.stop();
    print('Animación completada en: ${stopwatch.elapsedMilliseconds}ms');
  });
}
```

## Solución de Problemas

### Errores Comunes
1. **AnimationController no inicializado**: Verificar `initState()`
2. **TickerProvider faltante**: Añadir mixin apropiado
3. **Dispose no llamado**: Limpiar controllers en `dispose()`
4. **Mounted check faltante**: Verificar estado antes de animar

### Debug
```dart
// Habilitar logs de debug
void _debugAnimation() {
  _controller.addStatusListener((status) {
    print('Estado de animación: $status');
  });
  
  _controller.addListener(() {
    print('Valor de animación: ${_controller.value}');
  });
}
```

## Dependencias

### Flutter Core
- `flutter/material.dart`
- `flutter/foundation.dart`

### Paquetes Externos
- No se requieren paquetes adicionales

## Compatibilidad

- **Flutter**: 3.0.0+
- **Dart**: 2.17.0+
- **Plataformas**: Android, iOS, Web, Windows, macOS, Linux

## Licencia

Este código es parte del proyecto MindCompanion y está sujeto a los mismos términos de licencia.
