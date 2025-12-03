import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';
import '../../domain/repositories/sensor_repository.dart';

class SensorRepositoryImpl implements SensorRepository {
  StreamController<bool>? _tiltController;
  StreamSubscription? _gyroSubscription;

  @override
  Stream<bool> getDeviceTiltStream() {
    _tiltController ??= StreamController<bool>.broadcast();
    
    _gyroSubscription = accelerometerEventStream().listen((event) {
      // Calculate pitch angle from accelerometer
      final pitch = atan2(event.y, sqrt(event.x * event.x + event.z * event.z));
      final pitchDegrees = (pitch * 180 / pi).abs();
      
      // Phone is vertical if pitch is between 60° and 120°
      final isVertical = pitchDegrees > 60 && pitchDegrees < 120;
      _tiltController?.add(isVertical);
    });

    return _tiltController!.stream;
  }

  @override
  void dispose() {
    _gyroSubscription?.cancel();
    _tiltController?.close();
  }
}
