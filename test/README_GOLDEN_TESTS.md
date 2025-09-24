# 🖼️ Golden Tests Documentation

## Overview

Golden Tests are automated visual regression tests that capture screenshots of your app's UI and compare them against reference images. This ensures that visual changes are intentional and not accidental regressions.

## 📁 File Structure

```
test/
├── golden/                           # Golden test files
│   ├── welcome_screen_golden_test.dart
│   ├── home_screen_golden_test.dart
│   ├── ai_diary_screen_golden_test.dart
│   ├── personal_diary_screen_golden_test.dart
│   ├── emotional_history_golden_test.dart
│   ├── crisis_mode_screen_golden_test.dart
│   ├── settings_screen_golden_test.dart
│   ├── meditation_screen_golden_test.dart
│   └── privacy_policy_screen_golden_test.dart
└── integration_test/                 # Integration tests
    ├── app_test.dart                 # User journey tests
    ├── golden_integration_test.dart  # Golden integration tests
    └── golden/                       # Integration golden files
```

## 🚀 Commands

### Generate Golden Files (First Time)
```bash
flutter test --update-goldens
```

### Update Golden Files (After UI Changes)
```bash
flutter test --update-goldens
```

### Run Only Golden Tests
```bash
flutter test test/golden/
```

### Run Specific Golden Test
```bash
flutter test test/golden/welcome_screen_golden_test.dart --update-goldens
```

### Run Integration Tests
```bash
flutter test integration_test/
```

### Run Golden Integration Tests
```bash
flutter test integration_test/golden_integration_test.dart --update-goldens
```

## 🔧 How It Works

1. **Golden Tests**: Capture screenshots of individual screens at a fixed size (400x800)
2. **Integration Tests**: Test complete user journeys and capture golden screenshots during navigation
3. **CI/CD**: Automated testing on every push/PR with GitHub Actions

## 📊 Test Coverage

### Individual Screen Tests
- ✅ Welcome Screen
- ✅ Home Screen  
- ✅ AI Diary Screen
- ✅ Personal Diary Screen
- ✅ Emotional History Screen
- ✅ Crisis Mode Screen
- ✅ Settings Screen
- ✅ Meditation Screen
- ✅ Privacy Policy Screen

### Integration Journey Tests
- ✅ Complete User Journey (Welcome → Home → AI Diary → Personal Diary → History)
- ✅ Crisis Mode Journey (Home → Crisis Mode → Emergency Contacts)
- ✅ Meditation Journey (Home → Meditation → Audio Playback)

## 🛠️ Troubleshooting

### Common Issues

1. **Golden Test Failures**
   - Review the visual changes
   - If intentional: Update with `--update-goldens`
   - If unintentional: Fix the UI issues

2. **Animation Timeouts**
   - Golden tests use `pump()` instead of `pumpAndSettle()` to avoid timeouts
   - Fixed size rendering ensures consistency

3. **Layout Overflow**
   - Some screens may show overflow warnings in tests
   - This is expected in the fixed 400x800 test size
   - Focus on the golden comparison, not layout warnings

### Best Practices

1. **Always review changes** before updating golden files
2. **Use consistent test sizes** (400x800) for all golden tests
3. **Run tests locally** before pushing to catch issues early
4. **Update golden files** when making intentional UI changes

## 🔄 CI/CD Integration

### GitHub Actions Workflows

1. **Golden Tests** (`.github/workflows/golden-tests.yml`)
   - Runs on every push/PR
   - Detects visual changes
   - Comments on PRs with results

2. **Flutter Tests** (`.github/workflows/flutter-tests.yml`)
   - Runs unit and widget tests
   - Generates coverage reports

3. **Integration Tests** (`.github/workflows/integration-tests.yml`)
   - Runs user journey tests
   - Captures golden screenshots during navigation

### Automated Notifications

- **PR Comments**: Automatic comments when golden tests fail
- **Artifact Upload**: Test results and screenshots saved for 7 days
- **Coverage Reports**: Code coverage tracking with Codecov

## 📈 Benefits

1. **Visual Regression Detection**: Catch unintended UI changes
2. **Automated Testing**: No manual visual inspection needed
3. **CI/CD Integration**: Automatic testing on every push
4. **User Journey Testing**: End-to-end functionality verification
5. **Documentation**: Golden files serve as visual documentation

## 🎯 Next Steps

1. **Run initial golden generation**: `flutter test --update-goldens`
2. **Review generated images** in `test/golden/` directory
3. **Set up CI/CD** by pushing to GitHub
4. **Make UI changes** and see how tests detect them
5. **Update golden files** when changes are intentional

---

*This documentation is automatically maintained with the golden test suite.*
