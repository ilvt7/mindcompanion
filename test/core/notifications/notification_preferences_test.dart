import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mindcompanion/core/notifications/notification_preferences.dart';

void main() {
  group('NotificationPreferences Tests', () {
    setUp(() {
      // Clear SharedPreferences before each test
      SharedPreferences.setMockInitialValues({});
    });

    group('Daily Reminder Settings', () {
      test(
        'should return false by default for daily reminder enabled',
        () async {
          final enabled =
              await NotificationPreferences.isDailyReminderEnabled();
          expect(enabled, false);
        },
      );

      test('should set and get daily reminder enabled', () async {
        await NotificationPreferences.setDailyReminderEnabled(true);
        final enabled = await NotificationPreferences.isDailyReminderEnabled();
        expect(enabled, true);

        await NotificationPreferences.setDailyReminderEnabled(false);
        final disabled = await NotificationPreferences.isDailyReminderEnabled();
        expect(disabled, false);
      });

      test(
        'should return default time (8 PM) for daily reminder hour',
        () async {
          final hour = await NotificationPreferences.getDailyReminderHour();
          expect(hour, 20);
        },
      );

      test(
        'should return default time (0 minutes) for daily reminder minute',
        () async {
          final minute = await NotificationPreferences.getDailyReminderMinute();
          expect(minute, 0);
        },
      );

      test('should set and get daily reminder time', () async {
        await NotificationPreferences.setDailyReminderTime(9, 30);

        final hour = await NotificationPreferences.getDailyReminderHour();
        final minute = await NotificationPreferences.getDailyReminderMinute();

        expect(hour, 9);
        expect(minute, 30);
      });

      test('should handle edge cases for time', () async {
        // Test midnight
        await NotificationPreferences.setDailyReminderTime(0, 0);
        expect(await NotificationPreferences.getDailyReminderHour(), 0);
        expect(await NotificationPreferences.getDailyReminderMinute(), 0);

        // Test 11:59 PM
        await NotificationPreferences.setDailyReminderTime(23, 59);
        expect(await NotificationPreferences.getDailyReminderHour(), 23);
        expect(await NotificationPreferences.getDailyReminderMinute(), 59);
      });
    });

    group('Last Reminder Date', () {
      test('should return null by default for last reminder date', () async {
        final date = await NotificationPreferences.getLastReminderDate();
        expect(date, isNull);
      });

      test('should set and get last reminder date', () async {
        final testDate = DateTime(2024, 1, 15, 20, 0);
        await NotificationPreferences.setLastReminderDate(testDate);

        final retrievedDate =
            await NotificationPreferences.getLastReminderDate();
        expect(retrievedDate, isNotNull);
        expect(retrievedDate!.year, testDate.year);
        expect(retrievedDate.month, testDate.month);
        expect(retrievedDate.day, testDate.day);
        expect(retrievedDate.hour, testDate.hour);
        expect(retrievedDate.minute, testDate.minute);
      });

      test('should handle different dates', () async {
        final dates = [
          DateTime(2024, 1, 1),
          DateTime(2024, 6, 15, 12, 30),
          DateTime(2024, 12, 31, 23, 59),
        ];

        for (final date in dates) {
          await NotificationPreferences.setLastReminderDate(date);
          final retrieved = await NotificationPreferences.getLastReminderDate();
          expect(retrieved, isNotNull);
          expect(
            retrieved!.millisecondsSinceEpoch,
            date.millisecondsSinceEpoch,
          );
        }
      });
    });

    group('All Preferences', () {
      test('should return all preferences with default values', () async {
        final prefs = await NotificationPreferences.getAllPreferences();

        expect(prefs, isA<Map<String, dynamic>>());
        expect(prefs['dailyReminderEnabled'], false);
        expect(prefs['dailyReminderHour'], 20);
        expect(prefs['dailyReminderMinute'], 0);
        expect(prefs['lastReminderDate'], isNull);
      });

      test('should return all preferences with custom values', () async {
        final testDate = DateTime(2024, 3, 15, 14, 30);

        await NotificationPreferences.setDailyReminderEnabled(true);
        await NotificationPreferences.setDailyReminderTime(14, 30);
        await NotificationPreferences.setLastReminderDate(testDate);

        final prefs = await NotificationPreferences.getAllPreferences();

        expect(prefs['dailyReminderEnabled'], true);
        expect(prefs['dailyReminderHour'], 14);
        expect(prefs['dailyReminderMinute'], 30);
        expect(prefs['lastReminderDate'], isNotNull);
        expect(
          (prefs['lastReminderDate'] as DateTime).millisecondsSinceEpoch,
          testDate.millisecondsSinceEpoch,
        );
      });
    });

    group('Reset All', () {
      test('should reset all preferences to default', () async {
        // Set some values
        await NotificationPreferences.setDailyReminderEnabled(true);
        await NotificationPreferences.setDailyReminderTime(15, 45);
        await NotificationPreferences.setLastReminderDate(DateTime.now());

        // Verify they're set
        expect(await NotificationPreferences.isDailyReminderEnabled(), true);
        expect(await NotificationPreferences.getDailyReminderHour(), 15);
        expect(await NotificationPreferences.getDailyReminderMinute(), 45);
        expect(await NotificationPreferences.getLastReminderDate(), isNotNull);

        // Reset all
        await NotificationPreferences.resetAll();

        // Verify they're back to defaults
        expect(await NotificationPreferences.isDailyReminderEnabled(), false);
        expect(await NotificationPreferences.getDailyReminderHour(), 20);
        expect(await NotificationPreferences.getDailyReminderMinute(), 0);
        expect(await NotificationPreferences.getLastReminderDate(), isNull);
      });
    });

    group('Persistence', () {
      test('should persist values across multiple calls', () async {
        await NotificationPreferences.setDailyReminderEnabled(true);
        await NotificationPreferences.setDailyReminderTime(10, 15);

        // Make multiple calls to ensure persistence
        for (int i = 0; i < 3; i++) {
          expect(await NotificationPreferences.isDailyReminderEnabled(), true);
          expect(await NotificationPreferences.getDailyReminderHour(), 10);
          expect(await NotificationPreferences.getDailyReminderMinute(), 15);
        }
      });
    });
  });
}
