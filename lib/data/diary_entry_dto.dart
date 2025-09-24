import '../domain/diary_entry.dart';
import '../domain/emotion.dart';

/// Data Transfer Object for DiaryEntry
class DiaryEntryDto {
  final String id;
  final String date; // ISO 8601 string
  final String text;
  final EmotionDto? emotion;
  final String source; // 'ai' or 'personal'

  const DiaryEntryDto({
    required this.id,
    required this.date,
    required this.text,
    this.emotion,
    required this.source,
  });

  /// Convert from domain model
  factory DiaryEntryDto.fromDomain(DiaryEntry entry) {
    return DiaryEntryDto(
      id: entry.id,
      date: entry.date.toIso8601String(),
      text: entry.text,
      emotion: entry.emotion != null ? EmotionDto.fromDomain(entry.emotion!) : null,
      source: entry.source.name,
    );
  }

  /// Convert to domain model
  DiaryEntry toDomain() {
    return DiaryEntry(
      id: id,
      date: DateTime.parse(date),
      text: text,
      emotion: emotion?.toDomain(),
      source: DiarySource.values.firstWhere(
        (s) => s.name == source,
        orElse: () => DiarySource.personal,
      ),
    );
  }

  /// Convert from JSON
  factory DiaryEntryDto.fromJson(Map<String, dynamic> json) {
    return DiaryEntryDto(
      id: json['id'] as String,
      date: json['date'] as String,
      text: json['text'] as String,
      emotion: json['emotion'] != null 
          ? EmotionDto.fromJson(json['emotion'] as Map<String, dynamic>)
          : null,
      source: json['source'] as String,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'text': text,
      'emotion': emotion?.toJson(),
      'source': source,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DiaryEntryDto &&
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
    return 'DiaryEntryDto(id: $id, date: $date, text: $text, emotion: $emotion, source: $source)';
  }
}

/// Data Transfer Object for Emotion
class EmotionDto {
  final String id;
  final String name;
  final String emoji;
  final int valence;

  const EmotionDto({
    required this.id,
    required this.name,
    required this.emoji,
    required this.valence,
  });

  /// Convert from domain model
  factory EmotionDto.fromDomain(Emotion emotion) {
    return EmotionDto(
      id: emotion.id,
      name: emotion.name,
      emoji: emotion.emoji,
      valence: emotion.valence,
    );
  }

  /// Convert to domain model
  Emotion toDomain() {
    return Emotion(
      id: id,
      name: name,
      emoji: emoji,
      valence: valence,
    );
  }

  /// Convert from JSON
  factory EmotionDto.fromJson(Map<String, dynamic> json) {
    return EmotionDto(
      id: json['id'] as String,
      name: json['name'] as String,
      emoji: json['emoji'] as String,
      valence: json['valence'] as int,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'emoji': emoji,
      'valence': valence,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EmotionDto &&
        other.id == id &&
        other.name == name &&
        other.emoji == emoji &&
        other.valence == valence;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        emoji.hashCode ^
        valence.hashCode;
  }

  @override
  String toString() {
    return 'EmotionDto(id: $id, name: $name, emoji: $emoji, valence: $valence)';
  }
}
