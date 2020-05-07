import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rough/rough.dart';

import '../interactive_canvas.dart';

class CircleExamplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Interactive circle demo')),
      body: InteractiveBody(
        example: CircleExample(),
        properties: <DiscreteProperty>[
          DiscreteProperty(name: 'seed', label: 'Seed', min: 0, max: 50, steps: 50),
          DiscreteProperty(name: 'roughness', label: 'Rougness', min: 0, max: 2, steps: 50),
          DiscreteProperty(name: 'curveFitting', label: 'curveFitting', min: 0, max: 2, steps: 50),
          DiscreteProperty(name: 'curveTightness', label: 'curveTightness', min: 0, max: 1, steps: 100),
          DiscreteProperty(name: 'curveStepCount', label: 'curveStepCount', min: 1, max: 11, steps: 100),
        ],
      ),
    );
  }
}

class CircleExample extends InteractiveExample {
  final Paint pathPaint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true
    ..strokeWidth = 2;
  final Paint fillPaint = Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true
    ..strokeWidth = 1;

  @override
  void paintRough(Canvas canvas, Size size, DrawConfig drawConfig, Filler filler) {
    Generator generator = Generator(drawConfig, filler);
    double s = min(size.width, size.height);
    Drawable figure = generator.circle(size.width / 2, size.height / 2, s * 0.8);
    canvas.drawRough(figure, pathPaint, fillPaint);
  }
}
