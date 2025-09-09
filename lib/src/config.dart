import 'dart:math';

/// Configuration for how shapes are drawn with a rough/sketchy style.
///
/// This class controls various aspects of the sketchy rendering including
/// roughness, bowing, and curve fitting parameters.
class DrawConfig {
  const DrawConfig._({
    required this.maxRandomnessOffset,
    required this.roughness,
    required this.bowing,
    required this.curveFitting,
    required this.curveTightness,
    required this.curveStepCount,
    required this.seed,
    required this.randomizer,
  });

  /// Creates a [DrawConfig] with the specified parameters.
  ///
  /// Parameters:
  /// - [roughness]: Controls how rough the drawing is. A value of 0 creates
  ///   perfect shapes, while higher values increase sketchiness. Default: 1.
  /// - [bowing]: Controls how much lines bow/curve. A value of 0 creates
  ///   straight lines. Default: 1.
  /// - [seed]: Seed for random number generation, useful for reproducible
  ///   drawings. Default: 1.
  /// - [curveStepCount]: Number of points used to approximate curves.
  ///   Higher values create smoother curves. Default: 9.
  /// - [curveTightness]: Controls how tight curves are drawn. Default: 0.
  /// - [curveFitting]: Controls how closely curves match the specified
  ///   dimensions. Values closer to 1 are more accurate. Default: 0.95.
  /// - [maxRandomnessOffset]: Maximum random offset applied to points.
  ///   Default: 2.
  factory DrawConfig.build({
    double? maxRandomnessOffset,
    double? roughness,
    double? bowing,
    double? curveFitting,
    double? curveTightness,
    double? curveStepCount,
    int? seed,
  }) {
    final effectiveSeed = seed ?? defaultValues.seed;
    return DrawConfig._(
      maxRandomnessOffset:
          maxRandomnessOffset ?? defaultValues.maxRandomnessOffset,
      roughness: roughness ?? defaultValues.roughness,
      bowing: bowing ?? defaultValues.bowing,
      curveFitting: curveFitting ?? defaultValues.curveFitting,
      curveTightness: curveTightness ?? defaultValues.curveTightness,
      curveStepCount: curveStepCount ?? defaultValues.curveStepCount,
      seed: effectiveSeed,
      randomizer: Randomizer(seed: effectiveSeed),
    );
  }

  /// Maximum random offset applied to points.
  final double maxRandomnessOffset;

  /// Controls how rough the drawing is. A value of 0 creates perfect shapes.
  final double roughness;

  /// Controls how much lines bow/curve. A value of 0 creates straight lines.
  final double bowing;

  /// Controls how closely curves match the specified dimensions.
  final double curveFitting;

  /// Controls how tight curves are drawn.
  final double curveTightness;

  /// Number of points used to approximate curves.
  final double curveStepCount;

  /// Seed for random number generation.
  final int seed;

  /// The randomizer used for generating random values.
  final Randomizer randomizer;

  /// Default configuration values for drawing.
  static final DrawConfig defaultValues = DrawConfig._(
    maxRandomnessOffset: 2,
    roughness: 1,
    bowing: 1,
    curveFitting: 0.95,
    curveTightness: 0,
    curveStepCount: 9,
    seed: 1,
    randomizer: Randomizer(seed: 1),
  );

  /// Generates a random offset between [min] and [max] based on roughness.
  ///
  /// The [roughnessGain] parameter can be used to amplify or reduce the
  /// roughness effect for specific operations.
  double offset(double min, double max, [double roughnessGain = 1]) {
    return roughness *
        roughnessGain *
        ((randomizer.next() * (max - min)) + min);
  }

  /// Generates a random offset between -[x] and [x] based on roughness.
  ///
  /// This is a convenience method for symmetric offsets.
  double offsetSymmetric(double x, [double roughnessGain = 1]) {
    return offset(-x, x, roughnessGain);
  }

  /// Creates a copy of this configuration with the given fields replaced.
  DrawConfig copyWith({
    double? maxRandomnessOffset,
    double? roughness,
    double? bowing,
    double? curveFitting,
    double? curveTightness,
    double? curveStepCount,
    double? fillWeight,
    int? seed,
    bool? combineNestedSvgPaths,
    Randomizer? randomizer,
  }) {
    final effectiveSeed = seed ?? this.seed;
    return DrawConfig._(
      maxRandomnessOffset: maxRandomnessOffset ?? this.maxRandomnessOffset,
      roughness: roughness ?? this.roughness,
      bowing: bowing ?? this.bowing,
      curveFitting: curveFitting ?? this.curveFitting,
      curveTightness: curveTightness ?? this.curveTightness,
      curveStepCount: curveStepCount ?? this.curveStepCount,
      seed: effectiveSeed,
      randomizer: randomizer ?? Randomizer(seed: effectiveSeed),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DrawConfig &&
          runtimeType == other.runtimeType &&
          maxRandomnessOffset == other.maxRandomnessOffset &&
          roughness == other.roughness &&
          bowing == other.bowing &&
          curveFitting == other.curveFitting &&
          curveTightness == other.curveTightness &&
          curveStepCount == other.curveStepCount &&
          seed == other.seed;

  @override
  int get hashCode =>
      maxRandomnessOffset.hashCode ^
      roughness.hashCode ^
      bowing.hashCode ^
      curveFitting.hashCode ^
      curveTightness.hashCode ^
      curveStepCount.hashCode ^
      seed.hashCode;
}

/// A wrapper around [Random] that provides controlled random number generation
/// with the ability to reset to a known seed.
class Randomizer {
  Randomizer({int seed = 0})
      : _seed = seed,
        _random = Random(seed);
  late Random _random;
  final int _seed;

  /// The seed used for random number generation.
  int get seed => _seed;

  /// Returns the next random double in the range [0.0, 1.0).
  double next() => _random.nextDouble();

  /// Resets the random number generator to its initial state.
  void reset() {
    _random = Random(_seed);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Randomizer && _seed == other._seed;

  @override
  int get hashCode => _seed.hashCode;
}
