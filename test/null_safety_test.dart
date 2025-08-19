import 'package:flutter_test/flutter_test.dart';
import 'package:rough/rough.dart';

void main() {
  group('Null Safety Tests', () {
    test('DrawConfig creation works', () {
      final config = DrawConfig.build();
      expect(config, isNotNull);
      expect(config.roughness, equals(1));
      expect(config.bowing, equals(1));
      expect(config.maxRandomnessOffset, equals(2));
    });

    test('FillerConfig creation works', () {
      final config = FillerConfig.build();
      expect(config, isNotNull);
      expect(config.fillWeight, equals(1));
      expect(config.hachureAngle, equals(320));
      expect(config.hachureGap, equals(15));
    });

    test('Generator creation works', () {
      final drawConfig = DrawConfig.build();
      final filler = NoFiller();
      final generator = Generator(drawConfig, filler);
      expect(generator, isNotNull);
    });

    test('Drawing primitives work', () {
      final drawConfig = DrawConfig.build();
      final filler = HachureFiller();
      final generator = Generator(drawConfig, filler);

      final line = generator.line(0, 0, 100, 100);
      expect(line, isNotNull);
      expect(line.sets, isNotEmpty);

      final rect = generator.rectangle(10, 10, 80, 60);
      expect(rect, isNotNull);
      expect(rect.sets, isNotEmpty);

      final circle = generator.circle(50, 50, 40);
      expect(circle, isNotNull);
      expect(circle.sets, isNotEmpty);
    });

    test('All filler types work', () {
      final fillers = [
        NoFiller(),
        HachureFiller(),
        SolidFiller(),
        ZigZagFiller(),
        CrossHatchFiller(),
        DashedFiller(),
        DotDashFiller(),
      ];

      for (final filler in fillers) {
        expect(filler, isNotNull);
        final fillSet = filler.fill([
          PointD(0, 0),
          PointD(100, 0),
          PointD(100, 100),
          PointD(0, 100),
        ]);
        expect(fillSet, isNotNull);
        expect(fillSet.type, isA<OpSetType>());
      }
    });
  });
}
