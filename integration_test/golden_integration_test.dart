import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mindcompanion/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Golden Integration Tests', () {
    testWidgets('Capture golden screenshots during user journey', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // 1. Welcome Screen Golden
      await _captureWelcomeScreenGolden(tester);
      
      // 2. Navigate to Home and capture
      await _captureHomeScreenGolden(tester);
      
      // 3. Navigate to AI Diary and capture
      await _captureAIDiaryGolden(tester);
      
      // 4. Navigate to Personal Diary and capture
      await _capturePersonalDiaryGolden(tester);
      
      // 5. Navigate to Emotional History and capture
      await _captureEmotionalHistoryGolden(tester);
    });

    testWidgets('Capture crisis mode golden screenshots', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Navigate to Home
      await _navigateToHome(tester);
      
      // Navigate to Crisis Mode and capture
      await _captureCrisisModeGolden(tester);
    });

    testWidgets('Capture meditation golden screenshots', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Navigate to Home
      await _navigateToHome(tester);
      
      // Navigate to Meditation and capture
      await _captureMeditationGolden(tester);
    });
  });
}

// Golden capture functions
Future<void> _captureWelcomeScreenGolden(WidgetTester tester) async {
  // Set fixed size for consistent screenshots
  await tester.binding.setSurfaceSize(const Size(400, 800));
  
  // Wait for screen to stabilize
  await tester.pumpAndSettle();
  
  // Capture golden screenshot
  await expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile('integration_test/golden/welcome_screen_journey.png'),
  );
}

Future<void> _captureHomeScreenGolden(WidgetTester tester) async {
  // Navigate to home
  final homeButton = find.text('Get Started');
  if (homeButton.evaluate().isNotEmpty) {
    await tester.tap(homeButton);
    await tester.pumpAndSettle();
  }
  
  // Set fixed size
  await tester.binding.setSurfaceSize(const Size(400, 800));
  
  // Capture golden screenshot
  await expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile('integration_test/golden/home_screen_journey.png'),
  );
}

Future<void> _captureAIDiaryGolden(WidgetTester tester) async {
  // Navigate to AI Diary
  await tester.tap(find.text('AI Diary'));
  await tester.pumpAndSettle();
  
  // Set fixed size
  await tester.binding.setSurfaceSize(const Size(400, 800));
  
  // Capture golden screenshot
  await expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile('integration_test/golden/ai_diary_journey.png'),
  );
}

Future<void> _capturePersonalDiaryGolden(WidgetTester tester) async {
  // Navigate to Personal Diary
  await tester.tap(find.text('Personal Diary'));
  await tester.pumpAndSettle();
  
  // Set fixed size
  await tester.binding.setSurfaceSize(const Size(400, 800));
  
  // Capture golden screenshot
  await expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile('integration_test/golden/personal_diary_journey.png'),
  );
}

Future<void> _captureEmotionalHistoryGolden(WidgetTester tester) async {
  // Navigate to Emotional History
  await tester.tap(find.text('Emotional History'));
  await tester.pumpAndSettle();
  
  // Set fixed size
  await tester.binding.setSurfaceSize(const Size(400, 800));
  
  // Capture golden screenshot
  await expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile('integration_test/golden/emotional_history_journey.png'),
  );
}

Future<void> _captureCrisisModeGolden(WidgetTester tester) async {
  // Navigate to Crisis Mode
  await tester.tap(find.text('Crisis Mode'));
  await tester.pumpAndSettle();
  
  // Set fixed size
  await tester.binding.setSurfaceSize(const Size(400, 800));
  
  // Capture golden screenshot
  await expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile('integration_test/golden/crisis_mode_journey.png'),
  );
}

Future<void> _captureMeditationGolden(WidgetTester tester) async {
  // Navigate to Meditation
  await tester.tap(find.text('Meditation'));
  await tester.pumpAndSettle();
  
  // Set fixed size
  await tester.binding.setSurfaceSize(const Size(400, 800));
  
  // Capture golden screenshot
  await expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile('integration_test/golden/meditation_journey.png'),
  );
}

Future<void> _navigateToHome(WidgetTester tester) async {
  // Navigate to home screen
  final homeButton = find.text('Get Started');
  if (homeButton.evaluate().isNotEmpty) {
    await tester.tap(homeButton);
    await tester.pumpAndSettle();
  }
}
