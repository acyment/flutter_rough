# Flutter Rough - Dart 3 Migration Plan

## Overview
This plan outlines a safe, incremental migration of flutter_rough to Dart 3 with null safety, following TDD principles.

## Phase 1: Setup and Testing Infrastructure (Day 1)

### 1.1 Create baseline tests
- [ ] Write comprehensive unit tests for current functionality
- [ ] Test all drawing primitives (line, rectangle, ellipse, circle, arc, polygon, curve)
- [ ] Test fill styles (hachure, solid, zigzag, cross-hatch, dashed, dot-dash)
- [ ] Create visual regression tests using golden files
- [ ] Ensure 100% test coverage for core functionality

### 1.2 Setup CI/CD
- [ ] Configure GitHub Actions for automated testing
- [ ] Add dart analyze step
- [ ] Add test coverage reporting
- [ ] Create branch protection rules

### 1.3 Create migration branch
- [ ] Branch from master: `feature/dart-3-migration`
- [ ] Document current behavior before changes

## Phase 2: Dart 3 Migration - Core Library (Day 1-2)

### 2.1 Update SDK constraints incrementally
- [ ] First update to `>=2.12.0 <3.0.0` (null safety boundary)
- [ ] Run `dart migrate --no-apply-changes` to preview
- [ ] Review migration suggestions
- [ ] Apply migration with `dart migrate`
- [ ] Run tests to ensure nothing breaks

### 2.2 Fix immediate null safety issues
- [ ] Remove `assert(x != null)` statements
- [ ] Replace with proper null checks where needed
- [ ] Add `required` keyword to constructor parameters
- [ ] Fix null-aware operators (`??`, `?.`)

### 2.3 Update to full Dart 3
- [ ] Change SDK constraint to `>=3.0.0 <4.0.0`
- [ ] Run dart analyze and fix any new issues
- [ ] Ensure all tests still pass

## Phase 3: Fix Null Safety Issues (Day 2)

### 3.1 Core library files (order matters)
1. [ ] `lib/src/entities.dart` - Fix PointD, DrawConfig classes
2. [ ] `lib/src/config.dart` - Update configuration classes
3. [ ] `lib/src/core.dart` - Fix Op, OpSet, Line classes
4. [ ] `lib/src/geometry.dart` - Update geometric calculations
5. [ ] `lib/src/filler.dart` - Fix fill algorithms
6. [ ] `lib/src/renderer.dart` - Update rendering logic
7. [ ] `lib/src/generator.dart` - Fix generator class
8. [ ] `lib/src/decoration.dart` - Update decoration support
9. [ ] `lib/src/rough.dart` - Fix main rough class
10. [ ] `lib/rough.dart` - Update public API exports

### 3.2 For each file:
- [ ] Run `dart analyze` on the specific file
- [ ] Fix null safety warnings one by one
- [ ] Run tests after each fix
- [ ] Commit after each file is clean

## Phase 4: Update Example App (Day 2-3)

### 4.1 Fix package name
- [ ] Rename `RoughExample` to `rough_example` in pubspec.yaml
- [ ] Update all imports from `package:RoughExample/` to `package:rough_example/`

### 4.2 Update example dependencies
- [ ] Update example/pubspec.yaml SDK constraints
- [ ] Fix import issues
- [ ] Update deprecated Flutter APIs

### 4.3 Fix example code
- [ ] Update null safety in example files
- [ ] Fix any deprecated widget usage
- [ ] Ensure example runs without errors

## Phase 5: Modernize Code Style (Day 3)

### 5.1 Update linting
- [ ] Replace `extra_pedantic` with `flutter_lints: ^3.0.0`
- [ ] Update analysis_options.yaml
- [ ] Fix new linting issues incrementally

### 5.2 Code improvements
- [ ] Remove unnecessary lambdas (use tear-offs)
- [ ] Fix comment references
- [ ] Remove dead code
- [ ] Improve type annotations

### 5.3 Performance optimizations
- [ ] Use const constructors where possible
- [ ] Optimize list operations
- [ ] Review and optimize algorithms

## Phase 6: Documentation and Release (Day 3)

### 6.1 Update documentation
- [ ] Update README with new requirements
- [ ] Add migration guide for users
- [ ] Update API documentation
- [ ] Add more code examples

### 6.2 Prepare release
- [ ] Update CHANGELOG.md
- [ ] Bump version to 1.0.0 (breaking change)
- [ ] Run `dart pub publish --dry-run`
- [ ] Create GitHub release
- [ ] Publish to pub.dev

## Testing Strategy (Throughout)

### Unit Tests
- Test each drawing primitive in isolation
- Test configuration options
- Test edge cases (empty paths, single points, etc.)

### Integration Tests
- Test combinations of primitives
- Test different fill styles with different shapes
- Test performance with complex drawings

### Visual Tests
- Create golden files for each primitive
- Test different roughness levels
- Test different fill styles
- Compare output with rough.js reference

## Rollback Plan

If issues arise at any phase:
1. Tests will catch regressions immediately
2. Each phase is in small commits for easy revert
3. Feature branch allows safe experimentation
4. Can always fall back to current version

## Success Criteria

- [ ] All tests pass with Dart 3
- [ ] Zero analyzer warnings/errors
- [ ] Example app runs without issues
- [ ] Performance is same or better
- [ ] API remains backward compatible (where possible)
- [ ] Published successfully to pub.dev