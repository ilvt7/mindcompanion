import 'diary_entry.dart';

/// Repository interface for diary entries
abstract class DiaryRepository {
  /// Save or update a diary entry
  Future<void> upsertEntry(DiaryEntry entry);

  /// Get all diary entries
  Future<List<DiaryEntry>> getEntries({
    DateTime? from,
    DateTime? to,
    DiarySource? source,
  });

  /// Get a specific diary entry by ID
  Future<DiaryEntry?> getEntry(String id);

  /// Delete a diary entry by ID
  Future<void> deleteEntry(String id);

  /// Watch all diary entries as a stream
  Stream<List<DiaryEntry>> watchAll();

  /// Watch diary entries with filters as a stream
  Stream<List<DiaryEntry>> watchEntries({
    DateTime? from,
    DateTime? to,
    DiarySource? source,
  });

  /// Get entries for a specific date
  Future<List<DiaryEntry>> getEntriesForDate(DateTime date);

  /// Get entries for a date range
  Future<List<DiaryEntry>> getEntriesForDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  /// Get entries by source (AI or Personal)
  Future<List<DiaryEntry>> getEntriesBySource(DiarySource source);

  /// Get recent entries (last N entries)
  Future<List<DiaryEntry>> getRecentEntries(int count);

  /// Get entry count
  Future<int> getEntryCount();

  /// Clear all entries
  Future<void> clearAllEntries();

  /// Check if repository needs migration
  Future<bool> needsMigration();

  /// Perform migration if needed
  Future<void> migrateIfNeeded();
}
