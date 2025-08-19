import 'package:flutter/material.dart';
import 'package:rough_example/interactive_canvas.dart';
import 'package:rough_example/pages/decoration_page.dart';

import 'interactive_examples.dart';
import 'pages/interactive_example_page.dart';

abstract class Demo {
  Demo(this.name, this.description, this.icon);
  final String name;
  final String description;
  final Widget icon;

  Widget buildPage(BuildContext context);
}

class InteractiveDemo extends Demo {
  InteractiveDemo(
      String name, String description, this.exampleBuilder, Widget icon)
      : super(name, description, icon);
  final ExampleBuilder exampleBuilder;

  @override
  Widget buildPage(BuildContext context) {
    return ExamplePage(title: name, exampleBuilder: exampleBuilder);
  }
}

class NormalDemo extends Demo {
  NormalDemo(String name, String description, this.builder, Widget icon)
      : super(name, description, icon);
  final WidgetBuilder builder;

  @override
  Widget buildPage(BuildContext context) {
    return builder(context);
  }
}

typedef ExampleBuilder = InteractiveExample Function();

final List<Demo> demos = [
  InteractiveDemo('Flutter logo', 'A simple Flutter logo drawn using Rough',
      FlutterLogoExample.new, const FlutterLogo()),
  InteractiveDemo(
    'Interactive circle',
    'A circle drawn with Rough generated with interactive parameters',
    CircleExample.new,
    const Icon(Icons.add_circle, size: 36),
  ),
  InteractiveDemo(
    'Interactive rectangle',
    'A rectange drawn with Rough generated with interactive parameters',
    RectangleExample.new,
    const Icon(Icons.add_box, size: 36),
  ),
  InteractiveDemo(
    'Interactive arc',
    'An arc drawn with Rough generated with interactive parameters',
    ArcExample.new,
    const Icon(Icons.pie_chart_outline, size: 36),
  ),
  InteractiveDemo(
    'Interactive curve',
    'An curve drawn with Rough generated with interactive parameters',
    CurveExample.new,
    const Icon(Icons.gesture, size: 36),
  ),
  NormalDemo(
    'Decoration demo',
    'Create decorations with Rough',
    (_) => const DecorationExamplePage(),
    const Icon(Icons.format_shapes, size: 36),
  )
];
