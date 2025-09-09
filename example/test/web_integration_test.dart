import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rough_example/main.dart';

void main() {
  group('Web Integration Tests', () {
    testWidgets('Web: App launches and renders correctly', (tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(const MyApp());

      // Verify that app shows the title
      expect(find.text('Flutter Rough example'), findsOneWidget);

      // Verify demo items are present
      expect(find.text('Interactive circle'), findsOneWidget);
      expect(find.text('Interactive rectangle'), findsOneWidget);
      expect(find.text('Decoration demo'), findsOneWidget);
    });

    testWidgets('Web: Can navigate to interactive demos', (tester) async {
      await tester.pumpWidget(const MyApp());

      // Test navigation to circle demo
      await tester.tap(find.text('Interactive circle'));
      await tester.pumpAndSettle();

      // Verify we're on the interactive page
      expect(find.text('Interactive circle'), findsOneWidget);
      expect(find.text('Draw'), findsOneWidget);
      expect(find.text('Filler'), findsOneWidget);

      // Verify canvas is present (CustomPaint widget) - may be multiple due to UI elements
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('Web: Drawing controls work', (tester) async {
      await tester.pumpWidget(const MyApp());

      // Navigate to circle demo
      await tester.tap(find.text('Interactive circle'));
      await tester.pumpAndSettle();

      // Verify sliders are present and functional
      final sliders = find.byType(Slider);
      expect(sliders, findsWidgets);

      // Test slider interaction (simulate parameter change)
      if (tester.widgetList(sliders).isNotEmpty) {
        final firstSlider = sliders.first;
        await tester.drag(firstSlider, const Offset(50, 0));
        await tester.pumpAndSettle();

        // Verify no exceptions were thrown during interaction
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('Web: Filler tab switching works', (tester) async {
      await tester.pumpWidget(const MyApp());

      // Navigate to circle demo
      await tester.tap(find.text('Interactive circle'));
      await tester.pumpAndSettle();

      // Switch to filler tab
      await tester.tap(find.text('Filler'));
      await tester.pumpAndSettle();

      // Verify filler controls are present
      expect(find.byType(DropdownButton<String>), findsOneWidget);

      // Verify no exceptions during tab switch
      expect(tester.takeException(), isNull);
    });

    testWidgets('Web: Decoration demo works', (tester) async {
      await tester.pumpWidget(const MyApp());

      // Navigate to decoration demo
      await tester.tap(find.text('Decoration demo'));
      await tester.pumpAndSettle();

      // Verify decoration page loaded
      expect(find.text('RoughDecorator example'), findsOneWidget);

      // Verify rough decorations are present (text content may be different)
      expect(find.textContaining('decorating'), findsOneWidget);
      expect(find.text('Text remarked with a highlighter'), findsOneWidget);

      // Verify no rendering exceptions
      expect(tester.takeException(), isNull);
    });

    testWidgets('Web: All demo types can be accessed', (tester) async {
      await tester.pumpWidget(const MyApp());

      final demoTypes = [
        'Interactive circle',
        'Interactive rectangle', 
        'Interactive arc',
        'Interactive curve',
        'Decoration demo',
      ];

      for (final demo in demoTypes) {
        // Navigate to demo
        await tester.tap(find.text(demo));
        await tester.pumpAndSettle();

        // Verify navigation succeeded (no exceptions)
        expect(tester.takeException(), isNull);

        // Return to home
        await tester.pageBack();
        await tester.pumpAndSettle();

        // Verify we're back at home
        expect(find.text('Flutter Rough example'), findsOneWidget);
      }
    });

    testWidgets('Web: Performance benchmark - load time', (tester) async {
      final stopwatch = Stopwatch()..start();

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      final loadTime = stopwatch.elapsedMilliseconds;
      
      // Log performance for analysis
      print('Web app load time: ${loadTime}ms');

      // Reasonable load time expectation for web (5 seconds max)
      expect(loadTime, lessThan(5000));

      // Verify app loaded successfully
      expect(find.text('Flutter Rough example'), findsOneWidget);
    });

    testWidgets('Web: Drawing rendering performance', (tester) async {
      await tester.pumpWidget(const MyApp());

      // Navigate to circle demo
      await tester.tap(find.text('Interactive circle'));
      await tester.pumpAndSettle();

      final stopwatch = Stopwatch()..start();

      // Simulate multiple parameter changes
      final sliders = find.byType(Slider);
      if (tester.widgetList(sliders).isNotEmpty) {
        for (int i = 0; i < 5; i++) {
          await tester.drag(sliders.first, Offset(10.0 * i, 0));
          await tester.pump();
        }
        await tester.pumpAndSettle();
      }

      final renderTime = stopwatch.elapsedMilliseconds;
      print('Web rendering time for parameter changes: ${renderTime}ms');

      // Should be responsive (under 1 second for 5 changes)
      expect(renderTime, lessThan(1000));
      expect(tester.takeException(), isNull);
    });
  });
}