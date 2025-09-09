import '../filler.dart';
import 'filler_registry.dart';

/// Advanced fillers that can be loaded on demand
class AdvancedFillers {
  static bool _registered = false;
  
  /// Register advanced fillers for dynamic loading
  static void registerAll() {
    if (_registered) return;
    _registered = true;
    
    // Register advanced fillers as dynamically loadable
    FillerRegistry.registerDynamic('ZigZagFiller', () async {
      // Simulate dynamic loading with a small delay
      await Future.delayed(const Duration(milliseconds: 10));
      return ZigZagFiller.new;
    });
    
    FillerRegistry.registerDynamic('HatchFiller', () async {
      await Future.delayed(const Duration(milliseconds: 10));
      return HatchFiller.new;
    });
    
    FillerRegistry.registerDynamic('DotFiller', () async {
      await Future.delayed(const Duration(milliseconds: 10));
      return DotFiller.new;
    });
    
    FillerRegistry.registerDynamic('DashedFiller', () async {
      await Future.delayed(const Duration(milliseconds: 10));
      return DashedFiller.new;
    });
  }
  
  /// Preload commonly used advanced fillers
  static Future<void> preloadCommon() async {
    await FillerRegistry.preloadFillers([
      'ZigZagFiller',
      'DashedFiller',
    ]);
  }
  
  /// Preload all advanced fillers
  static Future<void> preloadAll() async {
    await FillerRegistry.preloadFillers([
      'ZigZagFiller',
      'HatchFiller', 
      'DotFiller',
      'DashedFiller',
    ]);
  }
}