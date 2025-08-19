import 'dart:async';

import 'package:flutter/foundation.dart';

import 'core.dart';
import 'entities.dart';
import 'filler.dart';
import 'generator.dart';
import 'config.dart';
import 'fillers/filler_registry.dart';
import 'lazy_loading_manager.dart';

/// Web-optimized generator that uses lazy loading for better performance
class WebOptimizedGenerator extends Generator {
  static bool _initialized = false;
  
  WebOptimizedGenerator([DrawConfig? config, Filler? filler]) 
      : super(config ?? DrawConfig.defaultValues, 
              filler ?? NoFiller(FillerConfig.defaultConfig)) {
    _ensureInitialized();
  }
  
  /// Initialize the web optimizations
  static Future<void> initialize({
    LoadingStrategy strategy = LoadingStrategy.progressive,
  }) async {
    if (_initialized) return;
    
    await LazyLoadingManager.instance.initialize(strategy: strategy);
    _initialized = true;
  }
  
  /// Ensure the system is initialized with defaults
  static void _ensureInitialized() {
    if (!_initialized) {
      // Initialize synchronously with onDemand strategy as fallback
      LazyLoadingManager.instance.initialize(
        strategy: LoadingStrategy.onDemand,
      ).catchError((e) {
        if (kDebugMode) {
          print('Failed to initialize lazy loading: $e');
        }
      });
      _initialized = true;
    }
  }
  
  /// Create a generator with a lazy-loaded filler
  static Future<WebOptimizedGenerator> withLazyFiller(
    String fillerName,
    FillerConfig fillerConfig, [
    DrawConfig? drawConfig,
  ]) async {
    _ensureInitialized();
    
    // Track usage for progressive loading optimization
    LazyLoadingManager.instance.trackUsage(fillerName);
    
    // Get the filler constructor
    final fillerConstructor = await FillerRegistry.getFiller(fillerName);
    final filler = fillerConstructor(fillerConfig);
    
    return WebOptimizedGenerator(drawConfig, filler);
  }
  
  /// Create a generator with a lazy filler (non-blocking)
  static WebOptimizedGenerator withLazyFillerSync(
    String fillerName,
    FillerConfig fillerConfig, [
    DrawConfig? drawConfig,
  ]) {
    _ensureInitialized();
    
    // Track usage
    LazyLoadingManager.instance.trackUsage(fillerName);
    
    // Try to get filler synchronously
    final fillerConstructor = FillerRegistry.getFillerSync(fillerName);
    if (fillerConstructor != null) {
      final filler = fillerConstructor(fillerConfig);
      return WebOptimizedGenerator(drawConfig, filler);
    }
    
    // Fall back to NoFiller if not available
    if (kDebugMode) {
      print('Filler $fillerName not loaded, falling back to NoFiller');
    }
    
    final fallbackFiller = NoFiller(fillerConfig);
    return WebOptimizedGenerator(drawConfig, fallbackFiller);
  }
  
  /// Check if a filler is available for immediate use
  static bool isFillerAvailable(String fillerName) {
    return FillerRegistry.isLoaded(fillerName);
  }
  
  /// Check if a filler is currently loading
  static bool isFillerLoading(String fillerName) {
    return FillerRegistry.isLoading(fillerName);
  }
  
  /// Preload specific fillers for better performance
  static Future<void> preloadFillers(List<String> fillerNames) async {
    _ensureInitialized();
    await FillerRegistry.preloadFillers(fillerNames);
  }
  
  /// Get all available filler names
  static List<String> getAvailableFillers() {
    _ensureInitialized();
    return FillerRegistry.getAvailableFillers();
  }
  
  /// Get statistics about the lazy loading system
  static Map<String, dynamic> getLoadingStats() {
    return LazyLoadingManager.instance.getStats();
  }
}

/// Async filler wrapper that handles loading states
class AsyncFillerWrapper {
  final String name;
  final FillerConfig config;
  final Completer<Filler> _completer = Completer<Filler>();
  
  bool _loading = false;
  Filler? _filler;
  
  AsyncFillerWrapper(this.name, this.config);
  
  /// Get the filler, loading if necessary
  Future<Filler> get filler async {
    if (_filler != null) return _filler!;
    
    if (!_loading) {
      _loading = true;
      _loadFiller();
    }
    
    return _completer.future;
  }
  
  /// Try to get the filler synchronously
  Filler? get fillerSync => _filler;
  
  /// Check if the filler is loaded
  bool get isLoaded => _filler != null;
  
  /// Check if the filler is currently loading
  bool get isLoading => _loading && !isLoaded;
  
  /// Load the filler asynchronously
  void _loadFiller() async {
    try {
      LazyLoadingManager.instance.trackUsage(name);
      
      final constructor = await FillerRegistry.getFiller(name);
      _filler = constructor(config);
      
      if (!_completer.isCompleted) {
        _completer.complete(_filler!);
      }
    } catch (e) {
      if (!_completer.isCompleted) {
        _completer.completeError(e);
      }
    }
  }
}

/// Builder pattern for creating web-optimized generators
class WebGeneratorBuilder {
  DrawConfig? _drawConfig;
  String? _fillerName;
  FillerConfig? _fillerConfig;
  
  /// Set the draw configuration
  WebGeneratorBuilder withDrawConfig(DrawConfig config) {
    _drawConfig = config;
    return this;
  }
  
  /// Set the filler by name (will be loaded lazily)
  WebGeneratorBuilder withFiller(String name, FillerConfig config) {
    _fillerName = name;
    _fillerConfig = config;
    return this;
  }
  
  /// Build the generator asynchronously
  Future<WebOptimizedGenerator> build() async {
    if (_fillerName != null && _fillerConfig != null) {
      return WebOptimizedGenerator.withLazyFiller(
        _fillerName!,
        _fillerConfig!,
        _drawConfig,
      );
    }
    
    // Default to NoFiller if no filler specified
    final defaultFiller = NoFiller(_fillerConfig ?? FillerConfig.defaultConfig);
    return WebOptimizedGenerator(_drawConfig, defaultFiller);
  }
  
  /// Build the generator synchronously (may use fallback filler)
  WebOptimizedGenerator buildSync() {
    if (_fillerName != null && _fillerConfig != null) {
      return WebOptimizedGenerator.withLazyFillerSync(
        _fillerName!,
        _fillerConfig!,
        _drawConfig,
      );
    }
    
    // Default to NoFiller if no filler specified
    final defaultFiller = NoFiller(_fillerConfig ?? FillerConfig.defaultConfig);
    return WebOptimizedGenerator(_drawConfig, defaultFiller);
  }
}