import '../../core/constants/qibla_constants.dart';

/// Configuration for Qibla calculation and behavior
class QiblaConfig {
  /// Kaaba latitude (default: Mecca coordinates)
  final double kaabaLatitude;
  
  /// Kaaba longitude (default: Mecca coordinates)
  final double kaabaLongitude;
  
  /// GPS timeout in seconds
  final int gpsTimeout;
  
  /// Whether to enable vibration feedback when aligned
  final bool enableVibration;
  
  /// Whether to show debug information
  final bool showDebugInfo;
  
  /// Alignment threshold in degrees
  final double alignmentThreshold;

  const QiblaConfig({
    this.kaabaLatitude = QiblaConstants.kaabaLatitude,
    this.kaabaLongitude = QiblaConstants.kaabaLongitude,
    this.gpsTimeout = QiblaConstants.defaultGpsTimeout,
    this.enableVibration = true,
    this.showDebugInfo = false,
    this.alignmentThreshold = QiblaConstants.alignmentThreshold,
  });

  /// Create a copy with updated values
  QiblaConfig copyWith({
    double? kaabaLatitude,
    double? kaabaLongitude,
    int? gpsTimeout,
    bool? enableVibration,
    bool? showDebugInfo,
    double? alignmentThreshold,
  }) {
    return QiblaConfig(
      kaabaLatitude: kaabaLatitude ?? this.kaabaLatitude,
      kaabaLongitude: kaabaLongitude ?? this.kaabaLongitude,
      gpsTimeout: gpsTimeout ?? this.gpsTimeout,
      enableVibration: enableVibration ?? this.enableVibration,
      showDebugInfo: showDebugInfo ?? this.showDebugInfo,
      alignmentThreshold: alignmentThreshold ?? this.alignmentThreshold,
    );
  }
}
