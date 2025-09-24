#!/bin/bash

# Golden Tests Validation Script
# This script validates golden tests in a clean environment similar to CI

set -e

echo "🔍 Starting Golden Tests Validation..."

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean
flutter pub get

# Run golden tests validation
echo "🎨 Running golden tests validation..."
flutter test test/golden/text_scaling_golden_test.dart
flutter test test/golden/theme_golden_test.dart

# Run integration tests
echo "🔗 Running integration tests..."
flutter test test/integration/theme_integration_test.dart

# Run all tests to ensure nothing is broken
echo "🧪 Running full test suite..."
flutter test

echo "✅ All golden tests validation completed successfully!"
echo "🚀 Ready for CI/CD pipeline validation"
