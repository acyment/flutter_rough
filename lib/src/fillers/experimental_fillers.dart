// Experimental filler implementations for dynamic loading
// These are the most complex and specialized fillers that are loaded
// only when specifically requested.

import '../core.dart';
import '../entities.dart';
import '../filler.dart';
import 'filler_registry.dart';

/// Experimental and specialized fillers
class ExperimentalFillers {
  static bool _registered = false;
  
  /// Register experimental fillers for dynamic loading
  static void registerAll() {
    if (_registered) return;
    _registered = true;
    
    // Register experimental fillers with longer load times to simulate complexity
    FillerRegistry.registerDynamic('CrossHatchFiller', () async {
      await Future.delayed(const Duration(milliseconds: 20));
      return CrossHatchFiller.new;
    });
    
    FillerRegistry.registerDynamic('DotDashFiller', () async {
      await Future.delayed(const Duration(milliseconds: 20));
      return DotDashFiller.new;
    });
  }
  
  /// Preload all experimental fillers
  static Future<void> preloadAll() async {
    await FillerRegistry.preloadFillers([
      'CrossHatchFiller',
      'DotDashFiller',
    ]);
  }
}

/// Custom experimental fillers that demonstrate advanced patterns
class CustomExperimentalFillers {
  /// Register custom filler patterns
  static void registerAll() {
    FillerRegistry.registerDynamic('WaveFiller', () async {
      await Future.delayed(const Duration(milliseconds: 30));
      return _WaveFiller.new;
    });
    
    FillerRegistry.registerDynamic('GridFiller', () async {
      await Future.delayed(const Duration(milliseconds: 25));
      return _GridFiller.new;
    });
  }
}

/// Example wave pattern filler
class _WaveFiller extends Filler {
  _WaveFiller([FillerConfig? config]) : super(config);
  
  @override
  OpSet fill(List<PointD> points) {
    // This would implement a wave-like fill pattern
    // For now, delegate to HachureFiller as a placeholder
    return HachureFiller(config).fill(points);
  }
}

/// Example grid pattern filler  
class _GridFiller extends Filler {
  _GridFiller([FillerConfig? config]) : super(config);
  
  @override
  OpSet fill(List<PointD> points) {
    // This would implement a grid fill pattern
    // For now, delegate to HachureFiller as a placeholder
    return HachureFiller(config).fill(points);
  }
}
