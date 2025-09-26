import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for managing high contrast mode
class HighContrastProvider extends ChangeNotifier {
  static const String _highContrastKey = 'accessibility_high_contrast';

  bool _isHighContrast = false;

  /// Current high contrast state
  bool get isHighContrast => _isHighContrast;

  /// Initialize the provider and load saved preferences
  Future<void> init() async {
    await _loadHighContrast();
  }

  /// Toggle high contrast mode
  Future<void> toggle() async {
    await setHighContrast(!_isHighContrast);
  }

  /// Enable high contrast mode
  Future<void> enable() async {
    await setHighContrast(true);
  }

  /// Disable high contrast mode
  Future<void> disable() async {
    await setHighContrast(false);
  }

  /// Set high contrast mode
  Future<void> setHighContrast(bool value) async {
    if (_isHighContrast != value) {
      _isHighContrast = value;
      await _saveHighContrast();
      notifyListeners();
    }
  }

  /// Reset to default (disabled)
  Future<void> resetToDefault() async {
    await setHighContrast(false);
  }

  /// Load high contrast state from SharedPreferences
  Future<void> _loadHighContrast() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isHighContrast = prefs.getBool(_highContrastKey) ?? false;
    } catch (e) {
      _isHighContrast = false;
      if (kDebugMode) {
        print('Error loading high contrast preference: $e');
      }
    }
  }

  /// Save high contrast state to SharedPreferences
  Future<void> _saveHighContrast() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_highContrastKey, _isHighContrast);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving high contrast preference: $e');
      }
    }
  }

  /// Get status information
  Map<String, dynamic> getStatus() {
    return {'isHighContrast': _isHighContrast};
  }
}
