# 🎨 Accesibilidad y Temas - MindCompanion

## 🌟 Características Implementadas

### 🎨 Sistema de Temas
- **Tema Claro**: Diseño limpio y moderno con colores suaves
- **Tema Oscuro**: Interfaz elegante para uso nocturno
- **Tema del Sistema**: Sigue automáticamente la configuración del dispositivo
- **Persistencia**: Las preferencias se guardan automáticamente

### 📱 Accesibilidad de Texto
- **Tamaños de Fuente Configurables**: Desde 80% hasta 200%
- **Presets Rápidos**: Pequeño, Normal, Grande, Extra Grande, Enorme
- **Aplicación Global**: Se aplica a toda la aplicación automáticamente
- **Persistencia**: Las preferencias se mantienen entre sesiones

### 🔊 Texto a Voz (TTS)
- **Lectura de Entradas**: Botones para escuchar las entradas del diario
- **Configuración Avanzada**: Velocidad, volumen y tono ajustables
- **Habilitación/Deshabilitación**: Control total sobre la funcionalidad
- **Integración Inteligente**: Solo aparece cuando hay texto para leer

## 🛠️ Implementación Técnica

### Estructura de Archivos
```
lib/
├── core/
│   ├── accessibility/
│   │   ├── accessibility_provider.dart    # Provider principal
│   │   └── tts_service.dart              # Servicio de TTS
│   └── theming/
│       ├── theme_provider.dart           # Gestión de temas
│       └── text_scale_provider.dart      # Escalado de texto
├── widgets/
│   ├── tts_button.dart                   # Botón TTS reutilizable
│   └── accessibility_settings_widget.dart # Widgets de configuración
└── screens/
    └── settings_screen.dart              # Pantalla de configuración actualizada
```

### Providers Utilizados
- **AccessibilityProvider**: Coordina todos los servicios de accesibilidad
- **ThemeProvider**: Maneja los temas claro/oscuro/sistema
- **TextScaleProvider**: Controla el escalado de texto
- **TTSService**: Servicio de texto a voz

## 🎯 Uso de la API

### Configuración de Temas
```dart
// Cambiar tema
accessibilityProvider.themeProvider.setThemeMode(AppThemeMode.dark);

// Obtener tema actual
final currentTheme = accessibilityProvider.currentTheme;
final isDark = accessibilityProvider.themeProvider.isDarkMode;
```

### Configuración de Texto
```dart
// Cambiar tamaño de fuente
accessibilityProvider.textScaleProvider.setTextScaleFactor(1.2);

// Usar presets
accessibilityProvider.textScaleProvider.setTextScalePercentage(150);

// Aumentar/disminuir
accessibilityProvider.textScaleProvider.increaseTextScale();
```

### Texto a Voz
```dart
// Habilitar/deshabilitar TTS
accessibilityProvider.ttsService.setEnabled(true);

// Configurar parámetros
accessibilityProvider.ttsService.setSpeechRate(0.8);
accessibilityProvider.ttsService.setVolume(0.9);
accessibilityProvider.ttsService.setPitch(1.2);

// Leer texto
await accessibilityProvider.ttsService.speak("Hola mundo");
```

### Widgets de UI
```dart
// Botón TTS simple
TTSButton(text: "Texto a leer")

// Botón TTS con etiqueta
TTSButton(
  text: "Texto a leer",
  label: "Escuchar",
  color: Colors.blue,
)

// Botón TTS compacto
CompactTTSButton(text: "Texto a leer")

// Widgets de configuración
AccessibilitySettingsWidget()
ThemeSelectionWidget()
TextScaleSettingsWidget()
TTSSettingsWidget()
```

## 🧪 Testing

### Tests Unitarios
- **TTSService**: Verificación de configuración y persistencia
- **ThemeProvider**: Validación de temas y modos
- **TextScaleProvider**: Pruebas de escalado y límites

### Tests de Integración
- **Theme Integration**: Verificación de aplicación de temas
- **Accessibility Integration**: Pruebas de funcionalidades combinadas

### Golden Tests
- **Theme Golden Tests**: Capturas de pantalla para diferentes temas
- **Text Scale Golden Tests**: Verificación visual de escalado

## 🚀 Características Avanzadas

### Persistencia Automática
- Todas las configuraciones se guardan automáticamente en SharedPreferences
- Se restauran al iniciar la aplicación
- Sincronización entre providers

### Integración con MaterialApp
- Aplicación automática de temas a toda la aplicación
- Escalado de texto global via MediaQuery
- Transiciones suaves entre temas

### Accesibilidad Inclusiva
- Cumple con estándares de accesibilidad
- Soporte para lectores de pantalla
- Controles táctiles optimizados
- Colores con suficiente contraste

## 📱 Compatibilidad

### Plataformas Soportadas
- ✅ Android
- ✅ iOS
- ✅ Windows
- ✅ macOS
- ✅ Linux
- ✅ Web

### Dependencias
- `provider`: Gestión de estado
- `flutter_tts`: Texto a voz
- `shared_preferences`: Persistencia

## 🔧 Configuración

### Inicialización
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AccessibilityProvider()),
      ],
      child: MyApp(),
    ),
  );
}
```

### MaterialApp Configuration
```dart
MaterialApp(
  theme: accessibilityProvider.currentTheme,
  darkTheme: accessibilityProvider.themeProvider.darkTheme,
  themeMode: accessibilityProvider.themeMode,
  builder: (context, child) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: accessibilityProvider.textScaleFactor,
      ),
      child: child!,
    );
  },
)
```

## 🎨 Personalización

### Colores de Tema
Los temas utilizan un esquema de colores coherente:
- **Primario**: Azul suave (#87CEEB)
- **Secundario**: Lavanda (#E6E6FA)
- **Superficie**: Azul muy claro (#F8F9FF)
- **Error**: Rojo suave (#E57373)

### Tamaños de Fuente
- **Mínimo**: 80% (0.8x)
- **Máximo**: 200% (2.0x)
- **Paso**: 10% (0.1x)
- **Presets**: 80%, 100%, 120%, 150%, 200%

### Configuración TTS
- **Velocidad**: 0.1x - 1.0x
- **Volumen**: 0.0 - 1.0
- **Tono**: 0.5x - 2.0x
- **Idioma**: Inglés (configurable)

## 🚀 Próximas Mejoras

- [ ] Soporte para múltiples idiomas en TTS
- [ ] Temas personalizados por el usuario
- [ ] Configuración de contraste alto
- [ ] Soporte para modo de alto contraste del sistema
- [ ] Animaciones reducidas para usuarios sensibles
- [ ] Configuración de espaciado de texto
- [ ] Soporte para fuentes personalizadas

## 📚 Recursos Adicionales

- [Flutter Accessibility](https://flutter.dev/docs/development/accessibility-and-localization/accessibility)
- [Material Design Accessibility](https://material.io/design/usability/accessibility.html)
- [WCAG Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [Flutter TTS Plugin](https://pub.dev/packages/flutter_tts)

---

**¡Tu app ahora es más inclusiva y accesible para todos los usuarios! 🌟**
