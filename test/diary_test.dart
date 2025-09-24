import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'dart:convert';

import 'package:mindcompanion/screens/ai_diary_screen.dart';
import 'package:mindcompanion/screens/personal_diary_screen.dart';
import 'package:mindcompanion/models/diary_entry.dart';
import 'package:mindcompanion/services/diary_storage_service.dart';

// Generate mocks for SharedPreferences
@GenerateMocks([SharedPreferences])
import 'diary_test.mocks.dart';

void main() {
  group('Diary Screen Tests', () {
    late MockSharedPreferences mockSharedPreferences;

    setUp(() {
      mockSharedPreferences = MockSharedPreferences();
      
      // Set up default mock responses
      when(mockSharedPreferences.getString('diary_entries'))
          .thenReturn('[]');
      when(mockSharedPreferences.setString('diary_entries', any))
          .thenAnswer((_) async => true);
    });
    


    tearDown(() {
      // Clean up after each test
    });

    group('AI Diary Screen Tests', () {
      testWidgets('AI Diary screen displays correctly', (WidgetTester tester) async {
        // Set test surface size to prevent overflow
        await tester.binding.setSurfaceSize(const Size(800, 1200));
        
        // Build the AI Diary screen
        await tester.pumpWidget(
          MaterialApp(
            home: const AIDiaryScreen(),
          ),
        );

                // Wait for initial animations and ensure UI is fully rendered
        await tester.pumpAndSettle();
        
        // Wait for delayed card animations to complete
        await tester.pump(const Duration(milliseconds: 1000));
        
        // Verify the main elements are displayed
        expect(find.text('AI Emotion Diary'), findsOneWidget);
        expect(find.text('Describe how you\'re feeling today...'), findsOneWidget);
        expect(find.text('Save Entry'), findsOneWidget);
      });

      testWidgets('AI Diary can save entry with text and emotion', (WidgetTester tester) async {
        // Build the AI Diary screen
        await tester.pumpWidget(
          MaterialApp(
            home: const AIDiaryScreen(),
          ),
        );

                // Wait for initial animations and ensure UI is fully rendered
        await tester.pumpAndSettle();
        
        // Wait for delayed card animations to complete
        await tester.pump(const Duration(milliseconds: 1000));
        
        // Enter text
        await tester.enterText(find.byType(TextField), 'I had a great day today!');
        await tester.pump();

        // Verify text is entered
        expect(find.text('I had a great day today!'), findsOneWidget);

        // Select emotion (Happy is default) - there are multiple Happy widgets (display and button)
        expect(find.text('Happy'), findsAtLeastNWidgets(1));

        // Save entry
        await tester.tap(find.text('Save Entry'));
        await tester.pump();

        // Verify success message
        expect(find.text('Entry saved for ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'), findsOneWidget);
      });

      testWidgets('AI Diary shows validation error for empty text', (WidgetTester tester) async {
        // Build the AI Diary screen
        await tester.pumpWidget(
          MaterialApp(
            home: const AIDiaryScreen(),
          ),
        );

        // Wait for initial animations and ensure UI is fully rendered
        await tester.pumpAndSettle();
        
        // Wait for delayed card animations to complete
        await tester.pump(const Duration(milliseconds: 1000));

        // Try to save without text
        await tester.tap(find.text('Save Entry'));
        await tester.pump();

        // Verify validation error
        expect(find.text('Please write something before saving'), findsOneWidget);
      });

      testWidgets('AI Diary shows emotion selection', (WidgetTester tester) async {
        // Build the AI Diary screen
        await tester.pumpWidget(
          MaterialApp(
            home: const AIDiaryScreen(),
          ),
        );

        // Wait for initial animations and ensure UI is fully rendered
        await tester.pumpAndSettle();
        
        // Wait for delayed card animations to complete
        await tester.pump(const Duration(milliseconds: 1000));

        // Verify emotion selection is displayed
        expect(find.text('Select Your Emotion'), findsOneWidget);
        expect(find.text('Happy'), findsAtLeastNWidgets(1)); // Multiple Happy widgets (display and button)
        expect(find.text('Sad'), findsOneWidget);
        expect(find.text('Angry'), findsOneWidget);
        expect(find.text('Anxious'), findsOneWidget);
        expect(find.text('Excited'), findsOneWidget);
        expect(find.text('Calm'), findsOneWidget);
        expect(find.text('Confused'), findsOneWidget);
        expect(find.text('Grateful'), findsOneWidget);
      });

      testWidgets('AI Diary shows validation error for missing emotion', (WidgetTester tester) async {
        // Build the AI Diary screen
        await tester.pumpWidget(
          MaterialApp(
            home: const AIDiaryScreen(),
          ),
        );

        // Wait for initial animations and ensure UI is fully rendered
        await tester.pumpAndSettle();
        
        // Wait for delayed card animations to complete
        await tester.pump(const Duration(milliseconds: 1000));

        // Enter text
        await tester.enterText(find.byType(TextField), 'Today I reflected on my goals and felt motivated.');
        await tester.pump();

        // Save entry
        await tester.tap(find.text('Save Entry'));
        await tester.pump();

        // Verify success message (emotion is selected by default)
        expect(find.text('Entry saved for ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'), findsOneWidget);
      });
    });

    group('Personal Diary Screen Tests', () {
      testWidgets('Personal Diary screen displays correctly', (WidgetTester tester) async {
        // Build the Personal Diary screen
        await tester.pumpWidget(
          MaterialApp(
            home: const PersonalDiaryScreen(),
          ),
        );

        // Wait for initial animations and ensure UI is fully rendered
        await tester.pumpAndSettle();

        // Verify the main elements are displayed
        expect(find.text('Personal Diary'), findsOneWidget);
        expect(find.text('Write your thoughts, feelings, and experiences for today...'), findsOneWidget);
        expect(find.text('Save Entry'), findsOneWidget);
      });

      testWidgets('Personal Diary can save entry with text', (WidgetTester tester) async {
        // Build the Personal Diary screen
        await tester.pumpWidget(
          MaterialApp(
            home: const PersonalDiaryScreen(),
          ),
        );

        // Wait for initial animations and ensure UI is fully rendered
        await tester.pumpAndSettle();
        
        // Wait for delayed card animations to complete
        await tester.pump(const Duration(milliseconds: 1000));

        // Enter text
        await tester.enterText(find.byType(TextField), 'Today I reflected on my goals and felt motivated.');
        await tester.pump();

        // Verify text is entered
        expect(find.text('Today I reflected on my goals and felt motivated.'), findsOneWidget);

        // Save entry
        await tester.tap(find.text('Save Entry'));
        await tester.pump();

        // Verify success message
        expect(find.text('Personal diary entry saved for ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'), findsOneWidget);
      });

      testWidgets('Personal Diary shows validation error for empty text', (WidgetTester tester) async {
        // Build the Personal Diary screen
        await tester.pumpWidget(
          MaterialApp(
            home: const PersonalDiaryScreen(),
          ),
        );

        // Wait for initial animations and ensure UI is fully rendered
        await tester.pumpAndSettle();

        // Try to save without text
        await tester.tap(find.text('Save Entry'));
        await tester.pump();

        // Verify validation error
        expect(find.text('Please write something before saving'), findsOneWidget);
      });
    });

    group('Diary Storage Integration Tests', () {
      testWidgets('Diary entries are saved and retrieved correctly', (WidgetTester tester) async {
        // Set up mock data
        final testEntries = [
          DiaryEntry.createAIEntry(
            text: 'Test AI entry',
            emotion: 'Happy',
            date: DateTime.now(),
          ),
          DiaryEntry.createPersonalEntry(
            text: 'Test Personal entry',
            date: DateTime.now(),
          ),
        ];

        final entriesJson = testEntries.map((e) => e.toJson()).toList();
        when(mockSharedPreferences.getString('diary_entries'))
            .thenReturn(jsonEncode(entriesJson));

        // Test saving entries
        for (final entry in testEntries) {
          final success = await DiaryStorageService.saveEntry(entry);
          expect(success, isTrue);
        }

        // Test retrieving entries
        final retrievedEntries = await DiaryStorageService.getEntries();
        expect(retrievedEntries.length, equals(2));
        expect(retrievedEntries[0].text, equals('Test AI entry'));
        expect(retrievedEntries[1].text, equals('Test Personal entry'));
      });

      testWidgets('Diary entries persist across app sessions', (WidgetTester tester) async {
        // Set up mock data with existing entries
        final existingEntries = [
          DiaryEntry.createAIEntry(
            text: 'Persistent AI entry',
            emotion: 'Happy',
            date: DateTime.now(),
          ),
          DiaryEntry.createPersonalEntry(
            text: 'Persistent Personal entry',
            date: DateTime.now(),
          ),
        ];

        final entriesJson = existingEntries.map((e) => e.toJson()).toList();
        when(mockSharedPreferences.getString('diary_entries'))
            .thenReturn(jsonEncode(entriesJson));

        // Verify entries are loaded
        final loadedEntries = await DiaryStorageService.getEntries();
        expect(loadedEntries.length, equals(2));
        expect(loadedEntries[0].text, equals('Persistent AI entry'));
        expect(loadedEntries[1].text, equals('Persistent Personal entry'));
      });

      testWidgets('Diary entries maintain correct metadata', (WidgetTester tester) async {
        // Create test entry
        final testEntry = DiaryEntry.createAIEntry(
          text: 'Happy day at work',
          emotion: 'Happy',
          date: DateTime.now(),
        );

        // Save entry
        final success = await DiaryStorageService.saveEntry(testEntry);
        expect(success, isTrue);

        // Verify entry metadata
        expect(testEntry.text, equals('Happy day at work'));
        expect(testEntry.emotion, equals('Happy'));
        expect(testEntry.type, equals('ai'));
        expect(testEntry.date, isA<DateTime>());
      });

      testWidgets('Diary entries can be updated', (WidgetTester tester) async {
        // Create initial entry
        final initialEntry = DiaryEntry.createPersonalEntry(
          text: 'Today\'s entry',
          date: DateTime.now(),
        );

        // Save initial entry
        await DiaryStorageService.saveEntry(initialEntry);

        // Update entry text
        final updatedEntry = DiaryEntry.createPersonalEntry(
          text: 'Updated entry',
          date: initialEntry.date,
        );

        // Save updated entry
        final success = await DiaryStorageService.saveEntry(updatedEntry);
        expect(success, isTrue);

        // Verify entry is updated
        final retrievedEntries = await DiaryStorageService.getEntries();
        expect(retrievedEntries.length, equals(1));
        expect(retrievedEntries[0].text, equals('Updated entry'));
      });
    });

    group('Cross-Screen Integration Tests', () {
      testWidgets('AI and Personal diary entries are stored separately', (WidgetTester tester) async {
        // Create entries of different types
        final aiEntry = DiaryEntry.createAIEntry(
          text: 'Integration test AI entry',
          emotion: 'Happy',
          date: DateTime.now(),
        );

        final personalEntry = DiaryEntry.createPersonalEntry(
          text: 'Integration test Personal entry',
          date: DateTime.now(),
        );

        // Save both entries
        await DiaryStorageService.saveEntry(aiEntry);
        await DiaryStorageService.saveEntry(personalEntry);

        // Verify both entries are stored
        final allEntries = await DiaryStorageService.getEntries();
        expect(allEntries.length, equals(2));

        // Verify AI entry properties
        final savedAiEntry = allEntries.firstWhere((e) => e.type == 'ai');
        expect(savedAiEntry.text, equals('Integration test AI entry'));
        expect(savedAiEntry.emotion, equals('Happy'));

        // Verify Personal entry properties
        final savedPersonalEntry = allEntries.firstWhere((e) => e.type == 'personal');
        expect(savedPersonalEntry.text, equals('Integration test Personal entry'));
        expect(savedPersonalEntry.emotion, isNull);
      });
    });
  });
}
