# Flutter Rough - Web API Reference

## 📚 Complete API Documentation

This reference covers all web optimization APIs added in Phases 1-3 of the flutter_rough web support system.

## 📋 Table of Contents

1. [Core Web APIs](#core-web-apis)
2. [Mobile Web APIs](#mobile-web-apis)
3. [Lazy Loading APIs](#lazy-loading-apis)
4. [UI Components](#ui-components)
5. [Performance APIs](#performance-apis)
6. [Utility Classes](#utility-classes)
7. [Extensions](#extensions)
8. [Enums](#enums)

---

## Core Web APIs

### `RoughWebUtils`

Provides web-specific utilities and adaptive drawing methods.

```dart
class RoughWebUtils {
  /// Check if running on web platform
  static bool get isWeb;
  
  /// Optimized drawing method that chooses the best approach based on platform
  static void drawRoughAdaptive(
    Canvas canvas,
    Drawable drawable, 
    Paint pathPaint, 
    Paint fillPaint
  );
  
  /// Performance monitoring for web
  static void measureDrawingPerformance(
    Canvas canvas,
    Drawable drawable,
    Paint pathPaint,
    Paint fillPaint,
    {String? label}
  );
}
```

**Example:**
```dart
// Automatically uses web-optimized drawing on web platforms
RoughWebUtils.drawRoughAdaptive(
  canvas, 
  drawable, 
  strokePaint, 
  fillPaint
);

// Monitor drawing performance
RoughWebUtils.measureDrawingPerformance(
  canvas,
  drawable,
  strokePaint,
  fillPaint,
  label: 'Rectangle drawing',
);
```

### `RoughWebOptimized` Extension

Canvas extension with web-specific optimizations including path caching and paint object reuse.

```dart
extension RoughWebOptimized on Canvas {
  /// Web-optimized rough drawing with performance enhancements
  void drawRoughOptimized(Drawable drawable, Paint pathPaint, Paint fillPaint);
  
  /// Clear optimization caches - useful for memory management
  static void clearWebOptimizationCaches();
  
  /// Get cache statistics for debugging
  static Map<String, int> getCacheStats();
}
```

**Example:**
```dart
// Use web-optimized drawing directly
canvas.drawRoughOptimized(drawable, strokePaint, fillPaint);

// Check cache performance
final stats = RoughWebOptimized.getCacheStats();
print('Path cache size: ${stats['pathCacheSize']}');

// Clear caches when needed
RoughWebOptimized.clearWebOptimizationCaches();
```

---

## Mobile Web APIs

### `RoughMobileWeb`

Core mobile web detection and optimization system.

```dart
class RoughMobileWeb {
  /// Initialize mobile web detection
  static void initialize();
  
  /// Check if currently on mobile web
  static bool get isMobileWeb;
  
  /// Get optimized canvas size for mobile web
  static Size getOptimizedCanvasSize(Size requestedSize);
  
  /// Get mobile-optimized drawing configuration
  static Map<String, dynamic> getMobileOptimizedConfig();
}
```

**Properties:**
- `isMobileWeb`: Returns `true` if running on mobile web browser
- Canvas size optimization: Limits to 800px on mobile for better performance
- Configuration optimization: Reduces complexity on mobile devices

**Example:**
```dart
void main() {
  // Always initialize in main()
  RoughMobileWeb.initialize();
  runApp(MyApp());
}

// Check if on mobile web
if (RoughMobileWeb.isMobileWeb) {
  // Mobile-specific behavior
}

// Optimize canvas size
final Size optimizedSize = RoughMobileWeb.getOptimizedCanvasSize(
  Size(1200, 900) // Will be scaled down to max 800px on mobile
);

// Get mobile config
final config = RoughMobileWeb.getMobileOptimizedConfig();
// Returns: {
//   'reducedComplexity': true/false,
//   'maxPathOperations': 500/1000,
//   'enableCaching': true/false,
//   'throttleUpdates': true/false,
// }
```

### `RoughMobileWebPainter`

Base class for mobile-aware custom painters with automatic optimization.

```dart
abstract class RoughMobileWebPainter extends CustomPainter {
  /// Paint with mobile web optimizations
  @override
  void paint(Canvas canvas, Size size);
  
  /// Override this method to implement rough painting
  void paintRough(Canvas canvas, Size size, Map<String, dynamic> config);
}
```

**Usage:**
```dart
class MyPainter extends RoughMobileWebPainter {
  @override
  void paintRough(Canvas canvas, Size size, Map<String, dynamic> config) {
    // Your painting code here
    // Automatically gets mobile-optimized canvas size and configuration
    
    final bool isReduced = config['reducedComplexity'] ?? false;
    final int maxOps = config['maxPathOperations'] ?? 1000;
    
    // Adapt drawing based on mobile configuration
    if (isReduced) {
      // Simplified drawing for mobile
    }
  }
}
```

### `RoughMobileLayout`

Responsive layout component that automatically switches between desktop and mobile layouts.

```dart
class RoughMobileLayout extends StatelessWidget {
  const RoughMobileLayout({
    super.key,
    required this.child,
    this.mobileChild,
  });
  
  final Widget child;
  final Widget? mobileChild;
  
  @override
  Widget build(BuildContext context);
}
```

**Parameters:**
- `child`: Widget shown on desktop (or mobile if no `mobileChild`)
- `mobileChild`: Optional widget shown on mobile (screen width < 768px)

**Example:**
```dart
RoughMobileLayout(
  child: DesktopControls(
    // Desktop layout with smaller controls
    sliderHeight: 40,
    fontSize: 14,
  ),
  mobileChild: MobileControls(
    // Mobile layout with larger touch targets
    sliderHeight: 60,
    fontSize: 16,
  ),
)
```

---

## Lazy Loading APIs

### `WebOptimizedGenerator`

Enhanced generator with lazy loading capabilities for optimal performance.

```dart
class WebOptimizedGenerator extends Generator {
  /// Initialize the web optimization system
  static Future<void> initialize({
    LoadingStrategy strategy = LoadingStrategy.progressive,
  });
  
  /// Create generator with lazy-loaded filler
  static Future<WebOptimizedGenerator> withLazyFiller(
    String fillerName,
    FillerConfig fillerConfig, [
    DrawConfig? drawConfig,
  ]);
  
  /// Create generator with sync fallback
  static WebOptimizedGenerator withLazyFillerSync(
    String fillerName,
    FillerConfig fillerConfig, [
    DrawConfig? drawConfig,
  ]);
  
  /// Check if a filler is available for immediate use
  static bool isFillerAvailable(String fillerName);
  
  /// Check if a filler is currently loading
  static bool isFillerLoading(String fillerName);
  
  /// Preload specific fillers
  static Future<void> preloadFillers(List<String> fillerNames);
  
  /// Get all available filler names
  static List<String> getAvailableFillers();
  
  /// Get loading statistics
  static Map<String, dynamic> getLoadingStats();
}
```

**Loading Methods:**

**Async Loading (Recommended):**
```dart
try {
  final generator = await WebOptimizedGenerator.withLazyFiller(
    'ZigZagFiller',
    fillerConfig,
    drawConfig,
  );
  // Use generator
} catch (e) {
  // Handle loading error
}
```

**Sync Loading with Fallback:**
```dart
final generator = WebOptimizedGenerator.withLazyFillerSync(
  'ZigZagFiller',
  fillerConfig,
  drawConfig,
);
// If ZigZagFiller isn't loaded, falls back to NoFiller
```

**Preloading:**
```dart
// Preload specific fillers
await WebOptimizedGenerator.preloadFillers([
  'ZigZagFiller',
  'DashedFiller',
  'CrossHatchFiller',
]);

// Check availability
final available = WebOptimizedGenerator.getAvailableFillers();
final isLoaded = WebOptimizedGenerator.isFillerAvailable('ZigZagFiller');
final isLoading = WebOptimizedGenerator.isFillerLoading('ZigZagFiller');
```

### `FillerRegistry`

Registry system for managing dynamic filler loading.

```dart
class FillerRegistry {
  /// Register a statically available filler
  static void registerStatic(String name, Filler Function(FillerConfig) constructor);
  
  /// Register a dynamically loadable filler
  static void registerDynamic(
    String name, 
    Future<Filler Function(FillerConfig)> Function() loader
  );
  
  /// Get a filler constructor, loading dynamically if needed
  static Future<Filler Function(FillerConfig)> getFiller(String name);
  
  /// Get a filler constructor synchronously (only works for loaded fillers)
  static Filler Function(FillerConfig)? getFillerSync(String name);
  
  /// Check if a filler is available
  static bool isAvailable(String name);
  
  /// Check if a filler is currently loaded
  static bool isLoaded(String name);
  
  /// Check if a filler is currently loading
  static bool isLoading(String name);
  
  /// Get all available filler names
  static List<String> getAvailableFillers();
  
  /// Preload a set of fillers
  static Future<void> preloadFillers(List<String> names);
  
  /// Get registry statistics
  static Map<String, dynamic> getStats();
}
```

**Example:**
```dart
// Register a custom filler for dynamic loading
FillerRegistry.registerDynamic('MyCustomFiller', () async {
  // Simulate loading time
  await Future.delayed(Duration(milliseconds: 50));
  return MyCustomFiller.new;
});

// Load and use
final constructor = await FillerRegistry.getFiller('MyCustomFiller');
final filler = constructor(config);
```

### `LazyLoadingManager`

Manages loading strategies and optimization of filler preloading.

```dart
class LazyLoadingManager {
  static LazyLoadingManager get instance;
  
  /// Initialize with loading strategy
  Future<void> initialize({
    LoadingStrategy strategy = LoadingStrategy.onDemand,
  });
  
  /// Track filler usage for optimization
  void trackUsage(String fillerName);
  
  /// Force preload a category
  Future<void> preloadCategory(String category);
  
  /// Check if a category is preloaded
  bool isCategoryPreloaded(String category);
  
  /// Get loading statistics
  Map<String, dynamic> getStats();
}
```

**Categories:**
- `'common'`: Frequently used fillers (ZigZag, Dashed)
- `'advanced'`: All advanced fillers
- `'experimental'`: All experimental fillers
- `'all'`: Every available filler

**Example:**
```dart
// Initialize with progressive loading
await LazyLoadingManager.instance.initialize(
  strategy: LoadingStrategy.progressive,
);

// Track usage for intelligent preloading
LazyLoadingManager.instance.trackUsage('HachureFiller');
// This will automatically preload related fillers: ZigZag, CrossHatch

// Force preload categories
await LazyLoadingManager.instance.preloadCategory('common');

// Get comprehensive statistics
final stats = LazyLoadingManager.instance.getStats();
```

### `LazyFiller`

Wrapper for fillers that may not be loaded yet.

```dart
class LazyFiller {
  LazyFiller(this.name, this.config);
  
  final String name;
  final FillerConfig config;
  
  /// Get the filler instance, loading if necessary
  Future<Filler> getInstance();
  
  /// Get the filler instance synchronously if available
  Filler? getInstanceSync();
  
  /// Check if the filler is loaded
  bool get isLoaded;
  
  /// Check if the filler is available to load
  bool get isAvailable;
}
```

**Example:**
```dart
final lazyFiller = LazyFiller('ZigZagFiller', config);

if (lazyFiller.isLoaded) {
  final filler = lazyFiller.getInstanceSync()!;
  // Use immediately
} else {
  // Show loading UI
  showLoadingIndicator();
  
  final filler = await lazyFiller.getInstance();
  hideLoadingIndicator();
  // Use filler
}
```

---

## UI Components

### `RoughMobileSlider`

Touch-optimized slider with larger targets for mobile web interaction.

```dart
class RoughMobileSlider extends StatefulWidget {
  const RoughMobileSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.label,
    this.onChanged,
  });
  
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String label;
  final ValueChanged<double>? onChanged;
}
```

**Mobile Optimizations:**
- **Thumb radius**: 16px (vs 12px on desktop)
- **Track height**: 6px (vs 4px on desktop)  
- **Overlay radius**: 32px (vs 24px on desktop)
- **Typography**: 16px (vs 14px on desktop)

**Example:**
```dart
RoughMobileSlider(
  label: 'Roughness',
  value: roughness,
  min: 0.0,
  max: 5.0,
  divisions: 50,
  onChanged: (value) {
    setState(() => roughness = value);
    RoughMobileHaptics.lightImpact(); // Optional haptic feedback
  },
)
```

### `LazyFillerDropdown`

Dropdown with visual loading states for lazy-loaded fillers.

```dart
class LazyFillerDropdown extends StatefulWidget {
  const LazyFillerDropdown({
    super.key,
    this.value,
    this.onChanged,
    this.availableFillers = const [],
    this.loadingBuilder,
    this.errorBuilder,
  });
  
  final String? value;
  final ValueChanged<String?>? onChanged;
  final List<String> availableFillers;
  final Widget Function(String)? loadingBuilder;
  final Widget Function(String, String)? errorBuilder;
}
```

**Loading States:**
- **Loading**: Shows spinner and "Loading..." text
- **Loaded**: Shows checkmark icon
- **Available**: Shows download icon
- **Error**: Shows error icon with message

**Example:**
```dart
LazyFillerDropdown(
  value: selectedFiller,
  availableFillers: ['NoFiller', 'HachureFiller', 'ZigZagFiller'],
  onChanged: (filler) => setState(() => selectedFiller = filler),
  loadingBuilder: (name) => Row(
    children: [
      SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      SizedBox(width: 8),
      Text('Loading $name...'),
    ],
  ),
  errorBuilder: (name, error) => Row(
    children: [
      Icon(Icons.error, color: Colors.red, size: 16),
      SizedBox(width: 8),
      Text('Failed: $name'),
    ],
  ),
)
```

### `LoadingProgressIndicator`

Shows real-time loading progress of the lazy loading system.

```dart
class LoadingProgressIndicator extends StatefulWidget {
  const LoadingProgressIndicator({
    super.key,
    this.builder,
    this.updateInterval = const Duration(milliseconds: 500),
  });
  
  final Widget Function(LoadingProgressData)? builder;
  final Duration updateInterval;
}
```

**LoadingProgressData:**
```dart
class LoadingProgressData {
  final int totalFillers;
  final int loadedFillers;
  final int loadingFillers;
  final String strategy;
  final int preloadedCategories;
  
  // Computed properties
  double get progress => totalFillers > 0 ? loadedFillers / totalFillers : 0.0;
  bool get isComplete => loadedFillers == totalFillers;
}
```

**Example:**
```dart
// Default progress indicator
LoadingProgressIndicator()

// Custom progress display
LoadingProgressIndicator(
  builder: (data) => Column(
    children: [
      LinearProgressIndicator(value: data.progress),
      Text('${data.loadedFillers}/${data.totalFillers} loaded'),
      if (data.loadingFillers > 0)
        Text('${data.loadingFillers} loading...'),
    ],
  ),
)
```

### `FillerPreloader`

Widget that preloads fillers in the background with loading UI.

```dart
class FillerPreloader extends StatefulWidget {
  const FillerPreloader({
    super.key,
    required this.fillersToPreload,
    required this.child,
    this.loadingBuilder,
  });
  
  final List<String> fillersToPreload;
  final Widget child;
  final Widget Function()? loadingBuilder;
}
```

**Example:**
```dart
FillerPreloader(
  fillersToPreload: ['ZigZagFiller', 'DashedFiller', 'CrossHatchFiller'],
  loadingBuilder: () => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text('Loading advanced fillers...'),
      ],
    ),
  ),
  child: MyDrawingCanvas(), // Shown after preloading completes
)
```

---

## Performance APIs

### `RoughMobilePerformance`

Performance monitoring system specifically designed for mobile web.

```dart
class RoughMobilePerformance {
  /// Record frame time for performance monitoring
  static void recordFrame();
  
  /// Get average frame time
  static Duration getAverageFrameTime();
  
  /// Check if performance is acceptable (under 16.67ms for 60fps)
  static bool isPerformanceGood();
  
  /// Get performance report
  static Map<String, dynamic> getPerformanceReport();
}
```

**Performance Report Structure:**
```dart
{
  'averageFrameTime': 12,        // milliseconds
  'estimatedFPS': 83,            // frames per second
  'isGoodPerformance': true,     // under 16.67ms average
  'isMobileWeb': false,          // platform detection
  'frameCount': 60,              // number of recorded frames
}
```

**Example:**
```dart
class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Record frame for monitoring
    RoughMobilePerformance.recordFrame();
    
    // Your painting code
    drawRoughContent(canvas, size);
    
    // Check performance periodically
    if (kDebugMode && Random().nextDouble() < 0.01) { // 1% of frames
      final report = RoughMobilePerformance.getPerformanceReport();
      if (!report['isGoodPerformance']) {
        print('Performance warning: ${report['averageFrameTime']}ms avg');
      }
    }
  }
}
```

### Performance Monitoring Best Practices

```dart
// Initialize monitoring
class MyApp extends StatefulWidget {
  @override
  void initState() {
    super.initState();
    
    // Start monitoring if in debug mode
    if (kDebugMode) {
      _startPerformanceMonitoring();
    }
  }
  
  void _startPerformanceMonitoring() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      final report = RoughMobilePerformance.getPerformanceReport();
      
      if (report['frameCount'] > 30) { // Enough data
        print('Performance: ${report['estimatedFPS']} FPS avg');
        
        if (!report['isGoodPerformance']) {
          print('⚠️ Performance below 60fps target');
        }
      }
    });
  }
}
```

---

## Utility Classes

### `RoughMobileHaptics`

Haptic feedback utilities for enhanced mobile web user experience.

```dart
class RoughMobileHaptics {
  /// Provide light haptic feedback if available
  static Future<void> lightImpact();
  
  /// Provide selection haptic feedback if available  
  static Future<void> selectionClick();
}
```

**Usage:**
```dart
// In slider onChanged
RoughMobileSlider(
  value: value,
  onChanged: (newValue) {
    updateValue(newValue);
    RoughMobileHaptics.lightImpact(); // Subtle feedback
  },
)

// In tab selection
TabBar(
  onTap: (index) {
    switchTab(index);
    RoughMobileHaptics.selectionClick(); // Selection feedback
  },
)
```

**Error Handling:**
The haptic methods safely handle platforms where haptic feedback is unavailable:
```dart
// Never throws exceptions - safe to call anywhere
await RoughMobileHaptics.lightImpact(); // Works or silently fails
```

### `WebGeneratorBuilder`

Builder pattern for creating web-optimized generators with fluent API.

```dart
class WebGeneratorBuilder {
  /// Set the draw configuration
  WebGeneratorBuilder withDrawConfig(DrawConfig config);
  
  /// Set the filler by name (will be loaded lazily)
  WebGeneratorBuilder withFiller(String name, FillerConfig config);
  
  /// Build the generator asynchronously
  Future<WebOptimizedGenerator> build();
  
  /// Build the generator synchronously (may use fallback filler)
  WebOptimizedGenerator buildSync();
}
```

**Example:**
```dart
// Fluent API for generator creation
final generator = await WebGeneratorBuilder()
    .withDrawConfig(DrawConfig.build(roughness: 2.0))
    .withFiller('ZigZagFiller', FillerConfig.build(hachureGap: 8))
    .build();

// Synchronous version with fallback
final generator = WebGeneratorBuilder()
    .withDrawConfig(drawConfig)
    .withFiller('AdvancedFiller', fillerConfig)
    .buildSync(); // Falls back to NoFiller if AdvancedFiller not loaded
```

### `AsyncFillerWrapper`

Wrapper that handles loading states for individual fillers.

```dart
class AsyncFillerWrapper {
  AsyncFillerWrapper(this.name, this.config);
  
  final String name;
  final FillerConfig config;
  
  /// Get the filler, loading if necessary
  Future<Filler> get filler;
  
  /// Try to get the filler synchronously
  Filler? get fillerSync;
  
  /// Check if the filler is loaded
  bool get isLoaded;
  
  /// Check if the filler is currently loading
  bool get isLoading;
}
```

**Example:**
```dart
final wrapper = AsyncFillerWrapper('ZigZagFiller', config);

// Use with StreamBuilder for reactive UI
StreamBuilder<bool>(
  stream: Stream.periodic(Duration(milliseconds: 100))
      .map((_) => wrapper.isLoaded),
  builder: (context, snapshot) {
    if (wrapper.isLoaded) {
      return CustomPaint(
        painter: MyPainter(wrapper.fillerSync!),
      );
    }
    
    if (wrapper.isLoading) {
      return CircularProgressIndicator();
    }
    
    return ElevatedButton(
      onPressed: () => wrapper.filler, // Trigger loading
      child: Text('Load ${wrapper.name}'),
    );
  },
)
```

---

## Extensions

### `RoughWebOptimized` Extension on `Canvas`

```dart
extension RoughWebOptimized on Canvas {
  /// Web-optimized drawing with caching
  void drawRoughOptimized(Drawable drawable, Paint pathPaint, Paint fillPaint);
  
  /// Clear optimization caches
  static void clearWebOptimizationCaches();
  
  /// Get cache statistics
  static Map<String, int> getCacheStats();
}
```

**Cache Statistics:**
```dart
final stats = RoughWebOptimized.getCacheStats();
// Returns:
{
  'pathCacheSize': 15,    // Number of cached paths
  'paintCacheSize': 8,    // Number of cached paint objects
}
```

**Memory Management:**
```dart
// Clear caches when memory is low
if (shouldClearCaches()) {
  RoughWebOptimized.clearWebOptimizationCaches();
}
```

---

## Enums

### `LoadingStrategy`

Defines different approaches to loading fillers for optimal performance.

```dart
enum LoadingStrategy {
  /// Load only when requested (fastest initial load, slowest when needed)
  onDemand,
  
  /// Preload common fillers after initialization (balanced approach)
  preloadCommon,
  
  /// Preload all available fillers (slowest initial, fastest when needed)
  preloadAll,
  
  /// Smart progressive loading based on usage patterns (recommended)
  progressive,
}
```

**Strategy Comparison:**

| Strategy | Initial Load | Memory Usage | Network | Best For |
|----------|-------------|--------------|---------|----------|
| `onDemand` | **Fastest** | **Lowest** | Most requests | Simple apps |
| `preloadCommon` | Fast | Medium | Balanced | Most apps |
| `preloadAll` | Slowest | **Highest** | **Fewest** | Power users |
| `progressive` | Balanced | Balanced | **Optimized** | **Recommended** |

**Usage:**
```dart
// Initialize with strategy
await WebOptimizedGenerator.initialize(
  strategy: LoadingStrategy.progressive, // Recommended default
);

// Strategy affects preloading behavior
switch (strategy) {
  case LoadingStrategy.onDemand:
    // Loads fillers only when explicitly requested
    break;
  case LoadingStrategy.preloadCommon:
    // Preloads: ZigZagFiller, DashedFiller
    break;
  case LoadingStrategy.preloadAll:
    // Preloads all available fillers in background
    break;
  case LoadingStrategy.progressive:
    // Starts with common, then progressively loads more
    break;
}
```

---

## Error Handling

### Common Error Types

```dart
// Filler loading errors
try {
  final generator = await WebOptimizedGenerator.withLazyFiller(
    'NonexistentFiller',
    config,
  );
} catch (e) {
  if (e is ArgumentError) {
    // Filler not found in registry
    print('Filler not available: ${e.message}');
  }
}

// Network/loading errors
try {
  await FillerRegistry.getFiller('RemoteFiller');
} catch (e) {
  // Could be network error, timeout, etc.
  print('Failed to load filler: $e');
  
  // Fallback to local filler
  final fallback = FillerRegistry.getFillerSync('NoFiller');
}
```

### Best Practices for Error Handling

```dart
// Always provide fallbacks
Future<WebOptimizedGenerator> createGenerator(String fillerName) async {
  try {
    return await WebOptimizedGenerator.withLazyFiller(fillerName, config);
  } catch (e) {
    // Log error but don't break user experience
    if (kDebugMode) print('Filler loading failed: $e');
    
    // Fallback to basic generator
    return WebOptimizedGenerator(config, NoFiller(FillerConfig.defaultConfig));
  }
}

// Use sync versions when appropriate
WebOptimizedGenerator createGeneratorSync(String fillerName) {
  final generator = WebOptimizedGenerator.withLazyFillerSync(
    fillerName,
    config,
  );
  
  // Check if fallback was used
  if (generator.filler is NoFiller && fillerName != 'NoFiller') {
    if (kDebugMode) print('$fillerName not loaded, using fallback');
  }
  
  return generator;
}
```

---

## Migration Examples

### From Basic to Web-Optimized

**Before:**
```dart
// Basic usage
final generator = Generator(drawConfig, HachureFiller(fillerConfig));
final drawable = generator.rectangle(10, 10, 100, 80);
canvas.drawRough(drawable, strokePaint, fillPaint);
```

**After:**
```dart
// Web-optimized with lazy loading
final generator = await WebOptimizedGenerator.withLazyFiller(
  'HachureFiller',
  fillerConfig,
  drawConfig,
);
final drawable = generator.rectangle(10, 10, 100, 80);
canvas.drawRoughOptimized(drawable, strokePaint, fillPaint);
```

### UI Component Migration

**Before:**
```dart
Slider(
  value: roughness,
  min: 0.0,
  max: 5.0,
  onChanged: (value) => setState(() => roughness = value),
)
```

**After:**
```dart
RoughMobileSlider(
  label: 'Roughness',
  value: roughness,
  min: 0.0,
  max: 5.0,
  divisions: 50,
  onChanged: (value) {
    setState(() => roughness = value);
    RoughMobileHaptics.lightImpact();
  },
)
```

---

This API reference provides comprehensive documentation for all web optimization features. For additional examples and usage patterns, see the [Web Optimization Guide](WEB_OPTIMIZATION_GUIDE.md).