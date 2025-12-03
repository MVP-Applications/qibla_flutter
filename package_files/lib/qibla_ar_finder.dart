/// A professional Flutter package for finding Qibla direction using AR, compass, and 360° panorama views.
///
/// This package provides multiple ways to find and display the Qibla direction:
/// - AR View: Augmented reality view with camera overlay (Android & iOS)
/// - Compass View: Traditional 2D compass with Qibla indicator
/// - Panorama View: 360° view with Qibla detection
///
/// Features:
/// - Automatic GPS location detection
/// - Accurate Qibla direction calculation
/// - Device orientation tracking
/// - Vertical position warning
/// - Permission handling
/// - Cross-platform support (Android & iOS)
///
/// Example usage:
/// ```dart
/// import 'package:qibla_ar_finder/qibla_ar_finder.dart';
///
/// // Simple AR View
/// QiblaARView(
///   onQiblaFound: (direction) {
///     print('Qibla direction: $direction°');
///   },
/// )
///
/// // Full featured page
/// QiblaARPage()
/// ```
library qibla_ar_finder;

// Core exports
export 'src/core/constants/qibla_constants.dart';
export 'src/core/utils/qibla_calculator.dart';

// Domain exports (entities only)
export 'src/domain/entities/qibla_direction.dart';
export 'src/domain/entities/device_orientation.dart';

// Presentation exports (public widgets and controllers)
export 'src/presentation/widgets/qibla_ar_view.dart';
export 'src/presentation/widgets/qibla_compass.dart';
export 'src/presentation/widgets/qibla_panorama.dart';
export 'src/presentation/pages/qibla_ar_page.dart';
export 'src/presentation/controllers/qibla_controller.dart';
export 'src/presentation/controllers/ar_controller.dart';

// Data models (for configuration)
export 'src/data/models/qibla_config.dart';
export 'src/data/models/ar_config.dart';
