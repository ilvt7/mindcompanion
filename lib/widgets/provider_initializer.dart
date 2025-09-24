import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/accessibility/simple_accessibility_provider.dart';
import '../core/accessibility/high_contrast_provider.dart';
import '../core/accessibility/animation_provider.dart';
import '../core/theming/enhanced_theme_provider.dart';

/// Widget that initializes all providers
class ProviderInitializer extends StatefulWidget {
  final Widget child;
  
  const ProviderInitializer({
    super.key,
    required this.child,
  });

  @override
  State<ProviderInitializer> createState() => _ProviderInitializerState();
}

class _ProviderInitializerState extends State<ProviderInitializer> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeProviders();
  }

  Future<void> _initializeProviders() async {
    try {
      final accessibilityProvider = Provider.of<SimpleAccessibilityProvider>(context, listen: false);
      final highContrastProvider = Provider.of<HighContrastProvider>(context, listen: false);
      final animationProvider = Provider.of<AnimationProvider>(context, listen: false);
      final themeProvider = Provider.of<EnhancedThemeProvider>(context, listen: false);

      // Initialize providers
      await accessibilityProvider.init();
      await highContrastProvider.init();
      await animationProvider.init();
      await themeProvider.init(highContrastProvider);

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      print('Error initializing providers: $e');
      if (mounted) {
        setState(() {
          _isInitialized = true; // Continue anyway
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return widget.child;
  }
}
