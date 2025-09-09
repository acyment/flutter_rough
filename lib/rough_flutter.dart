/// A Flutter implementation of the rough.js library for creating sketchy,
/// hand-drawn-like graphics.
///
/// This library provides tools to create graphics that appear to be drawn
/// by hand, with various customization options for roughness, fill styles,
/// and drawing parameters.
///
/// ## Basic Usage
///
/// ```dart
/// import 'package:rough_flutter/rough_flutter.dart';
///
/// // Create a rough canvas
/// final roughCanvas = Rough.canvas(canvas);
///
/// // Draw a rough rectangle
/// roughCanvas.rectangle(10, 10, 100, 80);
///
/// // Draw with custom configuration
/// final config = DrawConfig.build(
///   roughness: 2.0,
///   bowing: 1.5,
/// );
/// final filler = HachureFiller();
/// final generator = Generator(config, filler);
///
/// final drawable = generator.circle(50, 50, 40);
/// canvas.drawRough(drawable, paint, fillPaint);
/// ```
///
/// ## Main Components
///
/// - [DrawConfig]: Configuration for drawing parameters
/// - [Generator]: Creates drawable objects for various shapes
/// - [Filler]: Defines fill patterns (hachure, solid, zigzag, etc.)
/// - [RoughBoxDecoration]: Flutter decoration for rough-styled containers

export 'src/config.dart';
export 'src/core.dart';
export 'src/decoration.dart';
export 'src/entities.dart';
export 'src/filler.dart';
export 'src/fillers/advanced_fillers.dart';
export 'src/fillers/basic_fillers.dart';
export 'src/fillers/experimental_fillers.dart';
export 'src/fillers/filler_registry.dart';
export 'src/generator.dart';
export 'src/lazy_loading_manager.dart';
export 'src/rough.dart';
export 'src/rough_mobile_web.dart';
export 'src/rough_web_optimized.dart';
export 'src/web_optimized_generator.dart';
export 'src/widgets/loading_aware_widgets.dart';
