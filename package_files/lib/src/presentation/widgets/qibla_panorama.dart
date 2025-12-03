import 'package:flutter/material.dart';

/// A 360° panorama widget showing Kaaba view.
///
/// This widget displays a 360° panoramic view with Qibla detection.
///
/// Example:
/// ```dart
/// QiblaPanorama(
///   onQiblaDetected: () {
///     print('Qibla detected in panorama');
///   },
/// )
/// ```
class QiblaPanorama extends StatelessWidget {
  /// Callback when Qibla is detected in panorama
  final VoidCallback? onQiblaDetected;

  const QiblaPanorama({
    super.key,
    this.onQiblaDetected,
  });

  @override
  Widget build(BuildContext context) {
    // Placeholder implementation
    return const Center(
      child: Text(
        '360° Panorama View\n(Coming Soon)',
        textAlign: TextAlign.center,
      ),
    );
  }
}
