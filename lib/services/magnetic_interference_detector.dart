import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_compass/flutter_compass.dart';
import '../domain/entities/magnetic_interference_data.dart';

/// Service to detect magnetic interference affecting compass accuracy
/// 
/// Detects interference from:
/// - Nearby mobile phones
/// - Metal objects (keys, rings, tables)
/// - Electronic devices (power banks, chargers, laptops)
/// - Speakers, motors, wireless charging coils
class MagneticInterferenceDetector {
  static MagneticInterferenceDetector? _instance;
  
  static MagneticInterferenceDetector get instance {
    _instance ??= MagneticInterferenceDetector._internal();
    return _instance!;
  }

  MagneticInterferenceDetector._internal();

  StreamController<MagneticInterferenceData>? _interferenceController;
  StreamSubscription? _magnetometerSubscription;
  StreamSubscription? _compassSubscription;
  StreamSubscription? _gyroscopeSubscription;

  // Tracking variables
  double _lastMagnitude = 0.0;
  double _lastHeading = 0.0;
  double _gyroRotation = 0.0;
  int _warningStartTime = 0;
  bool _isWarningActive = false;

  // Thresholds (based on production Qibla apps)
  static const double _minNormalMagnitude = 20.0; // µT
  static const double _maxNormalMagnitude = 70.0; // µT
  static const double _magnitudeChangeDelta = 5.0; // µT
  static const double _headingJumpThreshold = 10.0; // degrees
  static const double _gyroStillThreshold = 0.5; // degrees/sec
  static const int _debounceMilliseconds = 1000; // 1 second

  /// Start monitoring for magnetic interference
  Stream<MagneticInterferenceData> startMonitoring() {
    if (_interferenceController != null) {
      return _interferenceController!.stream;
    }

    _interferenceController = StreamController<MagneticInterferenceData>.broadcast();
    
    _startMagnetometerMonitoring();
    _startCompassMonitoring();
    _startGyroscopeMonitoring();

    return _interferenceController!.stream;
  }

  void _startMagnetometerMonitoring() {
    _magnetometerSubscription = magnetometerEventStream().listen((event) {
      // Calculate magnetic field magnitude
      final x = event.x;
      final y = event.y;
      final z = event.z;
      final magnitude = sqrt(x * x + y * y + z * z);

      _checkInterference(magnitude: magnitude);
    });
  }

  void _startCompassMonitoring() {
    _compassSubscription = FlutterCompass.events?.listen((event) {
      if (event.heading != null) {
        final currentHeading = event.heading!;
        _checkInterference(heading: currentHeading);
        _lastHeading = currentHeading;
      }
    });
  }

  void _startGyroscopeMonitoring() {
    _gyroscopeSubscription = gyroscopeEventStream().listen((event) {
      // Calculate rotation magnitude
      _gyroRotation = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
    });
  }

  void _checkInterference({double? magnitude, double? heading}) {
    final currentMagnitude = magnitude ?? _lastMagnitude;
    final currentHeading = heading ?? _lastHeading;

    // 1. Check if magnetic field strength is outside Earth's normal range
    final bool magneticDistorted = 
        currentMagnitude < _minNormalMagnitude || 
        currentMagnitude > _maxNormalMagnitude;

    // 2. Check for sudden magnetic instability (rapid fluctuations)
    final double magnitudeDelta = (currentMagnitude - _lastMagnitude).abs();
    final bool isUnstable = magnitudeDelta > _magnitudeChangeDelta;

    // 3. Check for heading jump without physical rotation
    final double headingDelta = _calculateHeadingDelta(currentHeading, _lastHeading);
    final bool headingJump = headingDelta > _headingJumpThreshold;
    final bool deviceStill = _gyroRotation < _gyroStillThreshold;
    final bool hasHeadingJump = headingJump && deviceStill;

    // Decision logic: Show warning if at least 2 conditions are true
    final bool shouldShowWarning = 
        (magneticDistorted && isUnstable) ||
        (magneticDistorted && hasHeadingJump) ||
        (isUnstable && hasHeadingJump);

    // Debounce: Require condition to persist for 1 second
    final now = DateTime.now().millisecondsSinceEpoch;
    
    if (shouldShowWarning) {
      if (!_isWarningActive) {
        _warningStartTime = now;
      }
      
      if (now - _warningStartTime > _debounceMilliseconds) {
        if (!_isWarningActive) {
          _isWarningActive = true;
          _emitInterferenceData(
            isDetected: true,
            magnitude: currentMagnitude,
            isUnstable: isUnstable,
            hasHeadingJump: hasHeadingJump,
          );
          debugPrint('MagneticInterference: DETECTED - Magnitude: ${currentMagnitude.toStringAsFixed(1)}µT, '
              'Unstable: $isUnstable, HeadingJump: $hasHeadingJump');
        }
      }
    } else {
      if (_isWarningActive) {
        _isWarningActive = false;
        _emitInterferenceData(
          isDetected: false,
          magnitude: currentMagnitude,
          isUnstable: isUnstable,
          hasHeadingJump: hasHeadingJump,
        );
        debugPrint('MagneticInterference: CLEARED');
      }
      _warningStartTime = 0;
    }

    // Update tracking variables
    if (magnitude != null) {
      _lastMagnitude = currentMagnitude;
    }
  }

  double _calculateHeadingDelta(double current, double last) {
    double delta = (current - last).abs();
    // Handle 360° wrap-around
    if (delta > 180) {
      delta = 360 - delta;
    }
    return delta;
  }

  void _emitInterferenceData({
    required bool isDetected,
    required double magnitude,
    required bool isUnstable,
    required bool hasHeadingJump,
  }) {
    final data = MagneticInterferenceData(
      isInterferenceDetected: isDetected,
      magnitude: magnitude,
      isUnstable: isUnstable,
      hasHeadingJump: hasHeadingJump,
      timestamp: DateTime.now(),
    );

    _interferenceController?.add(data);
  }

  /// Stop monitoring
  void stopMonitoring() {
    _magnetometerSubscription?.cancel();
    _compassSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    _interferenceController?.close();
    
    _magnetometerSubscription = null;
    _compassSubscription = null;
    _gyroscopeSubscription = null;
    _interferenceController = null;
    
    _isWarningActive = false;
    _warningStartTime = 0;
  }

  /// Dispose resources
  void dispose() {
    stopMonitoring();
  }

  /// Reset instance (useful for testing)
  @visibleForTesting
  static void resetInstance() {
    _instance?.dispose();
    _instance = null;
  }
}
