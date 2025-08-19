import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'core.dart';
import 'entities.dart';
import 'rough.dart';

/// Web-optimized version of the Rough canvas extension
/// 
/// This extension includes optimizations specifically for web performance:
/// - Path caching for complex shapes
/// - Batch drawing operations
/// - Memory-efficient path construction
/// - Paint object reuse
extension RoughWebOptimized on Canvas {
  static final Map<int, Path> _pathCache = <int, Path>{};
  static final Map<String, Paint> _paintCache = <String, Paint>{};
  
  /// Optimized path creation with caching for web
  Path _drawToContextOptimized(OpSet drawing) {
    // Use hash for caching complex paths
    final int pathHash = drawing.hashCode;
    
    // Check cache first for repeated paths
    if (_pathCache.containsKey(pathHash)) {
      return _pathCache[pathHash]!;
    }
    
    final Path path = Path();
    final List<Op> ops = drawing.ops;
    
    // Batch path operations for better performance
    for (int i = 0; i < ops.length; i++) {
      final Op op = ops[i];
      final List<PointD> data = op.data;
      
      switch (op.op) {
        case OpType.move:
          path.moveTo(data[0].x, data[0].y);
          break;
        case OpType.curveTo:
          path.cubicTo(
            data[0].x, data[0].y, 
            data[1].x, data[1].y, 
            data[2].x, data[2].y
          );
          break;
        case OpType.lineTo:
          path.lineTo(data[0].x, data[0].y);
          break;
      }
    }
    
    // Cache the path if it's complex enough to benefit from caching
    if (ops.length > 10) {
      _pathCache[pathHash] = path;
      
      // Limit cache size to prevent memory issues
      if (_pathCache.length > 100) {
        _pathCache.clear();
      }
    }
    
    return path;
  }
  
  /// Get or create cached paint object
  Paint _getCachedPaint(Paint originalPaint, PaintingStyle? style) {
    final String key = '${originalPaint.color.value}_${style?.index ?? originalPaint.style.index}_${originalPaint.strokeWidth}';
    
    if (_paintCache.containsKey(key)) {
      return _paintCache[key]!;
    }
    
    final Paint paint = Paint()
      ..color = originalPaint.color
      ..style = style ?? originalPaint.style
      ..strokeWidth = originalPaint.strokeWidth
      ..strokeCap = originalPaint.strokeCap
      ..strokeJoin = originalPaint.strokeJoin
      ..isAntiAlias = originalPaint.isAntiAlias;
    
    _paintCache[key] = paint;
    
    // Limit paint cache size
    if (_paintCache.length > 50) {
      _paintCache.clear();
    }
    
    return paint;
  }
  
  /// Web-optimized rough drawing with performance enhancements
  void drawRoughOptimized(Drawable drawable, Paint pathPaint, Paint fillPaint) {
    final List<OpSet> sets = drawable.sets;
    
    // Batch similar operations together for web performance
    final List<OpSet> pathOps = [];
    final List<OpSet> fillPathOps = [];
    final List<OpSet> fillSketchOps = [];
    
    // Group operations by type
    for (final OpSet drawing in sets) {
      switch (drawing.type) {
        case OpSetType.path:
          pathOps.add(drawing);
          break;
        case OpSetType.fillPath:
          fillPathOps.add(drawing);
          break;
        case OpSetType.fillSketch:
          fillSketchOps.add(drawing);
          break;
      }
    }
    
    // Draw fill operations first (painter's algorithm)
    if (fillPathOps.isNotEmpty) {
      final Paint fillPaintCached = _getCachedPaint(fillPaint, PaintingStyle.fill);
      for (final OpSet drawing in fillPathOps) {
        final Path fillPath = _drawToContextOptimized(drawing)..close();
        drawPath(fillPath, fillPaintCached);
      }
    }
    
    // Draw fill sketches
    if (fillSketchOps.isNotEmpty) {
      final Paint fillPaintCached = _getCachedPaint(fillPaint, null);
      for (final OpSet drawing in fillSketchOps) {
        drawPath(_drawToContextOptimized(drawing), fillPaintCached);
      }
    }
    
    // Draw paths last
    if (pathOps.isNotEmpty) {
      final Paint pathPaintCached = _getCachedPaint(pathPaint, null);
      for (final OpSet drawing in pathOps) {
        drawPath(_drawToContextOptimized(drawing), pathPaintCached);
      }
    }
  }
  
  /// Clear caches - useful for memory management
  static void clearWebOptimizationCaches() {
    _pathCache.clear();
    _paintCache.clear();
  }
  
  /// Get cache statistics for debugging
  static Map<String, int> getCacheStats() {
    return {
      'pathCacheSize': _pathCache.length,
      'paintCacheSize': _paintCache.length,
    };
  }
}

/// Web-specific rough canvas utilities
class RoughWebUtils {
  /// Check if running on web platform
  static bool get isWeb => kIsWeb;
  
  /// Optimized drawing method that chooses the best approach based on platform
  static void drawRoughAdaptive(
    Canvas canvas,
    Drawable drawable, 
    Paint pathPaint, 
    Paint fillPaint
  ) {
    if (isWeb) {
      canvas.drawRoughOptimized(drawable, pathPaint, fillPaint);
    } else {
      // Use standard Rough extension for non-web platforms
      canvas.drawRough(drawable, pathPaint, fillPaint);
    }
  }
  
  /// Performance monitoring for web
  static void measureDrawingPerformance(
    Canvas canvas,
    Drawable drawable,
    Paint pathPaint,
    Paint fillPaint,
    {String? label}
  ) {
    if (isWeb) {
      final stopwatch = Stopwatch()..start();
      canvas.drawRoughOptimized(drawable, pathPaint, fillPaint);
      stopwatch.stop();
      
      if (kDebugMode) {
        print('${label ?? 'Drawing'} took ${stopwatch.elapsedMicroseconds}μs');
      }
    } else {
      // Use standard Rough extension for non-web platforms
      canvas.drawRough(drawable, pathPaint, fillPaint);
    }
  }
}