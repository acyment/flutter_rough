import '../filler.dart';
import 'filler_registry.dart';

/// Always-available basic fillers
class BasicFillers {
  /// Register basic fillers that are included in the main bundle
  static void registerAll() {
    // Core fillers - always available
    FillerRegistry.registerStatic('NoFiller', NoFiller.new);
    FillerRegistry.registerStatic('SolidFiller', SolidFiller.new);
    FillerRegistry.registerStatic('HachureFiller', HachureFiller.new);
  }
}