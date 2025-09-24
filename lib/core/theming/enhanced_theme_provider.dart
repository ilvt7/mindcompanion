import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../accessibility/high_contrast_provider.dart';

/// Enhanced theme provider that includes high contrast support
class EnhancedThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'app_theme_mode';
  
  AppThemeMode _themeMode = AppThemeMode.system;
  ThemeData? _lightTheme;
  ThemeData? _darkTheme;
  ThemeData? _lightHighContrastTheme;
  ThemeData? _darkHighContrastTheme;
  
  late HighContrastProvider _highContrastProvider;
  
  AppThemeMode get themeMode => _themeMode;
  ThemeData? get lightTheme => _lightTheme;
  ThemeData? get darkTheme => _darkTheme;
  ThemeData? get lightHighContrastTheme => _lightHighContrastTheme;
  ThemeData? get darkHighContrastTheme => _darkHighContrastTheme;
  
  /// Get current theme based on mode and contrast
  ThemeData get currentTheme {
    final isHighContrast = _highContrastProvider.isHighContrast;
    
    switch (_themeMode) {
      case AppThemeMode.light:
        return isHighContrast 
            ? (_lightHighContrastTheme ?? _createLightHighContrastTheme())
            : (_lightTheme ?? _createLightTheme());
      case AppThemeMode.dark:
        return isHighContrast 
            ? (_darkHighContrastTheme ?? _createDarkHighContrastTheme())
            : (_darkTheme ?? _createDarkTheme());
      case AppThemeMode.system:
        return isHighContrast 
            ? (_lightHighContrastTheme ?? _createLightHighContrastTheme())
            : (_lightTheme ?? _createLightTheme());
    }
  }
  
  /// Get theme mode for MaterialApp
  ThemeMode get materialThemeMode {
    switch (_themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
  
  /// Initialize theme provider
  Future<void> init(HighContrastProvider highContrastProvider) async {
    _highContrastProvider = highContrastProvider;
    await _loadThemeFromPreferences();
    _createThemes();
    
    // Listen to high contrast changes
    _highContrastProvider.addListener(_onHighContrastChanged);
  }
  
  /// Set theme mode
  Future<void> setThemeMode(AppThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    await _saveThemeToPreferences();
    notifyListeners();
  }
  
  /// Load theme from SharedPreferences
  Future<void> _loadThemeFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey) ?? AppThemeMode.system.index;
      _themeMode = AppThemeMode.values[themeIndex];
    } catch (e) {
      _themeMode = AppThemeMode.system;
    }
  }
  
  /// Save theme to SharedPreferences
  Future<void> _saveThemeToPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, _themeMode.index);
    } catch (e) {
      // Handle error silently
    }
  }
  
  /// Create all themes
  void _createThemes() {
    _lightTheme = _createLightTheme();
    _darkTheme = _createDarkTheme();
    _lightHighContrastTheme = _createLightHighContrastTheme();
    _darkHighContrastTheme = _createDarkHighContrastTheme();
  }
  
  /// Create light theme
  ThemeData _createLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF87CEEB),
        brightness: Brightness.light,
        primary: const Color(0xFF87CEEB),
        secondary: const Color(0xFFE6E6FA),
        surface: const Color(0xFFF8F9FF),
        background: const Color(0xFFFFFFFF),
        error: const Color(0xFFE53E3E),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
        headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
      ),
    );
  }
  
  /// Create dark theme
  ThemeData _createDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF87CEEB),
        brightness: Brightness.dark,
        primary: const Color(0xFF87CEEB),
        secondary: const Color(0xFF4A4A6A),
        surface: const Color(0xFF1A1A2E),
        background: const Color(0xFF0F0F23),
        error: const Color(0xFFFF6B6B),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
        headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
      ),
    );
  }
  
  /// Create light high contrast theme
  ThemeData _createLightHighContrastTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF0000FF), // Pure blue for high contrast
        brightness: Brightness.light,
        primary: const Color(0xFF0000FF), // Pure blue
        secondary: const Color(0xFF000000), // Pure black
        surface: const Color(0xFFFFFFFF), // Pure white
        background: const Color(0xFFFFFFFF), // Pure white
        error: const Color(0xFFFF0000), // Pure red
        onPrimary: const Color(0xFFFFFFFF), // White on blue
        onSecondary: const Color(0xFFFFFFFF), // White on black
        onSurface: const Color(0xFF000000), // Black on white
        onBackground: const Color(0xFF000000), // Black on white
        onError: const Color(0xFFFFFFFF), // White on red
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
        headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
        headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
        titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
        titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
        titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
        labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
      ),
    );
  }
  
  /// Create dark high contrast theme
  ThemeData _createDarkHighContrastTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF00FFFF), // Cyan for high contrast
        brightness: Brightness.dark,
        primary: const Color(0xFF00FFFF), // Cyan
        secondary: const Color(0xFFFFFFFF), // Pure white
        surface: const Color(0xFF000000), // Pure black
        background: const Color(0xFF000000), // Pure black
        error: const Color(0xFFFF0000), // Pure red
        onPrimary: const Color(0xFF000000), // Black on cyan
        onSecondary: const Color(0xFF000000), // Black on white
        onSurface: const Color(0xFFFFFFFF), // White on black
        onBackground: const Color(0xFFFFFFFF), // White on black
        onError: const Color(0xFFFFFFFF), // White on red
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
        headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
        headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
        titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
        titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
        titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
        labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
      ),
    );
  }
  
  /// Handle high contrast changes
  void _onHighContrastChanged() {
    notifyListeners();
  }
  
  /// Get theme mode display name
  String getThemeModeDisplayName(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.system:
        return 'System';
    }
  }
  
  /// Get theme mode description
  String getThemeModeDescription(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return 'Always use light theme';
      case AppThemeMode.dark:
        return 'Always use dark theme';
      case AppThemeMode.system:
        return 'Follow system theme';
    }
  }
  
  @override
  void dispose() {
    _highContrastProvider.removeListener(_onHighContrastChanged);
    super.dispose();
  }
}

/// Theme modes available in the app
enum AppThemeMode {
  light,
  dark,
  system,
}
