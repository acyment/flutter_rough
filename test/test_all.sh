#!/bin/bash

# Test runner script for Flutter Rough
# This script documents how to run tests once Dart 3 migration is complete

echo "Flutter Rough Test Suite"
echo "========================"
echo ""

# Check Flutter version
echo "Flutter version:"
flutter --version
echo ""

# Run analyzer
echo "Running dart analyze..."
dart analyze
if [ $? -ne 0 ]; then
    echo "❌ Dart analyze failed"
    exit 1
fi
echo "✅ Dart analyze passed"
echo ""

# Format check
echo "Checking code formatting..."
dart format --output=none --set-exit-if-changed .
if [ $? -ne 0 ]; then
    echo "❌ Code formatting check failed"
    echo "Run 'dart format .' to fix formatting"
    exit 1
fi
echo "✅ Code formatting check passed"
echo ""

# Run tests
echo "Running unit tests..."
flutter test
if [ $? -ne 0 ]; then
    echo "❌ Unit tests failed"
    exit 1
fi
echo "✅ Unit tests passed"
echo ""

# Run tests with coverage
echo "Running tests with coverage..."
flutter test --coverage
if [ $? -ne 0 ]; then
    echo "❌ Coverage generation failed"
    exit 1
fi
echo "✅ Coverage generated"
echo ""

# Generate coverage report (requires lcov)
if command -v lcov &> /dev/null; then
    echo "Generating coverage report..."
    genhtml coverage/lcov.info -o coverage/html
    echo "Coverage report generated at coverage/html/index.html"
fi

echo ""
echo "All tests passed! 🎉"