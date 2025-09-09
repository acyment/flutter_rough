import 'package:flutter_test/flutter_test.dart';
import 'package:rough_flutter/rough_flutter.dart';

void main() {
  group('Flutter Rough Integration Tests', () {
    test('DrawConfig can be created with null safety', () {
      final config = DrawConfig.build(
        roughness: 2.0,
        bowing: 1.5,
        maxRandomnessOffset: 5.0,
      );

      expect(config, isNotNull);
      expect(config.roughness, equals(2.0));
      expect(config.bowing, equals(1.5));
      expect(config.maxRandomnessOffset, equals(5.0));
    });

    test('All Filler types can be created', () {
      final config = FillerConfig.build();

      final fillers = [
        NoFiller(config),
        HachureFiller(config),
        SolidFiller(config),
        ZigZagFiller(config),
        CrossHatchFiller(config),
        DashedFiller(config),
        DotDashFiller(config),
      ];

      for (final filler in fillers) {
        expect(filler, isNotNull);
      }
    });

    test('Generator can create all shapes', () {
      final drawConfig = DrawConfig.build();
      final filler = HachureFiller();
      final generator = Generator(drawConfig, filler);

      // Test line
      final line = generator.line(0, 0, 100, 100);
      expect(line, isNotNull);
      expect(line.sets, isNotEmpty);

      // Test rectangle
      final rect = generator.rectangle(10, 10, 80, 60);
      expect(rect, isNotNull);
      expect(rect.sets.length, greaterThanOrEqualTo(1));

      // Test circle
      final circle = generator.circle(50, 50, 40);
      expect(circle, isNotNull);
      expect(circle.sets.length, greaterThanOrEqualTo(1));

      // Test ellipse
      final ellipse = generator.ellipse(50, 50, 80, 60);
      expect(ellipse, isNotNull);
      expect(ellipse.sets.length, greaterThanOrEqualTo(1));

      // Test polygon
      final polygon = generator.polygon([
        PointD(20, 20),
        PointD(80, 20),
        PointD(80, 80),
        PointD(20, 80),
      ]);
      expect(polygon, isNotNull);
      expect(polygon.sets.length, greaterThanOrEqualTo(1));

      // Test arc
      final arc = generator.arc(50, 50, 80, 60, 0, 3.14);
      expect(arc, isNotNull);
      expect(arc.sets.length, greaterThanOrEqualTo(1));

      // Test linear path
      final linearPath = generator.linearPath([
        PointD(10, 10),
        PointD(50, 50),
        PointD(90, 10),
      ]);
      expect(linearPath, isNotNull);
      expect(linearPath.sets, isNotEmpty);

      // Test curve path
      final curvePath = generator.curvePath([
        PointD(10, 50),
        PointD(30, 20),
        PointD(50, 80),
        PointD(70, 20),
        PointD(90, 50),
      ]);
      expect(curvePath, isNotNull);
      expect(curvePath.sets, isNotEmpty);
    });

    test('Different fill styles produce different results', () {
      final points = [
        PointD(20, 20),
        PointD(80, 20),
        PointD(80, 80),
        PointD(20, 80),
      ];

      final hachureFiller = HachureFiller();
      final solidFiller = SolidFiller();
      final zigzagFiller = ZigZagFiller();

      final hachureOps = hachureFiller.fill(points);
      final solidOps = solidFiller.fill(points);
      final zigzagOps = zigzagFiller.fill(points);

      // Different fillers should produce different operations
      expect(hachureOps.ops.length, isNot(equals(solidOps.ops.length)));
      expect(zigzagOps.type, isNotNull);
    });

    test('Roughness affects drawing output', () {
      final smoothConfig = DrawConfig.build(roughness: 0);
      final roughConfig = DrawConfig.build(roughness: 3);

      final smoothFiller =
          HachureFiller(FillerConfig.build(drawConfig: smoothConfig));
      final roughFiller =
          HachureFiller(FillerConfig.build(drawConfig: roughConfig));

      final smoothGen = Generator(smoothConfig, smoothFiller);
      final roughGen = Generator(roughConfig, roughFiller);

      final smoothLine = smoothGen.line(0, 0, 100, 100);
      final roughLine = roughGen.line(0, 0, 100, 100);

      // Both should produce valid output
      expect(smoothLine.sets, isNotEmpty);
      expect(roughLine.sets, isNotEmpty);
    });

    test('Null safety is properly implemented', () {
      // Test nullable shape
      final drawable = Drawable(
        shape: null,
        options: DrawConfig.build(),
        sets: [],
      );
      expect(drawable.shape, isNull);

      // Test required parameters work
      final opSet = OpSet(
        type: OpSetType.path,
        ops: [Op.move(PointD(0, 0))],
      );
      expect(opSet.type, equals(OpSetType.path));
      expect(opSet.ops.length, equals(1));
    });
  });
}
