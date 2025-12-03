import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibration/vibration.dart';
import '../cubits/qibla_cubit.dart';
import '../cubits/qibla_state.dart';
import '../widgets/panorama_viewer.dart';

class PanoramaKaabaPage extends StatefulWidget {
  const PanoramaKaabaPage({super.key});

  @override
  State<PanoramaKaabaPage> createState() => _PanoramaKaabaPageState();
}

class _PanoramaKaabaPageState extends State<PanoramaKaabaPage> {
  double? _qiblaBearing;
  double? _deviceHeading;
  bool _isFacingQibla = false;
  bool _hasVibrated = false;
  Timer? _compassTimer;
  
  // Qibla alignment threshold (degrees)
  static const double alignmentThreshold = 15.0;

  @override
  void initState() {
    super.initState();
    _startCompassTracking();
  }

  @override
  void dispose() {
    _compassTimer?.cancel();
    super.dispose();
  }

  void _startCompassTracking() {
    // Update compass data every 100ms
    _compassTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) return;
      
      final qiblaState = context.read<QiblaCubit>().state;
      if (qiblaState is QiblaUpdated) {
        setState(() {
          _qiblaBearing = qiblaState.qiblaData.qiblaDirection;
          _deviceHeading = qiblaState.qiblaData.deviceHeading;
          
          // Check if facing Qibla
          final difference = (qiblaState.qiblaData.differenceAngle).abs();
          final wasFacingQibla = _isFacingQibla;
          _isFacingQibla = difference < alignmentThreshold;
          
          // Trigger haptic feedback when entering Qibla zone
          if (_isFacingQibla && !wasFacingQibla && !_hasVibrated) {
            _triggerHapticFeedback();
            _hasVibrated = true;
          } else if (!_isFacingQibla) {
            _hasVibrated = false;
          }
        });
      }
    });
  }

  Future<void> _triggerHapticFeedback() async {
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      // Pattern: vibrate 200ms, pause 100ms, vibrate 200ms
      await Vibration.vibrate(duration: 200);
      await Future.delayed(const Duration(milliseconds: 100));
      await Vibration.vibrate(duration: 200);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 360° Panorama View with sensor alignment
          PanoramaViewer(
            imagePath: 'assets/panorama/kaaba_360.jpg',
            qiblaBearing: _qiblaBearing ?? 0.0,
            deviceHeading: _deviceHeading ?? 0.0,
          ),

          // Top bar with back button
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Expanded(
                      child: Text(
                        '360° Kaaba View',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
          ),

          // Qibla direction indicator
          if (_qiblaBearing != null && _deviceHeading != null)
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: _isFacingQibla
                        ? Colors.green.withValues(alpha: 0.9)
                        : Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: _isFacingQibla ? Colors.white : Colors.white24,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isFacingQibla ? Icons.check_circle : Icons.explore,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isFacingQibla
                            ? 'Facing Qibla!'
                            : 'Rotate to find Qibla',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Compass indicator
          if (_qiblaBearing != null && _deviceHeading != null)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Center(
                child: _buildCompassIndicator(),
              ),
            ),

          // Instructions
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone_android, color: Colors.white70, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Rotate your device to look around',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                  if (_isFacingQibla) ...[
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.vibration, color: Colors.green, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'You are facing Qibla direction',
                          style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompassIndicator() {
    if (_qiblaBearing == null || _deviceHeading == null) {
      return const SizedBox.shrink();
    }

    // Calculate angle difference
    final difference = (_qiblaBearing! - _deviceHeading! + 360) % 360;
    final displayAngle = difference > 180 ? difference - 360 : difference;

    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white24, width: 2),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Compass circle with degrees
          CustomPaint(
            size: const Size(180, 180),
            painter: CompassPainter(
              qiblaAngle: displayAngle,
              isFacingQibla: _isFacingQibla,
            ),
          ),
          
          // Center info
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${displayAngle.abs().toStringAsFixed(0)}°',
                style: TextStyle(
                  color: _isFacingQibla ? Colors.green : Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                displayAngle < 0 ? 'Turn Left' : displayAngle > 0 ? 'Turn Right' : 'Aligned',
                style: TextStyle(
                  color: _isFacingQibla ? Colors.green : Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom painter for compass
class CompassPainter extends CustomPainter {
  final double qiblaAngle;
  final bool isFacingQibla;

  CompassPainter({
    required this.qiblaAngle,
    required this.isFacingQibla,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw compass circle
    final circlePaint = Paint()
      ..color = Colors.white12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, circlePaint);

    // Draw cardinal directions
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    final directions = ['N', 'E', 'S', 'W'];
    for (var i = 0; i < 4; i++) {
      final angle = i * math.pi / 2;
      final x = center.dx + radius * 0.85 * math.sin(angle);
      final y = center.dy - radius * 0.85 * math.cos(angle);

      textPainter.text = TextSpan(
        text: directions[i],
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height / 2),
      );
    }

    // Draw Qibla direction arrow
    final qiblaRadians = qiblaAngle * math.pi / 180;
    final arrowPaint = Paint()
      ..color = isFacingQibla ? Colors.green : Colors.orange
      ..style = PaintingStyle.fill;

    final arrowPath = Path();
    final arrowLength = radius * 0.7;
    final arrowWidth = 15.0;

    // Arrow pointing to Qibla
    final tipX = center.dx + arrowLength * math.sin(qiblaRadians);
    final tipY = center.dy - arrowLength * math.cos(qiblaRadians);
    
    final leftX = center.dx + arrowWidth * math.sin(qiblaRadians - math.pi / 2);
    final leftY = center.dy - arrowWidth * math.cos(qiblaRadians - math.pi / 2);
    
    final rightX = center.dx + arrowWidth * math.sin(qiblaRadians + math.pi / 2);
    final rightY = center.dy - arrowWidth * math.cos(qiblaRadians + math.pi / 2);

    arrowPath.moveTo(tipX, tipY);
    arrowPath.lineTo(leftX, leftY);
    arrowPath.lineTo(center.dx, center.dy);
    arrowPath.lineTo(rightX, rightY);
    arrowPath.close();

    canvas.drawPath(arrowPath, arrowPaint);

    // Draw Kaaba icon at arrow tip
    final iconPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(tipX, tipY), 8, iconPaint);
    
    final kaabaPaint = Paint()
      ..color = isFacingQibla ? Colors.green : Colors.orange
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromCenter(center: Offset(tipX, tipY), width: 10, height: 10),
      kaabaPaint,
    );
  }

  @override
  bool shouldRepaint(CompassPainter oldDelegate) {
    return oldDelegate.qiblaAngle != qiblaAngle ||
        oldDelegate.isFacingQibla != isFacingQibla;
  }
}
