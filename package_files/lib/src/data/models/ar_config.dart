import 'package:flutter/material.dart';
import '../../core/constants/qibla_constants.dart';

/// Configuration for AR view appearance and behavior
class ARConfig {
  /// Whether to show vertical position warning
  final bool showVerticalWarning;
  
  /// Custom Kaaba image asset path (optional)
  final String? kaabaImagePath;
  
  /// Color of the arrow pointing to Kaaba
  final Color arrowColor;
  
  /// Opacity of the Kaaba image (0.0 to 1.0)
  final double kaabaOpacity;
  
  /// Whether to enable smoothing for stable AR rendering
  final bool enableSmoothing;
  
  /// Smoothing factor (0.0 to 1.0, lower = smoother)
  final double smoothingFactor;
  
  /// Scale factor for Kaaba image
  final double kaabaScale;
  
  /// Whether to show navigation arrows
  final bool showNavigationArrows;
  
  /// Whether to show compass overlay
  final bool showCompassOverlay;

  const ARConfig({
    this.showVerticalWarning = true,
    this.kaabaImagePath,
    this.arrowColor = Colors.white,
    this.kaabaOpacity = QiblaConstants.defaultKaabaOpacity,
    this.enableSmoothing = true,
    this.smoothingFactor = QiblaConstants.defaultSmoothingFactor,
    this.kaabaScale = 1.0,
    this.showNavigationArrows = true,
    this.showCompassOverlay = true,
  });

  /// Create a copy with updated values
  ARConfig copyWith({
    bool? showVerticalWarning,
    String? kaabaImagePath,
    Color? arrowColor,
    double? kaabaOpacity,
    bool? enableSmoothing,
    double? smoothingFactor,
    double? kaabaScale,
    bool? showNavigationArrows,
    bool? showCompassOverlay,
  }) {
    return ARConfig(
      showVerticalWarning: showVerticalWarning ?? this.showVerticalWarning,
      kaabaImagePath: kaabaImagePath ?? this.kaabaImagePath,
      arrowColor: arrowColor ?? this.arrowColor,
      kaabaOpacity: kaabaOpacity ?? this.kaabaOpacity,
      enableSmoothing: enableSmoothing ?? this.enableSmoothing,
      smoothingFactor: smoothingFactor ?? this.smoothingFactor,
      kaabaScale: kaabaScale ?? this.kaabaScale,
      showNavigationArrows: showNavigationArrows ?? this.showNavigationArrows,
      showCompassOverlay: showCompassOverlay ?? this.showCompassOverlay,
    );
  }
}
