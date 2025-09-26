import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mindcompanion/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('MindCompanion User Journey Tests', () {
    testWidgets(
      'Complete user journey: Welcome → Home → AI Diary → Personal Diary → History',
      (WidgetTester tester) async {
        // Start the app
        app.main();
        await tester.pumpAndSettle();

        // 1. Welcome Screen Journey
        await _testWelcomeScreen(tester);

        // 2. Navigate to Home Screen
        await _testHomeScreen(tester);

        // 3. Navigate to AI Diary
        await _testAIDiaryScreen(tester);

        // 4. Navigate to Personal Diary
        await _testPersonalDiaryScreen(tester);

        // 5. Navigate to Emotional History
        await _testEmotionalHistoryScreen(tester);

        // 6. Navigate to Settings
        await _testSettingsScreen(tester);
      },
    );

    testWidgets(
      'Crisis Mode Journey: Home → Crisis Mode → Emergency Contacts',
      (WidgetTester tester) async {
        // Start the app
        app.main();
        await tester.pumpAndSettle();

        // Navigate to Home
        await _navigateToHome(tester);

        // Access Crisis Mode
        await _testCrisisModeJourney(tester);
      },
    );

    testWidgets('Meditation Journey: Home → Meditation → Audio Playback', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Navigate to Home
      await _navigateToHome(tester);

      // Access Meditation
      await _testMeditationJourney(tester);
    });
  });
}

// Helper functions for testing each screen
Future<void> _testWelcomeScreen(WidgetTester tester) async {
  // Verify welcome screen elements
  expect(find.text('Welcome to MindCompanion'), findsOneWidget);
  expect(
    find.text('Your AI-powered mental wellness companion'),
    findsOneWidget,
  );

  // Look for navigation buttons
  expect(find.byType(ElevatedButton), findsAtLeastNWidgets(1));

  // Wait for any animations
  await tester.pumpAndSettle();
}

Future<void> _testHomeScreen(WidgetTester tester) async {
  // Navigate to home screen (assuming there's a button or navigation)
  final homeButton = find.text('Get Started');
  if (homeButton.evaluate().isNotEmpty) {
    await tester.tap(homeButton);
    await tester.pumpAndSettle();
  }

  // Verify home screen elements
  expect(find.text('MindCompanion'), findsOneWidget);

  // Look for main navigation options
  expect(find.text('AI Diary'), findsOneWidget);
  expect(find.text('Personal Diary'), findsOneWidget);
  expect(find.text('Emotional History'), findsOneWidget);
  expect(find.text('Meditation'), findsOneWidget);
  expect(find.text('Crisis Mode'), findsOneWidget);
}

Future<void> _testAIDiaryScreen(WidgetTester tester) async {
  // Navigate to AI Diary
  await tester.tap(find.text('AI Diary'));
  await tester.pumpAndSettle();

  // Verify AI Diary screen
  expect(find.text('AI Diary'), findsOneWidget);
  expect(find.text('Share your thoughts with AI'), findsOneWidget);

  // Test text input
  final textField = find.byType(TextField);
  if (textField.evaluate().isNotEmpty) {
    await tester.enterText(textField.first, 'I had a great day today!');
    await tester.pumpAndSettle();

    // Look for submit button
    final submitButton = find.text('Submit');
    if (submitButton.evaluate().isNotEmpty) {
      await tester.tap(submitButton);
      await tester.pumpAndSettle();
    }
  }
}

Future<void> _testPersonalDiaryScreen(WidgetTester tester) async {
  // Navigate to Personal Diary
  await tester.tap(find.text('Personal Diary'));
  await tester.pumpAndSettle();

  // Verify Personal Diary screen
  expect(find.text('Personal Diary'), findsOneWidget);
  expect(find.text('Your private thoughts'), findsOneWidget);

  // Test text input
  final textField = find.byType(TextField);
  if (textField.evaluate().isNotEmpty) {
    await tester.enterText(
      textField.first,
      'This is my personal reflection...',
    );
    await tester.pumpAndSettle();

    // Look for save button
    final saveButton = find.text('Save');
    if (saveButton.evaluate().isNotEmpty) {
      await tester.tap(saveButton);
      await tester.pumpAndSettle();
    }
  }
}

Future<void> _testEmotionalHistoryScreen(WidgetTester tester) async {
  // Navigate to Emotional History
  await tester.tap(find.text('Emotional History'));
  await tester.pumpAndSettle();

  // Verify Emotional History screen
  expect(find.text('Emotional History'), findsOneWidget);
  expect(find.text('Your Emotional Journey'), findsOneWidget);

  // Look for key elements
  expect(find.text('Mood Calendar'), findsOneWidget);
  expect(find.text('Emotion Trends Over Time'), findsOneWidget);
  expect(find.text('Recent Entries'), findsOneWidget);
}

Future<void> _testSettingsScreen(WidgetTester tester) async {
  // Navigate to Settings (assuming there's a settings button)
  final settingsButton = find.text('Settings');
  if (settingsButton.evaluate().isNotEmpty) {
    await tester.tap(settingsButton);
    await tester.pumpAndSettle();

    // Verify Settings screen
    expect(find.text('Settings'), findsOneWidget);

    // Look for common settings options
    expect(find.text('Privacy Policy'), findsOneWidget);
  }
}

Future<void> _navigateToHome(WidgetTester tester) async {
  // Navigate to home screen
  final homeButton = find.text('Get Started');
  if (homeButton.evaluate().isNotEmpty) {
    await tester.tap(homeButton);
    await tester.pumpAndSettle();
  }
}

Future<void> _testCrisisModeJourney(WidgetTester tester) async {
  // Access Crisis Mode
  await tester.tap(find.text('Crisis Mode'));
  await tester.pumpAndSettle();

  // Verify Crisis Mode screen
  expect(find.text('Crisis Mode'), findsOneWidget);
  expect(find.text('Emergency Support'), findsOneWidget);

  // Look for emergency contacts
  expect(find.text('Emergency Contacts'), findsOneWidget);
  expect(find.text('Crisis Hotlines'), findsOneWidget);
}

Future<void> _testMeditationJourney(WidgetTester tester) async {
  // Access Meditation
  await tester.tap(find.text('Meditation'));
  await tester.pumpAndSettle();

  // Verify Meditation screen
  expect(find.text('Meditation'), findsOneWidget);
  expect(find.text('Find your inner peace'), findsOneWidget);

  // Look for meditation options
  expect(find.text('Guided Meditation'), findsOneWidget);
  expect(find.text('Breathing Exercises'), findsOneWidget);

  // Test audio controls (if present)
  final playButton = find.text('Play');
  if (playButton.evaluate().isNotEmpty) {
    await tester.tap(playButton);
    await tester.pumpAndSettle();
  }
}
