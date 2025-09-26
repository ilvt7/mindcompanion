import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mindcompanion/core/accessibility/high_contrast_provider.dart';
import 'package:mindcompanion/core/theming/enhanced_theme_provider.dart';
import 'package:mindcompanion/screens/settings_screen.dart';
import 'package:mindcompanion/screens/welcome_screen.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('High Contrast Golden Tests', () {
    testWidgets('welcome screen normal mode', (WidgetTester tester) async {
      await TestHelpers.pumpAppWithProviders(tester, const WelcomeScreen());

      // Take golden test screenshot
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('welcome_normal_mode.png'),
      );
    });

    testWidgets('welcome screen high contrast mode', (
      WidgetTester tester,
    ) async {
      await TestHelpers.pumpAppWithProviders(tester, const WelcomeScreen());

      // Enable high contrast mode
      await TestHelpers.pumpUntilFound(tester, find.byType(MaterialApp));
      final highContrastProvider = Provider.of<HighContrastProvider>(
        tester.element(find.byType(MaterialApp).first),
        listen: false,
      );
      await highContrastProvider.enable();
      await tester.pump(const Duration(milliseconds: 300));

      // Take golden test screenshot
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('welcome_high_contrast_mode.png'),
      );
    });

    testWidgets('settings screen normal mode', (WidgetTester tester) async {
      await TestHelpers.pumpAppWithProviders(tester, const SettingsScreen());

      // Take golden test screenshot
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('settings_normal_mode.png'),
      );
    });

    testWidgets('settings screen high contrast mode', (
      WidgetTester tester,
    ) async {
      await TestHelpers.pumpAppWithProviders(tester, const SettingsScreen());

      // Enable high contrast mode
      await TestHelpers.pumpUntilFound(tester, find.byType(MaterialApp));
      final highContrastProvider = Provider.of<HighContrastProvider>(
        tester.element(find.byType(MaterialApp).first),
        listen: false,
      );
      await highContrastProvider.enable();
      await tester.pump(const Duration(milliseconds: 300));

      // Take golden test screenshot
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('settings_high_contrast_mode.png'),
      );
    });

    testWidgets('welcome screen dark mode normal', (WidgetTester tester) async {
      await TestHelpers.pumpAppWithProviders(tester, const WelcomeScreen());

      // Set to dark mode
      await TestHelpers.pumpUntilFound(tester, find.byType(MaterialApp));
      final themeProvider = Provider.of<EnhancedThemeProvider>(
        tester.element(find.byType(MaterialApp).first),
        listen: false,
      );
      await themeProvider.setThemeMode(AppThemeMode.dark);
      await tester.pump(const Duration(milliseconds: 300));

      // Take golden test screenshot
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('welcome_dark_normal_mode.png'),
      );
    });

    testWidgets('welcome screen dark mode high contrast', (
      WidgetTester tester,
    ) async {
      await TestHelpers.pumpAppWithProviders(tester, const WelcomeScreen());

      // Set to dark mode
      await TestHelpers.pumpUntilFound(tester, find.byType(MaterialApp));
      final themeProvider = Provider.of<EnhancedThemeProvider>(
        tester.element(find.byType(MaterialApp).first),
        listen: false,
      );
      await themeProvider.setThemeMode(AppThemeMode.dark);

      // Enable high contrast mode
      await TestHelpers.pumpUntilFound(tester, find.byType(MaterialApp));
      final highContrastProvider = Provider.of<HighContrastProvider>(
        tester.element(find.byType(MaterialApp).first),
        listen: false,
      );
      await highContrastProvider.enable();
      await tester.pump(const Duration(milliseconds: 300));

      // Take golden test screenshot
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('welcome_dark_high_contrast_mode.png'),
      );
    });

    testWidgets('settings screen dark mode normal', (
      WidgetTester tester,
    ) async {
      await TestHelpers.pumpAppWithProviders(tester, const SettingsScreen());

      // Set to dark mode
      await TestHelpers.pumpUntilFound(tester, find.byType(MaterialApp));
      final themeProvider = Provider.of<EnhancedThemeProvider>(
        tester.element(find.byType(MaterialApp).first),
        listen: false,
      );
      await themeProvider.setThemeMode(AppThemeMode.dark);
      await tester.pump(const Duration(milliseconds: 300));

      // Take golden test screenshot
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('settings_dark_normal_mode.png'),
      );
    });

    testWidgets('settings screen dark mode high contrast', (
      WidgetTester tester,
    ) async {
      await TestHelpers.pumpAppWithProviders(tester, const SettingsScreen());

      // Set to dark mode
      await TestHelpers.pumpUntilFound(tester, find.byType(MaterialApp));
      final themeProvider = Provider.of<EnhancedThemeProvider>(
        tester.element(find.byType(MaterialApp).first),
        listen: false,
      );
      await themeProvider.setThemeMode(AppThemeMode.dark);

      // Enable high contrast mode
      await TestHelpers.pumpUntilFound(tester, find.byType(MaterialApp));
      final highContrastProvider = Provider.of<HighContrastProvider>(
        tester.element(find.byType(MaterialApp).first),
        listen: false,
      );
      await highContrastProvider.enable();
      await tester.pump(const Duration(milliseconds: 300));

      // Take golden test screenshot
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('settings_dark_high_contrast_mode.png'),
      );
    });
  });
}
