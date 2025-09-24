import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/diary_entry.dart';

class DiaryStorageService {
  static const String _storageKey = 'diary_entries';
  
  // Save a diary entry
  static Future<bool> saveEntry(DiaryEntry entry) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final entries = await getEntries();
      
      // Add new entry
      entries.add(entry);
      
      // Convert to JSON strings
      final jsonStrings = entries.map((e) => jsonEncode(e.toJson())).toList();
      
      // Save to shared preferences
      return await prefs.setStringList(_storageKey, jsonStrings);
    } catch (e) {
      print('Error saving diary entry: $e');
      return false;
    }
  }
  
  // Get all diary entries
  static Future<List<DiaryEntry>> getEntries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStrings = prefs.getStringList(_storageKey) ?? [];
      
      return jsonStrings
          .map((jsonString) => DiaryEntry.fromJson(jsonDecode(jsonString)))
          .toList();
    } catch (e) {
      print('Error retrieving diary entries: $e');
      return [];
    }
  }
  
  // Get entries for a specific date
  static Future<List<DiaryEntry>> getEntriesForDate(DateTime date) async {
    try {
      final allEntries = await getEntries();
      return allEntries.where((entry) {
        return entry.date.year == date.year &&
               entry.date.month == date.month &&
               entry.date.day == date.day;
      }).toList();
    } catch (e) {
      print('Error retrieving entries for date: $e');
      return [];
    }
  }
  
  // Get entries for a date range
  static Future<List<DiaryEntry>> getEntriesForDateRange(DateTime startDate, DateTime endDate) async {
    try {
      final allEntries = await getEntries();
      return allEntries.where((entry) {
        return entry.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
               entry.date.isBefore(endDate.add(const Duration(days: 1)));
      }).toList();
    } catch (e) {
      print('Error retrieving entries for date range: $e');
      return [];
    }
  }
  
  // Get entries by type
  static Future<List<DiaryEntry>> getEntriesByType(String type) async {
    try {
      final allEntries = await getEntries();
      return allEntries.where((entry) => entry.type == type).toList();
    } catch (e) {
      print('Error retrieving entries by type: $e');
      return [];
    }
  }
  
  // Get AI diary entries only
  static Future<List<DiaryEntry>> getAIEntries() async {
    return await getEntriesByType('ai');
  }
  
  // Get personal diary entries only
  static Future<List<DiaryEntry>> getPersonalEntries() async {
    return await getEntriesByType('personal');
  }
  
  // Delete a specific entry
  static Future<bool> deleteEntry(String entryId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final entries = await getEntries();
      
      // Remove entry with matching ID
      entries.removeWhere((entry) => entry.id == entryId);
      
      // Convert to JSON strings
      final jsonStrings = entries.map((e) => jsonEncode(e.toJson())).toList();
      
      // Save updated list
      return await prefs.setStringList(_storageKey, jsonStrings);
    } catch (e) {
      print('Error deleting diary entry: $e');
      return false;
    }
  }
  
  // Clear all entries
  static Future<bool> clearAllEntries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_storageKey);
    } catch (e) {
      print('Error clearing diary entries: $e');
      return false;
    }
  }
  
  // Get entry count
  static Future<int> getEntryCount() async {
    try {
      final entries = await getEntries();
      return entries.length;
    } catch (e) {
      print('Error getting entry count: $e');
      return 0;
    }
  }
  
  // Get recent entries (last N entries)
  static Future<List<DiaryEntry>> getRecentEntries(int count) async {
    try {
      final entries = await getEntries();
      entries.sort((a, b) => b.date.compareTo(a.date)); // Sort by date, newest first
      return entries.take(count).toList();
    } catch (e) {
      print('Error getting recent entries: $e');
      return [];
    }
  }
}
