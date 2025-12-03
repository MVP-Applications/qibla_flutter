/// Represents device orientation information
class DeviceOrientation {
  /// Pitch angle in degrees (up/down tilt)
  final double pitch;
  
  /// Roll angle in degrees (side tilt)
  final double roll;
  
  /// Yaw angle in degrees (rotation around vertical axis)
  final double yaw;
  
  /// Whether device is held vertically
  final bool isVertical;
  
  /// Heading/compass direction in degrees (0-360) from North
  final double heading;

  const DeviceOrientation({
    required this.pitch,
    required this.roll,
    required this.yaw,
    required this.isVertical,
    required this.heading,
  });

  /// Create a copy with updated values
  DeviceOrientation copyWith({
    double? pitch,
    double? roll,
    double? yaw,
    bool? isVertical,
    double? heading,
  }) {
    return DeviceOrientation(
      pitch: pitch ?? this.pitch,
      roll: roll ?? this.roll,
      yaw: yaw ?? this.yaw,
      isVertical: isVertical ?? this.isVertical,
      heading: heading ?? this.heading,
    );
  }

  @override
  String toString() {
    return 'DeviceOrientation(pitch: ${pitch.toStringAsFixed(1)}°, '
        'roll: ${roll.toStringAsFixed(1)}°, heading: ${heading.toStringAsFixed(1)}°, '
        'vertical: $isVertical)';
  }
}
