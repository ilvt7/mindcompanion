import 'emotion.dart';

/// Source of diary entry (AI-generated or personal)
enum DiarySource {
  ai,
  personal,
}

/// Domain model for diary entries
class DiaryEntry {
  final String id;
  final DateTime date;
  final String text;
  final Emotion? emotion;
  final DiarySource source;

  const DiaryEntry({
    required this.id,
    required this.date,
    required this.text,
    this.emotion,
    required this.source,
  });

  /// Create a copy with updated fields
  DiaryEntry copyWith({
    String? id,
    DateTime? date,
    String? text,
    Emotion? emotion,
    DiarySource? source,
  }) {
    return DiaryEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      text: text ?? this.text,
      emotion: emotion ?? this.emotion,
      source: source ?? this.source,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DiaryEntry &&
        other.id == id &&
        other.date == date &&
        other.text == text &&
        other.emotion == emotion &&
        other.source == source;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        date.hashCode ^
        text.hashCode ^
        emotion.hashCode ^
        source.hashCode;
  }

  @override
  String toString() {
    return 'DiaryEntry(id: $id, date: $date, text: $text, emotion: $emotion, source: $source)';
  }

  /// Check if entry has emotion data
  bool get hasEmotion => emotion != null;

  /// Get emotion emoji or default
  String get emotionEmoji => emotion?.emoji ?? '📝';

  /// Get emotion name or default
  String get emotionName => emotion?.name ?? 'No emotion';

  /// Get source display name
  String get sourceDisplayName {
    switch (source) {
      case DiarySource.ai:
        return 'AI Diary';
      case DiarySource.personal:
        return 'Personal Diary';
    }
  }

  /// Get source emoji
  String get sourceEmoji {
    switch (source) {
      case DiarySource.ai:
        return '🤖';
      case DiarySource.personal:
        return '📝';
    }
  }

  /// Check if entry is from today
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if entry is from yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Get relative date string
  String get relativeDateString {
    if (isToday) return 'Today';
    if (isYesterday) return 'Yesterday';
    
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference < 7) {
      return '$difference days ago';
    } else if (difference < 30) {
      final weeks = (difference / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else if (difference < 365) {
      final months = (difference / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else {
      final years = (difference / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    }
  }

  /// Validate entry data
  bool get isValid {
    return id.isNotEmpty &&
        text.isNotEmpty &&
        text.trim().length > 0 &&
        (emotion == null || emotion!.isValidValence);
  }
}
