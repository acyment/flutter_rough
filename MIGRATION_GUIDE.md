# Migration Guide: flutter_rough 1.x to 2.0

This guide will help you migrate your code from flutter_rough 1.x to version 2.0, which adds Dart 3 support and null safety.

## Prerequisites

Before migrating, ensure your project meets these requirements:
- Dart SDK `>=3.0.0`
- Flutter 3.10.0 or later (recommended)

## Step 1: Update Dependencies

Update your `pubspec.yaml`:

```yaml
dependencies:
  rough: ^2.0.0
```

Then run:
```bash
flutter pub upgrade
```

## Step 2: Update Your Code

### FillerConfig Changes

The `FillerConfig` constructor has changed to use a factory method:

**Before:**
```dart
FillerConfig myFillerConfig = FillerConfig(
  hachureGap: 8,
  hachureAngle: -20,
  drawConfig: myDrawConfig,
);
```

**After:**
```dart
FillerConfig myFillerConfig = FillerConfig.build(
  hachureGap: 8,
  hachureAngle: -20,
  drawConfig: myDrawConfig,
);
```

### Widget Constructor Changes

All widget constructors now properly use null safety:

**Before:**
```dart
class MyWidget extends StatelessWidget {
  final String title;
  
  MyWidget({Key key, this.title}) : super(key: key);
}
```

**After:**
```dart
class MyWidget extends StatelessWidget {
  final String title;
  
  const MyWidget({super.key, required this.title});
}
```

### New Fillers Available

Two new fillers are now available:
- `CrossHatchFiller` - Creates a cross-hatch pattern
- `DotDashFiller` - Creates a dot-dash pattern

Example:
```dart
final crossHatch = CrossHatchFiller();
final dotDash = DotDashFiller();
```

## Step 3: Run Migration Tools

Flutter provides tools to help with migration:

```bash
# Fix most issues automatically
dart fix --apply

# Check for remaining issues
flutter analyze
```

## Step 4: Update Your Tests

Ensure your tests are updated for null safety:

```dart
// Before
test('creates config', () {
  final config = DrawConfig.build();
  expect(config, isNotNull);
});

// After (same code works, but now with null safety guarantees)
test('creates config', () {
  final config = DrawConfig.build();
  expect(config, isNotNull);
});
```

## Common Issues and Solutions

### Issue: The argument type 'Null' can't be assigned to the parameter type 'Key'

**Solution:** Use `super.key` instead of passing `key: key` in constructors.

### Issue: Missing required parameters

**Solution:** Add `required` keyword to all mandatory parameters:
```dart
// Add 'required' to mandatory parameters
MyWidget({required this.title, required this.config});
```

### Issue: Undefined name 'FillerConfig' constructor

**Solution:** Use `FillerConfig.build()` instead of `FillerConfig()`.

## Testing Your Migration

After migration, thoroughly test your app:

1. Run all unit tests
2. Run integration tests
3. Test the example app
4. Verify all drawing operations work correctly

```bash
# Run tests
flutter test

# Run the example app
cd example
flutter run
```

## Need Help?

If you encounter issues during migration:

1. Check the [CHANGELOG.md](CHANGELOG.md) for detailed changes
2. Review the updated [example app](example/) for reference implementations
3. File an issue on [GitHub](https://github.com/sergiandreplace/flutter_rough/issues)

## Summary

The migration to 2.0 mainly involves:
1. Updating to Dart 3 and null safety
2. Changing `FillerConfig` constructor to `FillerConfig.build()`
3. Adding `required` keywords to mandatory parameters
4. Using `super` parameters where applicable

Most changes can be applied automatically using `dart fix --apply`.