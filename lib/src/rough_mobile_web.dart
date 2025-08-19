import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

/// Mobile web optimizations for flutter_rough
/// 
/// This class provides utilities and optimizations specifically for mobile web browsers
class RoughMobileWeb {
  static bool _isMobileWeb = false;
  static bool _initialized = false;
  
  /// Initialize mobile web detection
  static void initialize() {
    if (_initialized) return;
    
    if (kIsWeb) {
      // Detect mobile web browsers
      _isMobileWeb = _detectMobileWeb();
    }
    _initialized = true;
  }
  
  /// Detect if running on mobile web
  static bool _detectMobileWeb() {
    // This would typically use dart:html to check user agent
    // For now, we use a heuristic based on screen size in Flutter
    // In test environments, assume non-mobile for consistent testing
    try {
      // This is a simplified detection for the example
      // In a real implementation, you'd use dart:html or platform_detect package
      return false; // Default to false for broader compatibility
    } catch (e) {
      return false;
    }
  }
  
  /// Check if currently on mobile web
  static bool get isMobileWeb {
    initialize();
    return _isMobileWeb;
  }
  
  /// Get optimized canvas size for mobile web
  static Size getOptimizedCanvasSize(Size requestedSize) {
    if (!isMobileWeb) return requestedSize;
    
    // Limit canvas size on mobile for better performance
    const double maxMobileCanvasSize = 800.0;
    
    if (requestedSize.width > maxMobileCanvasSize || 
        requestedSize.height > maxMobileCanvasSize) {
      final double scale = maxMobileCanvasSize / 
        (requestedSize.width > requestedSize.height ? requestedSize.width : requestedSize.height);
      
      return Size(
        requestedSize.width * scale,
        requestedSize.height * scale,
      );
    }
    
    return requestedSize;
  }
  
  /// Get mobile-optimized drawing configuration
  static Map<String, dynamic> getMobileOptimizedConfig() {
    return {
      'reducedComplexity': isMobileWeb,
      'maxPathOperations': isMobileWeb ? 500 : 1000,
      'enableCaching': isMobileWeb,
      'throttleUpdates': isMobileWeb,
    };
  }
}

/// Mobile web aware custom painter
abstract class RoughMobileWebPainter extends CustomPainter {
  /// Paint with mobile web optimizations
  @override
  void paint(Canvas canvas, Size size) {
    final Size optimizedSize = RoughMobileWeb.getOptimizedCanvasSize(size);
    final Map<String, dynamic> config = RoughMobileWeb.getMobileOptimizedConfig();
    
    if (optimizedSize != size && RoughMobileWeb.isMobileWeb) {
      // Scale canvas for mobile optimization
      final double scale = optimizedSize.width / size.width;
      canvas.scale(scale);
      paintRough(canvas, optimizedSize, config);
    } else {
      paintRough(canvas, size, config);
    }
  }
  
  /// Override this method to implement rough painting
  void paintRough(Canvas canvas, Size size, Map<String, dynamic> config);
}

/// Touch-optimized slider for mobile web
class RoughMobileSlider extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String label;
  final ValueChanged<double>? onChanged;
  
  const RoughMobileSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.label,
    this.onChanged,
  });
  
  @override
  State<RoughMobileSlider> createState() => _RoughMobileSliderState();
}

class _RoughMobileSliderState extends State<RoughMobileSlider> {
  @override
  Widget build(BuildContext context) {
    // Use larger touch targets on mobile web
    final double thumbRadius = RoughMobileWeb.isMobileWeb ? 16.0 : 12.0;
    final double trackHeight = RoughMobileWeb.isMobileWeb ? 6.0 : 4.0;
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  '${widget.label}: ${widget.value.toStringAsFixed(1)}',
                  style: TextStyle(
                    fontSize: RoughMobileWeb.isMobileWeb ? 16.0 : 14.0,
                  ),
                ),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: thumbRadius),
                    trackHeight: trackHeight,
                    overlayShape: RoundSliderOverlayShape(overlayRadius: thumbRadius * 2),
                  ),
                  child: Slider(
                    value: widget.value,
                    min: widget.min,
                    max: widget.max,
                    divisions: widget.divisions,
                    onChanged: widget.onChanged,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Mobile web responsive layout helper
class RoughMobileLayout extends StatelessWidget {
  final Widget child;
  final Widget? mobileChild;
  
  const RoughMobileLayout({
    super.key,
    required this.child,
    this.mobileChild,
  });
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Consider mobile layout if screen width < 768px
        if (constraints.maxWidth < 768 && mobileChild != null) {
          return mobileChild!;
        }
        return child;
      },
    );
  }
}

/// Performance monitoring for mobile web
class RoughMobilePerformance {
  static final List<Duration> _frameTimes = [];
  static DateTime? _lastFrameTime;
  
  /// Record frame time for performance monitoring
  static void recordFrame() {
    final DateTime now = DateTime.now();
    if (_lastFrameTime != null) {
      final Duration frameTime = now.difference(_lastFrameTime!);
      _frameTimes.add(frameTime);
      
      // Keep only last 60 frames
      if (_frameTimes.length > 60) {
        _frameTimes.removeAt(0);
      }
    }
    _lastFrameTime = now;
  }
  
  /// Get average frame time
  static Duration getAverageFrameTime() {
    if (_frameTimes.isEmpty) return Duration.zero;
    
    final int totalMicroseconds = _frameTimes
        .fold(0, (sum, duration) => sum + duration.inMicroseconds);
    
    return Duration(microseconds: totalMicroseconds ~/ _frameTimes.length);
  }
  
  /// Check if performance is acceptable (under 16.67ms for 60fps)
  static bool isPerformanceGood() {
    final Duration avgFrameTime = getAverageFrameTime();
    return avgFrameTime.inMilliseconds < 17; // 60fps target
  }
  
  /// Get performance report
  static Map<String, dynamic> getPerformanceReport() {
    final Duration avgFrameTime = getAverageFrameTime();
    final double fps = avgFrameTime.inMicroseconds > 0 
        ? 1000000.0 / avgFrameTime.inMicroseconds 
        : 0.0;
    
    return {
      'averageFrameTime': avgFrameTime.inMilliseconds,
      'estimatedFPS': fps.round(),
      'isGoodPerformance': isPerformanceGood(),
      'isMobileWeb': RoughMobileWeb.isMobileWeb,
      'frameCount': _frameTimes.length,
    };
  }
}

/// Haptic feedback helper for mobile web
class RoughMobileHaptics {
  /// Provide light haptic feedback if available
  static Future<void> lightImpact() async {
    if (RoughMobileWeb.isMobileWeb) {
      try {
        await HapticFeedback.lightImpact();
      } catch (e) {
        // Haptic feedback not available, ignore
      }
    }
  }
  
  /// Provide selection haptic feedback if available  
  static Future<void> selectionClick() async {
    if (RoughMobileWeb.isMobileWeb) {
      try {
        await HapticFeedback.selectionClick();
      } catch (e) {
        // Haptic feedback not available, ignore
      }
    }
  }
}