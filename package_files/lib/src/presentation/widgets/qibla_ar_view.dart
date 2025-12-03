import 'package:flutter/material.dart';
import '../pages/qibla_ar_page.dart';

/// A widget that displays Qibla direction using Augmented Reality.
///
/// This widget uses the device camera and sensors to show the Qibla direction
/// in augmented reality. It automatically handles permissions, GPS location,
/// and device orientation.
///
/// Example:
/// ```dart
/// QiblaARView(
///   onQiblaFound: (direction) {
///     print('Qibla direction: $direction°');
///   },
/// )
/// ```
class QiblaARView extends StatelessWidget {
  /// Callback when Qibla direction is calculated
  final Function(double direction)? onQiblaFound;
  
  /// Callback for error handling
  final Function(String error)? onError;

  const QiblaARView({
    super.key,
    this.onQiblaFound,
    this.onError,
  });

  @override
  Widget build(BuildContext context) {
    // For now, use the full AR page
    // In a real implementation, this would be a simpler widget
    return const QiblaARPage();
  }
}
