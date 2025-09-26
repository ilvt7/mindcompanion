import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Simple accessibility provider focused on text scaling
class SimpleAccessibilityProvider extends ChangeNotifier {
  static const String _textScaleKey = 'accessibility_text_scale';

  double _textScale = 1.0;

  /// Current text scale factor (0.8 - 1.5)
  double get textScale => _textScale;

  /// Initialize the provider and load saved preferences
  Future<void> init() async {
    await _loadTextScale();
  }

  /// Set text scale factor
  Future<void> setTextScale(double value) async {
    // Clamp value between 0.8 and 1.5
    final clampedValue = value.clamp(0.8, 1.5);

    if (_textScale != clampedValue) {
      _textScale = clampedValue;
      await _saveTextScale();
      notifyListeners();
    }
  }

  /// Reset to default text scale
  Future<void> resetToDefault() async {
    await setTextScale(1.0);
  }

  /// Load text scale from SharedPreferences
  Future<void> _loadTextScale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _textScale = prefs.getDouble(_textScaleKey) ?? 1.0;
      // Ensure value is within valid range
      _textScale = _textScale.clamp(0.8, 1.5);
    } catch (e) {
      _textScale = 1.0;
    }
  }

  /// Save text scale to SharedPreferences
  Future<void> _saveTextScale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_textScaleKey, _textScale);
    } catch (e) {
      // Handle error silently
      if (kDebugMode) {
        print('Error saving text scale: $e');
      }
    }
  }

  /// Get formatted text scale for display
  String get formattedTextScale => '${(_textScale * 10).round() / 10}x';

  /// Check if text scale is at minimum
  bool get isAtMinimum => _textScale <= 0.8;

  /// Check if text scale is at maximum
  bool get isAtMaximum => _textScale >= 1.5;
}
