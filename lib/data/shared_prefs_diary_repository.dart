import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/diary_entry.dart';
import '../domain/diary_repository.dart';
import 'diary_entry_dto.dart';
import 'emotion_mapper.dart';

/// SharedPreferences implementation of DiaryRepository
class SharedPrefsDiaryRepository implements DiaryRepository {
  static const String _storageKey = 'diary_entries_v2';
  static const String _oldAiKey = 'ai_diary_entries';
  static const String _oldPersonalKey = 'personal_diary_entries';
  static const String _oldUnifiedKey = 'diary_entries';

  final SharedPreferences _prefs;
  final StreamController<List<DiaryEntry>> _entriesController =
      StreamController<List<DiaryEntry>>.broadcast();
  List<DiaryEntry> _cachedEntries = [];
  Timer? _debounceTimer;

  SharedPrefsDiaryRepository(this._prefs);

  /// Factory constructor to create instance with SharedPreferences
  static Future<SharedPrefsDiaryRepository> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPrefsDiaryRepository(prefs);
  }

  @override
  Future<void> upsertEntry(DiaryEntry entry) async {
    try {
      // Update cache
      final existingIndex = _cachedEntries.indexWhere((e) => e.id == entry.id);
      if (existingIndex >= 0) {
        _cachedEntries[existingIndex] = entry;
      } else {
        _cachedEntries.add(entry);
      }

      // Sort by date (newest first)
      _cachedEntries.sort((a, b) => b.date.compareTo(a.date));

      // Debounced write to SharedPreferences
      _debounceWrite();

      // Emit updated entries
      _entriesController.add(List.from(_cachedEntries));
    } catch (e) {
      print('Error upserting diary entry: $e');
      rethrow;
    }
  }

  @override
  Future<List<DiaryEntry>> getEntries({
    DateTime? from,
    DateTime? to,
    DiarySource? source,
  }) async {
    try {
      await _ensureCacheLoaded();

      var filteredEntries = List<DiaryEntry>.from(_cachedEntries);

      // Apply filters
      if (from != null) {
        filteredEntries = filteredEntries
            .where(
              (entry) =>
                  entry.date.isAfter(from) || entry.date.isAtSameMomentAs(from),
            )
            .toList();
      }

      if (to != null) {
        filteredEntries = filteredEntries
            .where(
              (entry) =>
                  entry.date.isBefore(to) || entry.date.isAtSameMomentAs(to),
            )
            .toList();
      }

      if (source != null) {
        filteredEntries = filteredEntries
            .where((entry) => entry.source == source)
            .toList();
      }

      return filteredEntries;
    } catch (e) {
      print('Error getting diary entries: $e');
      return [];
    }
  }

  @override
  Future<DiaryEntry?> getEntry(String id) async {
    try {
      await _ensureCacheLoaded();
      return _cachedEntries.firstWhere(
        (entry) => entry.id == id,
        orElse: () => throw StateError('Entry not found'),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> deleteEntry(String id) async {
    try {
      _cachedEntries.removeWhere((entry) => entry.id == id);
      _debounceWrite();
      _entriesController.add(List.from(_cachedEntries));
    } catch (e) {
      print('Error deleting diary entry: $e');
      rethrow;
    }
  }

  @override
  Stream<List<DiaryEntry>> watchAll() {
    return _entriesController.stream;
  }

  @override
  Stream<List<DiaryEntry>> watchEntries({
    DateTime? from,
    DateTime? to,
    DiarySource? source,
  }) {
    return _entriesController.stream.map((entries) {
      var filteredEntries = List<DiaryEntry>.from(entries);

      if (from != null) {
        filteredEntries = filteredEntries
            .where(
              (entry) =>
                  entry.date.isAfter(from) || entry.date.isAtSameMomentAs(from),
            )
            .toList();
      }

      if (to != null) {
        filteredEntries = filteredEntries
            .where(
              (entry) =>
                  entry.date.isBefore(to) || entry.date.isAtSameMomentAs(to),
            )
            .toList();
      }

      if (source != null) {
        filteredEntries = filteredEntries
            .where((entry) => entry.source == source)
            .toList();
      }

      return filteredEntries;
    });
  }

  @override
  Future<List<DiaryEntry>> getEntriesForDate(DateTime date) async {
    return getEntries(
      from: DateTime(date.year, date.month, date.day),
      to: DateTime(date.year, date.month, date.day, 23, 59, 59),
    );
  }

  @override
  Future<List<DiaryEntry>> getEntriesForDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return getEntries(from: startDate, to: endDate);
  }

  @override
  Future<List<DiaryEntry>> getEntriesBySource(DiarySource source) async {
    return getEntries(source: source);
  }

  @override
  Future<List<DiaryEntry>> getRecentEntries(int count) async {
    final entries = await getEntries();
    return entries.take(count).toList();
  }

  @override
  Future<int> getEntryCount() async {
    await _ensureCacheLoaded();
    return _cachedEntries.length;
  }

  @override
  Future<void> clearAllEntries() async {
    try {
      _cachedEntries.clear();
      await _prefs.remove(_storageKey);
      _entriesController.add([]);
    } catch (e) {
      print('Error clearing diary entries: $e');
      rethrow;
    }
  }

  @override
  Future<bool> needsMigration() async {
    try {
      // Check if v2 data exists
      final v2Data = _prefs.getString(_storageKey);
      if (v2Data != null && v2Data.isNotEmpty) {
        return false; // Already migrated
      }

      // Check if old data exists
      final oldAiData = _prefs.getString(_oldAiKey);
      final oldPersonalData = _prefs.getString(_oldPersonalKey);
      final oldUnifiedData = _prefs.getString(_oldUnifiedKey);

      return oldAiData != null ||
          oldPersonalData != null ||
          oldUnifiedData != null;
    } catch (e) {
      print('Error checking migration status: $e');
      return false;
    }
  }

  @override
  Future<void> migrateIfNeeded() async {
    try {
      if (!await needsMigration()) {
        return; // No migration needed
      }

      print('Starting diary entries migration...');
      final migratedEntries = <DiaryEntry>[];

      // Migrate old AI entries
      await _migrateOldEntries(_oldAiKey, DiarySource.ai, migratedEntries);

      // Migrate old personal entries
      await _migrateOldEntries(
        _oldPersonalKey,
        DiarySource.personal,
        migratedEntries,
      );

      // Migrate old unified entries
      await _migrateOldUnifiedEntries(_oldUnifiedKey, migratedEntries);

      // Save migrated entries
      if (migratedEntries.isNotEmpty) {
        _cachedEntries = migratedEntries;
        await _writeToStorage();
        _entriesController.add(List.from(_cachedEntries));
        print(
          'Migration completed: ${migratedEntries.length} entries migrated',
        );
      }

      // Clean up old keys
      await _cleanupOldKeys();
    } catch (e) {
      print('Error during migration: $e');
      rethrow;
    }
  }

  /// Ensure cache is loaded from storage
  Future<void> _ensureCacheLoaded() async {
    if (_cachedEntries.isNotEmpty) return;

    try {
      final jsonString = _prefs.getString(_storageKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        _cachedEntries = jsonList
            .map(
              (json) => DiaryEntryDto.fromJson(
                json as Map<String, dynamic>,
              ).toDomain(),
            )
            .toList();
      } else {
        _cachedEntries = [];
      }
    } catch (e) {
      print('Error loading cached entries: $e');
      _cachedEntries = [];
    }
  }

  /// Debounced write to storage
  void _debounceWrite() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _writeToStorage();
    });
  }

  /// Write entries to storage
  Future<void> _writeToStorage() async {
    try {
      final jsonList = _cachedEntries
          .map((entry) => DiaryEntryDto.fromDomain(entry).toJson())
          .toList();
      await _prefs.setString(_storageKey, jsonEncode(jsonList));
    } catch (e) {
      print('Error writing to storage: $e');
      // Don't rethrow to avoid breaking the app
    }
  }

  /// Migrate old entries from a specific key
  Future<void> _migrateOldEntries(
    String key,
    DiarySource source,
    List<DiaryEntry> migratedEntries,
  ) async {
    try {
      final jsonString = _prefs.getString(key);
      if (jsonString == null || jsonString.isEmpty) return;

      final List<dynamic> jsonList = jsonDecode(jsonString);
      for (final json in jsonList) {
        try {
          final oldEntry = json as Map<String, dynamic>;
          final entry = _convertOldEntry(oldEntry, source);
          if (entry != null) {
            migratedEntries.add(entry);
          }
        } catch (e) {
          print('Error converting old entry: $e');
          continue;
        }
      }
    } catch (e) {
      print('Error migrating entries from $key: $e');
    }
  }

  /// Migrate old unified entries
  Future<void> _migrateOldUnifiedEntries(
    String key,
    List<DiaryEntry> migratedEntries,
  ) async {
    try {
      final jsonString = _prefs.getString(key);
      if (jsonString == null || jsonString.isEmpty) return;

      final List<dynamic> jsonList = jsonDecode(jsonString);
      for (final json in jsonList) {
        try {
          final oldEntry = json as Map<String, dynamic>;
          // Try to determine source from old data
          final source = _determineSourceFromOldEntry(oldEntry);
          final entry = _convertOldEntry(oldEntry, source);
          if (entry != null) {
            migratedEntries.add(entry);
          }
        } catch (e) {
          print('Error converting old unified entry: $e');
          continue;
        }
      }
    } catch (e) {
      print('Error migrating unified entries: $e');
    }
  }

  /// Convert old entry format to new DiaryEntry
  DiaryEntry? _convertOldEntry(
    Map<String, dynamic> oldEntry,
    DiarySource source,
  ) {
    try {
      final id = oldEntry['id'] as String? ?? _generateId();
      final text = oldEntry['text'] as String? ?? '';
      final dateString = oldEntry['date'] as String?;
      final emotionString = oldEntry['emotion'] as String?;

      if (text.isEmpty) return null;

      final date = dateString != null
          ? DateTime.tryParse(dateString) ?? DateTime.now()
          : DateTime.now();

      final emotion = emotionString != null
          ? EmotionMapper.fromString(emotionString)
          : null;

      return DiaryEntry(
        id: id,
        date: date,
        text: text,
        emotion: emotion,
        source: source,
      );
    } catch (e) {
      print('Error converting old entry: $e');
      return null;
    }
  }

  /// Determine source from old entry data
  DiarySource _determineSourceFromOldEntry(Map<String, dynamic> oldEntry) {
    final type = oldEntry['type'] as String?;
    if (type == 'ai') return DiarySource.ai;
    if (type == 'personal') return DiarySource.personal;

    // Default to personal for backward compatibility
    return DiarySource.personal;
  }

  /// Clean up old storage keys
  Future<void> _cleanupOldKeys() async {
    try {
      await _prefs.remove(_oldAiKey);
      await _prefs.remove(_oldPersonalKey);
      await _prefs.remove(_oldUnifiedKey);
    } catch (e) {
      print('Error cleaning up old keys: $e');
    }
  }

  /// Generate a new ID
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Dispose resources
  void dispose() {
    _debounceTimer?.cancel();
    _entriesController.close();
  }
}
