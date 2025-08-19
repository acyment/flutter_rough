import 'dart:async';

import 'package:flutter/foundation.dart';

import '../entities.dart';
import '../filler.dart';

/// Registry for lazy-loaded filler implementations
/// 
/// This registry manages dynamic loading of filler algorithms to reduce
/// initial bundle size and improve startup performance.
class FillerRegistry {
  static final Map<String, Filler Function(FillerConfig)> _staticFillers = {};
  static final Map<String, Future<Filler Function(FillerConfig)>> _loadingFillers = {};
  static final Map<String, Filler Function(FillerConfig)> _loadedFillers = {};
  
  /// Register a statically available filler (included in main bundle)
  static void registerStatic(String name, Filler Function(FillerConfig) constructor) {
    _staticFillers[name] = constructor;
  }
  
  /// Register a dynamically loadable filler
  static void registerDynamic(
    String name, 
    Future<Filler Function(FillerConfig)> Function() loader
  ) {
    // Store the loader function for later use
    _dynamicLoaders[name] = loader;
  }
  
  static final Map<String, Future<Filler Function(FillerConfig)> Function()> _dynamicLoaders = {};
  
  /// Get a filler constructor, loading dynamically if needed
  static Future<Filler Function(FillerConfig)> getFiller(String name) async {
    // Check if already loaded
    if (_loadedFillers.containsKey(name)) {
      return _loadedFillers[name]!;
    }
    
    // Check static fillers
    if (_staticFillers.containsKey(name)) {
      final constructor = _staticFillers[name]!;
      _loadedFillers[name] = constructor;
      return constructor;
    }
    
    // Check if currently loading
    if (_loadingFillers.containsKey(name)) {
      return await _loadingFillers[name]!;
    }
    
    // Load dynamically
    if (_dynamicLoaders.containsKey(name)) {
      final loadingFuture = _dynamicLoaders[name]!();
      _loadingFillers[name] = loadingFuture;
      
      try {
        final constructor = await loadingFuture;
        _loadedFillers[name] = constructor;
        _loadingFillers.remove(name);
        return constructor;
      } catch (e) {
        _loadingFillers.remove(name);
        if (kDebugMode) {
          print('Failed to load filler $name: $e');
        }
        rethrow;
      }
    }
    
    throw ArgumentError('Filler "$name" not found in registry');
  }
  
  /// Get a filler constructor synchronously (only works for loaded fillers)
  static Filler Function(FillerConfig)? getFillerSync(String name) {
    return _loadedFillers[name] ?? _staticFillers[name];
  }
  
  /// Check if a filler is available (loaded or can be loaded)
  static bool isAvailable(String name) {
    return _loadedFillers.containsKey(name) || 
           _staticFillers.containsKey(name) || 
           _dynamicLoaders.containsKey(name);
  }
  
  /// Check if a filler is currently loaded
  static bool isLoaded(String name) {
    return _loadedFillers.containsKey(name) || _staticFillers.containsKey(name);
  }
  
  /// Check if a filler is currently loading
  static bool isLoading(String name) {
    return _loadingFillers.containsKey(name);
  }
  
  /// Get all available filler names
  static List<String> getAvailableFillers() {
    final Set<String> names = {};
    names.addAll(_staticFillers.keys);
    names.addAll(_loadedFillers.keys);
    names.addAll(_dynamicLoaders.keys);
    return names.toList()..sort();
  }
  
  /// Get all currently loaded filler names
  static List<String> getLoadedFillers() {
    final Set<String> names = {};
    names.addAll(_staticFillers.keys);
    names.addAll(_loadedFillers.keys);
    return names.toList()..sort();
  }
  
  /// Preload a set of fillers
  static Future<void> preloadFillers(List<String> names) async {
    final futures = names
        .where((name) => !isLoaded(name) && isAvailable(name))
        .map((name) => getFiller(name));
    
    await Future.wait(futures);
  }
  
  /// Clear the registry (useful for testing)
  static void clear() {
    _staticFillers.clear();
    _loadedFillers.clear();
    _loadingFillers.clear();
    _dynamicLoaders.clear();
  }
  
  /// Get registry statistics
  static Map<String, dynamic> getStats() {
    return {
      'staticFillers': _staticFillers.length,
      'loadedFillers': _loadedFillers.length,
      'loadingFillers': _loadingFillers.length,
      'dynamicLoaders': _dynamicLoaders.length,
      'totalAvailable': getAvailableFillers().length,
    };
  }
}

/// Wrapper for a filler that may not be loaded yet
class LazyFiller {
  final String name;
  final FillerConfig config;
  Filler? _instance;
  
  LazyFiller(this.name, this.config);
  
  /// Get the filler instance, loading if necessary
  Future<Filler> getInstance() async {
    if (_instance != null) return _instance!;
    
    final constructor = await FillerRegistry.getFiller(name);
    _instance = constructor(config);
    return _instance!;
  }
  
  /// Get the filler instance synchronously if available
  Filler? getInstanceSync() {
    if (_instance != null) return _instance!;
    
    final constructor = FillerRegistry.getFillerSync(name);
    if (constructor != null) {
      _instance = constructor(config);
      return _instance!;
    }
    
    return null;
  }
  
  /// Check if the filler is loaded
  bool get isLoaded => _instance != null;
  
  /// Check if the filler is available to load
  bool get isAvailable => FillerRegistry.isAvailable(name);
}