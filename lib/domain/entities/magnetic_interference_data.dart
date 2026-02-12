import 'package:equatable/equatable.dart';

/// Represents magnetic interference detection data
class MagneticInterferenceData extends Equatable {
  /// Whether magnetic interference is currently detected
  final bool isInterferenceDetected;
  
  /// Magnetic field magnitude in µT (microtesla)
  final double magnitude;
  
  /// Whether the magnetic field is unstable (rapid changes)
  final bool isUnstable;
  
  /// Whether there's a heading jump without device rotation
  final bool hasHeadingJump;
  
  /// Timestamp of the detection
  final DateTime timestamp;

  const MagneticInterferenceData({
    required this.isInterferenceDetected,
    required this.magnitude,
    required this.isUnstable,
    required this.hasHeadingJump,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
        isInterferenceDetected,
        magnitude,
        isUnstable,
        hasHeadingJump,
        timestamp,
      ];
}
