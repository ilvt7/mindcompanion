import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mindcompanion/core/theming/enhanced_theme_provider.dart';
import 'package:mindcompanion/core/accessibility/simple_accessibility_provider.dart';
import 'package:mindcompanion/screens/welcome_screen.dart';
import 'package:mindcompanion/screens/home_screen.dart';
import 'package:mindcompanion/screens/ai_diary_screen.dart';
import 'package:mindcompanion/screens/settings_screen.dart';
import 'package:mindcompanion/screens/crisis_mode_screen.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('Smoke Test E2E - Screen Loading', () {
    testWidgets('should load Welcome Screen without errors', (
      WidgetTester tester,
    ) async {
      await TestHelpers.pumpAppWithProviders(tester, const WelcomeScreen());

      // Just verify the screen loads without crashing
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should load Home Screen without errors', (
      WidgetTester tester,
    ) async {
      await TestHelpers.pumpAppWithProviders(tester, const HomeScreen());

      // Just verify the screen loads without crashing
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should load AI Diary Screen without errors', (
      WidgetTester tester,
    ) async {
      await TestHelpers.pumpAppWithProviders(tester, const AIDiaryScreen());

      // Just verify the screen loads without crashing
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should load Settings Screen without errors', (
      WidgetTester tester,
    ) async {
      await TestHelpers.pumpAppWithProviders(tester, const SettingsScreen());

      // Just verify the screen loads without crashing
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should load Crisis Mode Screen without errors', (
      WidgetTester tester,
    ) async {
      await TestHelpers.pumpAppWithProviders(tester, const CrisisModeScreen());

      // Just verify the screen loads without crashing
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should handle theme switching correctly', (
      WidgetTester tester,
    ) async {
      await TestHelpers.pumpAppWithProviders(tester, const SettingsScreen());

      // Test theme switching
      final themeProvider = Provider.of<EnhancedThemeProvider>(
        tester.element(find.byType(MaterialApp).first),
        listen: false,
      );

      // Switch to dark theme
      await themeProvider.setThemeMode(AppThemeMode.dark);
      await tester.pumpAndSettle();

      // Verify theme change is applied
      final materialApp = tester.widget<MaterialApp>(
        find.byType(MaterialApp).first,
      );
      expect(materialApp.themeMode, ThemeMode.dark);

      // Switch back to light theme
      await themeProvider.setThemeMode(AppThemeMode.light);
      await tester.pumpAndSettle();

      // Verify theme change is applied
      final materialAppLight = tester.widget<MaterialApp>(
        find.byType(MaterialApp).first,
      );
      expect(materialAppLight.themeMode, ThemeMode.light);
    });

    testWidgets('should handle accessibility settings correctly', (
      WidgetTester tester,
    ) async {
      await TestHelpers.pumpAppWithProviders(tester, const SettingsScreen());

      // Verify Settings Screen loads
      expect(find.text('Settings'), findsOneWidget);

      // Test text scaling through provider
      final accessibilityProvider = Provider.of<SimpleAccessibilityProvider>(
        tester.element(find.byType(MaterialApp).first),
        listen: false,
      );

      // Set different text scales
      await accessibilityProvider.setTextScale(1.2);
      await tester.pumpAndSettle();

      // Verify text scale is applied
      expect(accessibilityProvider.textScale, 1.2);

      await accessibilityProvider.setTextScale(0.8);
      await tester.pumpAndSettle();

      // Verify text scale is applied
      expect(accessibilityProvider.textScale, 0.8);
    });

    testWidgets('should handle crisis mode without errors', (
      WidgetTester tester,
    ) async {
      await TestHelpers.pumpAppWithProviders(tester, const CrisisModeScreen());

      // This test ensures the crisis mode doesn't crash
      // We just verify the screen loads successfully
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
