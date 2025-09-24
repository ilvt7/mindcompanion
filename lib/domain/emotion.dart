/// Domain model for emotions with valence scoring
class Emotion {
  final String id;
  final String name;
  final String emoji;
  final int valence; // -2 (very negative) to +2 (very positive)

  const Emotion({
    required this.id,
    required this.name,
    required this.emoji,
    required this.valence,
  });

  /// Create a copy with updated fields
  Emotion copyWith({
    String? id,
    String? name,
    String? emoji,
    int? valence,
  }) {
    return Emotion(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      valence: valence ?? this.valence,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Emotion &&
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
    return 'Emotion(id: $id, name: $name, emoji: $emoji, valence: $valence)';
  }

  /// Validate valence is within acceptable range
  bool get isValidValence => valence >= -2 && valence <= 2;

  /// Get valence category
  String get valenceCategory {
    if (valence <= -1) return 'negative';
    if (valence == 0) return 'neutral';
    return 'positive';
  }
}

/// Predefined emotions with their characteristics
class Emotions {
  static const List<Emotion> predefined = [
    // Very Negative (-2)
    Emotion(id: 'angry', name: 'Angry', emoji: '😠', valence: -2),
    Emotion(id: 'devastated', name: 'Devastated', emoji: '💔', valence: -2),
    
    // Negative (-1)
    Emotion(id: 'sad', name: 'Sad', emoji: '😢', valence: -1),
    Emotion(id: 'anxious', name: 'Anxious', emoji: '😰', valence: -1),
    Emotion(id: 'frustrated', name: 'Frustrated', emoji: '😤', valence: -1),
    Emotion(id: 'worried', name: 'Worried', emoji: '😟', valence: -1),
    Emotion(id: 'tired', name: 'Tired', emoji: '😴', valence: -1),
    
    // Neutral (0)
    Emotion(id: 'neutral', name: 'Neutral', emoji: '😐', valence: 0),
    Emotion(id: 'confused', name: 'Confused', emoji: '😕', valence: 0),
    Emotion(id: 'contemplative', name: 'Contemplative', emoji: '🤔', valence: 0),
    
    // Positive (+1)
    Emotion(id: 'calm', name: 'Calm', emoji: '😌', valence: 1),
    Emotion(id: 'content', name: 'Content', emoji: '😊', valence: 1),
    Emotion(id: 'hopeful', name: 'Hopeful', emoji: '🤗', valence: 1),
    Emotion(id: 'grateful', name: 'Grateful', emoji: '🙏', valence: 1),
    
    // Very Positive (+2)
    Emotion(id: 'happy', name: 'Happy', emoji: '😄', valence: 2),
    Emotion(id: 'excited', name: 'Excited', emoji: '🤩', valence: 2),
    Emotion(id: 'joyful', name: 'Joyful', emoji: '🥳', valence: 2),
    Emotion(id: 'euphoric', name: 'Euphoric', emoji: '✨', valence: 2),
  ];

  /// Find emotion by ID
  static Emotion? findById(String id) {
    try {
      return predefined.firstWhere((emotion) => emotion.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Find emotion by name (case insensitive)
  static Emotion? findByName(String name) {
    try {
      return predefined.firstWhere(
        (emotion) => emotion.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Get emotions by valence category
  static List<Emotion> getByValenceCategory(String category) {
    return predefined.where((emotion) => emotion.valenceCategory == category).toList();
  }

  /// Get emotions by valence range
  static List<Emotion> getByValenceRange(int minValence, int maxValence) {
    return predefined.where(
      (emotion) => emotion.valence >= minValence && emotion.valence <= maxValence,
    ).toList();
  }
}
