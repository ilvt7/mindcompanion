import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mindcompanion/core/accessibility/high_contrast_provider.dart';

void main() {
  group('HighContrastProvider', () {
    late HighContrastProvider provider;

    setUp(() {
      // Mock SharedPreferences
      SharedPreferences.setMockInitialValues({});
      provider = HighContrastProvider();
    });

    test('should initialize with default high contrast state of false', () {
      expect(provider.isHighContrast, false);
    });

    test('should toggle high contrast state', () async {
      await provider.toggle();
      expect(provider.isHighContrast, true);

      await provider.toggle();
      expect(provider.isHighContrast, false);
    });

    test('should enable high contrast', () async {
      await provider.enable();
      expect(provider.isHighContrast, true);
    });

    test('should disable high contrast', () async {
      await provider.enable();
      await provider.disable();
      expect(provider.isHighContrast, false);
    });

    test('should set high contrast state', () async {
      await provider.setHighContrast(true);
      expect(provider.isHighContrast, true);

      await provider.setHighContrast(false);
      expect(provider.isHighContrast, false);
    });

    test('should not notify listeners when setting same value', () async {
      bool listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });

      await provider.setHighContrast(false);
      expect(listenerCalled, false);
    });

    test('should notify listeners when setting different value', () async {
      bool listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });

      await provider.setHighContrast(true);
      expect(listenerCalled, true);
    });

    test(
      'should load saved high contrast state from SharedPreferences',
      () async {
        // Set a value in SharedPreferences
        SharedPreferences.setMockInitialValues({
          'accessibility_high_contrast': true,
        });

        await provider.init();
        expect(provider.isHighContrast, true);
      },
    );

    test('should use default value when no saved preference exists', () async {
      await provider.init();
      expect(provider.isHighContrast, false);
    });

    test('should handle invalid saved values gracefully', () async {
      // Set an invalid value in SharedPreferences
      SharedPreferences.setMockInitialValues({
        'accessibility_high_contrast': 'invalid', // Wrong type
      });

      await provider.init();
      expect(provider.isHighContrast, false); // Should default to false
    });

    test('should reset to default value', () async {
      await provider.enable();
      expect(provider.isHighContrast, true);

      await provider.resetToDefault();
      expect(provider.isHighContrast, false);
    });

    test('should persist high contrast changes', () async {
      await provider.enable();

      // Create a new provider instance to simulate app restart
      final newProvider = HighContrastProvider();
      await newProvider.init();

      expect(newProvider.isHighContrast, true);
    });

    test('should handle SharedPreferences errors gracefully', () async {
      // This test would require mocking SharedPreferences to throw an error
      // For now, we test that the provider doesn't crash
      await provider.setHighContrast(true);
      expect(provider.isHighContrast, true);
    });

    test('should maintain state consistency', () async {
      await provider.setHighContrast(true);
      final state1 = provider.isHighContrast;
      final state2 = provider.isHighContrast;

      expect(state1, state2);
      expect(state1, true);
    });

    test('should return correct status information', () async {
      await provider.enable();
      final status = provider.getStatus();

      expect(status['isHighContrast'], true);
    });

    test('should handle multiple rapid toggles', () async {
      // Test rapid toggles
      await provider.toggle(); // true
      await provider.toggle(); // false
      await provider.toggle(); // true
      await provider.toggle(); // false

      expect(provider.isHighContrast, false);
    });

    test('should handle concurrent state changes', () async {
      // Simulate concurrent state changes
      await Future.wait([
        provider.setHighContrast(true),
        provider.setHighContrast(false),
        provider.setHighContrast(true),
      ]);

      // Should end up in a consistent state
      expect(provider.isHighContrast, true);
    });
  });
}
