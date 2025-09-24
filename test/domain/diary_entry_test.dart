import 'package:flutter_test/flutter_test.dart';
import 'package:mindcompanion/domain/diary_entry.dart';
import 'package:mindcompanion/domain/emotion.dart';

void main() {
  group('DiaryEntry Domain Model Tests', () {
    late Emotion testEmotion;

    setUp(() {
      testEmotion = const Emotion(
        id: 'happy',
        name: 'Happy',
        emoji: '😄',
        valence: 2,
      );
    });

    test('should create diary entry with valid data', () {
      final entry = DiaryEntry(
        id: 'test-id',
        date: DateTime(2024, 1, 1),
        text: 'Test entry',
        emotion: testEmotion,
        source: DiarySource.ai,
      );

      expect(entry.id, 'test-id');
      expect(entry.text, 'Test entry');
      expect(entry.emotion, testEmotion);
      expect(entry.source, DiarySource.ai);
    });

    test('should create diary entry without emotion', () {
      final entry = DiaryEntry(
        id: 'test-id',
        date: DateTime(2024, 1, 1),
        text: 'Test entry',
        source: DiarySource.personal,
      );

      expect(entry.hasEmotion, false);
      expect(entry.emotion, isNull);
    });

    test('should return correct emotion properties', () {
      final entry = DiaryEntry(
        id: 'test-id',
        date: DateTime(2024, 1, 1),
        text: 'Test entry',
        emotion: testEmotion,
        source: DiarySource.ai,
      );

      expect(entry.emotionEmoji, '😄');
      expect(entry.emotionName, 'Happy');
    });

    test('should return default values when no emotion', () {
      final entry = DiaryEntry(
        id: 'test-id',
        date: DateTime(2024, 1, 1),
        text: 'Test entry',
        source: DiarySource.personal,
      );

      expect(entry.emotionEmoji, '📝');
      expect(entry.emotionName, 'No emotion');
    });

    test('should return correct source display names', () {
      final aiEntry = DiaryEntry(
        id: 'ai-id',
        date: DateTime(2024, 1, 1),
        text: 'AI entry',
        source: DiarySource.ai,
      );

      final personalEntry = DiaryEntry(
        id: 'personal-id',
        date: DateTime(2024, 1, 1),
        text: 'Personal entry',
        source: DiarySource.personal,
      );

      expect(aiEntry.sourceDisplayName, 'AI Diary');
      expect(personalEntry.sourceDisplayName, 'Personal Diary');
      expect(aiEntry.sourceEmoji, '🤖');
      expect(personalEntry.sourceEmoji, '📝');
    });

    test('should detect today and yesterday correctly', () {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));

      final todayEntry = DiaryEntry(
        id: 'today',
        date: now,
        text: 'Today entry',
        source: DiarySource.ai,
      );

      final yesterdayEntry = DiaryEntry(
        id: 'yesterday',
        date: yesterday,
        text: 'Yesterday entry',
        source: DiarySource.ai,
      );

      final oldEntry = DiaryEntry(
        id: 'old',
        date: now.subtract(const Duration(days: 5)),
        text: 'Old entry',
        source: DiarySource.ai,
      );

      expect(todayEntry.isToday, true);
      expect(todayEntry.isYesterday, false);
      expect(yesterdayEntry.isToday, false);
      expect(yesterdayEntry.isYesterday, true);
      expect(oldEntry.isToday, false);
      expect(oldEntry.isYesterday, false);
    });

    test('should return correct relative date strings', () {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      final weekAgo = now.subtract(const Duration(days: 7));

      final todayEntry = DiaryEntry(
        id: 'today',
        date: now,
        text: 'Today entry',
        source: DiarySource.ai,
      );

      final yesterdayEntry = DiaryEntry(
        id: 'yesterday',
        date: yesterday,
        text: 'Yesterday entry',
        source: DiarySource.ai,
      );

      final weekAgoEntry = DiaryEntry(
        id: 'week-ago',
        date: weekAgo,
        text: 'Week ago entry',
        source: DiarySource.ai,
      );

      expect(todayEntry.relativeDateString, 'Today');
      expect(yesterdayEntry.relativeDateString, 'Yesterday');
      expect(weekAgoEntry.relativeDateString, '1 week ago');
    });

    test('should validate entry data', () {
      final validEntry = DiaryEntry(
        id: 'valid',
        date: DateTime(2024, 1, 1),
        text: 'Valid entry',
        source: DiarySource.ai,
      );

      final invalidIdEntry = DiaryEntry(
        id: '',
        date: DateTime(2024, 1, 1),
        text: 'Invalid ID entry',
        source: DiarySource.ai,
      );

      final invalidTextEntry = DiaryEntry(
        id: 'valid',
        date: DateTime(2024, 1, 1),
        text: '',
        source: DiarySource.ai,
      );

      final invalidEmotionEntry = DiaryEntry(
        id: 'valid',
        date: DateTime(2024, 1, 1),
        text: 'Valid text',
        emotion: const Emotion(
          id: 'invalid',
          name: 'Invalid',
          emoji: '❌',
          valence: 5, // Invalid valence
        ),
        source: DiarySource.ai,
      );

      expect(validEntry.isValid, true);
      expect(invalidIdEntry.isValid, false);
      expect(invalidTextEntry.isValid, false);
      expect(invalidEmotionEntry.isValid, false);
    });

    test('should support copyWith', () {
      final original = DiaryEntry(
        id: 'original',
        date: DateTime(2024, 1, 1),
        text: 'Original text',
        emotion: testEmotion,
        source: DiarySource.ai,
      );

      final updated = original.copyWith(
        text: 'Updated text',
        source: DiarySource.personal,
      );

      expect(updated.id, 'original');
      expect(updated.text, 'Updated text');
      expect(updated.emotion, testEmotion);
      expect(updated.source, DiarySource.personal);
    });

    test('should support equality', () {
      final entry1 = DiaryEntry(
        id: 'same',
        date: DateTime(2024, 1, 1),
        text: 'Same text',
        emotion: testEmotion,
        source: DiarySource.ai,
      );

      final entry2 = DiaryEntry(
        id: 'same',
        date: DateTime(2024, 1, 1),
        text: 'Same text',
        emotion: testEmotion,
        source: DiarySource.ai,
      );

      final entry3 = DiaryEntry(
        id: 'different',
        date: DateTime(2024, 1, 1),
        text: 'Different text',
        emotion: testEmotion,
        source: DiarySource.ai,
      );

      expect(entry1, equals(entry2));
      expect(entry1, isNot(equals(entry3)));
    });
  });
}
