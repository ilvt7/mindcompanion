import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/accessibility/simple_accessibility_provider.dart';
import '../core/accessibility/high_contrast_provider.dart';
import '../core/accessibility/animation_provider.dart';
import '../core/accessibility/semantics_helper.dart';

/// Widget for simple accessibility settings (text scaling)
class SimpleAccessibilitySettingsWidget extends StatelessWidget {
  const SimpleAccessibilitySettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SimpleAccessibilityProvider>(
      builder: (context, accessibilityProvider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Icon(
                      Icons.accessibility_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Accesibilidad',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Text Scale Section
                Text(
                  'Tamaño del Texto',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Slider
                Slider(
                  value: accessibilityProvider.textScale,
                  min: 0.8,
                  max: 1.5,
                  divisions: 7, // 0.8, 0.9, 1.0, 1.1, 1.2, 1.3, 1.4, 1.5
                  onChanged: (value) {
                    accessibilityProvider.setTextScale(value);
                  },
                  activeColor: Theme.of(context).colorScheme.primary,
                  inactiveColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                ).asSemanticSlider(
                  label: 'Tamaño del Texto',
                  value: accessibilityProvider.textScale,
                  min: 0.8,
                  max: 1.5,
                  unit: 'x',
                  hint: 'Ajusta el tamaño del texto para mejorar la legibilidad',
                ),
                
                // Current value display
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '0.8x',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    Text(
                      accessibilityProvider.formattedTextScale,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      '1.5x',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Sample text
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Texto de ejemplo',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Este texto se actualiza automáticamente con el tamaño seleccionado. Es perfecto para probar cómo se verá el contenido en diferentes escalas.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // High Contrast Section
                const Divider(),
                const SizedBox(height: 16),
                
                Text(
                  'Alto Contraste',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                
                Consumer<HighContrastProvider>(
                  builder: (context, highContrastProvider, child) {
                    return SwitchListTile(
                      title: const Text('Modo Alto Contraste'),
                      subtitle: const Text('Mejora la legibilidad con colores más marcados'),
                      value: highContrastProvider.isHighContrast,
                      onChanged: (value) {
                        highContrastProvider.toggle();
                      },
                      contentPadding: EdgeInsets.zero,
                      activeColor: Theme.of(context).colorScheme.primary,
                    ).asSemanticSwitch(
                      label: 'Modo Alto Contraste',
                      value: highContrastProvider.isHighContrast,
                      hint: 'Activa o desactiva el modo de alto contraste para mejorar la legibilidad',
                    );
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Reduced Motion Section
                Text(
                  'Animaciones',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                
                Consumer<AnimationProvider>(
                  builder: (context, animationProvider, child) {
                    return SwitchListTile(
                      title: const Text('Reducir Animaciones'),
                      subtitle: const Text('Reduce los efectos visuales para usuarios sensibles'),
                      value: animationProvider.reduceMotion,
                      onChanged: (value) {
                        animationProvider.toggle();
                      },
                      contentPadding: EdgeInsets.zero,
                      activeColor: Theme.of(context).colorScheme.primary,
                    ).asSemanticSwitch(
                      label: 'Reducir Animaciones',
                      value: animationProvider.reduceMotion,
                      hint: 'Activa o desactiva la reducción de animaciones para usuarios sensibles a movimientos',
                    );
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Reset button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: accessibilityProvider.textScale != 1.0
                          ? () => accessibilityProvider.resetToDefault()
                          : null,
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: const Text('Restablecer'),
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.primary,
                      ),
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
}
