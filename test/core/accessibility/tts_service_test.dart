import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mindcompanion/core/accessibility/tts_service.dart';

import 'tts_service_test.mocks.dart';

@GenerateMocks([FlutterTts, SharedPreferences])
void main() {
  group('TtsService', () {
    // Skip TTS tests in CI/CD due to plugin dependencies
    setUpAll(() {
      // Initialize Flutter binding for tests
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    // Skip all TTS tests due to plugin dependencies
    test('TTS tests disabled in CI/CD', () {
      // This test is intentionally empty to skip TTS functionality
      // TTS tests require platform-specific plugins that don't work in CI/CD
    }, skip: true);
    late TtsService ttsService;
    late MockFlutterTts mockFlutterTts;
    late MockSharedPreferences mockPrefs;

    setUpAll(() {
      // Initialize Flutter binding for tests
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    setUp(() {
      ttsService = TtsService();
      mockFlutterTts = MockFlutterTts();
      mockPrefs = MockSharedPreferences();
    });

    test('should initialize with default values', () {
      expect(ttsService.isInitialized, false);
      expect(ttsService.isEnabled, true);
      expect(ttsService.speechRate, 0.5);
      expect(ttsService.volume, 1.0);
      expect(ttsService.pitch, 1.0);
    });

    test('should set enabled state', () async {
      await ttsService.setEnabled(false);
      expect(ttsService.isEnabled, false);
    });

    test('should set speech rate within valid range', () async {
      await ttsService.setSpeechRate(0.8);
      expect(ttsService.speechRate, 0.8);
    });

    test('should clamp speech rate to valid range', () async {
      await ttsService.setSpeechRate(1.5); // Above max
      expect(ttsService.speechRate, 1.0);

      await ttsService.setSpeechRate(-0.1); // Below min
      expect(ttsService.speechRate, 0.0);
    });

    test('should set volume within valid range', () async {
      await ttsService.setVolume(0.7);
      expect(ttsService.volume, 0.7);
    });

    test('should clamp volume to valid range', () async {
      await ttsService.setVolume(1.5); // Above max
      expect(ttsService.volume, 1.0);

      await ttsService.setVolume(-0.1); // Below min
      expect(ttsService.volume, 0.0);
    });

    test('should set pitch within valid range', () async {
      await ttsService.setPitch(1.5);
      expect(ttsService.pitch, 1.5);
    });

    test('should set language', () async {
      await ttsService.setLanguage('es-ES');
      expect(ttsService.language, 'es-ES');
    });

    test('should clamp pitch to valid range', () async {
      await ttsService.setPitch(2.5); // Above max
      expect(ttsService.pitch, 2.0);

      await ttsService.setPitch(0.3); // Below min
      expect(ttsService.pitch, 0.5);
    });

    test('should reset to defaults', () async {
      // Change some values
      await ttsService.setEnabled(false);
      await ttsService.setSpeechRate(0.8);
      await ttsService.setVolume(0.7);
      await ttsService.setPitch(1.5);

      // Reset to defaults
      await ttsService.resetToDefaults();

      expect(ttsService.isEnabled, true);
      expect(ttsService.speechRate, 0.5);
      expect(ttsService.volume, 1.0);
      expect(ttsService.pitch, 1.0);
    });

    test('should return status map', () {
      final status = ttsService.getStatus();

      expect(status, isA<Map<String, dynamic>>());
      expect(status['initialized'], false);
      expect(status['enabled'], true);
      expect(status['speechRate'], 0.5);
      expect(status['volume'], 1.0);
      expect(status['pitch'], 1.0);
    });
  });
}
