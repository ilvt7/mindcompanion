import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'screens/ai_diary_screen.dart';
import 'screens/personal_diary_screen.dart';
import 'screens/emotional_history_screen.dart';
import 'screens/meditation_screen.dart';
import 'screens/crisis_mode_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/privacy_policy_screen.dart';
import 'examples/crisis_transition_example.dart';
import 'examples/settings_transition_example.dart';
import 'widgets/transition_demo.dart';
import 'services/navigation_service.dart';
import 'data/diary_repository_provider.dart';
import 'core/notifications/notification_service.dart';
import 'core/accessibility/simple_accessibility_provider.dart';
import 'core/accessibility/high_contrast_provider.dart';
import 'core/accessibility/animation_provider.dart';
import 'core/theming/enhanced_theme_provider.dart';
import 'core/accessibility/navigation_shortcuts.dart';
import 'widgets/provider_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notification service
  try {
    await NotificationService().init();
  } catch (e) {
    print('Failed to initialize notifications: $e');
  }

  runApp(const MindCompanionApp());
}

class MindCompanionApp extends StatelessWidget {
  const MindCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SimpleAccessibilityProvider()),
        ChangeNotifierProvider(create: (_) => HighContrastProvider()),
        ChangeNotifierProvider(create: (_) => AnimationProvider()),
        ChangeNotifierProvider(create: (_) => EnhancedThemeProvider()),
      ],
      child: ProviderInitializer(
        child: Consumer2<SimpleAccessibilityProvider, EnhancedThemeProvider>(
          builder: (context, accessibilityProvider, themeProvider, child) {
            return DiaryRepositoryScope(
              child: MaterialApp(
                title: 'MindCompanion',
                initialRoute: '/welcome',
                theme: themeProvider.lightTheme,
                darkTheme: themeProvider.darkTheme,
                themeMode: themeProvider.materialThemeMode,
                shortcuts: NavigationShortcuts.shortcuts,
                actions: NavigationShortcuts.actions,
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaler: TextScaler.linear(
                        accessibilityProvider.textScale,
                      ),
                    ),
                    child: child!,
                  );
                },
                // Global page transitions theme - all platforms use FadeThroughTransition
                // pageTransitionsTheme: const PageTransitionsTheme(
                //   builders: {
                //     TargetPlatform.android: FadeThroughPageTransitionsBuilder(),
                //     TargetPlatform.iOS: FadeThroughPageTransitionsBuilder(),
                //     TargetPlatform.windows: FadeThroughPageTransitionsBuilder(),
                //     TargetPlatform.macOS: FadeThroughPageTransitionsBuilder(),
                //     TargetPlatform.linux: FadeThroughPageTransitionsBuilder(),
                //   },
                // ),
                // Implement FadeThroughTransition for all routes using NavigationService
                onGenerateRoute: (RouteSettings settings) {
                  return NavigationService.createFadeThroughRoute(
                    _buildPageForRoute(settings.name!),
                    transitionDuration: const Duration(milliseconds: 300),
                    reverseTransitionDuration: const Duration(
                      milliseconds: 300,
                    ),
                  );
                },
                // Keep routes for compatibility - they will use the global FadeThroughTransition
                routes: {
                  '/welcome': (context) => const WelcomeScreen(),
                  '/home': (context) => const HomeScreen(),
                  '/ai-diary': (context) => const AIDiaryScreen(),
                  '/personal-diary': (context) => const PersonalDiaryScreen(),
                  '/crisis': (context) => const CrisisModeScreen(),
                  '/history': (context) => const EmotionalHistoryScreen(),
                  '/emotional-history': (context) =>
                      const EmotionalHistoryScreen(),
                  '/meditations': (context) => const MeditationScreen(),
                  '/privacy-policy': (context) => const PrivacyPolicyScreen(),
                  '/settings': (context) => const SettingsScreen(),
                  '/transition-demo': (context) => const TransitionDemo(),
                  '/crisis-transition-demo': (context) =>
                      const CrisisTransitionExample(),
                  '/settings-transition-demo': (context) =>
                      const SettingsTransitionExample(),
                },
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper method to build pages for routes
  Widget _buildPageForRoute(String routeName) {
    switch (routeName) {
      case '/welcome':
        return const WelcomeScreen();
      case '/home':
        return const HomeScreen();
      case '/ai-diary':
        return const AIDiaryScreen();
      case '/personal-diary':
        return const PersonalDiaryScreen();
      case '/crisis':
        return const CrisisModeScreen();
      case '/history':
      case '/emotional-history':
        return const EmotionalHistoryScreen();
      case '/meditations':
        return const MeditationScreen();
      case '/privacy-policy':
        return const PrivacyPolicyScreen();
      case '/settings':
        return const SettingsScreen();
      case '/transition-demo':
        return const TransitionDemo();
      case '/crisis-transition-demo':
        return const CrisisTransitionExample();
      case '/settings-transition-demo':
        return const SettingsTransitionExample();
      default:
        return const WelcomeScreen();
    }
  }
}
