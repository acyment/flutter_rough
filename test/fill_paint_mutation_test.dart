import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:rough_flutter/rough_flutter.dart';

void main() {
  group('drawRough fill paint handling', () {
    test('does not mutate caller-provided fill Paint', () {
      final drawConfig = DrawConfig.build(roughness: 0, seed: 1);
      final fillerConfig = FillerConfig.build(drawConfig: drawConfig);
      final filler = SolidFiller(fillerConfig); // Produces a fillPath set
      final generator = Generator(drawConfig, filler);

      // Create a simple rectangle drawable which will include a fillPath
      final drawable = generator.rectangle(0, 0, 100, 50);

      // Prepare paints
      final pathPaint = ui.Paint()
        ..color = const ui.Color(0xFF000000)
        ..style = ui.PaintingStyle.stroke
        ..strokeWidth = 1.0;

      final fillPaint = ui.Paint()
        ..color = const ui.Color(0xFF00FF00)
        ..style = ui.PaintingStyle.stroke
        ..strokeWidth = 1.0;

      // Draw on an offscreen canvas
      final recorder = ui.PictureRecorder();
      final canvas = ui.Canvas(recorder);

      // Call drawRough - previously this would mutate fillPaint.style to fill
      canvas.drawRough(drawable, pathPaint, fillPaint);

      // End recording to flush any operations
      recorder.endRecording();

      // Verify the original fillPaint was not mutated
      expect(fillPaint.style, ui.PaintingStyle.stroke);
    });
  });
}

