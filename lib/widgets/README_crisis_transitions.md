# Crisis Transition Wrapper Widgets

Este conjunto de widgets proporciona transiciones coordinadas y suaves para el modo crisis de la aplicación MindCompanion. Permite crear efectos visuales sofisticados como slide hacia arriba del HomeScreen con blur, y animaciones secuenciales de botones de crisis.

## 🚀 Características Principales

- **Transiciones Coordinadas**: Coordina múltiples animaciones simultáneamente
- **Efectos de Blur**: Aplica efectos de desenfoque durante las transiciones
- **Animaciones Secuenciales**: Botones que aparecen con timing escalonado
- **Efectos de Profundidad**: Crea sensación de profundidad con escalas y sombras
- **Configuración Flexible**: Parámetros personalizables para diferentes estilos

## 📦 Widgets Disponibles

### 1. CrisisTransitionWrapper
Wrapper principal que maneja la transición del HomeScreen con efectos de slide hacia arriba, blur y profundidad.

```dart
CrisisTransitionWrapper(
  isTransitioning: true,
  onTransitionComplete: () => print('Transición completada'),
  transitionDuration: Duration(milliseconds: 800),
  child: HomeScreen(),
)
```

**Propiedades:**
- `isTransitioning`: Controla si la transición está activa
- `onTransitionComplete`: Callback cuando la transición termina
- `transitionDuration`: Duración personalizada de la transición
- `child`: Widget que se animará (típicamente HomeScreen)

### 2. CrisisButtonsSequentialWrapper
Envuelve los botones de crisis con animaciones secuenciales de bounce y fade.

```dart
CrisisButtonsSequentialWrapper(
  isTransitioning: true,
  transitionDuration: Duration(milliseconds: 250),
  children: [
    CrisisButton1(),
    CrisisButton2(),
    CrisisButton3(),
    CrisisButton4(),
  ],
)
```

**Propiedades:**
- `isTransitioning`: Controla si las animaciones están activas
- `transitionDuration`: Duración individual de cada botón
- `children`: Lista de botones que se animarán secuencialmente

### 3. CrisisTransitionCoordinator
Coordina la transición completa entre HomeScreen y CrisisModeScreen.

```dart
CrisisTransitionCoordinator(
  homeScreen: HomeScreen(),
  crisisScreen: CrisisModeScreen(),
  showCrisis: true,
  onTransitionComplete: () => print('Crisis activado'),
  transitionDuration: Duration(milliseconds: 800),
)
```

**Propiedades:**
- `homeScreen`: Widget del HomeScreen
- `crisisScreen`: Widget del CrisisModeScreen
- `showCrisis`: Controla cuál pantalla mostrar
- `onTransitionComplete`: Callback cuando la transición termina
- `transitionDuration`: Duración total de la transición

### 4. BlurTransitionEffect
Efecto de blur simple para transiciones.

```dart
BlurTransitionEffect(
  isActive: true,
  duration: Duration(milliseconds: 300),
  blurRadius: 12.0,
  child: Widget(),
)
```

### 5. DepthSlideEffect
Efecto de profundidad con slide y escala.

```dart
DepthSlideEffect(
  isActive: true,
  duration: Duration(milliseconds: 400),
  slideOffset: -0.25,
  depthScale: 0.95,
  child: Widget(),
)
```

### 6. EmergencyPulseEffect
Efecto de pulso para elementos de emergencia.

```dart
EmergencyPulseEffect(
  isActive: true,
  duration: Duration(milliseconds: 1200),
  child: EmergencyButton(),
)
```

## ⚙️ Configuración

### CrisisTransitionConfig
Archivo de configuración central que define todos los parámetros de animación:

```dart
// Duración total de la transición
static const Duration totalTransitionDuration = Duration(milliseconds: 800);

// Curva para el slide hacia arriba del HomeScreen
static const Curve homeSlideUpCurve = Curves.easeOutCubic;

// Offset del slide hacia arriba (negativo = hacia arriba)
static const double homeSlideUpOffset = -0.15;

// Radio máximo de blur para el HomeScreen
static const double maxBlurRadius = 8.0;
```

### Configuraciones Predefinidas
```dart
// Transición rápida
CrisisTransitionConfig.quickCrisis

// Transición suave
CrisisTransitionConfig.smoothCrisis

// Transición dramática
CrisisTransitionConfig.dramaticCrisis
```

## 🎯 Casos de Uso

### 1. Transición Simple de HomeScreen
```dart
class HomeScreen extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return CrisisTransitionWrapper(
      isTransitioning: _isInCrisisMode,
      child: Scaffold(
        // ... contenido del HomeScreen
      ),
    );
  }
}
```

### 2. Botones de Crisis con Animaciones Secuenciales
```dart
class CrisisModeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CrisisButtonsSequentialWrapper(
        isTransitioning: true,
        children: [
          _buildCrisisButton('Contactar Ayuda', Icons.phone),
          _buildCrisisButton('Respiración', Icons.air),
          _buildCrisisButton('Ejercicios', Icons.fitness_center),
          _buildCrisisButton('Recursos', Icons.help),
        ],
      ),
    );
  }
}
```

### 3. Transición Coordinada Completa
```dart
class CrisisTransitionDemo extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return CrisisTransitionCoordinator(
      homeScreen: HomeScreen(),
      crisisScreen: CrisisModeScreen(),
      showCrisis: _showCrisis,
      onTransitionComplete: _onCrisisActivated,
    );
  }
}
```

## 🔧 Personalización

### Modificar Curvas de Animación
```dart
// En crisis_transition_config.dart
static const Curve homeSlideUpCurve = Curves.easeInOutBack;
static const Curve buttonIndividualCurve = Curves.bounceOut;
```

### Ajustar Timing
```dart
// Transición más rápida
static const Duration totalTransitionDuration = Duration(milliseconds: 600);

// Botones más espaciados
static const Duration buttonStaggerDelay = Duration(milliseconds: 120);
```

### Cambiar Efectos Visuales
```dart
// Más blur
static const double maxBlurRadius = 15.0;

// Slide más pronunciado
static const double homeSlideUpOffset = -0.25;

// Escala más dramática
static const double maxDepthScale = 0.9;
```

## 📱 Integración con Navegación

### Usar con Navigator.pushNamed
```dart
// En main.dart, configurar la ruta
'/crisis': (context) => CrisisModeScreen(),

// Navegar normalmente
Navigator.pushNamed(context, '/crisis');
```

### Usar con Transiciones Personalizadas
```dart
// En custom_page_transitions.dart
static PageRouteBuilder<T> crisisModeTransition<T>(Widget page) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Usar los widgets de transición aquí
      return CrisisTransitionWrapper(
        isTransitioning: true,
        child: child,
      );
    },
  );
}
```

## 🎨 Efectos Visuales Disponibles

### Efectos de Transición
- **Slide hacia arriba**: HomeScreen se desliza hacia arriba
- **Blur progresivo**: Desenfoque gradual durante la transición
- **Escala de profundidad**: HomeScreen se reduce ligeramente
- **Sombras dinámicas**: Sombras que aparecen durante la transición

### Efectos de Botones
- **Bounce secuencial**: Cada botón rebota con timing escalonado
- **Fade progresivo**: Opacidad que aumenta gradualmente
- **Escala dinámica**: Escala que varía durante la animación
- **Sombras reactivas**: Sombras que responden a la animación

## 🚨 Consideraciones de Rendimiento

### Optimizaciones Recomendadas
1. **Usar `const` constructors** cuando sea posible
2. **Evitar rebuilds innecesarios** en widgets anidados
3. **Limitar la complejidad** de las animaciones simultáneas
4. **Usar `RepaintBoundary`** para widgets complejos

### Monitoreo de Rendimiento
```dart
// Activar el indicador de rendimiento en debug
import 'package:flutter/foundation.dart';

if (kDebugMode) {
  debugPrintRebuildDirtyWidgets = true;
}
```

## 🧪 Testing y Debugging

### Verificar Animaciones
```dart
// En modo debug, mostrar información de animaciones
if (kDebugMode) {
  print('Animation value: ${animation.value}');
  print('Animation status: ${animation.status}');
}
```

### Simular Diferentes Estados
```dart
// Probar diferentes configuraciones
final testConfig = CrisisTransitionConfig.quickCrisis;
final customConfig = CrisisTransitionSettings(
  totalDuration: Duration(milliseconds: 500),
  homeSlideUpDuration: Duration(milliseconds: 250),
  blurDuration: Duration(milliseconds: 200),
  buttonStaggerDelay: Duration(milliseconds: 50),
);
```

## 📚 Ejemplos Completos

### Ejemplo Básico
Ver `examples/crisis_transition_example.dart` para implementaciones completas.

### Ejemplo Avanzado
```dart
class AdvancedCrisisTransition extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return CrisisTransitionCoordinator(
      homeScreen: CrisisTransitionWrapper(
        isTransitioning: _showCrisis,
        child: HomeScreen(),
      ),
      crisisScreen: CrisisButtonsSequentialWrapper(
        isTransitioning: _showCrisis,
        children: _buildCrisisButtons(),
      ),
      showCrisis: _showCrisis,
      onTransitionComplete: _onCrisisComplete,
    );
  }
}
```

## 🔗 Dependencias

- `flutter/material.dart` - Widgets básicos de Flutter
- `dart:ui` - Para efectos de ImageFilter (blur)
- `../config/crisis_transition_config.dart` - Configuración de transiciones

## 📝 Notas de Implementación

1. **Estado de Animación**: Mantener el estado de `isTransitioning` sincronizado
2. **Dispose de Controllers**: Siempre llamar `dispose()` en los AnimationControllers
3. **Mounted Check**: Verificar `mounted` antes de llamar `setState()`
4. **Performance**: Usar `AnimatedBuilder` solo cuando sea necesario

## 🆘 Solución de Problemas

### Animación No Funciona
- Verificar que `isTransitioning` esté en `true`
- Comprobar que los AnimationControllers estén inicializados
- Verificar que no haya errores en la consola

### Rendimiento Lento
- Reducir la complejidad de las animaciones
- Usar `RepaintBoundary` para widgets complejos
- Verificar que no haya rebuilds innecesarios

### Efectos Visuales Incorrectos
- Verificar los valores en `CrisisTransitionConfig`
- Comprobar que las curvas de animación sean apropiadas
- Ajustar los parámetros de blur y escala

## 🤝 Contribuciones

Para contribuir a este sistema de transiciones:

1. Mantener la consistencia con el diseño existente
2. Agregar tests para nuevas funcionalidades
3. Documentar cambios en este README
4. Seguir las convenciones de código del proyecto

## 📄 Licencia

Este código es parte del proyecto MindCompanion y sigue las mismas políticas de licencia.
