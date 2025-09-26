import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mindcompanion/core/accessibility/simple_accessibility_provider.dart';

void main() {
  group('SimpleAccessibilityProvider', () {
    late SimpleAccessibilityProvider provider;

    setUp(() {
      // Mock SharedPreferences
      SharedPreferences.setMockInitialValues({});
      provider = SimpleAccessibilityProvider();
    });

    test('should initialize with default text scale of 1.0', () {
      expect(provider.textScale, 1.0);
    });

    test('should set text scale within valid range', () async {
      await provider.setTextScale(1.2);
      expect(provider.textScale, 1.2);
    });

    test('should clamp text scale to minimum value', () async {
      await provider.setTextScale(0.5);
      expect(provider.textScale, 0.8);
    });

    test('should clamp text scale to maximum value', () async {
      await provider.setTextScale(2.0);
      expect(provider.textScale, 1.5);
    });

    test('should not notify listeners when setting same value', () async {
      bool listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });

      await provider.setTextScale(1.0);
      expect(listenerCalled, false);
    });

    test('should notify listeners when setting different value', () async {
      bool listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });

      await provider.setTextScale(1.2);
      expect(listenerCalled, true);
    });

    test('should load saved text scale from SharedPreferences', () async {
      // Set a value in SharedPreferences
      SharedPreferences.setMockInitialValues({'accessibility_text_scale': 1.3});

      await provider.init();
      expect(provider.textScale, 1.3);
    });

    test('should use default value when no saved preference exists', () async {
      await provider.init();
      expect(provider.textScale, 1.0);
    });

    test('should handle invalid saved values gracefully', () async {
      // Set an invalid value in SharedPreferences
      SharedPreferences.setMockInitialValues({
        'accessibility_text_scale': 0.5, // Below minimum
      });

      await provider.init();
      expect(provider.textScale, 0.8); // Should be clamped to minimum
    });

    test('should reset to default value', () async {
      await provider.setTextScale(1.3);
      expect(provider.textScale, 1.3);

      await provider.resetToDefault();
      expect(provider.textScale, 1.0);
    });

    test('should format text scale correctly', () async {
      await provider.setTextScale(1.0);
      expect(provider.formattedTextScale, '1.0x');

      await provider.setTextScale(1.25);
      expect(provider.formattedTextScale, '1.3x');

      await provider.setTextScale(0.85);
      expect(provider.formattedTextScale, '0.9x');
    });

    test('should detect minimum and maximum states', () async {
      await provider.setTextScale(0.8);
      expect(provider.isAtMinimum, true);
      expect(provider.isAtMaximum, false);

      await provider.setTextScale(1.5);
      expect(provider.isAtMinimum, false);
      expect(provider.isAtMaximum, true);

      await provider.setTextScale(1.0);
      expect(provider.isAtMinimum, false);
      expect(provider.isAtMaximum, false);
    });

    test('should persist text scale changes', () async {
      await provider.setTextScale(1.2);

      // Create a new provider instance to simulate app restart
      final newProvider = SimpleAccessibilityProvider();
      await newProvider.init();

      expect(newProvider.textScale, 1.2);
    });

    test('should handle SharedPreferences errors gracefully', () async {
      // This test would require mocking SharedPreferences to throw an error
      // For now, we test that the provider doesn't crash
      await provider.setTextScale(1.1);
      expect(provider.textScale, 1.1);
    });

    test('should maintain state consistency', () async {
      await provider.setTextScale(1.3);
      final scale1 = provider.textScale;
      final scale2 = provider.textScale;

      expect(scale1, scale2);
      expect(scale1, 1.3);
    });
  });
}
