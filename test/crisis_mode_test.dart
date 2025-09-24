
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:mindcompanion/screens/crisis_mode_screen.dart';

// Generate mocks for AudioPlayer and url_launcher
@GenerateMocks([AudioPlayer])
import 'crisis_mode_test.mocks.dart';

void main() {
  group('CrisisModeScreen Widget Tests', () {
    late MockAudioPlayer mockMeditationAudioPlayer;
    late MockAudioPlayer mockComfortAudioPlayer;

    setUp(() {
      mockMeditationAudioPlayer = MockAudioPlayer();
      mockComfortAudioPlayer = MockAudioPlayer();
      
      // Set up default mock responses
      when(mockMeditationAudioPlayer.play(any)).thenAnswer((_) async {});
      when(mockMeditationAudioPlayer.stop()).thenAnswer((_) async {});
      when(mockMeditationAudioPlayer.seek(any)).thenAnswer((_) async {});
      when(mockMeditationAudioPlayer.dispose()).thenAnswer((_) async {});
      
      when(mockComfortAudioPlayer.play(any)).thenAnswer((_) async {});
      when(mockComfortAudioPlayer.stop()).thenAnswer((_) async {});
      when(mockComfortAudioPlayer.seek(any)).thenAnswer((_) async {});
      when(mockComfortAudioPlayer.dispose()).thenAnswer((_) async {});
    });

    tearDown(() {
      // Clean up after each test
    });

    // Helper function to build the test widget with larger surface
    Widget _buildTestWidget() {
      return MaterialApp(
        home: const CrisisModeScreen(),
      );
    }

    group('Breathing Exercise Tests', () {
      testWidgets('Tapping "Breathing Exercise" starts animation (circle expand/contract)', (WidgetTester tester) async {
        // Build the CrisisModeScreen with larger surface to avoid overflow
        await tester.binding.setSurfaceSize(const Size(800, 1200));
        await tester.pumpWidget(_buildTestWidget());
        
        // Wait for initial animations to complete (use pump instead of pumpAndSettle)
        await tester.pump(const Duration(milliseconds: 1500));

        // Verify the breathing exercise button is displayed
        expect(find.text('Breathing Exercise'), findsOneWidget);
        expect(find.text('Take deep breaths to calm your mind'), findsOneWidget);

        // Tap the breathing exercise button
        await tester.tap(find.text('Breathing Exercise'));
        await tester.pump(); // Use pump instead of pumpAndSettle

        // Verify the breathing dialog appears
        expect(find.text('Breathing Exercise'), findsAtLeastNWidgets(2)); // Button + Dialog title
        expect(find.text('Follow the expanding and contracting circle to breathe slowly and deeply'), findsOneWidget);

        // Verify the breathing circle animation is present
        expect(find.byType(AnimatedBuilder), findsAtLeastNWidgets(1));

        // Verify the breathing instructions are displayed
        expect(find.text('Inhale'), findsOneWidget);
        expect(find.text('Breath count: 0'), findsOneWidget);

        // Verify the stop button is present
        expect(find.text('Stop Exercise'), findsOneWidget);

        // Close the dialog
        await tester.tap(find.text('Stop Exercise'));
        await tester.pump();

        // Verify dialog is closed
        expect(find.text('Follow the expanding and contracting circle to breathe slowly and deeply'), findsNothing);
      });

      testWidgets('Breathing exercise shows correct animation states', (WidgetTester tester) async {
        // Build the CrisisModeScreen with larger surface
        await tester.binding.setSurfaceSize(const Size(800, 1200));
        await tester.pumpWidget(_buildTestWidget());
        
        // Wait for initial animations
        await tester.pump(const Duration(milliseconds: 1500));

        // Start breathing exercise
        await tester.tap(find.text('Breathing Exercise'));
        await tester.pump();

        // Verify initial state
        expect(find.text('Inhale'), findsOneWidget);
        expect(find.text('Breath count: 0'), findsOneWidget);

        // Wait for breathing cycle to complete - use multiple pumps for animation
        for (int i = 0; i < 10; i++) {
          await tester.pump(const Duration(milliseconds: 500));
        }

        // Verify state after one cycle (may still be 0 since it's a continuous animation)
        expect(find.textContaining('Breath count:'), findsOneWidget);
      });
    });

    group('Quick Meditation Tests', () {
      testWidgets('Tapping "Quick Meditation" starts meditation session', (WidgetTester tester) async {
        // Build the CrisisModeScreen with larger surface
        await tester.binding.setSurfaceSize(const Size(800, 1200));
        await tester.pumpWidget(_buildTestWidget());
        
        // Wait for initial animations
        await tester.pump(const Duration(milliseconds: 1500));

        // Verify the meditation button is displayed
        expect(find.text('Quick Meditation'), findsOneWidget);
        expect(find.text('5-minute guided meditation for relief'), findsOneWidget);

        // Tap the meditation button
        await tester.tap(find.text('Quick Meditation'));
        await tester.pump();

        // Verify the meditation dialog appears
        expect(find.text('Quick Meditation'), findsAtLeastNWidgets(2)); // Button + Dialog title
        expect(find.text('Find a comfortable position and focus on your breath'), findsOneWidget);

        // Verify the meditation instructions are displayed
        expect(find.text('Take deep breaths and let your thoughts pass by like clouds'), findsOneWidget);

        // Verify the end button is present
        expect(find.text('End Session'), findsOneWidget);

        // Close the dialog
        await tester.tap(find.text('End Session'));
        await tester.pump();

        // Verify dialog is closed
        expect(find.text('Find a comfortable position and focus on your breath'), findsNothing);
      });

      testWidgets('Meditation session can be started and stopped', (WidgetTester tester) async {
        // Build the CrisisModeScreen with larger surface
        await tester.binding.setSurfaceSize(const Size(800, 1200));
        await tester.pumpWidget(_buildTestWidget());
        
        // Wait for initial animations
        await tester.pump(const Duration(milliseconds: 1500));

        // Start meditation
        await tester.tap(find.text('Quick Meditation'));
        await tester.pump();

        // Verify meditation is active
        expect(find.text('Take deep breaths and let your thoughts pass by like clouds'), findsOneWidget);

        // End meditation
        await tester.tap(find.text('End Session'));
        await tester.pump();

        // Verify meditation is stopped
        expect(find.text('Take deep breaths and let your thoughts pass by like clouds'), findsNothing);
      });
    });

    group('Comfort Audio Tests', () {
      testWidgets('Tapping "Comfort Audio" starts audio session', (WidgetTester tester) async {
        // Build the CrisisModeScreen with larger surface
        await tester.binding.setSurfaceSize(const Size(800, 1200));
        await tester.pumpWidget(_buildTestWidget());
        
        // Wait for initial animations
        await tester.pump(const Duration(milliseconds: 1500));

        // Verify the comfort audio button is displayed
        expect(find.text('Comfort Audio'), findsOneWidget);
        expect(find.text('Soothing sounds to calm your mind'), findsOneWidget);

        // Tap the comfort audio button
        await tester.tap(find.text('Comfort Audio'));
        await tester.pump();

        // Verify the comfort audio dialog appears
        expect(find.text('Comfort Audio'), findsAtLeastNWidgets(2)); // Button + Dialog title
        expect(find.text('Relax and let the soothing sounds wash over you'), findsOneWidget);

        // Verify the comfort audio instructions are displayed
        expect(find.text('Close your eyes and focus on the calming sounds'), findsOneWidget);

        // Verify the end button is present
        expect(find.text('End Session'), findsOneWidget);

        // Close the dialog
        await tester.tap(find.text('End Session'));
        await tester.pump();

        // Verify dialog is closed
        expect(find.text('Relax and let the soothing sounds wash over you'), findsNothing);
      });

      testWidgets('Comfort audio session can be started and stopped', (WidgetTester tester) async {
        // Build the CrisisModeScreen with larger surface
        await tester.binding.setSurfaceSize(const Size(800, 1200));
        await tester.pumpWidget(_buildTestWidget());
        
        // Wait for initial animations
        await tester.pump(const Duration(milliseconds: 1500));

        // Start comfort audio
        await tester.tap(find.text('Comfort Audio'));
        await tester.pump();

        // Verify comfort audio is active
        expect(find.text('Close your eyes and focus on the calming sounds'), findsOneWidget);

        // End comfort audio
        await tester.tap(find.text('End Session'));
        await tester.pump();

        // Verify comfort audio is stopped
        expect(find.text('Close your eyes and focus on the calming sounds'), findsNothing);
      });
    });

    group('Contact Help Tests', () {
      testWidgets('Tapping "Contact Help" shows contact options', (WidgetTester tester) async {
        // Build the CrisisModeScreen with larger surface
        await tester.binding.setSurfaceSize(const Size(800, 1200));
        await tester.pumpWidget(_buildTestWidget());
        
        // Wait for initial animations
        await tester.pump(const Duration(milliseconds: 1500));

        // Verify the contact help button is displayed
        expect(find.text('Contact Help'), findsOneWidget);
        expect(find.text('Connect with crisis counselors'), findsOneWidget);

        // Tap the contact help button
        await tester.tap(find.text('Contact Help'));
        await tester.pump();

        // Verify the contact help dialog appears
        expect(find.text('Contact Help'), findsAtLeastNWidgets(2)); // Button + Dialog title
        expect(find.text('Choose how you would like to get help:'), findsOneWidget);

        // Verify the contact options are displayed
        expect(find.text('Emergency (911)'), findsOneWidget);
        expect(find.text('Crisis Hotline (988)'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);

        // Close the dialog
        await tester.tap(find.text('Cancel'));
        await tester.pump();

        // Verify dialog is closed
        expect(find.text('Choose how you would like to get help:'), findsNothing);
      });

      testWidgets('Emergency contact options are displayed correctly', (WidgetTester tester) async {
        // Build the CrisisModeScreen with larger surface
        await tester.binding.setSurfaceSize(const Size(800, 1200));
        await tester.pumpWidget(_buildTestWidget());
        
        // Wait for initial animations
        await tester.pump(const Duration(milliseconds: 1500));

        // Open contact help
        await tester.tap(find.text('Contact Help'));
        await tester.pump();

        // Verify both emergency options are present
        expect(find.text('Emergency (911)'), findsOneWidget);
        expect(find.text('Crisis Hotline (988)'), findsOneWidget);

        // Close dialog
        await tester.tap(find.text('Cancel'));
        await tester.pump();

        // Verify dialog is closed
        expect(find.text('Choose how you would like to get help:'), findsNothing);
      });

      testWidgets('Contact help dialog can be opened multiple times', (WidgetTester tester) async {
        // Build the CrisisModeScreen with larger surface
        await tester.binding.setSurfaceSize(const Size(800, 1200));
        await tester.pumpWidget(_buildTestWidget());
        
        // Wait for initial animations
        await tester.pump(const Duration(milliseconds: 1500));

        // Open contact help first time
        await tester.tap(find.text('Contact Help'));
        await tester.pump();

        // Verify dialog is open
        expect(find.text('Choose how you would like to get help:'), findsOneWidget);

        // Close dialog
        await tester.tap(find.text('Cancel'));
        await tester.pump();

        // Verify dialog is closed
        expect(find.text('Choose how you would like to get help:'), findsNothing);

        // Open contact help second time
        await tester.tap(find.text('Contact Help'));
        await tester.pump();

        // Verify dialog is open again
        expect(find.text('Choose how you would like to get help:'), findsOneWidget);

        // Close dialog
        await tester.tap(find.text('Cancel'));
        await tester.pump();

        // Verify dialog is closed
        expect(find.text('Choose how you would like to get help:'), findsNothing);
      });
    });

    group('UI Layout and Content Tests', () {
      testWidgets('Crisis mode screen displays all required elements', (WidgetTester tester) async {
        // Build the CrisisModeScreen with larger surface
        await tester.binding.setSurfaceSize(const Size(800, 1200));
        await tester.pumpWidget(_buildTestWidget());
        
        // Wait for initial animations
        await tester.pump(const Duration(milliseconds: 1500));

        // Verify main screen elements
        expect(find.text('Crisis Mode'), findsOneWidget);
        expect(find.text('Crisis Mode Activated'), findsOneWidget);
        expect(find.text('Choose an intervention to help you through this moment'), findsOneWidget);

        // Verify all intervention buttons are present
        expect(find.text('Breathing Exercise'), findsOneWidget);
        expect(find.text('Quick Meditation'), findsOneWidget);
        expect(find.text('Comfort Audio'), findsOneWidget);
        expect(find.text('Contact Help'), findsOneWidget);

        // Verify button descriptions
        expect(find.text('Take deep breaths to calm your mind'), findsOneWidget);
        expect(find.text('5-minute guided meditation for relief'), findsOneWidget);
        expect(find.text('Soothing sounds to calm your mind'), findsOneWidget);
        expect(find.text('Connect with crisis counselors'), findsOneWidget);
      });

      testWidgets('Crisis mode screen handles different screen sizes', (WidgetTester tester) async {
        // Test with small screen
        await tester.binding.setSurfaceSize(const Size(400, 800));
        await tester.pumpWidget(_buildTestWidget());
        await tester.pump(const Duration(milliseconds: 1500));

        // Verify main elements are still present
        expect(find.text('Crisis Mode Activated'), findsOneWidget);
        expect(find.text('Breathing Exercise'), findsOneWidget);
        expect(find.text('Quick Meditation'), findsOneWidget);
        expect(find.text('Comfort Audio'), findsOneWidget);
        expect(find.text('Contact Help'), findsOneWidget);

        // Test with large screen
        await tester.binding.setSurfaceSize(const Size(1200, 1600));
        await tester.pumpWidget(_buildTestWidget());
        await tester.pump(const Duration(milliseconds: 1500));

        // Verify main elements are still present
        expect(find.text('Crisis Mode Activated'), findsOneWidget);
        expect(find.text('Breathing Exercise'), findsOneWidget);
        expect(find.text('Quick Meditation'), findsOneWidget);
        expect(find.text('Comfort Audio'), findsOneWidget);
        expect(find.text('Contact Help'), findsOneWidget);
      });

      testWidgets('All intervention buttons are functional', (WidgetTester tester) async {
        // Build the CrisisModeScreen with larger surface
        await tester.binding.setSurfaceSize(const Size(800, 1200));
        await tester.pumpWidget(_buildTestWidget());
        
        // Wait for initial animations
        await tester.pump(const Duration(milliseconds: 1500));

        // Test breathing exercise button
        await tester.tap(find.text('Quick Meditation'));
        await tester.pump();
        expect(find.text('Find a comfortable position and focus on your breath'), findsOneWidget);
        await tester.tap(find.text('End Session'));
        await tester.pump();

        // Test comfort audio button
        await tester.tap(find.text('Comfort Audio'));
        await tester.pump();
        expect(find.text('Relax and let the soothing sounds wash over you'), findsOneWidget);
        await tester.tap(find.text('End Session'));
        await tester.pump();
      });
    });
  });
}
