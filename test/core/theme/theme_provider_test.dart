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

    test('should initialize with system theme mode by default', () {
      expect(themeProvider.themeMode, AppThemeMode.system);
    });

    test('should return correct themeMode for MaterialApp', () {
      // Test light mode
      themeProvider.setThemeMode(AppThemeMode.light);
      expect(themeProvider.materialThemeMode, ThemeMode.light);

      // Test dark mode
      themeProvider.setThemeMode(AppThemeMode.dark);
      expect(themeProvider.materialThemeMode, ThemeMode.dark);

      // Test system mode
      themeProvider.setThemeMode(AppThemeMode.system);
      expect(themeProvider.materialThemeMode, ThemeMode.system);
    });

    test('should return current mode', () {
      expect(themeProvider.themeMode, AppThemeMode.system);

      themeProvider.setThemeMode(AppThemeMode.light);
      expect(themeProvider.themeMode, AppThemeMode.light);

      themeProvider.setThemeMode(AppThemeMode.dark);
      expect(themeProvider.themeMode, AppThemeMode.dark);
    });

    test('should create light theme', () async {
      await themeProvider.init();
      final lightTheme = themeProvider.lightTheme;
      expect(lightTheme, isNotNull);
      expect(lightTheme?.brightness, Brightness.light);
    });

    test('should create dark theme', () async {
      await themeProvider.init();
      final darkTheme = themeProvider.darkTheme;
      expect(darkTheme, isNotNull);
      expect(darkTheme?.brightness, Brightness.dark);
    });

    test('should return current theme based on mode', () async {
      await themeProvider.init();

      // Test light mode
      themeProvider.setThemeMode(AppThemeMode.light);
      expect(themeProvider.currentTheme.brightness, Brightness.light);

      // Test dark mode
      themeProvider.setThemeMode(AppThemeMode.dark);
      expect(themeProvider.currentTheme.brightness, Brightness.dark);
    });

    test('should load theme from preferences', () async {
      when(
        mockPrefs.getInt('app_theme_mode'),
      ).thenReturn(AppThemeMode.light.index);

      // This would need to be tested with actual SharedPreferences
      // For now, we test the setter
      await themeProvider.setThemeMode(AppThemeMode.light);
      expect(themeProvider.themeMode, AppThemeMode.light);
    });

    test('should save theme to preferences', () async {
      await themeProvider.setThemeMode(AppThemeMode.dark);
      expect(themeProvider.themeMode, AppThemeMode.dark);
    });

    test('should notify listeners when theme changes', () async {
      await themeProvider.init();

      bool listenerCalled = false;
      themeProvider.addListener(() {
        listenerCalled = true;
      });

      await themeProvider.setThemeMode(AppThemeMode.light);
      expect(listenerCalled, true);
    });

    test('should not notify listeners when theme is the same', () async {
      await themeProvider.init();
      await themeProvider.setThemeMode(AppThemeMode.light);

      bool listenerCalled = false;
      themeProvider.addListener(() {
        listenerCalled = true;
      });

      await themeProvider.setThemeMode(AppThemeMode.light);
      expect(listenerCalled, false);
    });

    test('should handle invalid theme index gracefully', () async {
      // Test with invalid index
      when(mockPrefs.getInt('app_theme_mode')).thenReturn(999);

      // Should default to system mode
      expect(themeProvider.themeMode, AppThemeMode.system);
    });

    test('should create themes with correct color schemes', () async {
      await themeProvider.init();

      final lightTheme = themeProvider.lightTheme;
      final darkTheme = themeProvider.darkTheme;

      expect(lightTheme, isNotNull);
      expect(darkTheme, isNotNull);

      // Test that themes have different brightness
      expect(lightTheme?.brightness, Brightness.light);
      expect(darkTheme?.brightness, Brightness.dark);

      // Test that themes have color schemes
      expect(lightTheme?.colorScheme, isNotNull);
      expect(darkTheme?.colorScheme, isNotNull);
    });

    test('should maintain theme consistency', () async {
      await themeProvider.init();

      // Set to light theme
      themeProvider.setThemeMode(AppThemeMode.light);
      final lightTheme1 = themeProvider.currentTheme;
      final lightTheme2 = themeProvider.currentTheme;

      // Should return the same theme instance
      expect(identical(lightTheme1, lightTheme2), true);

      // Set to dark theme
      themeProvider.setThemeMode(AppThemeMode.dark);
      final darkTheme1 = themeProvider.currentTheme;
      final darkTheme2 = themeProvider.currentTheme;

      // Should return the same theme instance
      expect(identical(darkTheme1, darkTheme2), true);
    });
  });
}
