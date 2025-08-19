import 'dart:async';

import 'package:flutter/foundation.dart';

import 'fillers/filler_registry.dart';
import 'fillers/basic_fillers.dart';
import 'fillers/advanced_fillers.dart';
import 'fillers/experimental_fillers.dart';

/// Strategy for loading fillers
enum LoadingStrategy {
  /// Load only when requested
  onDemand,
  /// Preload common fillers after initialization
  preloadCommon,
  /// Preload all available fillers
  preloadAll,
  /// Load progressively based on usage patterns
  progressive,
}

/// Manages lazy loading of filler algorithms and other complex components
class LazyLoadingManager {
  static LazyLoadingManager? _instance;
  static LazyLoadingManager get instance => _instance ??= LazyLoadingManager._();
  
  LazyLoadingManager._();
  
  LoadingStrategy _strategy = LoadingStrategy.onDemand;
  bool _initialized = false;
  final Map<String, DateTime> _usageTracking = {};
  final Set<String> _preloadedCategories = {};
  
  /// Initialize the lazy loading system
  Future<void> initialize({
    LoadingStrategy strategy = LoadingStrategy.onDemand,
  }) async {
    if (_initialized) return;
    
    _strategy = strategy;
    
    // Register all filler modules
    BasicFillers.registerAll();
    AdvancedFillers.registerAll();
    ExperimentalFillers.registerAll();
    CustomExperimentalFillers.registerAll();
    
    // Apply loading strategy
    switch (strategy) {
      case LoadingStrategy.onDemand:
        // Do nothing - load only when requested
        break;
        
      case LoadingStrategy.preloadCommon:
        unawaited(_preloadCommonFillers());
        break;
        
      case LoadingStrategy.preloadAll:
        unawaited(_preloadAllFillers());
        break;
        
      case LoadingStrategy.progressive:
        unawaited(_startProgressiveLoading());
        break;
    }
    
    _initialized = true;
    
    if (kDebugMode) {
      print('LazyLoadingManager initialized with strategy: $strategy');
      _logStats();
    }
  }
  
  /// Preload common fillers in the background
  Future<void> _preloadCommonFillers() async {
    if (_preloadedCategories.contains('common')) return;
    
    try {
      await AdvancedFillers.preloadCommon();
      _preloadedCategories.add('common');
      
      if (kDebugMode) {
        print('Common fillers preloaded');
        _logStats();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to preload common fillers: $e');
      }
    }
  }
  
  /// Preload all available fillers
  Future<void> _preloadAllFillers() async {
    if (_preloadedCategories.contains('all')) return;
    
    try {
      await Future.wait([
        AdvancedFillers.preloadAll(),
        ExperimentalFillers.preloadAll(),
      ]);
      
      _preloadedCategories.add('all');
      
      if (kDebugMode) {
        print('All fillers preloaded');
        _logStats();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to preload all fillers: $e');
      }
    }
  }
  
  /// Start progressive loading based on usage patterns
  Future<void> _startProgressiveLoading() async {
    // Start with common fillers
    await _preloadCommonFillers();
    
    // Schedule progressive loading of remaining fillers
    Timer(const Duration(seconds: 2), () {
      unawaited(_preloadAllFillers());
    });
  }
  
  /// Track usage of a filler for progressive loading optimization
  void trackUsage(String fillerName) {
    _usageTracking[fillerName] = DateTime.now();
    
    // If a filler is used and not loaded, prioritize similar fillers
    if (!FillerRegistry.isLoaded(fillerName)) {
      unawaited(_preloadRelatedFillers(fillerName));
    }
  }
  
  /// Preload fillers related to the one being used
  Future<void> _preloadRelatedFillers(String fillerName) async {
    final related = _getRelatedFillers(fillerName);
    
    try {
      await FillerRegistry.preloadFillers(related);
    } catch (e) {
      if (kDebugMode) {
        print('Failed to preload related fillers for $fillerName: $e');
      }
    }
  }
  
  /// Get fillers related to the given filler name
  List<String> _getRelatedFillers(String fillerName) {
    // Define filler relationships for intelligent preloading
    const relationships = {
      'HachureFiller': ['ZigZagFiller', 'CrossHatchFiller'],
      'ZigZagFiller': ['HachureFiller', 'DashedFiller'],
      'DashedFiller': ['DotDashFiller', 'ZigZagFiller'],
      'DotFiller': ['DotDashFiller', 'HachureFiller'],
      'CrossHatchFiller': ['HachureFiller', 'HatchFiller'],
    };
    
    return relationships[fillerName] ?? [];
  }
  
  /// Get loading statistics
  Map<String, dynamic> getStats() {
    final registryStats = FillerRegistry.getStats();
    
    return {
      'strategy': _strategy.name,
      'initialized': _initialized,
      'preloadedCategories': _preloadedCategories.length,
      'usageTracking': _usageTracking.length,
      'registry': registryStats,
      'mostUsedFillers': _getMostUsedFillers(),
    };
  }
  
  /// Get most frequently used fillers
  List<String> _getMostUsedFillers({int limit = 5}) {
    final entries = _usageTracking.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return entries.take(limit).map((e) => e.key).toList();
  }
  
  /// Log current statistics (debug mode only)
  void _logStats() {
    if (!kDebugMode) return;
    
    final stats = getStats();
    print('LazyLoadingManager stats: $stats');
  }
  
  /// Force preload a specific category
  Future<void> preloadCategory(String category) async {
    if (_preloadedCategories.contains(category)) return;
    
    switch (category) {
      case 'common':
        await _preloadCommonFillers();
        break;
      case 'advanced':
        await AdvancedFillers.preloadAll();
        _preloadedCategories.add('advanced');
        break;
      case 'experimental':
        await ExperimentalFillers.preloadAll();
        _preloadedCategories.add('experimental');
        break;
      case 'all':
        await _preloadAllFillers();
        break;
      default:
        throw ArgumentError('Unknown category: $category');
    }
  }
  
  /// Check if a category is preloaded
  bool isCategoryPreloaded(String category) {
    return _preloadedCategories.contains(category);
  }
  
  /// Reset the manager (useful for testing)
  void reset() {
    _initialized = false;
    _usageTracking.clear();
    _preloadedCategories.clear();
    FillerRegistry.clear();
  }
}

