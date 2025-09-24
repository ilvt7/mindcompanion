import '../domain/emotion.dart';

/// Mapper for converting between emotion representations
class EmotionMapper {
  /// Map emotion ID to Emotion object
  static Emotion? fromId(String? emotionId) {
    if (emotionId == null || emotionId.isEmpty) return null;
    return Emotions.findById(emotionId);
  }

  /// Map emotion name to Emotion object
  static Emotion? fromName(String? emotionName) {
    if (emotionName == null || emotionName.isEmpty) return null;
    return Emotions.findByName(emotionName);
  }

  /// Map emotion string (could be ID or name) to Emotion object
  static Emotion? fromString(String? emotionString) {
    if (emotionString == null || emotionString.isEmpty) return null;
    
    // Try by ID first
    final byId = Emotions.findById(emotionString);
    if (byId != null) return byId;
    
    // Try by name
    return Emotions.findByName(emotionString);
  }

  /// Map emotion to string (returns ID)
  static String? toId(Emotion? emotion) {
    return emotion?.id;
  }

  /// Map emotion to display name
  static String toDisplayName(Emotion? emotion) {
    return emotion?.name ?? 'No emotion';
  }

  /// Map emotion to emoji
  static String toEmoji(Emotion? emotion) {
    return emotion?.emoji ?? '📝';
  }

  /// Map emotion to valence category
  static String toValenceCategory(Emotion? emotion) {
    return emotion?.valenceCategory ?? 'neutral';
  }

  /// Get all emotions by category
  static List<Emotion> getByCategory(String category) {
    return Emotions.getByValenceCategory(category);
  }

  /// Get emotions by valence range
  static List<Emotion> getByValenceRange(int minValence, int maxValence) {
    return Emotions.getByValenceRange(minValence, maxValence);
  }

  /// Get all predefined emotions
  static List<Emotion> getAll() {
    return List.from(Emotions.predefined);
  }

  /// Get positive emotions (valence > 0)
  static List<Emotion> getPositive() {
    return Emotions.getByValenceRange(1, 2);
  }

  /// Get negative emotions (valence < 0)
  static List<Emotion> getNegative() {
    return Emotions.getByValenceRange(-2, -1);
  }

  /// Get neutral emotions (valence = 0)
  static List<Emotion> getNeutral() {
    return Emotions.getByValenceRange(0, 0);
  }

  /// Validate emotion string
  static bool isValidEmotion(String? emotionString) {
    return fromString(emotionString) != null;
  }

  /// Get emotion statistics
  static Map<String, int> getEmotionStats(List<Emotion?> emotions) {
    final stats = <String, int>{};
    
    for (final emotion in emotions) {
      if (emotion != null) {
        final category = emotion.valenceCategory;
        stats[category] = (stats[category] ?? 0) + 1;
      }
    }
    
    return stats;
  }

  /// Get most common emotion category
  static String? getMostCommonCategory(List<Emotion?> emotions) {
    final stats = getEmotionStats(emotions);
    if (stats.isEmpty) return null;
    
    return stats.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  /// Get average valence
  static double getAverageValence(List<Emotion?> emotions) {
    final validEmotions = emotions.where((e) => e != null).cast<Emotion>();
    if (validEmotions.isEmpty) return 0.0;
    
    final sum = validEmotions.fold<int>(0, (sum, emotion) => sum + emotion.valence);
    return sum / validEmotions.length;
  }
}
