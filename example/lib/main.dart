import 'package:flutter/material.dart';
import 'package:rough_flutter/rough_flutter.dart';
import 'package:rough_example/pages/home_page.dart';

void main() {
  // Initialize mobile web optimizations
  RoughMobileWeb.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Rough Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const HomePage(),
    );
  }
}
