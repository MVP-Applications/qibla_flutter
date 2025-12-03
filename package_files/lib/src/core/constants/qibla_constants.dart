/// Constants used throughout the Qibla AR Finder package
class QiblaConstants {
  /// Kaaba latitude in Mecca, Saudi Arabia
  static const double kaabaLatitude = 21.4225;
  
  /// Kaaba longitude in Mecca, Saudi Arabia
  static const double kaabaLongitude = 39.8262;
  
  /// Default GPS timeout in seconds
  static const int defaultGpsTimeout = 30;
  
  /// Smoothing factor for AR positioning (0.0 to 1.0)
  static const double defaultSmoothingFactor = 0.1;
  
  /// Threshold for considering device as vertical (in degrees)
  static const double verticalThresholdMin = 60.0;
  static const double verticalThresholdMax = 120.0;
  
  /// Default Kaaba image opacity
  static const double defaultKaabaOpacity = 0.8;
  
  /// Alignment threshold in degrees
  static const double alignmentThreshold = 15.0;
  
  /// Arrow visibility threshold in degrees
  static const double arrowThreshold = 5.0;
}
