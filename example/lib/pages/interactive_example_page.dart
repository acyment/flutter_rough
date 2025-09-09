import 'package:flutter/material.dart';

import '../interactive_canvas.dart';

class ExamplePage extends StatelessWidget {
  const ExamplePage(
      {super.key, required this.title, required this.exampleBuilder});
  final String title;
  final InteractiveExample Function() exampleBuilder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: InteractiveBody(
        example: exampleBuilder(),
      ),
    );
  }
}
