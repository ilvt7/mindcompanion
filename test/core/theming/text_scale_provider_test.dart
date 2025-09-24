import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mindcompanion/core/theming/text_scale_provider.dart';

import 'text_scale_provider_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  group('TextScaleProvider', () {
    late TextScaleProvider textScaleProvider;
    late MockSharedPreferences mockPrefs;

    setUp(() {
      textScaleProvider = TextScaleProvider();
      mockPrefs = MockSharedPreferences();
    });

    test('should initialize with default values', () {
      expect(textScaleProvider.textScaleFactor, 1.0);
      expect(textScaleProvider.minScale, 0.8);
      expect(textScaleProvider.maxScale, 2.0);
      expect(textScaleProvider.step, 0.1);
    });

    test('should set text scale factor within valid range', () async {
      await textScaleProvider.setTextScaleFactor(1.2);
      expect(textScaleProvider.textScaleFactor, 1.2);
    });

    test('should clamp text scale factor to valid range', () async {
      await textScaleProvider.setTextScaleFactor(2.5); // Above max
      expect(textScaleProvider.textScaleFactor, 2.0);
      
      await textScaleProvider.setTextScaleFactor(0.5); // Below min
      expect(textScaleProvider.textScaleFactor, 0.8);
    });

    test('should increase text scale factor', () async {
      await textScaleProvider.increaseTextScale();
      expect(textScaleProvider.textScaleFactor, 1.1);
    });

    test('should not increase beyond maximum', () async {
      await textScaleProvider.setTextScaleFactor(2.0);
      await textScaleProvider.increaseTextScale();
      expect(textScaleProvider.textScaleFactor, 2.0);
    });

    test('should decrease text scale factor', () async {
      await textScaleProvider.setTextScaleFactor(1.2);
      await textScaleProvider.decreaseTextScale();
      expect(textScaleProvider.textScaleFactor, closeTo(1.1, 0.01));
    });

    test('should not decrease below minimum', () async {
      await textScaleProvider.setTextScaleFactor(0.8);
      await textScaleProvider.decreaseTextScale();
      expect(textScaleProvider.textScaleFactor, 0.8);
    });

    test('should reset to default', () async {
      await textScaleProvider.setTextScaleFactor(1.5);
      await textScaleProvider.resetTextScale();
      expect(textScaleProvider.textScaleFactor, 1.0);
    });

    test('should return correct percentage', () {
      textScaleProvider.setTextScaleFactor(1.2);
      expect(textScaleProvider.textScalePercentage, 120);
    });

    test('should set text scale by percentage', () async {
      await textScaleProvider.setTextScalePercentage(150);
      expect(textScaleProvider.textScaleFactor, 1.5);
    });

    test('should clamp percentage to valid range', () async {
      await textScaleProvider.setTextScalePercentage(300); // Above max
      expect(textScaleProvider.textScaleFactor, 2.0);
      
      await textScaleProvider.setTextScalePercentage(50); // Below min
      expect(textScaleProvider.textScaleFactor, 0.8);
    });

    test('should return correct display name', () {
      textScaleProvider.setTextScaleFactor(0.8);
      expect(textScaleProvider.textScaleDisplayName, 'Small');
      
      textScaleProvider.setTextScaleFactor(1.0);
      expect(textScaleProvider.textScaleDisplayName, 'Normal');
      
      textScaleProvider.setTextScaleFactor(1.2);
      expect(textScaleProvider.textScaleDisplayName, 'Large');
      
      textScaleProvider.setTextScaleFactor(1.4);
      expect(textScaleProvider.textScaleDisplayName, 'Extra Large');
      
      textScaleProvider.setTextScaleFactor(1.6);
      expect(textScaleProvider.textScaleDisplayName, 'Huge');
    });

    test('should return correct description', () {
      textScaleProvider.setTextScaleFactor(1.2);
      expect(textScaleProvider.textScaleDescription, '120% - Large');
    });

    test('should detect minimum and maximum states', () {
      textScaleProvider.setTextScaleFactor(0.8);
      expect(textScaleProvider.isAtMinimum, true);
      expect(textScaleProvider.isAtMaximum, false);
      
      textScaleProvider.setTextScaleFactor(2.0);
      expect(textScaleProvider.isAtMinimum, false);
      expect(textScaleProvider.isAtMaximum, true);
    });

    test('should return media query text scale factor', () {
      textScaleProvider.setTextScaleFactor(1.3);
      expect(textScaleProvider.mediaQueryTextScaleFactor, 1.3);
    });
  });
}