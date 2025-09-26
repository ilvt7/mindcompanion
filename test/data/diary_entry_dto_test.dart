import 'package:flutter_test/flutter_test.dart';
import 'package:mindcompanion/domain/diary_entry.dart';
import 'package:mindcompanion/domain/emotion.dart';
import 'package:mindcompanion/data/diary_entry_dto.dart';

void main() {
  group('DiaryEntryDto Tests', () {
    late DiaryEntry testEntry;
    late Emotion testEmotion;

    setUp(() {
      testEmotion = const Emotion(
        id: 'happy',
        name: 'Happy',
        emoji: '😄',
        valence: 2,
      );

      testEntry = DiaryEntry(
        id: 'test-id',
        date: DateTime(2024, 1, 1, 12, 30, 45),
        text: 'Test entry text',
        emotion: testEmotion,
        source: DiarySource.ai,
      );
    });

    test('should convert from domain model', () {
      final dto = DiaryEntryDto.fromDomain(testEntry);

      expect(dto.id, 'test-id');
      expect(dto.date, '2024-01-01T12:30:45.000');
      expect(dto.text, 'Test entry text');
      expect(dto.source, 'ai');
      expect(dto.emotion, isNotNull);
      expect(dto.emotion!.id, 'happy');
    });

    test('should convert to domain model', () {
      final dto = DiaryEntryDto.fromDomain(testEntry);
      final convertedEntry = dto.toDomain();

      expect(convertedEntry.id, testEntry.id);
      expect(convertedEntry.date, testEntry.date);
      expect(convertedEntry.text, testEntry.text);
      expect(convertedEntry.source, testEntry.source);
      expect(convertedEntry.emotion, testEntry.emotion);
    });

    test('should convert from JSON', () {
      final json = {
        'id': 'test-id',
        'date': '2024-01-01T12:30:45.000',
        'text': 'Test entry text',
        'source': 'ai',
        'emotion': {
          'id': 'happy',
          'name': 'Happy',
          'emoji': '😄',
          'valence': 2,
        },
      };

      final dto = DiaryEntryDto.fromJson(json);

      expect(dto.id, 'test-id');
      expect(dto.date, '2024-01-01T12:30:45.000');
      expect(dto.text, 'Test entry text');
      expect(dto.source, 'ai');
      expect(dto.emotion!.id, 'happy');
    });

    test('should convert to JSON', () {
      final dto = DiaryEntryDto.fromDomain(testEntry);
      final json = dto.toJson();

      expect(json['id'], 'test-id');
      expect(json['date'], '2024-01-01T12:30:45.000');
      expect(json['text'], 'Test entry text');
      expect(json['source'], 'ai');
      expect(json['emotion'], isNotNull);
      expect(json['emotion']['id'], 'happy');
    });

    test('should handle entry without emotion', () {
      final entryWithoutEmotion = DiaryEntry(
        id: 'test-id',
        date: DateTime(2024, 1, 1),
        text: 'Test entry',
        source: DiarySource.personal,
      );

      final dto = DiaryEntryDto.fromDomain(entryWithoutEmotion);
      final json = dto.toJson();
      final convertedDto = DiaryEntryDto.fromJson(json);
      final convertedEntry = convertedDto.toDomain();

      expect(dto.emotion, isNull);
      expect(json['emotion'], isNull);
      expect(convertedDto.emotion, isNull);
      expect(convertedEntry.emotion, isNull);
    });

    test('should handle personal source', () {
      final personalEntry = DiaryEntry(
        id: 'personal-id',
        date: DateTime(2024, 1, 1),
        text: 'Personal entry',
        source: DiarySource.personal,
      );

      final dto = DiaryEntryDto.fromDomain(personalEntry);
      final convertedEntry = dto.toDomain();

      expect(dto.source, 'personal');
      expect(convertedEntry.source, DiarySource.personal);
    });

    test('should support equality', () {
      final dto1 = DiaryEntryDto.fromDomain(testEntry);
      final dto2 = DiaryEntryDto.fromDomain(testEntry);

      expect(dto1, equals(dto2));
    });
  });

  group('EmotionDto Tests', () {
    late Emotion testEmotion;

    setUp(() {
      testEmotion = const Emotion(
        id: 'sad',
        name: 'Sad',
        emoji: '😢',
        valence: -1,
      );
    });

    test('should convert from domain model', () {
      final dto = EmotionDto.fromDomain(testEmotion);

      expect(dto.id, 'sad');
      expect(dto.name, 'Sad');
      expect(dto.emoji, '😢');
      expect(dto.valence, -1);
    });

    test('should convert to domain model', () {
      final dto = EmotionDto.fromDomain(testEmotion);
      final convertedEmotion = dto.toDomain();

      expect(convertedEmotion.id, testEmotion.id);
      expect(convertedEmotion.name, testEmotion.name);
      expect(convertedEmotion.emoji, testEmotion.emoji);
      expect(convertedEmotion.valence, testEmotion.valence);
    });

    test('should convert from JSON', () {
      final json = {'id': 'sad', 'name': 'Sad', 'emoji': '😢', 'valence': -1};

      final dto = EmotionDto.fromJson(json);

      expect(dto.id, 'sad');
      expect(dto.name, 'Sad');
      expect(dto.emoji, '😢');
      expect(dto.valence, -1);
    });

    test('should convert to JSON', () {
      final dto = EmotionDto.fromDomain(testEmotion);
      final json = dto.toJson();

      expect(json['id'], 'sad');
      expect(json['name'], 'Sad');
      expect(json['emoji'], '😢');
      expect(json['valence'], -1);
    });

    test('should support equality', () {
      final dto1 = EmotionDto.fromDomain(testEmotion);
      final dto2 = EmotionDto.fromDomain(testEmotion);

      expect(dto1, equals(dto2));
    });
  });
}
