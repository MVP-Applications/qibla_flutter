import 'dart:math';
import '../entities/location_data.dart';

class GetARQiblaBearing {
  // Kaaba coordinates (Mecca)
  static const double kaabaLatitude = 21.422487;
  static const double kaabaLongitude = 39.826206;

  /// Calculate bearing from user location to Kaaba
  /// Returns bearing in degrees (0-360)
  double call(LocationData userLocation) {
    return _calculateBearing(
      userLocation.latitude,
      userLocation.longitude,
      kaabaLatitude,
      kaabaLongitude,
    );
  }

  /// Calculate bearing between two coordinates
  double _calculateBearing(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    final lat1Rad = _toRadians(lat1);
    final lat2Rad = _toRadians(lat2);
    final deltaLon = _toRadians(lon2 - lon1);

    final y = sin(deltaLon) * cos(lat2Rad);
    final x = cos(lat1Rad) * sin(lat2Rad) -
        sin(lat1Rad) * cos(lat2Rad) * cos(deltaLon);

    var bearing = atan2(y, x);
    
    // Convert to degrees
    bearing = bearing * 180 / pi;
    
    // Normalize to 0-360
    bearing = (bearing + 360) % 360;

    return bearing;
  }

  double _toRadians(double degrees) => degrees * pi / 180;
}
