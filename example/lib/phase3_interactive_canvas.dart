import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:rough_flutter/rough_flutter.dart';

import 'interactive_examples.dart' as ie;

/// Phase 3 interactive canvas with lazy loading and advanced optimizations
class Phase3InteractiveCanvas extends StatelessWidget {
  const Phase3InteractiveCanvas({
    super.key,
    required this.example,
    required this.drawConfigValues,
    required this.fillerConfigValues,
    required this.fillerType,
  });
  
  final ie.InteractiveExample example;
  final Map<String, double> drawConfigValues;
  final Map<String, double> fillerConfigValues;
  final String fillerType;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebOptimizedGenerator>(
      future: _createGenerator(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error, color: Colors.red),
                const SizedBox(height: 8),
                Text('Error loading filler: ${snapshot.error}'),
                TextButton(
                  onPressed: () {
                    // Trigger a rebuild to retry
                    (context as Element).markNeedsBuild();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        
        if (!snapshot.hasData) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading filler...'),
              ],
            ),
          );
        }
        
        return CustomPaint(
          size: const Size.square(double.infinity),
          painter: Phase3InteractivePainter(snapshot.data!, example),
        );
      },
    );
  }
  
  Future<WebOptimizedGenerator> _createGenerator() async {
    final drawConfig = DrawConfig.build(
      maxRandomnessOffset: drawConfigValues['maxRandomnessOffset'],
      bowing: drawConfigValues['bowing'],
      roughness: drawConfigValues['roughness'],
      curveFitting: drawConfigValues['curveFitting'],
      curveTightness: drawConfigValues['curveTightness'],
      curveStepCount: drawConfigValues['curveStepCount'],
      seed: (drawConfigValues['seed'] ?? 0).floor(),
    );
    
    final fillerConfig = FillerConfig.build(
      fillWeight: fillerConfigValues['fillWeight'] ?? 1,
      hachureAngle: fillerConfigValues['hachureAngle'] ?? 320,
      hachureGap: fillerConfigValues['hachureGap'] ?? 15,
      dashOffset: fillerConfigValues['dashOffset'] ?? 15,
      dashGap: fillerConfigValues['dashGap'] ?? 2,
      zigzagOffset: fillerConfigValues['zigzagOffset'] ?? 5,
      drawConfig: drawConfig,
    );
    
    return WebOptimizedGenerator.withLazyFiller(
      fillerType,
      fillerConfig,
      drawConfig,
    );
  }
}

/// Phase 3 painter with performance monitoring
class Phase3InteractivePainter extends RoughMobileWebPainter {
  Phase3InteractivePainter(this.generator, this.interactiveExample);
  
  final WebOptimizedGenerator generator;
  final ie.InteractiveExample interactiveExample;

  @override
  void paintRough(Canvas canvas, Size size, Map<String, dynamic> config) {
    // Record frame for performance monitoring
    RoughMobilePerformance.recordFrame();
    
    // Reset randomizer for consistent drawing
    generator.drawConfig.randomizer.reset();
    
    // Use the interactive example's paint method
    interactiveExample.paintRough(canvas, size, generator.drawConfig, generator.filler);
  }

  @override
  bool shouldRepaint(Phase3InteractivePainter oldDelegate) {
    return oldDelegate.generator.drawConfig != generator.drawConfig ||
           oldDelegate.generator.filler != generator.filler;
  }
}

/// Phase 3 enhanced interactive body with lazy loading
class Phase3InteractiveBody extends StatefulWidget {
  const Phase3InteractiveBody({super.key, required this.example});
  final ie.InteractiveExample example;

  @override
  State<Phase3InteractiveBody> createState() => _Phase3InteractiveBodyState();
}

class _Phase3InteractiveBodyState extends State<Phase3InteractiveBody>
    with TickerProviderStateMixin {
  Map<String, double> drawConfigValues = HashMap<String, double>();
  Map<String, double> fillerConfigValues = HashMap<String, double>();
  late String fillerType;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _initializeValues();
    _tabController = TabController(
      length: 2,
      initialIndex: 0,
      vsync: this,
    );
  }
  
  void _initializeValues() {
    // Initialize draw config values
    drawConfigValues['maxRandomnessOffset'] = DrawConfig.defaultValues.maxRandomnessOffset;
    drawConfigValues['bowing'] = DrawConfig.defaultValues.bowing;
    drawConfigValues['roughness'] = DrawConfig.defaultValues.roughness;
    drawConfigValues['curveFitting'] = DrawConfig.defaultValues.curveFitting;
    drawConfigValues['curveTightness'] = DrawConfig.defaultValues.curveTightness;
    drawConfigValues['curveStepCount'] = DrawConfig.defaultValues.curveStepCount;
    drawConfigValues['seed'] = DrawConfig.defaultValues.seed.toDouble();
    
    // Initialize filler config values
    fillerConfigValues['fillWeight'] = FillerConfig.defaultConfig.fillWeight;
    fillerConfigValues['hachureAngle'] = FillerConfig.defaultConfig.hachureAngle;
    fillerConfigValues['hachureGap'] = FillerConfig.defaultConfig.hachureGap;
    fillerConfigValues['dashOffset'] = FillerConfig.defaultConfig.dashOffset;
    fillerConfigValues['dashGap'] = FillerConfig.defaultConfig.dashGap;
    fillerConfigValues['zigzagOffset'] = FillerConfig.defaultConfig.zigzagOffset;
    
    // Initialize with first available filler
    final availableFillers = WebOptimizedGenerator.getAvailableFillers();
    fillerType = availableFillers.isNotEmpty ? availableFillers.first : 'NoFiller';
  }

  void updateDrawingConfig({required String property, required double value}) {
    setState(() {
      drawConfigValues[property] = value;
    });
  }

  void updateFillerConfig({required String property, required double value}) {
    setState(() {
      fillerConfigValues[property] = value;
    });
  }

  void updateFillerType({required String value}) {
    setState(() {
      fillerType = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RoughMobileLayout(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Card(
              child: Phase3InteractiveCanvas(
                example: widget.example,
                drawConfigValues: drawConfigValues,
                fillerConfigValues: fillerConfigValues,
                fillerType: fillerType,
              ),
            ),
          ),
          TabBar(
            controller: _tabController,
            tabs: const <Widget>[
              ConfigTab(label: 'Draw', iconData: Icons.border_color),
              ConfigTab(label: 'Filler', iconData: Icons.format_color_fill),
            ],
            onTap: (index) {
              setState(() => _tabController.index = index);
              RoughMobileHaptics.selectionClick();
            },
          ),
          SizedBox(
            height: RoughMobileWeb.isMobileWeb ? 280 : 230,
            child: IndexedStack(
              sizing: StackFit.expand,
              index: _tabController.index,
              children: <Widget>[
                // Draw configuration tab
                ListView(
                  children: DiscreteProperty.drawConfigProperties
                      .map(
                        (property) => RoughMobileSlider(
                          label: property.name,
                          value: drawConfigValues[property.name] ?? 0,
                          min: property.min,
                          max: property.max,
                          divisions: property.steps,
                          onChanged: (value) {
                            updateDrawingConfig(
                                property: property.name, value: value);
                            RoughMobileHaptics.lightImpact();
                          },
                        ),
                      )
                      .toList(),
                ),
                
                // Filler configuration tab
                ListView(
                  children: [
                    // Phase 3: Lazy loading filler dropdown
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 120,
                            child: Text(
                              'Filler Type:',
                              style: TextStyle(
                                fontSize: RoughMobileWeb.isMobileWeb ? 16.0 : 14.0,
                              ),
                            ),
                          ),
                          Expanded(
                            child: LazyFillerDropdown(
                              value: fillerType,
                              onChanged: (value) {
                                if (value != null) {
                                  updateFillerType(value: value);
                                  RoughMobileHaptics.selectionClick();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Filler property sliders
                    ...DiscreteProperty.fillerConfigProperties
                        .map(
                          (property) => RoughMobileSlider(
                            label: property.name,
                            value: fillerConfigValues[property.name] ?? 0,
                            min: property.min,
                            max: property.max,
                            divisions: property.steps,
                            onChanged: (value) {
                              updateFillerConfig(
                                  property: property.name, value: value);
                              RoughMobileHaptics.lightImpact();
                            },
                          ),
                        )
                        .toList()
                  ],
                ),
              ],
            ),
          ),
          
          // Phase 3: Loading progress indicator
          const LoadingProgressIndicator(),
        ],
      ),
    );
  }
}

/// Helper class for discrete properties (same as original)
class DiscreteProperty {
  DiscreteProperty({
    required this.name,
    required this.min,
    required this.max,
    required this.steps,
    this.value = 0,
  });
  
  final String name;
  final double max;
  final double min;
  final int steps;
  final double value;

  static List<DiscreteProperty> drawConfigProperties = [
    DiscreteProperty(name: 'seed', min: 0, max: 50, steps: 50),
    DiscreteProperty(name: 'roughness', min: 0, max: 5, steps: 50),
    DiscreteProperty(name: 'curveFitting', min: 0, max: 5, steps: 50),
    DiscreteProperty(name: 'curveTightness', min: 0, max: 1, steps: 100),
    DiscreteProperty(name: 'curveStepCount', min: 1, max: 20, steps: 190),
    DiscreteProperty(name: 'bowing', min: 0, max: 20, steps: 400),
    DiscreteProperty(name: 'maxRandomnessOffset', min: 0, max: 20, steps: 50),
  ];

  static List<DiscreteProperty> fillerConfigProperties = [
    DiscreteProperty(name: 'fillWeight', min: 0, max: 50, steps: 500),
    DiscreteProperty(name: 'hachureAngle', min: 0, max: 360, steps: 360),
    DiscreteProperty(name: 'hachureGap', min: 0, max: 50, steps: 500),
    DiscreteProperty(name: 'dashOffset', min: 0, max: 50, steps: 500),
    DiscreteProperty(name: 'dashGap', min: 0, max: 50, steps: 500),
    DiscreteProperty(name: 'zigzagOffset', min: 0, max: 50, steps: 500),
  ];
}

/// Config tab widget (same as original)
class ConfigTab extends StatelessWidget {
  const ConfigTab({super.key, required this.label, required this.iconData});
  final String label;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(iconData, size: 16),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}
