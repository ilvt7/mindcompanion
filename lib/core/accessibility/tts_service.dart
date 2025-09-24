import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for Text-to-Speech functionality
class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;
  bool _isEnabled = true;
  bool _isSpeaking = false;
  String _language = "en-US";
  double _speechRate = 0.5;
  double _volume = 1.0;
  double _pitch = 1.0;

  // Keys for SharedPreferences
  static const String _enabledKey = 'tts_enabled';
  static const String _languageKey = 'tts_language';
  static const String _speechRateKey = 'tts_speech_rate';
  static const String _volumeKey = 'tts_volume';
  static const String _pitchKey = 'tts_pitch';

  bool get isInitialized => _isInitialized;
  bool get isEnabled => _isEnabled;
  bool get isSpeaking => _isSpeaking;
  String get language => _language;
  double get speechRate => _speechRate;
  double get volume => _volume;
  double get pitch => _pitch;

  /// Initialize the TTS service
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      // Load preferences
      await _loadPreferences();

      // Set up TTS with defaults
      await _flutterTts.setLanguage(_language);
      await _flutterTts.setSpeechRate(_speechRate);
      await _flutterTts.setVolume(_volume);
      await _flutterTts.setPitch(_pitch);

      // Set up completion handler
      _flutterTts.setCompletionHandler(() {
        _isSpeaking = false;
        if (kDebugMode) {
          print('TTS completed');
        }
      });

      // Set up error handler
      _flutterTts.setErrorHandler((msg) {
        _isSpeaking = false;
        if (kDebugMode) {
          print('TTS error: $msg');
        }
      });

      _isInitialized = true;
      if (kDebugMode) {
        print('TTS Service initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing TTS Service: $e');
      }
      rethrow;
    }
  }

  /// Speak text
  Future<void> speak(String text) async {
    if (!_isInitialized) {
      throw StateError('TTS Service not initialized. Call init() first.');
    }

    if (!_isEnabled || text.isEmpty) return;

    try {
      _isSpeaking = true;
      await _flutterTts.speak(text);
      if (kDebugMode) {
        print('TTS speaking: $text');
      }
    } catch (e) {
      _isSpeaking = false;
      if (kDebugMode) {
        print('Error speaking text: $e');
      }
      rethrow;
    }
  }

  /// Stop speaking
  Future<void> stop() async {
    if (!_isInitialized) {
      throw StateError('TTS Service not initialized. Call init() first.');
    }

    try {
      await _flutterTts.stop();
      _isSpeaking = false;
      if (kDebugMode) {
        print('TTS stopped');
      }
    } catch (e) {
      _isSpeaking = false;
      if (kDebugMode) {
        print('Error stopping TTS: $e');
      }
      rethrow;
    }
  }

  /// Set language
  Future<void> setLanguage(String langCode) async {
    if (!_isInitialized) {
      throw StateError('TTS Service not initialized. Call init() first.');
    }

    try {
      await _flutterTts.setLanguage(langCode);
      _language = langCode;
      await _savePreferences();
      if (kDebugMode) {
        print('TTS language set to: $langCode');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error setting language: $e');
      }
      rethrow;
    }
  }

  /// Pause speaking
  Future<void> pause() async {
    if (!_isInitialized) {
      throw StateError('TTS Service not initialized. Call init() first.');
    }

    try {
      await _flutterTts.pause();
      if (kDebugMode) {
        print('TTS paused');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error pausing TTS: $e');
      }
      rethrow;
    }
  }

  /// Set TTS enabled/disabled
  Future<void> setEnabled(bool enabled) async {
    if (_isEnabled == enabled) return;

    _isEnabled = enabled;
    await _savePreferences();

    if (!enabled) {
      await stop();
    }

    if (kDebugMode) {
      print('TTS enabled: $enabled');
    }
  }

  /// Set speech rate (0.1 to 1.0)
  Future<void> setSpeechRate(double rate) async {
    final clampedRate = rate.clamp(0.1, 1.0);
    if (_speechRate == clampedRate) return;

    _speechRate = clampedRate;
    await _flutterTts.setSpeechRate(_speechRate);
    await _savePreferences();

    if (kDebugMode) {
      print('TTS speech rate set to: $_speechRate');
    }
  }

  /// Set volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    final clampedVolume = volume.clamp(0.0, 1.0);
    if (_volume == clampedVolume) return;

    _volume = clampedVolume;
    await _flutterTts.setVolume(_volume);
    await _savePreferences();

    if (kDebugMode) {
      print('TTS volume set to: $_volume');
    }
  }

  /// Set pitch (0.5 to 2.0)
  Future<void> setPitch(double pitch) async {
    final clampedPitch = pitch.clamp(0.5, 2.0);
    if (_pitch == clampedPitch) return;

    _pitch = clampedPitch;
    await _flutterTts.setPitch(_pitch);
    await _savePreferences();

    if (kDebugMode) {
      print('TTS pitch set to: $_pitch');
    }
  }

  /// Get available languages
  Future<List<dynamic>> getLanguages() async {
    if (!_isInitialized) {
      throw StateError('TTS Service not initialized. Call init() first.');
    }

    try {
      return await _flutterTts.getLanguages;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting languages: $e');
      }
      return [];
    }
  }


  /// Load preferences from SharedPreferences
  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isEnabled = prefs.getBool(_enabledKey) ?? true;
      _language = prefs.getString(_languageKey) ?? "en-US";
      _speechRate = prefs.getDouble(_speechRateKey) ?? 0.5;
      _volume = prefs.getDouble(_volumeKey) ?? 1.0;
      _pitch = prefs.getDouble(_pitchKey) ?? 1.0;
    } catch (e) {
      if (kDebugMode) {
        print('Error loading TTS preferences: $e');
      }
    }
  }

  /// Save preferences to SharedPreferences
  Future<void> _savePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_enabledKey, _isEnabled);
      await prefs.setString(_languageKey, _language);
      await prefs.setDouble(_speechRateKey, _speechRate);
      await prefs.setDouble(_volumeKey, _volume);
      await prefs.setDouble(_pitchKey, _pitch);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving TTS preferences: $e');
      }
    }
  }

  /// Get TTS status
  Map<String, dynamic> getStatus() {
    return {
      'initialized': _isInitialized,
      'enabled': _isEnabled,
      'isSpeaking': _isSpeaking,
      'language': _language,
      'speechRate': _speechRate,
      'volume': _volume,
      'pitch': _pitch,
    };
  }

  /// Reset all settings to default
  Future<void> resetToDefaults() async {
    _isEnabled = true;
    _language = "en-US";
    _speechRate = 0.5;
    _volume = 1.0;
    _pitch = 1.0;

    if (_isInitialized) {
      await _flutterTts.setLanguage(_language);
      await _flutterTts.setSpeechRate(_speechRate);
      await _flutterTts.setVolume(_volume);
      await _flutterTts.setPitch(_pitch);
    }

    await _savePreferences();
  }

  /// Dispose resources
  void dispose() {
    _flutterTts.stop();
  }
}
