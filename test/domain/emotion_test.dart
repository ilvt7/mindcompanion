import 'package:flutter_test/flutter_test.dart';
import 'package:mindcompanion/domain/emotion.dart';

void main() {
  group('Emotion Domain Model Tests', () {
    test('should create emotion with valid data', () {
      const emotion = Emotion(
        id: 'happy',
        name: 'Happy',
        emoji: '😄',
        valence: 2,
      );

      expect(emotion.id, 'happy');
      expect(emotion.name, 'Happy');
      expect(emotion.emoji, '😄');
      expect(emotion.valence, 2);
    });

    test('should validate valence range', () {
      const validEmotion = Emotion(
        id: 'happy',
        name: 'Happy',
        emoji: '😄',
        valence: 2,
      );

      const invalidEmotion = Emotion(
        id: 'invalid',
        name: 'Invalid',
        emoji: '❌',
        valence: 5,
      );

      expect(validEmotion.isValidValence, true);
      expect(invalidEmotion.isValidValence, false);
    });

    test('should return correct valence category', () {
      const negativeEmotion = Emotion(
        id: 'sad',
        name: 'Sad',
        emoji: '😢',
        valence: -1,
      );

      const neutralEmotion = Emotion(
        id: 'neutral',
        name: 'Neutral',
        emoji: '😐',
        valence: 0,
      );

      const positiveEmotion = Emotion(
        id: 'happy',
        name: 'Happy',
        emoji: '😄',
        valence: 2,
      );

      expect(negativeEmotion.valenceCategory, 'negative');
      expect(neutralEmotion.valenceCategory, 'neutral');
      expect(positiveEmotion.valenceCategory, 'positive');
    });

    test('should support copyWith', () {
      const original = Emotion(
        id: 'happy',
        name: 'Happy',
        emoji: '😄',
        valence: 2,
      );

      final updated = original.copyWith(name: 'Very Happy', valence: 1);

      expect(updated.id, 'happy');
      expect(updated.name, 'Very Happy');
      expect(updated.emoji, '😄');
      expect(updated.valence, 1);
    });

    test('should support equality', () {
      const emotion1 = Emotion(
        id: 'happy',
        name: 'Happy',
        emoji: '😄',
        valence: 2,
      );

      const emotion2 = Emotion(
        id: 'happy',
        name: 'Happy',
        emoji: '😄',
        valence: 2,
      );

      const emotion3 = Emotion(
        id: 'sad',
        name: 'Sad',
        emoji: '😢',
        valence: -1,
      );

      expect(emotion1, equals(emotion2));
      expect(emotion1, isNot(equals(emotion3)));
    });
  });

  group('Emotions Predefined Tests', () {
    test('should have predefined emotions', () {
      expect(Emotions.predefined.isNotEmpty, true);
      expect(Emotions.predefined.length, greaterThan(10));
    });

    test('should find emotion by ID', () {
      final emotion = Emotions.findById('happy');
      expect(emotion, isNotNull);
      expect(emotion!.id, 'happy');
      expect(emotion.name, 'Happy');
    });

    test('should find emotion by name', () {
      final emotion = Emotions.findByName('Happy');
      expect(emotion, isNotNull);
      expect(emotion!.id, 'happy');
      expect(emotion.name, 'Happy');
    });

    test('should return null for non-existent emotion', () {
      final emotion = Emotions.findById('nonexistent');
      expect(emotion, isNull);
    });

    test('should get emotions by valence category', () {
      final positiveEmotions = Emotions.getByValenceCategory('positive');
      final negativeEmotions = Emotions.getByValenceCategory('negative');
      final neutralEmotions = Emotions.getByValenceCategory('neutral');

      expect(positiveEmotions.isNotEmpty, true);
      expect(negativeEmotions.isNotEmpty, true);
      expect(neutralEmotions.isNotEmpty, true);

      for (final emotion in positiveEmotions) {
        expect(emotion.valence, greaterThan(0));
      }

      for (final emotion in negativeEmotions) {
        expect(emotion.valence, lessThan(0));
      }

      for (final emotion in neutralEmotions) {
        expect(emotion.valence, equals(0));
      }
    });

    test('should get emotions by valence range', () {
      final veryPositiveEmotions = Emotions.getByValenceRange(2, 2);
      final negativeEmotions = Emotions.getByValenceRange(-2, -1);

      expect(veryPositiveEmotions.isNotEmpty, true);
      expect(negativeEmotions.isNotEmpty, true);

      for (final emotion in veryPositiveEmotions) {
        expect(emotion.valence, equals(2));
      }

      for (final emotion in negativeEmotions) {
        expect(emotion.valence, lessThan(0));
      }
    });
  });
}
