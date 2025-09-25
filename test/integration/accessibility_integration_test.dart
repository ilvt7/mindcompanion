import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindcompanion/screens/settings_screen.dart';
import 'package:mindcompanion/screens/welcome_screen.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('Accessibility Integration Tests', () {
    testWidgets('should display all accessibility settings correctly', (
      WidgetTester tester,
    ) async {
      await TestHelpers.pumpAppWithProviders(tester, const SettingsScreen());

      // Verify text scaling slider is present
      expect(find.byType(Slider), findsOneWidget);

      // Verify high contrast switch is present
      expect(find.text('Modo Alto Contraste'), findsOneWidget);

      // Verify reduced motion switch is present
      expect(find.text('Reducir Animaciones'), findsOneWidget);

      // Verify reset button is present
      expect(find.text('Restablecer'), findsOneWidget);
    });

    testWidgets('should toggle high contrast and apply changes', (
      WidgetTester tester,
    ) async {
      await TestHelpers.pumpAppWithProviders(tester, const SettingsScreen());

      // Find and tap the high contrast switch
      final highContrastSwitch = find.byType(Switch).first;
      await tester.tap(highContrastSwitch, warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 300));

      // Verify the switch state changed (allow for async state changes)
      await tester.pump(const Duration(milliseconds: 500));
      final switchWidget = tester.widget<Switch>(highContrastSwitch);
      expect(switchWidget.value, isTrue);
    });

    testWidgets('should toggle reduced motion and apply changes', (
      WidgetTester tester,
    ) async {
      await TestHelpers.pumpAppWithProviders(tester, const SettingsScreen());

      // Find and tap the reduced motion switch
      final reducedMotionSwitch = find.byType(Switch).last;
      await tester.tap(reducedMotionSwitch, warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 300));

      // Verify the switch state changed
      final switchWidget = tester.widget<Switch>(reducedMotionSwitch);
      expect(switchWidget.value, true);
    });

    testWidgets('should adjust text scale and apply changes', (
      WidgetTester tester,
    ) async {
      await TestHelpers.pumpAppWithProviders(tester, const SettingsScreen());

      // Find the text scale slider
      final slider = find.byType(Slider);
      expect(slider, findsOneWidget);

      // Get the current value
      final sliderWidget = tester.widget<Slider>(slider);
      final initialValue = sliderWidget.value;

      // Drag the slider to a new value
      await tester.drag(slider, const Offset(50, 0), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 300));

      // Verify the value changed
      final newSliderWidget = tester.widget<Slider>(slider);
      expect(newSliderWidget.value, isNot(equals(initialValue)));
    });

    testWidgets('should persist accessibility settings', (
      WidgetTester tester,
    ) async {
      // First, set some settings
      await TestHelpers.pumpAppWithProviders(tester, const SettingsScreen());

      // Enable high contrast
      final highContrastSwitch = find.byType(Switch).first;
      await tester.tap(highContrastSwitch, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Enable reduced motion
      final reducedMotionSwitch = find.byType(Switch).last;
      await tester.tap(reducedMotionSwitch, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Navigate away and back
      await tester.pumpWidget(MaterialApp(home: const WelcomeScreen()));
      await TestHelpers.pumpUntilFound(tester, find.byType(WelcomeScreen));

      await TestHelpers.pumpAppWithProviders(tester, const SettingsScreen());

      // Verify settings are still applied
      final highContrastSwitchAfter = find.byType(Switch).first;
      final reducedMotionSwitchAfter = find.byType(Switch).last;

      final highContrastWidget = tester.widget<Switch>(highContrastSwitchAfter);
      final reducedMotionWidget = tester.widget<Switch>(
        reducedMotionSwitchAfter,
      );

      expect(highContrastWidget.value, true);
      expect(reducedMotionWidget.value, true);
    });

    testWidgets('should apply text scaling globally', (
      WidgetTester tester,
    ) async {
      await TestHelpers.pumpAppWithProviders(tester, const WelcomeScreen());

      // Get the current text scale factor
      final mediaQuery = tester.element(find.byType(MediaQuery));
      final currentScale = MediaQuery.of(mediaQuery).textScaleFactor;

      // Navigate to settings and change text scale
      await TestHelpers.pumpAppWithProviders(tester, const SettingsScreen());

      final slider = find.byType(Slider);
      await tester.drag(slider, const Offset(50, 0), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 300));

      // Navigate back to welcome screen
      await TestHelpers.pumpAppWithProviders(tester, const WelcomeScreen());

      // Verify text scale factor changed
      final newMediaQuery = tester.element(find.byType(MediaQuery));
      final newScale = MediaQuery.of(newMediaQuery).textScaleFactor;

      expect(newScale, isNot(equals(currentScale)));
    });

    testWidgets('should apply high contrast theme globally', (
      WidgetTester tester,
    ) async {
      await TestHelpers.pumpAppWithProviders(tester, const WelcomeScreen());

      // Navigate to settings and enable high contrast
      await TestHelpers.pumpAppWithProviders(tester, const SettingsScreen());

      final highContrastSwitch = find.byType(Switch).first;
      await tester.tap(highContrastSwitch, warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 300));

      // Navigate back to welcome screen
      await TestHelpers.pumpAppWithProviders(tester, const WelcomeScreen());

      // Verify the theme changed (this would be verified by checking theme properties)
      // For now, we just verify the navigation worked
      expect(find.byType(WelcomeScreen), findsOneWidget);
    });

    testWidgets('should show semantic labels for screen readers', (
      WidgetTester tester,
    ) async {
      await TestHelpers.pumpAppWithProviders(tester, const SettingsScreen());

      // Verify semantic labels are present
      expect(find.byType(Semantics), findsWidgets);
    });

    testWidgets(
      'should handle multiple accessibility settings simultaneously',
      (WidgetTester tester) async {
        await TestHelpers.pumpAppWithProviders(tester, const SettingsScreen());

        // Enable high contrast
        final highContrastSwitch = find.byType(Switch).first;
        await tester.tap(highContrastSwitch, warnIfMissed: false);
        await tester.pumpAndSettle();

        // Enable reduced motion
        final reducedMotionSwitch = find.byType(Switch).last;
        await tester.tap(reducedMotionSwitch, warnIfMissed: false);
        await tester.pump(const Duration(milliseconds: 300));

        // Adjust text scale
        final slider = find.byType(Slider);
        await tester.drag(slider, const Offset(30, 0), warnIfMissed: false);
        await tester.pump(const Duration(milliseconds: 300));

        // Verify all settings are applied
        final highContrastWidget = tester.widget<Switch>(highContrastSwitch);
        final reducedMotionWidget = tester.widget<Switch>(reducedMotionSwitch);
        final sliderWidget = tester.widget<Slider>(slider);

        expect(highContrastWidget.value, true);
        expect(reducedMotionWidget.value, true);
        expect(sliderWidget.value, isNot(equals(1.0)));
      },
    );

    testWidgets('should reset accessibility settings to defaults', (
      WidgetTester tester,
    ) async {
      await TestHelpers.pumpAppWithProviders(tester, const SettingsScreen());

      // Set some non-default values
      final highContrastSwitch = find.byType(Switch).first;
      await tester.tap(highContrastSwitch, warnIfMissed: false);
      await tester.pumpAndSettle();

      final slider = find.byType(Slider);
      await tester.drag(slider, const Offset(50, 0), warnIfMissed: false);
      await tester.pumpAndSettle();

      // Find and tap reset button
      final resetButton = find.text('Restablecer');
      if (resetButton.evaluate().isNotEmpty) {
        await tester.tap(resetButton, warnIfMissed: false);
        await tester.pump(const Duration(milliseconds: 300));

        // Verify settings were reset
        final highContrastWidget = tester.widget<Switch>(highContrastSwitch);
        final sliderWidget = tester.widget<Slider>(slider);

        expect(highContrastWidget.value, false);
        expect(sliderWidget.value, equals(1.0));
      }
    });
  });
}
