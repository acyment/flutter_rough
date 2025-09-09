import 'package:flutter_test/flutter_test.dart';
import 'package:rough_flutter/rough_flutter.dart';

void main() {
  group('linearPath with two points', () {
    test('creates a straight segment from (x1,y1) to (x2,y2)', () {
      // Use zero roughness to remove randomness and make coordinates deterministic
      final drawConfig = DrawConfig.build(roughness: 0, curveStepCount: 9, seed: 1);
      final filler = NoFiller();
      final generator = Generator(drawConfig, filler);

      final p1 = PointD(10, 50);
      final p2 = PointD(70, 130);

      final drawable = generator.linearPath([p1, p2]);

      // Expect exactly one set of operations for the path
      expect(drawable.sets, isNotEmpty);
      final set = drawable.sets.first;
      expect(set.type, OpSetType.path);
      expect(set.ops, isNotEmpty);

      // The first op should move to the first point
      final firstOp = set.ops.first;
      expect(firstOp.op, OpType.move);
      expect(firstOp.data.first.x, closeTo(p1.x, 1e-9));
      expect(firstOp.data.first.y, closeTo(p1.y, 1e-9));

      // The next op should be a curve that ends at the second point
      // doubleLine produces a curveTo with the destination == (x2, y2) at zero roughness
      final curveOp = set.ops.firstWhere((op) => op.op == OpType.curveTo);
      final end = curveOp.data[2];
      expect(end.x, closeTo(p2.x, 1e-9));
      expect(end.y, closeTo(p2.y, 1e-9));
    });
  });
}

