/// Represents the Qibla direction information
class QiblaDirection {
  /// Bearing to Qibla in degrees (0-360) from North
  final double bearing;
  
  /// Current device heading in degrees (0-360) from North
  final double deviceHeading;
  
  /// Distance to Kaaba in kilometers
  final double? distanceKm;
  
  /// Whether the device is aligned with Qibla direction
  final bool isAligned;
  
  /// Angle difference between device heading and Qibla bearing
  final double angleDifference;

  const QiblaDirection({
    required this.bearing,
    required this.deviceHeading,
    this.distanceKm,
    required this.isAligned,
    required this.angleDifference,
  });

  /// Create a copy with updated values
  QiblaDirection copyWith({
    double? bearing,
    double? deviceHeading,
    double? distanceKm,
    bool? isAligned,
    double? angleDifference,
  }) {
    return QiblaDirection(
      bearing: bearing ?? this.bearing,
      deviceHeading: deviceHeading ?? this.deviceHeading,
      distanceKm: distanceKm ?? this.distanceKm,
      isAligned: isAligned ?? this.isAligned,
      angleDifference: angleDifference ?? this.angleDifference,
    );
  }

  @override
  String toString() {
    return 'QiblaDirection(bearing: $bearing°, heading: $deviceHeading°, '
        'aligned: $isAligned, diff: ${angleDifference.toStringAsFixed(1)}°)';
  }
}
