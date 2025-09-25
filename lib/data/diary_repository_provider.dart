import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/diary_repository.dart';
import 'shared_prefs_diary_repository.dart';

/// Provider for DiaryRepository dependency injection
class DiaryRepositoryProvider extends InheritedWidget {
  final DiaryRepository repository;

  const DiaryRepositoryProvider({
    super.key,
    required this.repository,
    required super.child,
  });

  /// Get repository from context
  static DiaryRepository of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<DiaryRepositoryProvider>();
    if (provider == null) {
      throw StateError('DiaryRepositoryProvider not found in widget tree');
    }
    return provider.repository;
  }

  @override
  bool updateShouldNotify(DiaryRepositoryProvider oldWidget) {
    return repository != oldWidget.repository;
  }
}

/// Factory for creating DiaryRepository instances
class DiaryRepositoryFactory {
  static DiaryRepository? _instance;

  /// Get singleton instance
  static Future<DiaryRepository> getInstance() async {
    if (_instance == null) {
      final prefs = await SharedPreferences.getInstance();
      _instance = SharedPrefsDiaryRepository(prefs);

      // Perform migration if needed
      await _instance!.migrateIfNeeded();
    }
    return _instance!;
  }

  /// Create new instance (for testing)
  static Future<DiaryRepository> createInstance(SharedPreferences prefs) async {
    final repository = SharedPrefsDiaryRepository(prefs);
    await repository.migrateIfNeeded();
    return repository;
  }

  /// Reset instance (for testing)
  static void reset() {
    _instance = null;
  }
}

/// Widget that provides DiaryRepository to the widget tree
class DiaryRepositoryScope extends StatefulWidget {
  final Widget child;

  const DiaryRepositoryScope({super.key, required this.child});

  @override
  State<DiaryRepositoryScope> createState() => _DiaryRepositoryScopeState();
}

class _DiaryRepositoryScopeState extends State<DiaryRepositoryScope> {
  DiaryRepository? _repository;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeRepository();
  }

  Future<void> _initializeRepository() async {
    try {
      final repository = await DiaryRepositoryFactory.getInstance();
      if (mounted) {
        setState(() {
          _repository = repository;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error initializing repository: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    if (_repository == null) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text('Failed to initialize diary repository'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _initializeRepository,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return DiaryRepositoryProvider(
      repository: _repository!,
      child: widget.child,
    );
  }
}
