import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mindcompanion/domain/diary_entry.dart';
import 'package:mindcompanion/domain/emotion.dart';
import 'package:mindcompanion/data/shared_prefs_diary_repository.dart';

@GenerateMocks([SharedPreferences])
import 'shared_prefs_diary_repository_test.mocks.dart';

void main() {
  group('SharedPrefsDiaryRepository Tests', () {
    late MockSharedPreferences mockPrefs;
    late SharedPrefsDiaryRepository repository;
    late DiaryEntry testEntry;
    late Emotion testEmotion;

    setUp(() {
      mockPrefs = MockSharedPreferences();
      repository = SharedPrefsDiaryRepository(mockPrefs);
      
      testEmotion = const Emotion(
        id: 'happy',
        name: 'Happy',
        emoji: '😄',
        valence: 2,
      );

      testEntry = DiaryEntry(
        id: 'test-id',
        date: DateTime(2024, 1, 1),
        text: 'Test entry',
        emotion: testEmotion,
        source: DiarySource.ai,
      );
    });

    tearDown(() {
      repository.dispose();
    });

    group('CRUD Operations', () {
      test('should upsert entry successfully', () async {
        when(mockPrefs.getString('diary_entries_v2')).thenReturn('[]');
        when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);

        await repository.upsertEntry(testEntry);
        
        // Wait for debounced write
        await Future.delayed(const Duration(milliseconds: 600));

        verify(mockPrefs.setString(any, any)).called(1);
      });

      test('should get entries successfully', () async {
        final jsonString = jsonEncode([
          {
            'id': 'test-id',
            'date': '2024-01-01T00:00:00.000',
            'text': 'Test entry',
            'source': 'ai',
            'emotion': {
              'id': 'happy',
              'name': 'Happy',
              'emoji': '😄',
              'valence': 2,
            },
          }
        ]);

        when(mockPrefs.getString('diary_entries_v2')).thenReturn(jsonString);

        final entries = await repository.getEntries();

        expect(entries.length, 1);
        expect(entries.first.id, 'test-id');
        expect(entries.first.text, 'Test entry');
        expect(entries.first.source, DiarySource.ai);
      });

      test('should get entry by ID', () async {
        final jsonString = jsonEncode([
          {
            'id': 'test-id',
            'date': '2024-01-01T00:00:00.000',
            'text': 'Test entry',
            'source': 'ai',
            'emotion': {
              'id': 'happy',
              'name': 'Happy',
              'emoji': '😄',
              'valence': 2,
            },
          }
        ]);

        when(mockPrefs.getString('diary_entries_v2')).thenReturn(jsonString);

        final entry = await repository.getEntry('test-id');

        expect(entry, isNotNull);
        expect(entry!.id, 'test-id');
      });

      test('should return null for non-existent entry', () async {
        when(mockPrefs.getString('diary_entries_v2')).thenReturn('[]');

        final entry = await repository.getEntry('non-existent');

        expect(entry, isNull);
      });

      test('should delete entry successfully', () async {
        final jsonString = jsonEncode([
          {
            'id': 'test-id',
            'date': '2024-01-01T00:00:00.000',
            'text': 'Test entry',
            'source': 'ai',
            'emotion': {
              'id': 'happy',
              'name': 'Happy',
              'emoji': '😄',
              'valence': 2,
            },
          }
        ]);

        when(mockPrefs.getString('diary_entries_v2')).thenReturn(jsonString);
        when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);

        await repository.deleteEntry('test-id');
        
        // Wait for debounced write
        await Future.delayed(const Duration(milliseconds: 600));

        verify(mockPrefs.setString(any, any)).called(1);
      });

      test('should clear all entries', () async {
        when(mockPrefs.remove('diary_entries_v2')).thenAnswer((_) async => true);

        await repository.clearAllEntries();

        verify(mockPrefs.remove('diary_entries_v2')).called(1);
      });
    });

    group('Filtering Operations', () {
      setUp(() {
        final jsonString = jsonEncode([
          {
            'id': 'ai-entry',
            'date': '2024-01-01T00:00:00.000',
            'text': 'AI entry',
            'source': 'ai',
            'emotion': {
              'id': 'happy',
              'name': 'Happy',
              'emoji': '😄',
              'valence': 2,
            },
          },
          {
            'id': 'personal-entry',
            'date': '2024-01-02T00:00:00.000',
            'text': 'Personal entry',
            'source': 'personal',
            'emotion': null,
          },
        ]);

        when(mockPrefs.getString('diary_entries_v2')).thenReturn(jsonString);
      });

      test('should filter by source', () async {
        final aiEntries = await repository.getEntriesBySource(DiarySource.ai);
        final personalEntries = await repository.getEntriesBySource(DiarySource.personal);

        expect(aiEntries.length, 1);
        expect(aiEntries.first.source, DiarySource.ai);
        expect(personalEntries.length, 1);
        expect(personalEntries.first.source, DiarySource.personal);
      });

      test('should filter by date range', () async {
        final from = DateTime(2024, 1, 1);
        final to = DateTime(2024, 1, 1, 23, 59, 59);

        final entries = await repository.getEntriesForDateRange(from, to);

        expect(entries.length, 1);
        expect(entries.first.id, 'ai-entry');
      });

      test('should get entries for specific date', () async {
        final date = DateTime(2024, 1, 1);

        final entries = await repository.getEntriesForDate(date);

        expect(entries.length, 1);
        expect(entries.first.id, 'ai-entry');
      });

      test('should get recent entries', () async {
        final recentEntries = await repository.getRecentEntries(1);

        expect(recentEntries.length, 1);
        expect(recentEntries.first.id, 'ai-entry'); // Most recent (sorted by date)
      });
    });

    group('Migration Tests', () {
      test('should detect migration needed', () async {
        when(mockPrefs.getString('diary_entries_v2')).thenReturn(null);
        when(mockPrefs.getString('ai_diary_entries')).thenReturn('[]');
        when(mockPrefs.getString('personal_diary_entries')).thenReturn(null);
        when(mockPrefs.getString('diary_entries')).thenReturn(null);

        final needsMigration = await repository.needsMigration();

        expect(needsMigration, true);
      });

      test('should not need migration if v2 data exists', () async {
        when(mockPrefs.getString('diary_entries_v2')).thenReturn('[]');
        when(mockPrefs.getString('ai_diary_entries')).thenReturn('[]');

        final needsMigration = await repository.needsMigration();

        expect(needsMigration, false);
      });

      test('should migrate old AI entries', () async {
        when(mockPrefs.getString('diary_entries_v2')).thenReturn(null);
        when(mockPrefs.getString('ai_diary_entries')).thenReturn(jsonEncode([
          {
            'id': 'old-ai-entry',
            'text': 'Old AI entry',
            'date': '2024-01-01T00:00:00.000',
            'emotion': 'happy',
          }
        ]));
        when(mockPrefs.getString('personal_diary_entries')).thenReturn(null);
        when(mockPrefs.getString('diary_entries')).thenReturn(null);
        when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);
        when(mockPrefs.remove(any)).thenAnswer((_) async => true);

        await repository.migrateIfNeeded();

        verify(mockPrefs.setString('diary_entries_v2', any)).called(1);
        verify(mockPrefs.remove('ai_diary_entries')).called(1);
      });

      test('should migrate old personal entries', () async {
        when(mockPrefs.getString('diary_entries_v2')).thenReturn(null);
        when(mockPrefs.getString('ai_diary_entries')).thenReturn(null);
        when(mockPrefs.getString('personal_diary_entries')).thenReturn(jsonEncode([
          {
            'id': 'old-personal-entry',
            'text': 'Old personal entry',
            'date': '2024-01-01T00:00:00.000',
          }
        ]));
        when(mockPrefs.getString('diary_entries')).thenReturn(null);
        when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);
        when(mockPrefs.remove(any)).thenAnswer((_) async => true);

        await repository.migrateIfNeeded();

        verify(mockPrefs.setString('diary_entries_v2', any)).called(1);
        verify(mockPrefs.remove('personal_diary_entries')).called(1);
      });

      test('should migrate old unified entries', () async {
        when(mockPrefs.getString('diary_entries_v2')).thenReturn(null);
        when(mockPrefs.getString('ai_diary_entries')).thenReturn(null);
        when(mockPrefs.getString('personal_diary_entries')).thenReturn(null);
        when(mockPrefs.getString('diary_entries')).thenReturn(jsonEncode([
          {
            'id': 'old-unified-entry',
            'text': 'Old unified entry',
            'date': '2024-01-01T00:00:00.000',
            'type': 'ai',
          }
        ]));
        when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);
        when(mockPrefs.remove(any)).thenAnswer((_) async => true);

        await repository.migrateIfNeeded();

        verify(mockPrefs.setString('diary_entries_v2', any)).called(1);
        verify(mockPrefs.remove('diary_entries')).called(1);
      });
    });

    group('Stream Operations', () {
      test('should emit entries when upserted', () async {
        when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);

        final entriesStream = repository.watchAll();
        final entriesList = <List<DiaryEntry>>[];
        
        final subscription = entriesStream.listen(entriesList.add);

        await repository.upsertEntry(testEntry);
        await Future.delayed(const Duration(milliseconds: 100));

        expect(entriesList.length, greaterThan(0));
        expect(entriesList.last.length, 1);
        expect(entriesList.last.first.id, 'test-id');

        subscription.cancel();
      });
    });

    group('Error Handling', () {
      test('should handle JSON parsing errors gracefully', () async {
        when(mockPrefs.getString('diary_entries_v2')).thenReturn('invalid-json');

        final entries = await repository.getEntries();

        expect(entries, isEmpty);
      });

      test('should handle storage write errors', () async {
        when(mockPrefs.getString('diary_entries_v2')).thenReturn('[]');
        when(mockPrefs.setString(any, any)).thenThrow(Exception('Storage error'));

        await repository.upsertEntry(testEntry);
        
        // Wait for debounced write to trigger error
        await Future.delayed(const Duration(milliseconds: 600));

        // The error should be caught and logged, not thrown
        // This test verifies that the error is handled gracefully
        verify(mockPrefs.setString(any, any)).called(1);
      });
    });
  });
}
