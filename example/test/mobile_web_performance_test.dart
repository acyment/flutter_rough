import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rough_flutter/rough_flutter.dart';
import 'package:rough_example/main.dart';

void main() {
  group('Mobile Web Performance Tests', () {
    testWidgets('Mobile web initialization works', (tester) async {
      // Initialize mobile web detection
      RoughMobileWeb.initialize();
      
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Mobile slider renders with larger touch targets', (tester) async {
      const slider = RoughMobileSlider(
        value: 5.0,
        min: 0.0,
        max: 10.0,
        divisions: 10,
        label: 'Test Slider',
      );
      
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: slider)));
      await tester.pumpAndSettle();
      
      expect(find.byType(RoughMobileSlider), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);
      expect(find.text('Test Slider: 5.0'), findsOneWidget);
    });

    testWidgets('Mobile layout responds to screen width', (tester) async {
      const desktopChild = Text('Desktop Layout');
      const mobileChild = Text('Mobile Layout');
      
      const layout = RoughMobileLayout(
        child: desktopChild,
        mobileChild: mobileChild,
      );
      
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: layout)));
      await tester.pumpAndSettle();
      
      // Should show desktop layout in test environment (wide screen)
      expect(find.text('Desktop Layout'), findsOneWidget);
    });

    testWidgets('Performance monitoring records frames', (tester) async {
      // Clear any existing frame data
      RoughMobilePerformance.recordFrame();
      
      // Record several frames
      for (int i = 0; i < 5; i++) {
        RoughMobilePerformance.recordFrame();
        await Future.delayed(const Duration(milliseconds: 16)); // ~60fps
      }
      
      final report = RoughMobilePerformance.getPerformanceReport();
      
      expect(report['frameCount'], greaterThan(0));
      expect(report['averageFrameTime'], greaterThan(0));
      expect(report['estimatedFPS'], greaterThan(0));
      expect(report['isMobileWeb'], isA<bool>());
      expect(report['isGoodPerformance'], isA<bool>());
    });

    testWidgets('Canvas size optimization works', (tester) async {
      const largeSize = Size(1200, 1200);
      const smallSize = Size(400, 400);
      
      final optimizedLarge = RoughMobileWeb.getOptimizedCanvasSize(largeSize);
      final optimizedSmall = RoughMobileWeb.getOptimizedCanvasSize(smallSize);
      
      // Large canvas should be optimized if on mobile web
      if (RoughMobileWeb.isMobileWeb) {
        expect(optimizedLarge.width, lessThanOrEqualTo(800));
        expect(optimizedLarge.height, lessThanOrEqualTo(800));
      } else {
        expect(optimizedLarge, equals(largeSize));
      }
      
      // Small canvas should remain unchanged
      expect(optimizedSmall, equals(smallSize));
    });

    testWidgets('Mobile config provides appropriate settings', (tester) async {
      final config = RoughMobileWeb.getMobileOptimizedConfig();
      
      expect(config, containsPair('reducedComplexity', isA<bool>()));
      expect(config, containsPair('maxPathOperations', isA<int>()));
      expect(config, containsPair('enableCaching', isA<bool>()));
      expect(config, containsPair('throttleUpdates', isA<bool>()));
      
      if (RoughMobileWeb.isMobileWeb) {
        expect(config['maxPathOperations'], equals(500));
        expect(config['enableCaching'], isTrue);
        expect(config['throttleUpdates'], isTrue);
        expect(config['reducedComplexity'], isTrue);
      } else {
        expect(config['maxPathOperations'], equals(1000));
      }
    });

    testWidgets('Haptic feedback calls work safely', (tester) async {
      // These should not throw exceptions even if haptic feedback is unavailable
      await expectLater(
        RoughMobileHaptics.lightImpact(),
        completes,
      );
      
      await expectLater(
        RoughMobileHaptics.selectionClick(),
        completes,
      );
    });
  });
}