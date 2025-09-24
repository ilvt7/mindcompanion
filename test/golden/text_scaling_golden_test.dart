import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mindcompanion/core/accessibility/simple_accessibility_provider.dart';
import 'package:mindcompanion/screens/settings_screen.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('Text Scaling Golden Tests', () {
    testWidgets('settings screen with default text scale (1.0x)', (WidgetTester tester) async {
      await TestHelpers.pumpAppWithProviders(
        tester,
        const SettingsScreen(),
      );

      // Ensure text scale is at default
      await TestHelpers.pumpUntilFound(tester, find.byType(MaterialApp));
      final accessibilityProvider = Provider.of<SimpleAccessibilityProvider>(
        tester.element(find.byType(MaterialApp).first),
        listen: false,
      );
      await accessibilityProvider.setTextScale(1.0);
      await tester.pump(const Duration(milliseconds: 300));

      // Take golden test screenshot
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('settings_text_scale_1_0.png'),
      );
    });

    testWidgets('settings screen with minimum text scale (0.8x)', (WidgetTester tester) async {
      await TestHelpers.pumpAppWithProviders(
        tester,
        const SettingsScreen(),
      );

      // Set to minimum text scale
      await TestHelpers.pumpUntilFound(tester, find.byType(MaterialApp));
      final accessibilityProvider = Provider.of<SimpleAccessibilityProvider>(
        tester.element(find.byType(MaterialApp).first),
        listen: false,
      );
      await accessibilityProvider.setTextScale(0.8);
      await tester.pump(const Duration(milliseconds: 300));

      // Take golden test screenshot
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('settings_text_scale_0_8.png'),
      );
    });

    testWidgets('settings screen with maximum text scale (1.5x)', (WidgetTester tester) async {
      await TestHelpers.pumpAppWithProviders(
        tester,
        const SettingsScreen(),
      );

      // Set to maximum text scale
      await TestHelpers.pumpUntilFound(tester, find.byType(MaterialApp));
      final accessibilityProvider = Provider.of<SimpleAccessibilityProvider>(
        tester.element(find.byType(MaterialApp).first),
        listen: false,
      );
      await accessibilityProvider.setTextScale(1.5);
      await tester.pump(const Duration(milliseconds: 300));

      // Take golden test screenshot
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('settings_text_scale_1_5.png'),
      );
    });

    testWidgets('settings screen with medium text scale (1.2x)', (WidgetTester tester) async {
      await TestHelpers.pumpAppWithProviders(
        tester,
        const SettingsScreen(),
      );

      // Set to medium text scale
      await TestHelpers.pumpUntilFound(tester, find.byType(MaterialApp));
      final accessibilityProvider = Provider.of<SimpleAccessibilityProvider>(
        tester.element(find.byType(MaterialApp).first),
        listen: false,
      );
      await accessibilityProvider.setTextScale(1.2);
      await tester.pump(const Duration(milliseconds: 300));

      // Take golden test screenshot
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('settings_text_scale_1_2.png'),
      );
    });

    testWidgets('welcome screen with different text scales', (WidgetTester tester) async {
      // Test with default scale
      await TestHelpers.pumpAppWithProviders(
        tester,
        const SettingsScreen(),
      );

      await TestHelpers.pumpUntilFound(tester, find.byType(MaterialApp));
      final accessibilityProvider = Provider.of<SimpleAccessibilityProvider>(
        tester.element(find.byType(MaterialApp).first),
        listen: false,
      );

      // Test 1.0x scale
      await accessibilityProvider.setTextScale(1.0);
      await tester.pump(const Duration(milliseconds: 300));
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('welcome_text_scale_1_0.png'),
      );

      // Test 1.3x scale
      await accessibilityProvider.setTextScale(1.3);
      await tester.pump(const Duration(milliseconds: 300));
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('welcome_text_scale_1_3.png'),
      );
    });

    testWidgets('accessibility settings widget only', (WidgetTester tester) async {
      await TestHelpers.pumpAppWithProviders(
        tester,
        const SettingsScreen(),
      );

      // Get accessibility provider from MaterialApp context
      await TestHelpers.pumpUntilFound(tester, find.byType(MaterialApp));
      final accessibilityProvider = Provider.of<SimpleAccessibilityProvider>(
        tester.element(find.byType(MaterialApp).first),
        listen: false,
      );

      // Test different scales for the accessibility widget
      final scales = [0.8, 1.0, 1.2, 1.5];
      
      for (final scale in scales) {
        await accessibilityProvider.setTextScale(scale);
        await tester.pump(const Duration(milliseconds: 300));
        
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('accessibility_widget_scale_${scale.toString().replaceAll('.', '_')}.png'),
        );
      }
    });
  });
}
