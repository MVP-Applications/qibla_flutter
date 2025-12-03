import 'package:flutter/material.dart';

/// A traditional compass widget showing Qibla direction.
///
/// This widget displays a 2D compass with Qibla indicator.
/// It's a simpler alternative to the AR view.
///
/// Example:
/// ```dart
/// QiblaCompass(
///   onDirectionChanged: (direction) {
///     print('Current heading: $direction°');
///   },
/// )
/// ```
class QiblaCompass extends StatelessWidget {
  /// Callback when direction changes
  final Function(double direction)? onDirectionChanged;
  
  /// Whether to show degree values
  final bool showDegrees;
  
  /// Size of the compass widget
  final double compassSize;
  
  /// Color of Qibla indicator
  final Color qiblaColor;

  const QiblaCompass({
    super.key,
    this.onDirectionChanged,
    this.showDegrees = true,
    this.compassSize = 300,
    this.qiblaColor = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    // Placeholder implementation
    // In a real implementation, this would show an actual compass
    return Center(
      child: Container(
        width: compassSize,
        height: compassSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: qiblaColor, width: 2),
        ),
        child: const Center(
          child: Text(
            'Compass View\n(Coming Soon)',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
