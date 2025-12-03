import 'dart:math' as math;
import '../constants/qibla_constants.dart';

/// Utility class for calculating Qibla direction
class QiblaCalculator {
  /// Calculate Qibla bearing from user's location to Kaaba
  /// 
  /// Returns the bearing in degrees (0-360) from North
  static double calculateQiblaBearing({
    required double userLatitude,
    required double userLongitude,
    double kaabaLatitude = QiblaConstants.kaabaLatitude,
    double kaabaLongitude = QiblaConstants.kaabaLongitude,
  }) {
    // Convert to radians
    final lat1 = _degreesToRadians(userLatitude);
    final lon1 = _degreesToRadians(userLongitude);
    final lat2 = _degreesToRadians(kaabaLatitude);
    final lon2 = _degreesToRadians(kaabaLongitude);

    // Calculate bearing using great circle formula
    final dLon = lon2 - lon1;
    final y = math.sin(dLon) * math.cos(lat2);
    final x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);
    
    var bearing = math.atan2(y, x);
    bearing = _radiansToDegrees(bearing);
    bearing = (bearing + 360) % 360; // Normalize to 0-360

    return bearing;
  }

  /// Calculate distance from user's location to Kaaba in kilometers
  static double calculateDistance({
    required double userLatitude,
    required double userLongitude,
    double kaabaLatitude = QiblaConstants.kaabaLatitude,
    double kaabaLongitude = QiblaConstants.kaabaLongitude,
  }) {
    const earthRadius = 6371.0; // km

    final lat1 = _degreesToRadians(userLatitude);
    final lon1 = _degreesToRadians(userLongitude);
    final lat2 = _degreesToRadians(kaabaLatitude);
    final lon2 = _degreesToRadians(kaabaLongitude);

    final dLat = lat2 - lat1;
    final dLon = lon2 - lon1;

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    
    return earthRadius * c;
  }

  /// Calculate angle difference between two bearings
  static double angleDifference(double bearing1, double bearing2) {
    var diff = (bearing1 - bearing2).abs();
    if (diff > 180) {
      diff = 360 - diff;
    }
    return diff;
  }

  /// Check if two bearings are aligned within threshold
  static bool isAligned(
    double bearing1,
    double bearing2, {
    double threshold = QiblaConstants.alignmentThreshold,
  }) {
    return angleDifference(bearing1, bearing2) < threshold;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * math.pi / 180.0;
  }

  static double _radiansToDegrees(double radians) {
    return radians * 180.0 / math.pi;
  }
}
