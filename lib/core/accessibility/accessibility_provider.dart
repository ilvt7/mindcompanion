import 'package:flutter/material.dart';
import '../theming/theme_provider.dart';
import '../theming/text_scale_provider.dart';
import 'tts_service.dart';

/// Combined provider for all accessibility features
class AccessibilityProvider extends ChangeNotifier {
  late ThemeProvider _themeProvider;
  late TextScaleProvider _textScaleProvider;
  late TtsService _ttsService;
  bool _isInitialized = false;

  ThemeProvider get themeProvider => _themeProvider;
  TextScaleProvider get textScaleProvider => _textScaleProvider;
  TtsService get ttsService => _ttsService;
  bool get isInitialized => _isInitialized;

  /// Initialize all accessibility providers
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      _themeProvider = ThemeProvider();
      _textScaleProvider = TextScaleProvider();
      _ttsService = TtsService();

      // Initialize all providers
      await Future.wait([
        _themeProvider.init(),
        _textScaleProvider.init(),
        _ttsService.init(),
      ]);

      // Listen to changes in sub-providers
      _themeProvider.addListener(_onThemeChanged);
      _textScaleProvider.addListener(_onTextScaleChanged);

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      print('Error initializing AccessibilityProvider: $e');
      rethrow;
    }
  }

  /// Handle theme changes
  void _onThemeChanged() {
    notifyListeners();
  }

  /// Handle text scale changes
  void _onTextScaleChanged() {
    notifyListeners();
  }

  /// Get current theme data
  ThemeData get currentTheme => _themeProvider.currentTheme;

  /// Get theme mode for MaterialApp
  ThemeMode get themeMode => _themeProvider.materialThemeMode;

  /// Get text scale factor for MediaQuery
  double get textScaleFactor => _textScaleProvider.mediaQueryTextScaleFactor;

  /// Get accessibility status
  Map<String, dynamic> getAccessibilityStatus() {
    return {
      'initialized': _isInitialized,
      'theme': {
        'mode': _themeProvider.themeMode.name,
        'isDark': _themeProvider.isDarkMode,
      },
      'textScale': {
        'factor': _textScaleProvider.textScaleFactor,
        'percentage': _textScaleProvider.textScalePercentage,
        'displayName': _textScaleProvider.textScaleDisplayName,
      },
      'tts': _ttsService.getStatus(),
    };
  }

  /// Reset all accessibility settings to default
  Future<void> resetToDefaults() async {
    await Future.wait([
      _themeProvider.setThemeMode(AppThemeMode.system),
      _textScaleProvider.resetTextScale(),
      _ttsService.resetToDefaults(),
    ]);
    notifyListeners();
  }

  @override
  void dispose() {
    _themeProvider.removeListener(_onThemeChanged);
    _textScaleProvider.removeListener(_onTextScaleChanged);
    _ttsService.dispose();
    super.dispose();
  }
}
