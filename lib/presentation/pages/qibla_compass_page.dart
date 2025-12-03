import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibration/vibration.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/di/injection.dart';
import '../../domain/usecases/check_location_services.dart';
import '../cubits/qibla_cubit.dart';
import '../cubits/qibla_state.dart';
import '../cubits/tilt_cubit.dart';
import '../cubits/tilt_state.dart';
import '../widgets/ar_camera_view.dart';
import '../widgets/qibla_image_overlay.dart';
import '../widgets/direction_arrow.dart';
import '../widgets/tilt_warning_overlay.dart';
import 'ar_qibla_page.dart';
import 'panorama_kaaba_page.dart';

class QiblaCompassPage extends StatefulWidget {
  const QiblaCompassPage({super.key});

  @override
  State<QiblaCompassPage> createState() => _QiblaCompassPageState();
}

class _QiblaCompassPageState extends State<QiblaCompassPage> {
  bool _hasTriggeredHaptic = false;
  bool _cameraPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    context.read<QiblaCubit>().startTracking();
    context.read<TiltCubit>().startMonitoring();
  }

  Future<void> _requestPermissions() async {
    final cameraStatus = await Permission.camera.request();
    setState(() {
      _cameraPermissionGranted = cameraStatus.isGranted;
    });
  }

  void _triggerHapticFeedback() async {
    if (!_hasTriggeredHaptic) {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        Vibration.vibrate(duration: 200);
      }
      _hasTriggeredHaptic = true;
    }
  }

  void _resetHaptic() {
    _hasTriggeredHaptic = false;
  }

  Future<void> _handleARButtonPress() async {
    final checkLocationServices = getIt<CheckLocationServices>();

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Colors.green),
      ),
    );

    // Perform complete check
    final result = await checkLocationServices.performCompleteCheck();

    // Close loading dialog
    if (mounted) {
      Navigator.of(context).pop();
    }

    if (!mounted) return;

    // Handle result
    if (result.isReady) {
      // All checks passed, open AR screen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ARQiblaPage(),
        ),
      );
    } else {
      // Show appropriate dialog based on reason
      _handleLocationCheckFailure(result, checkLocationServices);
    }
  }

  void _handleLocationCheckFailure(
    LocationCheckResult result,
    CheckLocationServices checkLocationServices,
  ) {
    switch (result.reason) {
      case LocationCheckReason.serviceDisabled:
        _showGPSDisabledDialog(checkLocationServices);
        break;
      case LocationCheckReason.permissionDenied:
        _showPermissionDeniedDialog(checkLocationServices);
        break;
      case LocationCheckReason.permissionPermanentlyDenied:
        _showPermissionPermanentlyDeniedDialog(checkLocationServices);
        break;
      default:
        _showGenericErrorDialog(result.message);
    }
  }

  void _showGPSDisabledDialog(CheckLocationServices checkLocationServices) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.location_off, color: Colors.orange),
            SizedBox(width: 8),
            Text('GPS Disabled'),
          ],
        ),
        content: const Text(
          'Location services (GPS) are disabled on your device.\n\n'
          'AR Qibla requires GPS to calculate the accurate direction to Mecca.\n\n'
          'Please enable location services to continue.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await checkLocationServices.openLocationSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text(
              'Open Settings',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showPermissionDeniedDialog(CheckLocationServices checkLocationServices) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.location_disabled, color: Colors.orange),
            SizedBox(width: 8),
            Text('Location Permission'),
          ],
        ),
        content: const Text(
          'Location permission is required to calculate the Qibla direction.\n\n'
          'AR Qibla uses your GPS location to determine the accurate direction to Mecca.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final status = await checkLocationServices.requestLocationPermission();
              if (status.isGranted) {
                _handleARButtonPress(); // Retry
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text(
              'Grant Permission',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showPermissionPermanentlyDeniedDialog(CheckLocationServices checkLocationServices) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.block, color: Colors.red),
            SizedBox(width: 8),
            Text('Permission Denied'),
          ],
        ),
        content: const Text(
          'Location permission has been permanently denied.\n\n'
          'To use AR Qibla, you need to enable location permission in your device settings.\n\n'
          'Steps:\n'
          '1. Open Settings\n'
          '2. Find this app\n'
          '3. Enable Location permission',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await checkLocationServices.openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text(
              'Open Settings',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showGenericErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 8),
            Text('Error'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // AR Camera Background
          if (_cameraPermissionGranted)
            const ARCameraView()
          else
            Container(
              color: Colors.black,
              child: const Center(
                child: Text(
                  'Camera permission required',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

          // Qibla State Management
          BlocConsumer<QiblaCubit, QiblaState>(
            listener: (context, state) {
              if (state is QiblaUpdated && state.qiblaData.isAligned) {
                _triggerHapticFeedback();
              } else {
                _resetHaptic();
              }
            },
            builder: (context, qiblaState) {
              return BlocBuilder<TiltCubit, TiltState>(
                builder: (context, tiltState) {
                  // Show tilt warning if not vertical
                  if (tiltState is TiltNotVertical) {
                    return TiltWarningOverlay(animate: tiltState.animateIcon);
                  }

                  // Show Qibla image when aligned
                  if (qiblaState is QiblaUpdated && qiblaState.qiblaData.isAligned) {
                    return const QiblaImageOverlay();
                  }

                  // Show direction arrow when not aligned
                  if (qiblaState is QiblaUpdated && !qiblaState.qiblaData.isAligned) {
                    return DirectionArrow(
                      differenceAngle: qiblaState.qiblaData.differenceAngle,
                    );
                  }

                  // Show permission denied message
                  if (qiblaState is QiblaPermissionDenied) {
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Enable Location to detect Qibla direction.',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  // Loading state
                  if (qiblaState is QiblaLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.green),
                    );
                  }

                  return const SizedBox.shrink();
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 360° Panorama Button (Works without GPS!)
          FloatingActionButton.extended(
            onPressed: () {
              // Open 360° view immediately - no GPS check needed
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PanoramaKaabaPage(),
                ),
              );
            },
            heroTag: 'panorama',
            backgroundColor: Colors.blue,
            icon: const Icon(Icons.panorama_photosphere, color: Colors.white),
            label: const Text(
              '360° View',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // AR View Button with proper permission handling
          FloatingActionButton.extended(
            onPressed: _handleARButtonPress,
            heroTag: 'ar',
            backgroundColor: Colors.green,
            icon: const Icon(Icons.view_in_ar, color: Colors.white),
            label: const Text(
              'AR View',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
