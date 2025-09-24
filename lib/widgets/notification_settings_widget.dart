import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../core/notifications/notification_service.dart';
import '../core/notifications/notification_preferences.dart';

/// Widget for managing notification settings
class NotificationSettingsWidget extends StatefulWidget {
  const NotificationSettingsWidget({super.key});

  @override
  State<NotificationSettingsWidget> createState() => _NotificationSettingsWidgetState();
}

class _NotificationSettingsWidgetState extends State<NotificationSettingsWidget> {
  bool _isLoading = true;
  bool _dailyReminderEnabled = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 20, minute: 0);
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final enabled = await NotificationPreferences.isDailyReminderEnabled();
      final hour = await NotificationPreferences.getDailyReminderHour();
      final minute = await NotificationPreferences.getDailyReminderMinute();

      setState(() {
        _dailyReminderEnabled = enabled;
        _reminderTime = TimeOfDay(hour: hour, minute: minute);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Error loading notification settings: $e');
    }
  }

  Future<void> _toggleDailyReminder(bool enabled) async {
    try {
      await NotificationPreferences.setDailyReminderEnabled(enabled);
      
      if (enabled) {
        // Schedule the reminder
                  await _notificationService.scheduleDailyReminder(
            1, // ID for daily reminder
            'MindCompanion Reminder',
            '¿Quieres registrar tus emociones hoy?',
            _reminderTime,
          );
        _showSuccessSnackBar('Daily reminder enabled');
      } else {
        // Cancel the reminder
        await _notificationService.cancel(1);
        _showSuccessSnackBar('Daily reminder disabled');
      }

      setState(() {
        _dailyReminderEnabled = enabled;
      });
    } catch (e) {
      _showErrorSnackBar('Error updating reminder: $e');
    }
  }

  Future<void> _selectTime() async {
    try {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: _reminderTime,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: const Color(0xFF87CEEB),
              ),
            ),
            child: child!,
          );
        },
      );

      if (picked != null && picked != _reminderTime) {
        await NotificationPreferences.setDailyReminderTime(picked.hour, picked.minute);
        
        if (_dailyReminderEnabled) {
          // Reschedule with new time
          await _notificationService.cancel(1);
          await _notificationService.scheduleDailyReminder(
            1,
            'MindCompanion Reminder',
            '¿Quieres registrar tus emociones hoy?',
            picked,
          );
        }

        setState(() {
          _reminderTime = picked;
        });

        _showSuccessSnackBar('Reminder time updated');
      }
    } catch (e) {
      _showErrorSnackBar('Error updating time: $e');
    }
  }

  Future<void> _testNotification() async {
    try {
      await _notificationService.scheduleTestNotification();
      _showSuccessSnackBar('Test notification sent!');
    } catch (e) {
      _showErrorSnackBar('Error sending test notification: $e');
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        const Text(
          'Notification Settings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 16),

        // Daily Reminder Toggle
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Daily Reminder',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Get reminded to log your emotions daily',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _dailyReminderEnabled,
                      onChanged: _toggleDailyReminder,
                      activeColor: const Color(0xFF87CEEB),
                    ),
                  ],
                ),
                
                if (_dailyReminderEnabled) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  
                  // Time Selection
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Reminder Time',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      InkWell(
                        onTap: _selectTime,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF87CEEB)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.access_time,
                                color: Color(0xFF87CEEB),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _reminderTime.format(context),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF87CEEB),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Test Notification Button
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Test Notifications',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Send a test notification to verify everything is working',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _testNotification,
                    icon: const Icon(Icons.notifications_active),
                    label: const Text('Send Test Notification'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF87CEEB),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Notification Status
        FutureBuilder<Map<String, dynamic>>(
          future: _notificationService.getStatus(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final status = snapshot.data!;
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Notification Status',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildStatusRow('Initialized', status['initialized']),
                      _buildStatusRow('Enabled', status['enabled']),
                      _buildStatusRow('Pending Notifications', status['pendingCount']),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildStatusRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: _getStatusColor(value),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _formatValue(value),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(dynamic value) {
    if (value is bool) {
      return value ? Colors.green : Colors.red;
    } else if (value is int) {
      return value > 0 ? Colors.blue : Colors.grey;
    }
    return Colors.grey;
  }

  String _formatValue(dynamic value) {
    if (value is bool) {
      return value ? 'Yes' : 'No';
    } else if (value is int) {
      return value.toString();
    }
    return value.toString();
  }
}
