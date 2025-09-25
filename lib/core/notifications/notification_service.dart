import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

/// Service for managing local notifications
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  /// Initialize the notification service
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      // Initialize timezone data
      tz.initializeTimeZones();

      // Android initialization settings
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS initialization settings
      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );

      // Combined initialization settings
      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      // Initialize the plugin
      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Request permissions
      await _requestPermissions();

      _isInitialized = true;
      if (kDebugMode) {
        print('NotificationService initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing NotificationService: $e');
      }
      rethrow;
    }
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notifications
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      await androidImplementation?.requestNotificationsPermission();
      await androidImplementation?.requestExactAlarmsPermission();
    } else if (Platform.isIOS) {
      await _notifications
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  /// Show an immediate notification
  Future<void> showImmediate(String title, String body) async {
    if (!_isInitialized) {
      throw StateError(
        'NotificationService not initialized. Call init() first.',
      );
    }

    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'mindcompanion_immediate',
            'MindCompanion Immediate',
            channelDescription: 'Immediate notifications from MindCompanion',
            importance: Importance.high,
            priority: Priority.high,
            showWhen: true,
          );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        notificationDetails,
      );

      if (kDebugMode) {
        print('Immediate notification shown: $title');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error showing immediate notification: $e');
      }
      rethrow;
    }
  }

  /// Schedule a daily reminder notification
  Future<void> scheduleDailyReminder(
    int id,
    String title,
    String body,
    TimeOfDay time,
  ) async {
    if (!_isInitialized) {
      throw StateError(
        'NotificationService not initialized. Call init() first.',
      );
    }

    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'mindcompanion_reminders',
            'MindCompanion Reminders',
            channelDescription: 'Daily reminders from MindCompanion',
            importance: Importance.high,
            priority: Priority.high,
            showWhen: true,
            ongoing: false,
            autoCancel: true,
          );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // Schedule the notification
      await _notifications.zonedSchedule(
        id,
        title,
        body,
        _nextInstanceOfTime(time),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      if (kDebugMode) {
        print(
          'Daily reminder scheduled for ${time.hour}:${time.minute.toString().padLeft(2, '0')}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error scheduling daily reminder: $e');
      }
      rethrow;
    }
  }

  /// Cancel a specific notification by ID
  Future<void> cancel(int id) async {
    if (!_isInitialized) {
      throw StateError(
        'NotificationService not initialized. Call init() first.',
      );
    }

    try {
      await _notifications.cancel(id);
      if (kDebugMode) {
        print('Notification $id cancelled');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error cancelling notification $id: $e');
      }
      rethrow;
    }
  }

  /// Cancel all notifications
  Future<void> cancelAll() async {
    if (!_isInitialized) {
      throw StateError(
        'NotificationService not initialized. Call init() first.',
      );
    }

    try {
      await _notifications.cancelAll();
      if (kDebugMode) {
        print('All notifications cancelled');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error cancelling all notifications: $e');
      }
      rethrow;
    }
  }

  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    if (!_isInitialized) {
      throw StateError(
        'NotificationService not initialized. Call init() first.',
      );
    }

    try {
      return await _notifications.pendingNotificationRequests();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting pending notifications: $e');
      }
      return [];
    }
  }

  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    if (!_isInitialized) {
      return false;
    }

    try {
      if (Platform.isAndroid) {
        final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
            _notifications
                .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin
                >();
        return await androidImplementation?.areNotificationsEnabled() ?? false;
      } else if (Platform.isIOS) {
        // iOS doesn't have a direct way to check, assume enabled if initialized
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking notification permissions: $e');
      }
      return false;
    }
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    if (kDebugMode) {
      print('Notification tapped: ${response.id} - ${response.payload}');
    }

    // Handle notification tap based on payload
    // This could navigate to specific screens or perform actions
  }

  /// Calculate the next instance of a given time
  tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  /// Schedule a test notification (for testing purposes)
  Future<void> scheduleTestNotification() async {
    await showImmediate(
      'MindCompanion Test',
      'This is a test notification to verify everything is working!',
    );
  }

  /// Get notification status info
  Future<Map<String, dynamic>> getStatus() async {
    if (!_isInitialized) {
      return {
        'initialized': false,
        'enabled': false,
        'pendingCount': 0,
        'pendingNotifications': <Map<String, dynamic>>[],
      };
    }

    final pending = await getPendingNotifications();
    final enabled = await areNotificationsEnabled();

    return {
      'initialized': _isInitialized,
      'enabled': enabled,
      'pendingCount': pending.length,
      'pendingNotifications': pending
          .map((n) => {'id': n.id, 'title': n.title, 'body': n.body})
          .toList(),
    };
  }
}
