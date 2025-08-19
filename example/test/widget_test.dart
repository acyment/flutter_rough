import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rough_example/main.dart';

void main() {
  testWidgets('Integration test: App launches and shows demos',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that app shows the title
    expect(find.text('Flutter Rough example'), findsOneWidget);

    // Verify demo items are present
    expect(find.text('Interactive circle'), findsOneWidget);
    expect(find.text('Interactive rectangle'), findsOneWidget);
    expect(find.text('Interactive arc'), findsOneWidget);
    expect(find.text('Interactive curve'), findsOneWidget);
    expect(find.text('Decoration demo'), findsOneWidget);
  });

  testWidgets('Integration test: Can navigate to interactive circle demo',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Tap on the interactive circle demo
    await tester.tap(find.text('Interactive circle'));
    await tester.pumpAndSettle();

    // Verify we're on the interactive page
    expect(find.text('Interactive circle'), findsOneWidget);
    // The tabs say "Draw" and "Filler", not "Drawing"
    expect(find.text('Draw'), findsOneWidget);
    expect(find.text('Filler'), findsOneWidget);
  });

  testWidgets('Integration test: Interactive sliders exist',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Navigate to interactive circle
    await tester.tap(find.text('Interactive circle'));
    await tester.pumpAndSettle();

    // Check for configuration sliders
    expect(find.textContaining('roughness:'), findsOneWidget);
    
    // Check for slider widgets - there should be many
    final sliders = find.byType(Slider);
    expect(sliders, findsWidgets);
    
    // Should have at least 5 sliders on the Draw tab
    expect(tester.widgetList(sliders).length, greaterThanOrEqualTo(5));
  });

  testWidgets('Integration test: Can switch to filler tab',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Navigate to interactive circle
    await tester.tap(find.text('Interactive circle'));
    await tester.pumpAndSettle();

    // Switch to filler tab
    await tester.tap(find.text('Filler'));
    await tester.pumpAndSettle();

    // Check for filler configuration options
    expect(find.byType(DropdownButton<String>), findsOneWidget);
    expect(find.textContaining('fillWeight:'), findsOneWidget);
    expect(find.textContaining('hachureAngle:'), findsOneWidget);
  });
}