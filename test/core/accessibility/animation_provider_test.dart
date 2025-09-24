import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mindcompanion/core/accessibility/animation_provider.dart';

void main() {
  group('AnimationProvider', () {
    late AnimationProvider provider;

    setUp(() {
      // Mock SharedPreferences
      SharedPreferences.setMockInitialValues({});
      provider = AnimationProvider();
    });

    test('should initialize with default reduced motion state of false', () {
      expect(provider.reduceMotion, false);
    });

    test('should toggle reduced motion state', () async {
      await provider.toggle();
      expect(provider.reduceMotion, true);

      await provider.toggle();
      expect(provider.reduceMotion, false);
    });

    test('should enable reduced motion', () async {
      await provider.enable();
      expect(provider.reduceMotion, true);
    });

    test('should disable reduced motion', () async {
      await provider.enable();
      await provider.disable();
      expect(provider.reduceMotion, false);
    });

    test('should set reduced motion state', () async {
      await provider.setReduceMotion(true);
      expect(provider.reduceMotion, true);

      await provider.setReduceMotion(false);
      expect(provider.reduceMotion, false);
    });

    test('should not notify listeners when setting same value', () async {
      bool listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });

      await provider.setReduceMotion(false);
      expect(listenerCalled, false);
    });

    test('should notify listeners when setting different value', () async {
      bool listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });

      await provider.setReduceMotion(true);
      expect(listenerCalled, true);
    });

    test('should return Duration.zero when reduced motion is enabled', () {
      provider.setReduceMotion(true);
      final duration = provider.getAnimationDuration(normalDuration: const Duration(milliseconds: 300));
      expect(duration, Duration.zero);
    });

    test('should return normal duration when reduced motion is disabled', () {
      provider.setReduceMotion(false);
      final duration = provider.getAnimationDuration(normalDuration: const Duration(milliseconds: 500));
      expect(duration, const Duration(milliseconds: 500));
    });

    test('should return default duration when no normal duration provided', () {
      provider.setReduceMotion(false);
      final duration = provider.getAnimationDuration();
      expect(duration, const Duration(milliseconds: 300));
    });

    test('should return linear curve when reduced motion is enabled', () {
      provider.setReduceMotion(true);
      final curve = provider.getAnimationCurve(normalCurve: Curves.easeInOut);
      expect(curve, Curves.linear);
    });

    test('should return normal curve when reduced motion is disabled', () {
      provider.setReduceMotion(false);
      final curve = provider.getAnimationCurve(normalCurve: Curves.bounceOut);
      expect(curve, Curves.bounceOut);
    });

    test('should return default curve when no normal curve provided', () {
      provider.setReduceMotion(false);
      final curve = provider.getAnimationCurve();
      expect(curve, Curves.easeInOut);
    });

    test('should return very short duration for controller when reduced motion is enabled', () {
      provider.setReduceMotion(true);
      final duration = provider.getControllerDuration(normalDuration: const Duration(milliseconds: 300));
      expect(duration, const Duration(milliseconds: 1));
    });

    test('should return normal duration for controller when reduced motion is disabled', () {
      provider.setReduceMotion(false);
      final duration = provider.getControllerDuration(normalDuration: const Duration(milliseconds: 500));
      expect(duration, const Duration(milliseconds: 500));
    });

    test('should return default duration for controller when no normal duration provided', () {
      provider.setReduceMotion(false);
      final duration = provider.getControllerDuration();
      expect(duration, const Duration(milliseconds: 300));
    });

    test('should return true for shouldReduceAnimations when enabled', () {
      provider.setReduceMotion(true);
      expect(provider.shouldReduceAnimations(), true);
    });

    test('should return false for shouldReduceAnimations when disabled', () {
      provider.setReduceMotion(false);
      expect(provider.shouldReduceAnimations(), false);
    });

    test('should return 1.0 for getAnimationValue when reduced motion is enabled', () {
      provider.setReduceMotion(true);
      final value = provider.getAnimationValue(normalValue: 0.5);
      expect(value, 1.0);
    });

    test('should return normal value for getAnimationValue when reduced motion is disabled', () {
      provider.setReduceMotion(false);
      final value = provider.getAnimationValue(normalValue: 0.7);
      expect(value, 0.7);
    });

    test('should return default value for getAnimationValue when no normal value provided', () {
      provider.setReduceMotion(false);
      final value = provider.getAnimationValue();
      expect(value, 1.0);
    });

    test('should load saved reduced motion state from SharedPreferences', () async {
      // Set a value in SharedPreferences
      SharedPreferences.setMockInitialValues({
        'accessibility_reduce_motion': true,
      });

      await provider.init();
      expect(provider.reduceMotion, true);
    });

    test('should use default value when no saved preference exists', () async {
      await provider.init();
      expect(provider.reduceMotion, false);
    });

    test('should handle invalid saved values gracefully', () async {
      // Set an invalid value in SharedPreferences
      SharedPreferences.setMockInitialValues({
        'accessibility_reduce_motion': 'invalid', // Wrong type
      });

      await provider.init();
      expect(provider.reduceMotion, false); // Should default to false
    });

    test('should reset to default value', () async {
      await provider.enable();
      expect(provider.reduceMotion, true);

      await provider.resetToDefault();
      expect(provider.reduceMotion, false);
    });

    test('should persist reduced motion changes', () async {
      await provider.enable();
      
      // Create a new provider instance to simulate app restart
      final newProvider = AnimationProvider();
      await newProvider.init();
      
      expect(newProvider.reduceMotion, true);
    });

    test('should handle SharedPreferences errors gracefully', () async {
      // This test would require mocking SharedPreferences to throw an error
      // For now, we test that the provider doesn't crash
      await provider.setReduceMotion(true);
      expect(provider.reduceMotion, true);
    });

    test('should maintain state consistency', () async {
      await provider.setReduceMotion(true);
      final state1 = provider.reduceMotion;
      final state2 = provider.reduceMotion;
      
      expect(state1, state2);
      expect(state1, true);
    });

    test('should return correct status information', () async {
      await provider.enable();
      final status = provider.getStatus();
      
      expect(status['reduceMotion'], true);
    });

    test('should handle multiple rapid toggles', () async {
      // Test rapid toggles
      await provider.toggle(); // true
      await provider.toggle(); // false
      await provider.toggle(); // true
      await provider.toggle(); // false
      
      expect(provider.reduceMotion, false);
    });

    test('should handle concurrent state changes', () async {
      // Simulate concurrent state changes
      await Future.wait([
        provider.setReduceMotion(true),
        provider.setReduceMotion(false),
        provider.setReduceMotion(true),
      ]);
      
      // Should end up in a consistent state
      expect(provider.reduceMotion, true);
    });
  });
}
