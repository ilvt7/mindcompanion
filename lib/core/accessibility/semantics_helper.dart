import 'package:flutter/material.dart';

/// Helper class for creating accessible semantic labels and tooltips
class SemanticsHelper {
  /// Create semantic label for diary entry with context
  static String diaryEntryLabel(String text, {bool isListening = false}) {
    final preview = text.length > 20 ? '${text.substring(0, 20)}...' : text;
    final action = isListening ? 'Detener reproducción' : 'Escuchar entrada del diario';
    return '$action: $preview';
  }

  /// Create semantic label for emotion emoji
  static String emotionLabel(String emoji) {
    switch (emoji) {
      case '😊':
      case '😄':
      case '😃':
      case '😁':
      case '🤗':
        return 'Emoción feliz';
      case '😢':
      case '😭':
      case '😔':
      case '😞':
      case '😟':
        return 'Emoción triste';
      case '😐':
      case '😑':
      case '😶':
      case '🤐':
        return 'Emoción neutra';
      case '😡':
      case '😠':
      case '🤬':
      case '😤':
        return 'Emoción enojada';
      case '😨':
      case '😰':
      case '😱':
      case '😳':
        return 'Emoción asustada';
      case '😍':
      case '🥰':
      case '😘':
      case '😗':
        return 'Emoción enamorada';
      case '🤔':
      case '😕':
      case '😖':
      case '😣':
        return 'Emoción confundida';
      default:
        return 'Emoción: $emoji';
    }
  }

  /// Create semantic label for TTS button
  static String ttsButtonLabel(String text, {bool isSpeaking = false}) {
    final preview = text.length > 20 ? '${text.substring(0, 20)}...' : text;
    if (isSpeaking) {
      return 'Detener reproducción de: $preview';
    } else {
      return 'Reproducir en voz alta: $preview';
    }
  }

  /// Create semantic label for slider with value and range
  static String sliderLabel(String label, double value, double min, double max, {String? unit}) {
    final unitText = unit ?? '';
    return '$label: ${value.toStringAsFixed(1)}$unitText (rango: ${min.toStringAsFixed(1)}$unitText - ${max.toStringAsFixed(1)}$unitText)';
  }

  /// Create semantic label for switch/toggle
  static String switchLabel(String label, bool isEnabled) {
    return '$label: ${isEnabled ? 'activado' : 'desactivado'}';
  }

  /// Create semantic label for navigation button
  static String navigationLabel(String destination, {String? description}) {
    if (description != null) {
      return 'Ir a $destination: $description';
    }
    return 'Ir a $destination';
  }

  /// Create semantic label for action button
  static String actionLabel(String action, {String? context}) {
    if (context != null) {
      return '$action: $context';
    }
    return action;
  }

  /// Create semantic label for card with content preview
  static String cardLabel(String title, {String? subtitle, String? content}) {
    if (content != null && content.isNotEmpty) {
      final preview = content.length > 30 ? '${content.substring(0, 30)}...' : content;
      return '$title: $preview';
    }
    if (subtitle != null) {
      return '$title: $subtitle';
    }
    return title;
  }

  /// Create semantic label for date/time
  static String dateLabel(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return 'Hoy, ${_formatTime(date)}';
    } else if (difference == 1) {
      return 'Ayer, ${_formatTime(date)}';
    } else if (difference < 7) {
      return 'Hace $difference días, ${_formatTime(date)}';
    } else {
      return '${_formatDate(date)}, ${_formatTime(date)}';
    }
  }

  /// Create semantic label for progress indicator
  static String progressLabel(int current, int total, {String? context}) {
    final percentage = ((current / total) * 100).round();
    if (context != null) {
      return '$context: $current de $total ($percentage%)';
    }
    return 'Progreso: $current de $total ($percentage%)';
  }

  /// Create semantic label for status indicator
  static String statusLabel(String status, {String? context}) {
    if (context != null) {
      return '$context: $status';
    }
    return 'Estado: $status';
  }

  /// Helper method to format time
  static String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Helper method to format date
  static String _formatDate(DateTime date) {
    final months = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];
    return '${date.day} de ${months[date.month - 1]} de ${date.year}';
  }
}

/// Extension for adding semantic properties to widgets
extension SemanticWidgetExtension on Widget {
  /// Add semantic label to widget
  Widget withSemanticLabel(String label, {String? hint}) {
    return Semantics(
      label: label,
      hint: hint,
      child: this,
    );
  }

  /// Add semantic button properties
  Widget asSemanticButton(String label, {String? hint, VoidCallback? onTap}) {
    return Semantics(
      label: label,
      hint: hint,
      button: true,
      onTap: onTap,
      child: this,
    );
  }

  /// Add semantic slider properties
  Widget asSemanticSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    String? hint,
    String? unit,
  }) {
    return Semantics(
      label: SemanticsHelper.sliderLabel(label, value, min, max, unit: unit),
      hint: hint,
      slider: true,
      value: value.toString(),
      child: this,
    );
  }

  /// Add semantic switch properties
  Widget asSemanticSwitch({
    required String label,
    required bool value,
    String? hint,
  }) {
    return Semantics(
      label: SemanticsHelper.switchLabel(label, value),
      hint: hint,
      toggled: value,
      child: this,
    );
  }
}
