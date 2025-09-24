import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mindcompanion/core/accessibility/simple_accessibility_provider.dart';
import 'package:mindcompanion/core/accessibility/high_contrast_provider.dart';
import 'package:mindcompanion/core/accessibility/animation_provider.dart';
import 'package:mindcompanion/core/theming/enhanced_theme_provider.dart';
import 'package:mindcompanion/data/diary_repository_provider.dart';
import 'package:mindcompanion/data/shared_prefs_diary_repository.dart';

/// Helper class for testing with all providers properly initialized
class TestHelpers {
  /// Espera hasta que un [finder] encuentre al menos un widget en el árbol.
  /// Lanza un [TestFailure] si el widget no aparece dentro del timeout.
  static Future<void> pumpUntilFound(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 10),
    Duration interval = const Duration(milliseconds: 100),
  }) async {
    final endTime = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(endTime)) {
      await tester.pump(interval);
      if (finder.evaluate().isNotEmpty) {
        return; // encontrado
      }
    }
    throw TestFailure(
      '⏱️ pumpUntilFound: El widget nunca apareció dentro de $timeout\nFinder: $finder',
    );
  }

  /// Espera hasta que un [finder] desaparezca completamente del árbol.
  /// Lanza un [TestFailure] si el widget sigue presente al expirar el timeout.
  static Future<void> pumpUntilGone(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 10),
    Duration interval = const Duration(milliseconds: 100),
  }) async {
    final endTime = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(endTime)) {
      await tester.pump(interval);
      if (finder.evaluate().isEmpty) {
        return; // desaparecido
      }
    }
    throw TestFailure(
      '⏱️ pumpUntilGone: El widget nunca desapareció dentro de $timeout\nFinder: $finder',
    );
  }
  /// Pumps a widget with all necessary providers initialized
  static Future<void> pumpAppWithProviders(
    WidgetTester tester,
    Widget child, {
    List<ChangeNotifierProvider>? additionalProviders,
    bool initializeProviders = true,
  }) async {
    // Mock SharedPreferences for testing
    SharedPreferences.setMockInitialValues({});
    
    final providers = <ChangeNotifierProvider<dynamic>>[
      ChangeNotifierProvider<SimpleAccessibilityProvider>(create: (_) => SimpleAccessibilityProvider()),
      ChangeNotifierProvider<HighContrastProvider>(create: (_) => HighContrastProvider()),
      ChangeNotifierProvider<AnimationProvider>(create: (_) => AnimationProvider()),
      ChangeNotifierProvider<EnhancedThemeProvider>(create: (_) => EnhancedThemeProvider()),
      if (additionalProviders != null) ...additionalProviders,
    ];

    await tester.pumpWidget(
      MultiProvider(
        providers: providers,
        child: Consumer2<SimpleAccessibilityProvider, EnhancedThemeProvider>(
          builder: (context, accessibilityProvider, themeProvider, _) {
            return MaterialApp(
              title: 'MindCompanion Test',
              theme: themeProvider.lightTheme,
              darkTheme: themeProvider.darkTheme,
              themeMode: themeProvider.materialThemeMode,
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaleFactor: accessibilityProvider.textScale,
                  ),
                  child: child!,
                );
              },
              home: child,
            );
          },
        ),
      ),
    );

    // Ensure first frames build so MaterialApp exists in the tree
    await tester.pump();
    // Retry until present (up to ~10 seconds)
    final materialAppFinder = find.byType(MaterialApp);
    int safetyPumps = 0;
    while (materialAppFinder.evaluate().isEmpty && safetyPumps < 100) {
      await tester.pump(const Duration(milliseconds: 100));
      safetyPumps++;
    }
    if (materialAppFinder.evaluate().isEmpty) {
      throw TestFailure('MaterialApp no apareció tras espera en pumpAppWithProviders');
    }
    final element = tester.element(materialAppFinder.first);

    // Initialize providers if requested
    if (initializeProviders) {
      final accessibilityProvider = Provider.of<SimpleAccessibilityProvider>(
        element,
        listen: false,
      );
      final highContrastProvider = Provider.of<HighContrastProvider>(
        element,
        listen: false,
      );
      final animationProvider = Provider.of<AnimationProvider>(
        element,
        listen: false,
      );
      final themeProvider = Provider.of<EnhancedThemeProvider>(
        element,
        listen: false,
      );
      
      await accessibilityProvider.init();
      await highContrastProvider.init();
      await animationProvider.init();
      await themeProvider.init(highContrastProvider);
      // Pumps temporizados para evitar cuelgues por animaciones infinitas
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));
    }
  }

  /// Pumps a widget with minimal providers for simple tests
  static Future<void> pumpAppWithMinimalProviders(
    WidgetTester tester,
    Widget child,
  ) async {
    SharedPreferences.setMockInitialValues({});
    
    await tester.pumpWidget(
      MaterialApp(
        title: 'MindCompanion Test',
        home: child,
      ),
    );
  }

  /// Pumps a widget with theme provider only
  static Future<void> pumpAppWithThemeProvider(
    WidgetTester tester,
    Widget child, {
    AppThemeMode? themeMode,
  }) async {
    SharedPreferences.setMockInitialValues({});
    
    final themeProvider = EnhancedThemeProvider();
    if (themeMode != null) {
      await themeProvider.setThemeMode(themeMode);
    }
    
    await tester.pumpWidget(
      ChangeNotifierProvider<EnhancedThemeProvider>(
        create: (_) => themeProvider,
        child: Consumer<EnhancedThemeProvider>(
          builder: (context, theme, _) {
            return MaterialApp(
              title: 'MindCompanion Test',
              theme: theme.lightTheme,
              darkTheme: theme.darkTheme,
              themeMode: theme.materialThemeMode,
              home: child,
            );
          },
        ),
      ),
    );
  }

  /// Pumps a widget with accessibility provider only
  static Future<void> pumpAppWithAccessibilityProvider(
    WidgetTester tester,
    Widget child, {
    bool initialize = true,
  }) async {
    SharedPreferences.setMockInitialValues({});
    
    final accessibilityProvider = SimpleAccessibilityProvider();
    
    await tester.pumpWidget(
      ChangeNotifierProvider<SimpleAccessibilityProvider>(
        create: (_) => accessibilityProvider,
        child: Consumer<SimpleAccessibilityProvider>(
          builder: (context, accessibility, _) {
            return MaterialApp(
              title: 'MindCompanion Test',
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              themeMode: ThemeMode.system,
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaleFactor: accessibility.textScale,
                  ),
                  child: child!,
                );
              },
              home: child,
            );
          },
        ),
      ),
    );

    if (initialize) {
      await accessibilityProvider.init();
      await tester.pumpAndSettle();
    }
  }

  /// Helper to create a mock diary entry for testing
  static Map<String, dynamic> createMockDiaryEntry({
    String id = 'test-id',
    String text = 'Test diary entry',
    String emotion = 'happy',
    DateTime? createdAt,
  }) {
    return {
      'id': id,
      'text': text,
      'emotion': emotion,
      'createdAt': (createdAt ?? DateTime.now()).toIso8601String(),
    };
  }

  /// Helper to create a mock settings screen for testing
  static Widget createMockSettingsScreen() {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Theme Selection Widget
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.palette_rounded),
                          SizedBox(width: 12),
                          Text('Theme', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      SizedBox(height: 16),
                      RadioListTile<AppThemeMode>(
                        title: Text('Light'),
                        subtitle: Text('Always use light theme'),
                        value: AppThemeMode.light,
                        groupValue: AppThemeMode.light,
                        onChanged: null,
                      ),
                      RadioListTile<AppThemeMode>(
                        title: Text('Dark'),
                        subtitle: Text('Always use dark theme'),
                        value: AppThemeMode.dark,
                        groupValue: AppThemeMode.light,
                        onChanged: null,
                      ),
                      RadioListTile<AppThemeMode>(
                        title: Text('System'),
                        subtitle: Text('Follow system theme'),
                        value: AppThemeMode.system,
                        groupValue: AppThemeMode.light,
                        onChanged: null,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper to create a mock welcome screen for testing
  static Widget createMockWelcomeScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.psychology_rounded,
              size: 100,
              color: Colors.blue,
            ),
            SizedBox(height: 24),
            Text(
              'Welcome to MindCompanion',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Your AI-powered mental wellness companion',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {},
              child: Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
