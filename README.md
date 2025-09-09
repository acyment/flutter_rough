[![Pub](https://img.shields.io/pub/v/rough_flutter?label=latest%20version)](https://pub.dev/packages/rough_flutter)
[![GitHub Release Date](https://img.shields.io/github/release-date/acyment/flutter_rough)](https://github.com/acyment/flutter_rough/releases)
[![GitHub](https://img.shields.io/github/license/acyment/flutter_rough)](https://github.com/acyment/flutter_rough/blob/master/LICENSE)
![Dart 3 Compatible](https://img.shields.io/badge/Dart-3.0%2B-blue)

# Rough

Rough is a library that allows you draw in a sketchy, hand-drawn-like style. It's a direct port of [Rough.js](https://roughjs.com/).

## 🎉 Dart 3 Support

This library is now fully compatible with Dart 3 and includes complete null safety support!

## Recent Updates (v0.1.2)

- Fix: Corrected `linearPath` 2-point rendering bug
- Fix: Prevented `drawRough` from mutating caller `Paint`
- Docs: Updated badges/imports to `rough_flutter`
- Docs: Switched screenshots to relative paths for pub.dev

## Installation

In the `dependencies:` section of your `pubspec.yaml`, add the following line:

```yaml
dependencies:
  rough_flutter: <latest_version>
```

### Requirements

- Dart SDK: `>=3.0.0 <4.0.0`
- Flutter: Latest stable version recommended

## Basic usage

Rough allows you to draw in a sketchy, hand-drawn-like style. Here's how to get started:

### 1. Create a DrawConfig

The `DrawConfig` object determines how your drawing will look:

```dart
final drawConfig = DrawConfig.build(
  roughness: 3,          // How rough the drawing is
  bowing: 1,             // How much lines bow
  seed: 1,               // Seed for randomness
  curveStepCount: 9,     // Number of points for curves
  maxRandomnessOffset: 2, // Maximum random offset
);
```

### 2. Choose a Filler

Select from various fill styles:

```dart
// Hachure fill (default sketchy fill)
final hachureFiller = HachureFiller();

// Solid fill
final solidFiller = SolidFiller();

// Zigzag fill
final zigzagFiller = ZigZagFiller();

// Cross-hatch fill
final crossHatchFiller = CrossHatchFiller();

// Dots fill
final dotFiller = DotFiller();

// Dashed fill
final dashedFiller = DashedFiller();

// Dot-dash fill
final dotDashFiller = DotDashFiller();
```

### 3. Create a Generator

```dart
final generator = Generator(drawConfig, hachureFiller);
```

### 4. Draw shapes

```dart
// Draw a circle
final circle = generator.circle(200, 200, 160);

// Draw a rectangle
final rectangle = generator.rectangle(10, 10, 200, 100);

// Draw a line
final line = generator.line(0, 0, 100, 100);

// Draw an ellipse
final ellipse = generator.ellipse(300, 200, 200, 150);

// Draw a polygon
final polygon = generator.polygon([
  PointD(10, 10),
  PointD(100, 10),
  PointD(50, 100),
]);
```

### 5. Paint on Canvas

Use the `drawRough` extension method on Canvas:

```dart
canvas.drawRough(circle, pathPaint, fillPaint);
```

## Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:rough_flutter/rough_flutter.dart';

class RoughExample extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Create draw config
    final drawConfig = DrawConfig.build(
      roughness: 2,
      curveStepCount: 10,
      seed: 1,
    );

    // Create filler config
    final fillerConfig = FillerConfig.build(
      hachureGap: 8,
      hachureAngle: -20,
      drawConfig: drawConfig,
    );
    
    // Create filler
    final filler = ZigZagFiller(fillerConfig);

    // Create generator
    final generator = Generator(drawConfig, filler);

    // Create drawable
    final circle = generator.circle(size.width / 2, size.height / 2, 100);

    // Create paints
    final pathPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
      
    final fillPaint = Paint()
      ..color = Colors.red.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw on canvas
    canvas.drawRough(circle, pathPaint, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
```

## Box Decoration

Rough also provides a `RoughBoxDecoration` for decorating containers:

```dart
Container(
  decoration: RoughBoxDecoration(
    shape: RoughBoxShape.rectangle,
    borderStyle: RoughDrawingStyle(
      width: 2,
      color: Colors.blue,
    ),
    fillStyle: RoughDrawingStyle(
      color: Colors.blue.withOpacity(0.3),
    ),
    filler: HachureFiller(),
  ),
  child: Text('Rough Box'),
)
```

## Advanced Configuration

### Custom Filler Configuration

```dart
final fillerConfig = FillerConfig.build(
  fillWeight: 2,        // Weight of fill lines
  hachureAngle: 60,     // Angle of hachure lines in degrees
  hachureGap: 10,       // Gap between hachure lines
  dashOffset: 10,       // Length of dashes
  dashGap: 10,          // Gap between dashes
  zigzagOffset: 10,     // Width of zigzag
);
```

## Samples

Some screenshots of the example app:

![Example 1](screenshots/example_app_1.jpg)
![Example 2](screenshots/example_app_2.jpg)
![Example 3](screenshots/example_app_3.jpg)
![Example 4](screenshots/example_app_4.jpg)

## Migration from 1.0.0

If you're upgrading from version 1.0.0, please note:

1. **Dart 3 Required**: The minimum Dart SDK version is now 3.0.0
2. **Null Safety**: All APIs now use null safety
3. **API Changes**: 
   - `FillerConfig` constructor now uses `FillerConfig.build()`
   - All widget constructors now have `required` parameters
   - Some properties that were implicitly nullable are now explicitly nullable

See [CHANGELOG.md](CHANGELOG.md) for detailed migration notes.

## Contributing

Contributions are welcome! Please read our [contributing guidelines](CONTRIBUTING.md) before submitting a PR.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
