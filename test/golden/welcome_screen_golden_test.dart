import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindcompanion/screens/welcome_screen.dart';

void main() {
  group('Welcome Screen Golden Tests', () {
    testWidgets('Welcome screen matches golden file', (WidgetTester tester) async {
      // Render WelcomeScreen at a fixed size (400x800)
      await tester.binding.setSurfaceSize(const Size(400, 800));
      
      // Build the WelcomeScreen widget
      await tester.pumpWidget(
        const MaterialApp(
          home: WelcomeScreen(),
        ),
      );

      // Wait for initial build and skip animations for golden tests
      await tester.pump();
      
      // Wait a bit more for any immediate animations
      await tester.pump(const Duration(milliseconds: 100));

      // Compare against golden file
      // If the golden file does not exist, it will be generated on first run
      await expectLater(
        find.byType(WelcomeScreen),
        matchesGoldenFile('test/golden/welcome_screen.png'),
      );
    });
  });
}

/*
HOW TO UPDATE GOLDEN FILES:

1. To generate new golden files (first time):
   flutter test --update-goldens

2. To update existing golden files after UI changes:
   flutter test --update-goldens

3. To run tests without updating (normal testing):
   flutter test

4. To run only golden tests:
   flutter test test/golden/

5. To update only specific golden files:
   flutter test test/golden/welcome_screen_golden_test.dart --update-goldens

IMPORTANT NOTES:
- Golden files are stored in test/golden/ directory
- Each golden file represents the expected visual appearance
- When UI changes, you need to update golden files with --update-goldens
- Always review the changes before updating golden files
- Golden tests help catch unintended visual regressions
*/
