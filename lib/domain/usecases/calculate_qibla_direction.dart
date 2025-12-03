import 'dart:math';
import '../entities/location_data.dart';
import '../entities/qibla_data.dart';

class CalculateQiblaDirection {
  // Mecca coordinates
  static const double meccaLatitude = 21.422504;
  static const double meccaLongitude = 39.826195;
  static const double alignmentThreshold = 6.0; // degrees

  QiblaData call({
    required LocationData userLocation,
    required double deviceHeading,
  }) {
    final qiblaDirection = _computeQiblaDirection(userLocation);
    final difference = _normalizeDifference(qiblaDirection - deviceHeading);
    final isAligned = difference.abs() < alignmentThreshold;

    return QiblaData(
      qiblaDirection: qiblaDirection,
      deviceHeading: deviceHeading,
      differenceAngle: difference,
      isAligned: isAligned,
    );
  }

  double _computeQiblaDirection(LocationData location) {
    final lat1 = _toRadians(location.latitude);
    final lon1 = _toRadians(location.longitude);
    final lat2 = _toRadians(meccaLatitude);
    final lon2 = _toRadians(meccaLongitude);

    final deltaLon = lon2 - lon1;

    final y = sin(deltaLon) * cos(lat2);
    final x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLon);

    var bearing = atan2(y, x);
    if (bearing < 0) {
      bearing += 2 * pi;
    }

    return (bearing * 180 / pi).roundToDouble();
  }

  double _normalizeDifference(double diff) {
    var normalized = diff % 360;
    if (normalized < -180) normalized += 360;
    if (normalized > 180) normalized -= 360;
    return normalized;
  }

  double _toRadians(double degrees) => degrees * pi / 180;
}
