import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'qibla_compass_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Schedule permission request after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestCameraPermissionAndNavigate();
    });
  }

  Future<void> _requestCameraPermissionAndNavigate() async {
    // Wait a moment for UI to settle
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Check current permission status
    PermissionStatus status = await Permission.camera.status;
    debugPrint('Initial camera permission status: $status');
    
    // Request permission if not granted
    if (!status.isGranted) {
      debugPrint('Requesting camera permission...');
      status = await Permission.camera.request();
      debugPrint('Camera permission after request: $status');
    }
    
    // If permission is permanently denied, show settings dialog
    if (status.isPermanentlyDenied && mounted) {
      _showPermissionDialog();
      return;
    }
    
    // Wait for remaining splash duration
    await Future.delayed(const Duration(milliseconds: 1700));
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const QiblaCompassPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Camera Permission Required'),
        content: const Text(
          'This app needs camera access to show AR Qibla direction. Please enable camera permission in Settings.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const QiblaCompassPage(),
                ),
              );
            },
            child: const Text('Continue Anyway'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/qibla.png',
          width: 200,
          height: 300,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
