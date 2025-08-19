# Changelog

## [2.0.0] - 2025-08-19

### 🎉 Major Release: Dart 3 Support

This release brings full Dart 3 compatibility and null safety support to flutter_rough!

### Breaking Changes
- **Minimum Dart SDK version is now 3.0.0**
- **All APIs now use null safety**
- `FillerConfig` constructor changed to use named parameters
- All widget constructors now require `key` parameter to be explicitly marked as nullable
- Removed deprecated linting rules

### New Features
- Full Dart 3.0+ support
- Complete null safety implementation
- Added `CrossHatchFiller` and `DotDashFiller` implementations
- Improved type safety across all APIs
- Better documentation with dartdoc comments

### Improvements
- Updated to use `flutter_lints` instead of `extra_pedantic`
- Modernized code to use latest Dart idioms:
  - Used `super` parameters where applicable
  - Applied const constructors where possible
  - Used tear-offs for cleaner code
- Improved test coverage
- Better organized exports in main library file
- Enhanced README with comprehensive examples

### Migration Guide

If you're upgrading from 1.x:

1. Update your Dart SDK constraint to `>=3.0.0 <4.0.0`
2. Update `FillerConfig` instantiation:
   ```dart
   // Old
   FillerConfig(
     hachureGap: 8,
     hachureAngle: -20,
     drawConfig: myDrawConfig,
   );
   
   // New
   FillerConfig.build(
     hachureGap: 8,
     hachureAngle: -20,
     drawConfig: myDrawConfig,
   );
   ```
3. Ensure all widget constructors use `required` for mandatory parameters
4. Run `dart fix --apply` to automatically fix most issues

### Development
- Added comprehensive integration tests
- Created example app with interactive demos
- Set up CI/CD with GitHub Actions
- Added proper test coverage for all fillers

### Bug Fixes
- Fixed null safety issues throughout the codebase
- Resolved all analyzer warnings
- Fixed missing filler implementations

## [0.1.1] - 2020-May-5

* `FillConfig` now has a builder
* `Rough.draw` is now `drawRough`, an extension method of `Canvas`
* Basic external API documentation

## [0.1.0+2] - 2020-May-5

* Basic documentation
* Cute badges!

## [0.1.0+1] - 2020-May-5

* Testing publication through CI

## [0.1.0] - 2020-May-4

* Initial release
* Support for basic figures with some fillings