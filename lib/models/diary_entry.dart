class DiaryEntry {
  final String id;
  final String text;
  final DateTime date;
  final String? emotion; // null for personal diary entries
  final String type; // 'ai' or 'personal'

  DiaryEntry({
    required this.id,
    required this.text,
    required this.date,
    this.emotion,
    required this.type,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'date': date.toIso8601String(),
      'emotion': emotion,
      'type': type,
    };
  }

  // Create from JSON
  factory DiaryEntry.fromJson(Map<String, dynamic> json) {
    return DiaryEntry(
      id: json['id'],
      text: json['text'],
      date: DateTime.parse(json['date']),
      emotion: json['emotion'],
      type: json['type'],
    );
  }

  // Create AI Diary entry
  factory DiaryEntry.createAIEntry({
    required String text,
    required String emotion,
    required DateTime date,
  }) {
    return DiaryEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      date: date,
      emotion: emotion,
      type: 'ai',
    );
  }

  // Create Personal Diary entry
  factory DiaryEntry.createPersonalEntry({
    required String text,
    required DateTime date,
  }) {
    return DiaryEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      date: date,
      emotion: null,
      type: 'personal',
    );
  }

  // Get display text for emotion
  String get emotionDisplay {
    if (emotion == null) return 'Personal';
    return emotion!;
  }

  // Get emoji for emotion
  String get emotionEmoji {
    if (emotion == null) return '📝';
    
    switch (emotion!.toLowerCase()) {
      case 'happy':
      case 'joy':
        return '😊';
      case 'sad':
      case 'sadness':
        return '😢';
      case 'angry':
      case 'anger':
        return '😠';
      case 'anxious':
      case 'anxiety':
        return '😰';
      case 'excited':
        return '🤩';
      case 'calm':
      case 'peaceful':
        return '😌';
      case 'confused':
        return '😕';
      case 'grateful':
        return '🙏';
      default:
        return '😐';
    }
  }
}
