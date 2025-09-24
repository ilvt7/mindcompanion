import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing notification preferences
class NotificationPreferences {
  static const String _dailyReminderEnabledKey = 'daily_reminder_enabled';
  static const String _dailyReminderHourKey = 'daily_reminder_hour';
  static const String _dailyReminderMinuteKey = 'daily_reminder_minute';
  static const String _lastReminderDateKey = 'last_reminder_date';

  /// Check if daily reminder is enabled
  static Future<bool> isDailyReminderEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_dailyReminderEnabledKey) ?? false;
  }

  /// Set daily reminder enabled/disabled
  static Future<void> setDailyReminderEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_dailyReminderEnabledKey, enabled);
  }

  /// Get daily reminder time (hour)
  static Future<int> getDailyReminderHour() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_dailyReminderHourKey) ?? 20; // Default 8 PM
  }

  /// Get daily reminder time (minute)
  static Future<int> getDailyReminderMinute() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_dailyReminderMinuteKey) ?? 0; // Default 0 minutes
  }

  /// Set daily reminder time
  static Future<void> setDailyReminderTime(int hour, int minute) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_dailyReminderHourKey, hour);
    await prefs.setInt(_dailyReminderMinuteKey, minute);
  }

  /// Get last reminder date
  static Future<DateTime?> getLastReminderDate() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_lastReminderDateKey);
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }

  /// Set last reminder date
  static Future<void> setLastReminderDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastReminderDateKey, date.millisecondsSinceEpoch);
  }

  /// Get all notification preferences
  static Future<Map<String, dynamic>> getAllPreferences() async {
    return {
      'dailyReminderEnabled': await isDailyReminderEnabled(),
      'dailyReminderHour': await getDailyReminderHour(),
      'dailyReminderMinute': await getDailyReminderMinute(),
      'lastReminderDate': await getLastReminderDate(),
    };
  }

  /// Reset all notification preferences
  static Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_dailyReminderEnabledKey);
    await prefs.remove(_dailyReminderHourKey);
    await prefs.remove(_dailyReminderMinuteKey);
    await prefs.remove(_lastReminderDateKey);
  }
}
