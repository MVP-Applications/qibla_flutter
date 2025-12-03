import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:camera/camera.dart';

/// Simple panorama viewer using camera overlay
class PanoramaViewer extends StatefulWidget {
  final String imagePath;
  final double qiblaBearing;
  final double deviceHeading;

  const PanoramaViewer({
    super.key,
    required this.imagePath,
    required this.qiblaBearing,
    required this.deviceHeading,
  });

  @override
  State<PanoramaViewer> createState() => _PanoramaViewerState();
}

class _PanoramaViewerState extends State<PanoramaViewer> {
  StreamSubscription? _compassSubscription;
  double _currentHeading = 0.0;
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _startCompassTracking();
    _initializeCamera();
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _cameraController = CameraController(
          cameras[0],
          ResolutionPreset.high,
          enableAudio: false,
        );
        await _cameraController!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Camera error: $e');
    }
  }

  void _startCompassTracking() {
    _compassSubscription = FlutterCompass.events?.listen((event) {
      if (event.heading != null && mounted) {
        setState(() {
          _currentHeading = event.heading!;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final angleDiff = (_currentHeading - widget.qiblaBearing).abs();
    final normalizedDiff = angleDiff > 180 ? 360 - angleDiff : angleDiff;
    final isFacingQibla = normalizedDiff < 15;

    return Stack(
      children: [
        // Camera background
        if (_isCameraInitialized && _cameraController != null)
          SizedBox.expand(
            child: CameraPreview(_cameraController!),
          )
        else
          Container(
            color: Colors.black,
            child: Center(
              child: Image.asset(
                widget.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.image, color: Colors.white, size: 100),
                  );
                },
              ),
            ),
          ),

        // Qibla indicator overlay
        if (isFacingQibla)
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.white, size: 40),
                  SizedBox(height: 8),
                  Text(
                    'Facing\nQibla',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Info panel
        Positioned(
          top: 80,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isFacingQibla ? Icons.check_circle : Icons.explore,
                        color: isFacingQibla ? Colors.green : Colors.orange,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isFacingQibla ? 'Aligned with Qibla!' : 'Rotate to find Qibla',
                        style: TextStyle(
                          color: isFacingQibla ? Colors.green : Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildInfoChip('You', '${_currentHeading.toStringAsFixed(0)}°', Colors.blue),
                      const SizedBox(width: 8),
                      _buildInfoChip('Qibla', '${widget.qiblaBearing.toStringAsFixed(0)}°', Colors.green),
                      const SizedBox(width: 8),
                      _buildInfoChip('Off', '${normalizedDiff.toStringAsFixed(0)}°',
                          isFacingQibla ? Colors.green : Colors.orange),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(color: color, fontSize: 9)),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
