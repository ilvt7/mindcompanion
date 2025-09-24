import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/accessibility/accessibility_provider.dart';
import '../core/theming/theme_provider.dart';
import '../core/theming/text_scale_provider.dart';

/// Widget for theme selection settings
class ThemeSelectionWidget extends StatelessWidget {
  const ThemeSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AccessibilityProvider>(
      builder: (context, accessibilityProvider, child) {
        final themeProvider = accessibilityProvider.themeProvider;
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.palette_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Theme',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...AppThemeMode.values.map((mode) {
                  return RadioListTile<AppThemeMode>(
                    title: Text(themeProvider.getThemeModeDisplayName(mode)),
                    subtitle: Text(themeProvider.getThemeModeDescription(mode)),
                    value: mode,
                    groupValue: themeProvider.themeMode,
                    onChanged: (AppThemeMode? value) {
                      if (value != null) {
                        themeProvider.setThemeMode(value);
                      }
                    },
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Widget for text scale settings
class TextScaleSettingsWidget extends StatelessWidget {
  const TextScaleSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AccessibilityProvider>(
      builder: (context, accessibilityProvider, child) {
        final textScaleProvider = accessibilityProvider.textScaleProvider;
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.text_fields_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Text Size',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    IconButton(
                      onPressed: textScaleProvider.isAtMinimum
                          ? null
                          : () => textScaleProvider.decreaseTextScale(),
                      icon: const Icon(Icons.remove),
                    ),
                    Expanded(
                      child: Slider(
                        value: textScaleProvider.textScaleFactor,
                        min: textScaleProvider.minScale,
                        max: textScaleProvider.maxScale,
                        divisions: ((textScaleProvider.maxScale - textScaleProvider.minScale) / textScaleProvider.step).round(),
                        onChanged: (value) {
                          textScaleProvider.setTextScaleFactor(value);
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: textScaleProvider.isAtMaximum
                          ? null
                          : () => textScaleProvider.increaseTextScale(),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    textScaleProvider.textScaleDescription,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildPresetButton(
                      context,
                      'Small',
                      0.8,
                      textScaleProvider,
                    ),
                    _buildPresetButton(
                      context,
                      'Normal',
                      1.0,
                      textScaleProvider,
                    ),
                    _buildPresetButton(
                      context,
                      'Large',
                      1.2,
                      textScaleProvider,
                    ),
                    _buildPresetButton(
                      context,
                      'Huge',
                      1.5,
                      textScaleProvider,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPresetButton(
    BuildContext context,
    String label,
    double value,
    TextScaleProvider textScaleProvider,
  ) {
    final isSelected = (textScaleProvider.textScaleFactor - value).abs() < 0.1;
    
    return OutlinedButton(
      onPressed: () => textScaleProvider.setTextScaleFactor(value),
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected
            ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
            : null,
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface,
          fontSize: 12,
        ),
      ),
    );
  }
}

/// Widget for TTS settings
class TTSSettingsWidget extends StatelessWidget {
  const TTSSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AccessibilityProvider>(
      builder: (context, accessibilityProvider, child) {
        final ttsService = accessibilityProvider.ttsService;
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.volume_up_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Text-to-Speech',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Enable TTS'),
                  subtitle: const Text('Read diary entries aloud'),
                  value: ttsService.isEnabled,
                  onChanged: (value) {
                    ttsService.setEnabled(value);
                  },
                ),
                if (ttsService.isEnabled) ...[
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    'Language',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  DropdownButton<String>(
                    value: ttsService.language,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: 'en-US', child: Text('English')),
                      DropdownMenuItem(value: 'es-ES', child: Text('Spanish')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        ttsService.setLanguage(value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Speech Rate',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Slider(
                    value: ttsService.speechRate,
                    min: 0.1,
                    max: 1.0,
                    divisions: 9,
                    onChanged: (value) {
                      ttsService.setSpeechRate(value);
                    },
                  ),
                  Text(
                    '${(ttsService.speechRate * 100).round()}%',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Volume',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Slider(
                    value: ttsService.volume,
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    onChanged: (value) {
                      ttsService.setVolume(value);
                    },
                  ),
                  Text(
                    '${(ttsService.volume * 100).round()}%',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Pitch',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Slider(
                    value: ttsService.pitch,
                    min: 0.5,
                    max: 2.0,
                    divisions: 15,
                    onChanged: (value) {
                      ttsService.setPitch(value);
                    },
                  ),
                  Text(
                    '${ttsService.pitch.toStringAsFixed(1)}x',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Combined accessibility settings widget
class AccessibilitySettingsWidget extends StatelessWidget {
  const AccessibilitySettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ThemeSelectionWidget(),
        SizedBox(height: 16),
        TextScaleSettingsWidget(),
        SizedBox(height: 16),
        TTSSettingsWidget(),
      ],
    );
  }
}