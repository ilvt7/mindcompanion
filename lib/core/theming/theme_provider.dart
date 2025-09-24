import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme modes available in the app
enum AppThemeMode {
  light,
  dark,
  system,
}

/// Provider for managing app themes
class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'app_theme_mode';
  
  AppThemeMode _themeMode = AppThemeMode.system;
  ThemeData? _lightTheme;
  ThemeData? _darkTheme;

  AppThemeMode get themeMode => _themeMode;
  ThemeData? get lightTheme => _lightTheme;
  ThemeData? get darkTheme => _darkTheme;

  /// Get current theme based on mode
  ThemeData get currentTheme {
    switch (_themeMode) {
      case AppThemeMode.light:
        return _lightTheme ?? _createLightTheme();
      case AppThemeMode.dark:
        return _darkTheme ?? _createDarkTheme();
      case AppThemeMode.system:
        return _lightTheme ?? _createLightTheme(); // Will be overridden by system
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
  Future<void> init() async {
    await _loadThemeFromPreferences();
    _createThemes();
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

  /// Create light theme
  void _createThemes() {
    _lightTheme = _createLightTheme();
    _darkTheme = _createDarkTheme();
  }

  /// Create light theme data
  ThemeData _createLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF87CEEB), // Soft blue
        brightness: Brightness.light,
        primary: const Color(0xFF87CEEB),
        secondary: const Color(0xFFE6E6FA), // Lavender
        surface: const Color(0xFFF8F9FF), // Very light blue
        background: const Color(0xFFF8F9FF),
        error: const Color(0xFFE57373),
        onPrimary: Colors.white,
        onSecondary: const Color(0xFF2C3E50),
        onSurface: const Color(0xFF2C3E50),
        onBackground: const Color(0xFF2C3E50),
        onError: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF87CEEB),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
        color: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF87CEEB),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: Color(0xFF2C3E50)),
        headlineMedium: TextStyle(color: Color(0xFF2C3E50)),
        headlineSmall: TextStyle(color: Color(0xFF2C3E50)),
        titleLarge: TextStyle(color: Color(0xFF2C3E50)),
        titleMedium: TextStyle(color: Color(0xFF2C3E50)),
        titleSmall: TextStyle(color: Color(0xFF2C3E50)),
        bodyLarge: TextStyle(color: Color(0xFF2C3E50)),
        bodyMedium: TextStyle(color: Color(0xFF2C3E50)),
        bodySmall: TextStyle(color: Color(0xFF2C3E50)),
      ),
    );
  }

  /// Create dark theme data
  ThemeData _createDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF87CEEB), // Soft blue
        brightness: Brightness.dark,
        primary: const Color(0xFF87CEEB),
        secondary: const Color(0xFF4A4A6A), // Dark lavender
        surface: const Color(0xFF1A1A2E), // Dark surface
        background: const Color(0xFF0F0F23), // Very dark background
        error: const Color(0xFFCF6679),
        onPrimary: const Color(0xFF0F0F23),
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onBackground: Colors.white,
        onError: const Color(0xFF0F0F23),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF87CEEB),
          foregroundColor: const Color(0xFF0F0F23),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        color: const Color(0xFF1A1A2E),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1A1A2E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: Colors.white),
        headlineMedium: TextStyle(color: Colors.white),
        headlineSmall: TextStyle(color: Colors.white),
        titleLarge: TextStyle(color: Colors.white),
        titleMedium: TextStyle(color: Colors.white),
        titleSmall: TextStyle(color: Colors.white),
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
        bodySmall: TextStyle(color: Colors.white),
      ),
    );
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

  /// Check if current theme is dark
  bool get isDarkMode {
    switch (_themeMode) {
      case AppThemeMode.light:
        return false;
      case AppThemeMode.dark:
        return true;
      case AppThemeMode.system:
        // This would need to be determined at runtime based on system
        return false; // Default to light for now
    }
  }
}
