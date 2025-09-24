import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/accessibility/accessibility_provider.dart';

/// A reusable TTS button widget for reading text aloud
class TTSButton extends StatefulWidget {
  final String text;
  final String? label;
  final IconData? icon;
  final Color? color;
  final double? size;
  final EdgeInsets? padding;
  final bool showLabel;
  final bool enabled;

  const TTSButton({
    super.key,
    required this.text,
    this.label,
    this.icon,
    this.color,
    this.size,
    this.padding,
    this.showLabel = true,
    this.enabled = true,
  });

  @override
  State<TTSButton> createState() => _TTSButtonState();
}

class _TTSButtonState extends State<TTSButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _speakText() async {
    if (!widget.enabled || widget.text.isEmpty) return;

    final accessibilityProvider = Provider.of<AccessibilityProvider>(
      context,
      listen: false,
    );

    if (!accessibilityProvider.isInitialized) return;

    try {
      _animationController.forward();
      
      if (accessibilityProvider.ttsService.isSpeaking) {
        // Stop if already speaking
        await accessibilityProvider.ttsService.stop();
        setState(() {
          _isSpeaking = false;
        });
      } else {
        // Start speaking
        setState(() {
          _isSpeaking = true;
        });
        await accessibilityProvider.ttsService.speak(widget.text);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error reading text: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        _animationController.reverse();
        setState(() {
          _isSpeaking = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = widget.color ?? theme.colorScheme.primary;
    final size = widget.size ?? 24.0;
    final padding = widget.padding ?? const EdgeInsets.all(8.0);

    return Consumer<AccessibilityProvider>(
      builder: (context, accessibilityProvider, child) {
        final isTTSEnabled = accessibilityProvider.isInitialized &&
            accessibilityProvider.ttsService.isEnabled;

        if (!isTTSEnabled) {
          return const SizedBox.shrink();
        }

        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3 * _glowAnimation.value),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _isSpeaking ? null : _speakText,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: padding,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isSpeaking 
                                ? Icons.stop_rounded
                                : (widget.icon ?? Icons.volume_up_rounded),
                            color: _isSpeaking
                                ? color.withOpacity(0.6)
                                : color,
                            size: size,
                          ),
                          if (widget.showLabel) ...[
                            const SizedBox(width: 4),
                            Text(
                              _isSpeaking ? "Stop" : (widget.label ?? "Listen"),
                              style: TextStyle(
                                color: _isSpeaking
                                    ? color.withOpacity(0.6)
                                    : color,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// A compact TTS button for use in app bars or small spaces
class CompactTTSButton extends StatelessWidget {
  final String text;
  final Color? color;
  final double? size;

  const CompactTTSButton({
    super.key,
    required this.text,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return TTSButton(
      text: text,
      color: color,
      size: size ?? 20.0,
      padding: const EdgeInsets.all(4.0),
      showLabel: false,
    );
  }
}

/// A TTS button with a custom label
class LabeledTTSButton extends StatelessWidget {
  final String text;
  final String label;
  final Color? color;
  final double? size;

  const LabeledTTSButton({
    super.key,
    required this.text,
    required this.label,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return TTSButton(
      text: text,
      label: label,
      color: color,
      size: size ?? 20.0,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      showLabel: true,
    );
  }
}