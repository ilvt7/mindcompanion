import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mindcompanion/core/theming/enhanced_theme_provider.dart';
import 'package:mindcompanion/screens/settings_screen.dart';
import 'package:mindcompanion/screens/welcome_screen.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('Theme Integration Tests', () {
    testWidgets('should display light theme by default', (WidgetTester tester) async {
      await TestHelpers.pumpAppWithProviders(
        tester,
        const SettingsScreen(),
      );

      // Check provider has initialized themes
      await TestHelpers.pumpUntilFound(tester, find.byType(MaterialApp));
      final themeProvider = Provider.of<EnhancedThemeProvider>(
        tester.element(find.byType(MaterialApp).first),
        listen: false,
      );
      expect(themeProvider.lightTheme, isNotNull);
    });

    testWidgets('should switch to dark theme when selected', (WidgetTester tester) async {
      await TestHelpers.pumpAppWithProviders(
        tester,
        const SettingsScreen(),
      );

      // Get the theme provider
      await TestHelpers.pumpUntilFound(tester, find.byType(MaterialApp));
      final themeProvider = Provider.of<EnhancedThemeProvider>(
        tester.element(find.byType(MaterialApp).first),
        listen: false,
      );

      // Switch to dark theme
      await themeProvider.setThemeMode(AppThemeMode.dark);
      await tester.pump(const Duration(milliseconds: 300));

      // Verify dark theme is applied
      await TestHelpers.pumpUntilFound(tester, find.byType(MaterialApp));
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp).first);
      expect(materialApp.themeMode, ThemeMode.dark);
    });

    testWidgets('should switch to light theme when selected', (WidgetTester tester) async {
      await TestHelpers.pumpAppWithProviders(
        tester,
        const SettingsScreen(),
      );

      // Get the theme provider
      await TestHelpers.pumpUntilFound(tester, find.byType(MaterialApp));
      final themeProvider = Provider.of<EnhancedThemeProvider>(
        tester.element(find.byType(MaterialApp).first),
        listen: false,
      );

      // Switch to light theme
      await themeProvider.setThemeMode(AppThemeMode.light);
      await tester.pump(const Duration(milliseconds: 300));

      // Verify light theme is applied
      await TestHelpers.pumpUntilFound(tester, find.byType(MaterialApp));
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp).first);
      expect(materialApp.themeMode, ThemeMode.light);
    });

    testWidgets('should use system theme when selected', (WidgetTester tester) async {
      await TestHelpers.pumpAppWithProviders(
        tester,
        const SettingsScreen(),
      );

      // Get the theme provider
      await TestHelpers.pumpUntilFound(tester, find.byType(MaterialApp));
      final themeProvider = Provider.of<EnhancedThemeProvider>(
        tester.element(find.byType(MaterialApp).first),
        listen: false,
      );

      // Switch to system theme
      await themeProvider.setThemeMode(AppThemeMode.system);
      await tester.pump(const Duration(milliseconds: 300));

      // Verify system theme is applied
      await TestHelpers.pumpUntilFound(tester, find.byType(MaterialApp));
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp).first);
      expect(materialApp.themeMode, ThemeMode.system);
    });

    testWidgets('should persist theme selection', (WidgetTester tester) async {
      await TestHelpers.pumpAppWithProviders(
        tester,
        const SettingsScreen(),
      );

      // Get the theme provider
      await TestHelpers.pumpUntilFound(tester, find.byType(MaterialApp));
      final themeProvider = Provider.of<EnhancedThemeProvider>(
        tester.element(find.byType(MaterialApp).first),
        listen: false,
      );

      // Switch to dark theme
      await themeProvider.setThemeMode(AppThemeMode.dark);
      await tester.pump(const Duration(milliseconds: 300));

      // Verify theme is persisted
      await TestHelpers.pumpUntilFound(tester, find.byType(MaterialApp));
      final themeProviderPersist = Provider.of<EnhancedThemeProvider>(
        tester.element(find.byType(MaterialApp).first),
        listen: false,
      );
      expect(themeProviderPersist.themeMode, AppThemeMode.dark);
    });

    testWidgets('should apply theme to welcome screen', (WidgetTester tester) async {
      await TestHelpers.pumpAppWithProviders(
        tester,
        const WelcomeScreen(),
      );

      // Get the theme provider
      await TestHelpers.pumpUntilFound(tester, find.byType(MaterialApp));
      final themeProvider = Provider.of<EnhancedThemeProvider>(
        tester.element(find.byType(MaterialApp).first),
        listen: false,
      );

      // Switch to dark theme
      await themeProvider.setThemeMode(AppThemeMode.dark);
      await tester.pump(const Duration(milliseconds: 300));

      // Verify theme is applied to welcome screen
      await TestHelpers.pumpUntilFound(tester, find.byType(MaterialApp));
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp).first);
      expect(materialApp.themeMode, ThemeMode.dark);
    });

    testWidgets('should apply theme to settings screen', (WidgetTester tester) async {
      await TestHelpers.pumpAppWithProviders(
        tester,
        const SettingsScreen(),
      );

      // Get the theme provider and switch to light
      await TestHelpers.pumpUntilFound(tester, find.byType(MaterialApp));
      final themeProvider3 = Provider.of<EnhancedThemeProvider>(
        tester.element(find.byType(MaterialApp).first),
        listen: false,
      );

      // Switch to light theme
      await themeProvider3.setThemeMode(AppThemeMode.light);
      await tester.pump(const Duration(milliseconds: 300));

      // Verify theme is applied to settings screen
      await TestHelpers.pumpUntilFound(tester, find.byType(MaterialApp));
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp).first);
      expect(materialApp.themeMode, ThemeMode.light);
    });

    testWidgets('should maintain theme consistency across navigation', (WidgetTester tester) async {
      await TestHelpers.pumpAppWithProviders(
        tester,
        const WelcomeScreen(),
      );

      // Get the theme provider
      await TestHelpers.pumpUntilFound(tester, find.byType(MaterialApp));
      final themeProvider = Provider.of<EnhancedThemeProvider>(
        tester.element(find.byType(MaterialApp).first),
        listen: false,
      );

      // Set to dark theme
      await themeProvider.setThemeMode(AppThemeMode.dark);
      await tester.pump(const Duration(milliseconds: 300));

      // Navigate to settings with providers
      await TestHelpers.pumpAppWithProviders(
        tester,
        const SettingsScreen(),
      );
      await tester.pump(const Duration(milliseconds: 300));

      // Verify theme is consistent
      await TestHelpers.pumpUntilFound(tester, find.byType(MaterialApp));
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp).first);
      expect(materialApp.themeMode, ThemeMode.dark);
    });
  });
}