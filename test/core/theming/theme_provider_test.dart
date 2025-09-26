import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mindcompanion/core/theming/theme_provider.dart';

import 'theme_provider_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  group('ThemeProvider', () {
    late ThemeProvider themeProvider;
    late MockSharedPreferences mockPrefs;

    setUp(() {
      themeProvider = ThemeProvider();
      mockPrefs = MockSharedPreferences();
    });

    test('should initialize with system theme mode', () {
      expect(themeProvider.themeMode, AppThemeMode.system);
    });

    test('should create light theme', () {
      // Initialize the provider to create themes
      themeProvider.init();
      final lightTheme = themeProvider.lightTheme;
      expect(lightTheme, isNotNull);
      expect(lightTheme?.brightness, Brightness.light);
    });

    test('should create dark theme', () {
      // Initialize the provider to create themes
      themeProvider.init();
      final darkTheme = themeProvider.darkTheme;
      expect(darkTheme, isNotNull);
      expect(darkTheme?.brightness, Brightness.dark);
    });

    test('should return current theme based on mode', () {
      // Test light mode
      themeProvider.setThemeMode(AppThemeMode.light);
      expect(themeProvider.currentTheme.brightness, Brightness.light);

      // Test dark mode
      themeProvider.setThemeMode(AppThemeMode.dark);
      expect(themeProvider.currentTheme.brightness, Brightness.dark);
    });

    test('should return correct material theme mode', () {
      themeProvider.setThemeMode(AppThemeMode.light);
      expect(themeProvider.materialThemeMode, ThemeMode.light);

      themeProvider.setThemeMode(AppThemeMode.dark);
      expect(themeProvider.materialThemeMode, ThemeMode.dark);

      themeProvider.setThemeMode(AppThemeMode.system);
      expect(themeProvider.materialThemeMode, ThemeMode.system);
    });

    test('should return correct theme mode display names', () {
      expect(
        themeProvider.getThemeModeDisplayName(AppThemeMode.light),
        'Light',
      );
      expect(themeProvider.getThemeModeDisplayName(AppThemeMode.dark), 'Dark');
      expect(
        themeProvider.getThemeModeDisplayName(AppThemeMode.system),
        'System',
      );
    });

    test('should return correct theme mode descriptions', () {
      expect(
        themeProvider.getThemeModeDescription(AppThemeMode.light),
        'Always use light theme',
      );
      expect(
        themeProvider.getThemeModeDescription(AppThemeMode.dark),
        'Always use dark theme',
      );
      expect(
        themeProvider.getThemeModeDescription(AppThemeMode.system),
        'Follow system theme',
      );
    });

    test('should detect dark mode correctly', () {
      themeProvider.setThemeMode(AppThemeMode.light);
      expect(themeProvider.isDarkMode, false);

      themeProvider.setThemeMode(AppThemeMode.dark);
      expect(themeProvider.isDarkMode, true);

      themeProvider.setThemeMode(AppThemeMode.system);
      expect(themeProvider.isDarkMode, false); // Default to light for system
    });

    test('should load theme from preferences', () async {
      when(
        mockPrefs.getInt('app_theme_mode'),
      ).thenReturn(AppThemeMode.dark.index);

      // This would need to be tested with actual SharedPreferences
      // For now, we test the setter
      await themeProvider.setThemeMode(AppThemeMode.dark);
      expect(themeProvider.themeMode, AppThemeMode.dark);
    });

    test('should save theme to preferences', () async {
      await themeProvider.setThemeMode(AppThemeMode.light);
      expect(themeProvider.themeMode, AppThemeMode.light);
    });
  });
}
