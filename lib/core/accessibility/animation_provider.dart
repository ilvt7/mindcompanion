import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for managing reduced motion preferences
class AnimationProvider extends ChangeNotifier {
  static const String _reduceMotionKey = 'accessibility_reduce_motion';

  bool _reduceMotion = false;

  /// Current reduced motion state
  bool get reduceMotion => _reduceMotion;

  /// Initialize the provider and load saved preferences
  Future<void> init() async {
    await _loadReduceMotion();
  }

  /// Toggle reduced motion
  Future<void> toggle() async {
    await setReduceMotion(!_reduceMotion);
  }

  /// Enable reduced motion
  Future<void> enable() async {
    await setReduceMotion(true);
  }

  /// Disable reduced motion
  Future<void> disable() async {
    await setReduceMotion(false);
  }

  /// Set reduced motion state
  Future<void> setReduceMotion(bool value) async {
    if (_reduceMotion != value) {
      _reduceMotion = value;
      await _saveReduceMotion();
      notifyListeners();
    }
  }

  /// Reset to default (disabled)
  Future<void> resetToDefault() async {
    await setReduceMotion(false);
  }

  /// Get animation duration based on reduced motion setting
  Duration getAnimationDuration({Duration? normalDuration}) {
    if (_reduceMotion) {
      return Duration.zero;
    }
    return normalDuration ?? const Duration(milliseconds: 300);
  }

  /// Get animation curve based on reduced motion setting
  Curve getAnimationCurve({Curve? normalCurve}) {
    if (_reduceMotion) {
      return Curves.linear;
    }
    return normalCurve ?? Curves.easeInOut;
  }

  /// Get animation controller duration
  Duration getControllerDuration({Duration? normalDuration}) {
    if (_reduceMotion) {
      return const Duration(milliseconds: 1); // Very short duration
    }
    return normalDuration ?? const Duration(milliseconds: 300);
  }

  /// Check if animations should be reduced
  bool shouldReduceAnimations() {
    return _reduceMotion;
  }

  /// Get animation value based on reduced motion setting
  double getAnimationValue({double? normalValue}) {
    if (_reduceMotion) {
      return 1.0; // Skip to final state
    }
    return normalValue ?? 1.0;
  }

  /// Load reduced motion state from SharedPreferences
  Future<void> _loadReduceMotion() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _reduceMotion = prefs.getBool(_reduceMotionKey) ?? false;
    } catch (e) {
      _reduceMotion = false;
      if (kDebugMode) {
        print('Error loading reduce motion preference: $e');
      }
    }
  }

  /// Save reduced motion state to SharedPreferences
  Future<void> _saveReduceMotion() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_reduceMotionKey, _reduceMotion);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving reduce motion preference: $e');
      }
    }
  }

  /// Get status information
  Map<String, dynamic> getStatus() {
    return {'reduceMotion': _reduceMotion};
  }
}

/// Extension for easy animation duration access
extension AnimationProviderExtension on BuildContext {
  /// Get animation duration from AnimationProvider
  Duration getAnimationDuration({Duration? normalDuration}) {
    try {
      final animationProvider = Provider.of<AnimationProvider>(
        this,
        listen: false,
      );
      return animationProvider.getAnimationDuration(
        normalDuration: normalDuration,
      );
    } catch (e) {
      return normalDuration ?? const Duration(milliseconds: 300);
    }
  }

  /// Get animation curve from AnimationProvider
  Curve getAnimationCurve({Curve? normalCurve}) {
    try {
      final animationProvider = Provider.of<AnimationProvider>(
        this,
        listen: false,
      );
      return animationProvider.getAnimationCurve(normalCurve: normalCurve);
    } catch (e) {
      return normalCurve ?? Curves.easeInOut;
    }
  }

  /// Check if animations should be reduced
  bool shouldReduceAnimations() {
    try {
      final animationProvider = Provider.of<AnimationProvider>(
        this,
        listen: false,
      );
      return animationProvider.shouldReduceAnimations();
    } catch (e) {
      return false;
    }
  }
}
