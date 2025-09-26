import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for managing text scale factor (font size)
class TextScaleProvider extends ChangeNotifier {
  static const String _textScaleKey = 'text_scale_factor';
  static const double _defaultScale = 1.0;
  static const double _minScale = 0.8;
  static const double _maxScale = 2.0;
  static const double _step = 0.1;

  double _textScaleFactor = _defaultScale;

  double get textScaleFactor => _textScaleFactor;
  double get minScale => _minScale;
  double get maxScale => _maxScale;
  double get step => _step;

  /// Initialize text scale provider
  Future<void> init() async {
    await _loadTextScaleFromPreferences();
  }

  /// Set text scale factor
  Future<void> setTextScaleFactor(double scale) async {
    // Clamp the scale factor to valid range
    final clampedScale = scale.clamp(_minScale, _maxScale);

    if (_textScaleFactor == clampedScale) return;

    _textScaleFactor = clampedScale;
    await _saveTextScaleToPreferences();
    notifyListeners();
  }

  /// Increase text scale factor
  Future<void> increaseTextScale() async {
    final newScale = (_textScaleFactor + _step).clamp(_minScale, _maxScale);
    await setTextScaleFactor(newScale);
  }

  /// Decrease text scale factor
  Future<void> decreaseTextScale() async {
    final newScale = (_textScaleFactor - _step).clamp(_minScale, _maxScale);
    await setTextScaleFactor(newScale);
  }

  /// Reset text scale factor to default
  Future<void> resetTextScale() async {
    await setTextScaleFactor(_defaultScale);
  }

  /// Load text scale from SharedPreferences
  Future<void> _loadTextScaleFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final scale = prefs.getDouble(_textScaleKey) ?? _defaultScale;
      _textScaleFactor = scale.clamp(_minScale, _maxScale);
    } catch (e) {
      _textScaleFactor = _defaultScale;
    }
  }

  /// Save text scale to SharedPreferences
  Future<void> _saveTextScaleToPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_textScaleKey, _textScaleFactor);
    } catch (e) {
      // Handle error silently
    }
  }

  /// Get text scale factor percentage
  int get textScalePercentage => (_textScaleFactor * 100).round();

  /// Set text scale factor by percentage
  Future<void> setTextScalePercentage(int percentage) async {
    final scale = (percentage / 100.0).clamp(_minScale, _maxScale);
    await setTextScaleFactor(scale);
  }

  /// Get text scale factor display name
  String get textScaleDisplayName {
    if (_textScaleFactor <= 0.9) {
      return 'Small';
    } else if (_textScaleFactor <= 1.1) {
      return 'Normal';
    } else if (_textScaleFactor <= 1.3) {
      return 'Large';
    } else if (_textScaleFactor <= 1.5) {
      return 'Extra Large';
    } else {
      return 'Huge';
    }
  }

  /// Get text scale factor description
  String get textScaleDescription {
    return '$textScalePercentage% - $textScaleDisplayName';
  }

  /// Check if text scale is at minimum
  bool get isAtMinimum => _textScaleFactor <= _minScale;

  /// Check if text scale is at maximum
  bool get isAtMaximum => _textScaleFactor >= _maxScale;

  /// Get text scale factor for MediaQuery
  double get mediaQueryTextScaleFactor => _textScaleFactor;
}
