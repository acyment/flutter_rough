import 'dart:async';

import 'package:flutter/material.dart';

import '../fillers/filler_registry.dart';
import '../lazy_loading_manager.dart';
import '../web_optimized_generator.dart';

/// A widget that shows loading states for lazy-loaded fillers
class LazyFillerDropdown extends StatefulWidget {
  final String? value;
  final ValueChanged<String?>? onChanged;
  final List<String> availableFillers;
  final Widget Function(String)? loadingBuilder;
  final Widget Function(String, String)? errorBuilder;
  
  const LazyFillerDropdown({
    super.key,
    this.value,
    this.onChanged,
    this.availableFillers = const [],
    this.loadingBuilder,
    this.errorBuilder,
  });
  
  @override
  State<LazyFillerDropdown> createState() => _LazyFillerDropdownState();
}

class _LazyFillerDropdownState extends State<LazyFillerDropdown> {
  final Map<String, bool> _loadingStates = {};
  final Map<String, String> _errorStates = {};
  
  @override
  void initState() {
    super.initState();
    _initializeLoadingStates();
  }
  
  void _initializeLoadingStates() {
    for (final filler in widget.availableFillers) {
      _loadingStates[filler] = FillerRegistry.isLoading(filler);
      
      // Listen for loading completion
      if (_loadingStates[filler]!) {
        _listenForLoadingCompletion(filler);
      }
    }
  }
  
  void _listenForLoadingCompletion(String fillerName) {
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted) {
        final isLoading = FillerRegistry.isLoading(fillerName);
        final isLoaded = FillerRegistry.isLoaded(fillerName);
        
        if (!isLoading && (isLoaded || _errorStates.containsKey(fillerName))) {
          timer.cancel();
          if (mounted) {
            setState(() {
              _loadingStates[fillerName] = false;
            });
          }
        }
      } else {
        timer.cancel();
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final availableFillers = widget.availableFillers.isEmpty
        ? FillerRegistry.getAvailableFillers()
        : widget.availableFillers;
    
    return DropdownButton<String>(
      value: widget.value,
      isExpanded: true,
      onChanged: (value) {
        if (value != null && !FillerRegistry.isLoaded(value)) {
          // Trigger loading
          _triggerFillerLoading(value);
        }
        widget.onChanged?.call(value);
      },
      items: availableFillers.map((fillerName) {
        return DropdownMenuItem<String>(
          value: fillerName,
          child: _buildDropdownItem(fillerName),
        );
      }).toList(),
    );
  }
  
  Widget _buildDropdownItem(String fillerName) {
    final isLoading = _loadingStates[fillerName] ?? false;
    final error = _errorStates[fillerName];
    final isLoaded = FillerRegistry.isLoaded(fillerName);
    
    if (error != null) {
      return widget.errorBuilder?.call(fillerName, error) ??
          Row(
            children: [
              const Icon(Icons.error, color: Colors.red, size: 16),
              const SizedBox(width: 8),
              Text(fillerName),
            ],
          );
    }
    
    if (isLoading) {
      return widget.loadingBuilder?.call(fillerName) ??
          Row(
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 8),
              Text(fillerName),
            ],
          );
    }
    
    return Row(
      children: [
        Icon(
          isLoaded ? Icons.check_circle : Icons.cloud_download,
          color: isLoaded ? Colors.green : Colors.grey,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(fillerName),
      ],
    );
  }
  
  void _triggerFillerLoading(String fillerName) {
    setState(() {
      _loadingStates[fillerName] = true;
      _errorStates.remove(fillerName);
    });
    
    FillerRegistry.getFiller(fillerName).catchError((error) {
      if (mounted) {
        setState(() {
          _loadingStates[fillerName] = false;
          _errorStates[fillerName] = error.toString();
        });
      }
    });
    
    _listenForLoadingCompletion(fillerName);
  }
}

/// A widget that shows the loading progress of the lazy loading system
class LoadingProgressIndicator extends StatefulWidget {
  final Widget Function(LoadingProgressData)? builder;
  final Duration updateInterval;
  
  const LoadingProgressIndicator({
    super.key,
    this.builder,
    this.updateInterval = const Duration(milliseconds: 500),
  });
  
  @override
  State<LoadingProgressIndicator> createState() => _LoadingProgressIndicatorState();
}

class _LoadingProgressIndicatorState extends State<LoadingProgressIndicator> {
  Timer? _updateTimer;
  LoadingProgressData _progressData = LoadingProgressData.empty();
  
  @override
  void initState() {
    super.initState();
    _startUpdating();
  }
  
  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }
  
  void _startUpdating() {
    _updateProgress();
    _updateTimer = Timer.periodic(widget.updateInterval, (_) {
      _updateProgress();
    });
  }
  
  void _updateProgress() {
    final stats = LazyLoadingManager.instance.getStats();
    final registryStats = stats['registry'] as Map<String, dynamic>;
    
    final newProgressData = LoadingProgressData(
      totalFillers: registryStats['totalAvailable'] as int,
      loadedFillers: registryStats['loadedFillers'] as int,
      loadingFillers: registryStats['loadingFillers'] as int,
      strategy: stats['strategy'] as String,
      preloadedCategories: stats['preloadedCategories'] as int,
    );
    
    if (mounted && newProgressData != _progressData) {
      setState(() {
        _progressData = newProgressData;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return widget.builder?.call(_progressData) ?? _buildDefaultProgress();
  }
  
  Widget _buildDefaultProgress() {
    if (_progressData.totalFillers == 0) {
      return const SizedBox.shrink();
    }
    
    final progress = _progressData.loadedFillers / _progressData.totalFillers;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Loading Fillers (${_progressData.strategy})',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 4),
            Text(
              '${_progressData.loadedFillers}/${_progressData.totalFillers} loaded'
              '${_progressData.loadingFillers > 0 ? ' (${_progressData.loadingFillers} loading)' : ''}',
              style: const TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

/// Data class for loading progress information
class LoadingProgressData {
  final int totalFillers;
  final int loadedFillers;
  final int loadingFillers;
  final String strategy;
  final int preloadedCategories;
  
  const LoadingProgressData({
    required this.totalFillers,
    required this.loadedFillers,
    required this.loadingFillers,
    required this.strategy,
    required this.preloadedCategories,
  });
  
  LoadingProgressData.empty()
      : totalFillers = 0,
        loadedFillers = 0,
        loadingFillers = 0,
        strategy = 'none',
        preloadedCategories = 0;
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoadingProgressData &&
        other.totalFillers == totalFillers &&
        other.loadedFillers == loadedFillers &&
        other.loadingFillers == loadingFillers &&
        other.strategy == strategy &&
        other.preloadedCategories == preloadedCategories;
  }
  
  @override
  int get hashCode {
    return Object.hash(
      totalFillers,
      loadedFillers,
      loadingFillers,
      strategy,
      preloadedCategories,
    );
  }
}

/// A widget that preloads fillers in the background
class FillerPreloader extends StatefulWidget {
  final List<String> fillersToPreload;
  final Widget child;
  final Widget Function()? loadingBuilder;
  
  const FillerPreloader({
    super.key,
    required this.fillersToPreload,
    required this.child,
    this.loadingBuilder,
  });
  
  @override
  State<FillerPreloader> createState() => _FillerPreloaderState();
}

class _FillerPreloaderState extends State<FillerPreloader> {
  bool _preloading = true;
  String? _error;
  
  @override
  void initState() {
    super.initState();
    _startPreloading();
  }
  
  void _startPreloading() async {
    try {
      await WebOptimizedGenerator.preloadFillers(widget.fillersToPreload);
      
      if (mounted) {
        setState(() {
          _preloading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _preloading = false;
          _error = e.toString();
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_preloading) {
      return widget.loadingBuilder?.call() ??
          const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading fillers...'),
              ],
            ),
          );
    }
    
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error, color: Colors.red),
            const SizedBox(height: 8),
            Text('Failed to load fillers: $_error'),
          ],
        ),
      );
    }
    
    return widget.child;
  }
}