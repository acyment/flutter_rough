import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rough/rough.dart';

import '../interactive_canvas.dart';

class ArcExamplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Interactive arc demo')),
      body: InteractiveBody(
        example: ArcExample(),
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

class ArcExample extends InteractiveExample {
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
    Drawable figure = generator.arc(size.width / 2, size.height / 2, s * 0.8, s * 0.8, pi * 0.2, pi * 1.8, true);
    canvas.drawRough(figure, pathPaint, fillPaint);
  }
}
