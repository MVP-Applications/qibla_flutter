import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class CheckLocationServices {
  /// Check if location permission is granted
  Future<PermissionStatus> checkLocationPermission() async {
    return await Permission.location.status;
  }

  /// Request location permission
  Future<PermissionStatus> requestLocationPermission() async {
    return await Permission.location.request();
  }

  /// Check if location services (GPS) are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Open app settings
  Future<bool> openAppSettings() async {
    return await openAppSettings();
  }

  /// Open location settings (GPS settings)
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  /// Complete check: permission + GPS enabled
  Future<LocationCheckResult> performCompleteCheck() async {
    // Check if location services are enabled
    final serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationCheckResult(
        isReady: false,
        reason: LocationCheckReason.serviceDisabled,
        message: 'Location services are disabled. Please enable GPS.',
      );
    }

    // Check permission status
    final permissionStatus = await checkLocationPermission();
    
    if (permissionStatus.isGranted) {
      return LocationCheckResult(
        isReady: true,
        reason: LocationCheckReason.ready,
        message: 'Location is ready',
      );
    }

    if (permissionStatus.isPermanentlyDenied) {
      return LocationCheckResult(
        isReady: false,
        reason: LocationCheckReason.permissionPermanentlyDenied,
        message: 'Location permission is permanently denied. Please enable it in Settings.',
      );
    }

    if (permissionStatus.isDenied) {
      return LocationCheckResult(
        isReady: false,
        reason: LocationCheckReason.permissionDenied,
        message: 'Location permission is required to calculate Qibla direction.',
      );
    }

    return LocationCheckResult(
      isReady: false,
      reason: LocationCheckReason.unknown,
      message: 'Unable to check location status.',
    );
  }
}

enum LocationCheckReason {
  ready,
  serviceDisabled,
  permissionDenied,
  permissionPermanentlyDenied,
  unknown,
}

class LocationCheckResult {
  final bool isReady;
  final LocationCheckReason reason;
  final String message;

  LocationCheckResult({
    required this.isReady,
    required this.reason,
    required this.message,
  });
}
