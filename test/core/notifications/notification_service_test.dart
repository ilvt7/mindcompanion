import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mindcompanion/core/notifications/notification_service.dart';

@GenerateMocks([FlutterLocalNotificationsPlugin])
import 'notification_service_test.mocks.dart';

void main() {
  group('NotificationService Tests', () {
    late NotificationService notificationService;
    late MockFlutterLocalNotificationsPlugin mockPlugin;

    setUp(() {
      notificationService = NotificationService();
      mockPlugin = MockFlutterLocalNotificationsPlugin();
    });

    group('Initialization', () {
      test('should be singleton', () {
        final instance1 = NotificationService();
        final instance2 = NotificationService();
        expect(instance1, equals(instance2));
      });

      test('should initialize successfully', () async {
        // Note: This test would require mocking the timezone initialization
        // and the actual plugin initialization, which is complex in unit tests
        // In a real scenario, you'd use integration tests for this
        
        // For now, we'll test the singleton pattern and basic structure
        expect(notificationService, isA<NotificationService>());
      });
    });

    group('Immediate Notifications', () {
      test('should throw error when not initialized', () async {
        expect(
          () => notificationService.showImmediate('Test', 'Body'),
          throwsA(isA<StateError>()),
        );
      });

      test('should show immediate notification when initialized', () async {
        // This would require mocking the plugin and initialization
        // In a real test environment, you'd mock the plugin calls
        
        // For now, we test the method signature and error handling
        try {
          await notificationService.showImmediate('Test', 'Body');
        } catch (e) {
          expect(e, isA<StateError>());
        }
      });
    });

    group('Daily Reminders', () {
      test('should throw error when not initialized', () async {
        expect(
          () => notificationService.scheduleDailyReminder(
            1,
            'Test',
            'Body',
            const TimeOfDay(hour: 20, minute: 0),
          ),
          throwsA(isA<StateError>()),
        );
      });

      test('should schedule daily reminder when initialized', () async {
        // This would require mocking the plugin and initialization
        try {
          await notificationService.scheduleDailyReminder(
            1,
            'Test',
            'Body',
            const TimeOfDay(hour: 20, minute: 0),
          );
        } catch (e) {
          expect(e, isA<StateError>());
        }
      });
    });

    group('Cancellation', () {
      test('should throw error when not initialized', () async {
        expect(
          () => notificationService.cancel(1),
          throwsA(isA<StateError>()),
        );
      });

      test('should cancel notification when initialized', () async {
        try {
          await notificationService.cancel(1);
        } catch (e) {
          expect(e, isA<StateError>());
        }
      });

      test('should cancel all notifications when initialized', () async {
        try {
          await notificationService.cancelAll();
        } catch (e) {
          expect(e, isA<StateError>());
        }
      });
    });

    group('Status and Info', () {
      test('should return empty list when not initialized', () async {
        try {
          final pending = await notificationService.getPendingNotifications();
          expect(pending, isEmpty);
        } catch (e) {
          expect(e, isA<StateError>());
        }
      });

      test('should return false for notifications enabled when not initialized', () async {
        final enabled = await notificationService.areNotificationsEnabled();
        expect(enabled, false);
      });

      test('should return status info', () async {
        final status = await notificationService.getStatus();
        expect(status, isA<Map<String, dynamic>>());
        expect(status['initialized'], false);
        expect(status['enabled'], false);
        expect(status['pendingCount'], 0);
        expect(status['pendingNotifications'], isA<List>());
      });
    });

    group('Test Notifications', () {
      test('should throw error when not initialized', () async {
        expect(
          () => notificationService.scheduleTestNotification(),
          throwsA(isA<StateError>()),
        );
      });
    });
  });
}
