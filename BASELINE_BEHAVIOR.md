# Flutter Rough - Baseline Behavior Documentation

## Current State (Pre-Migration)

### Environment
- **Dart SDK Required**: `>=2.6.0 <3.0.0` (pre-null safety)
- **Flutter SDK**: Compatible with pre-null safety Flutter
- **Current Dart SDK**: 3.9.0 (requires manual downgrade to run)

### Known Issues
1. **Dart Analyze Results**: 655 issues
   - 224 errors (mostly null safety related)
   - 419 warnings (null checks, dead code, null-aware operators)
   - 12 info messages (style issues)

2. **Example App Issues**:
   - Package name `RoughExample` not following conventions
   - Import errors due to package name
   - Missing Flutter imports in example

3. **Library Issues**:
   - `assert(x != null)` patterns throughout
   - Unnecessary null-aware operators
   - Dead code due to null safety assumptions
   - No proper null safety annotations

### API Surface

#### Main Classes
1. **Rough** - Main entry point
   - `Rough.canvas(Canvas)` - Create rough canvas
   - Drawing methods: line, rectangle, circle, ellipse, polygon, arc, curvePath, linearPath

2. **DrawConfig** - Configuration options
   - `roughness`: 0-3+ (default: 1)
   - `strokeWidth`: Line thickness (default: 2)
   - `stroke`: Line color (default: black)
   - `fill`: Fill color (optional)
   - `fillStyle`: enum (hachure, solid, zigzag, crossHatch, dashed, dotDash)
   - `bowing`: Line bowing effect (default: 1)
   - `hachureAngle`: Angle for hachure lines (default: 0)
   - `hachureGap`: Gap between hachure lines (default: 0)
   - `seed`: Random seed for reproducible drawings

3. **FillingStyle** enum
   - hachure (default)
   - solid
   - zigzag  
   - crossHatch
   - dashed
   - dotDash

#### Drawing Primitives
- `line(x1, y1, x2, y2, [config])`
- `rectangle(x, y, width, height, [config])`
- `circle(x, y, diameter, [config])`
- `ellipse(x, y, width, height, [config])`
- `polygon(points, [config])`
- `arc(x, y, width, height, start, stop, closed, [config])`
- `curvePath(points, [config])`
- `linearPath(points, [config])`

### Test Coverage
- **Existing Tests**: Single empty test file
- **New Test Suite**: 
  - Drawing primitives (all shapes)
  - Fill styles (all 6 types + no fill)
  - Configuration options
  - Edge cases (zero dimensions, empty points, etc.)
  - Visual golden tests

### Expected Behavior

1. **Randomness**: Each drawing has slight variations unless seed is set
2. **Fill Behavior**: Fill is drawn before outline
3. **Coordinate System**: Standard Flutter canvas coordinates
4. **Performance**: Should handle complex paths efficiently
5. **Error Handling**: Currently minimal, relies on asserts

### Migration Risks

1. **Breaking Changes**: 
   - Null safety will require API changes
   - Constructor parameters may need `required` keyword
   - Some implicit behaviors will become explicit

2. **Behavioral Changes**:
   - Null checks will be enforced at compile time
   - Dead code removal may change edge case behavior
   - Assert removal may change error detection

### Baseline Metrics
- **Package Size**: ~50KB
- **Dependencies**: Only Flutter SDK
- **Platform Support**: All Flutter platforms
- **Example App**: Functional but with naming issues

This document serves as a reference point for the migration. Any deviations from this behavior should be intentional and documented.