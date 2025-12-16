import '../../domain/repositories/sensor_repository.dart';

/// Use case for getting device tilt/vertical position
/// Returns a stream of boolean values indicating if device is vertical
class GetDeviceTilt {
  final SensorRepository repository;

  GetDeviceTilt(this.repository);

  Stream<bool> call() {
    return repository.getDeviceTiltStream();
  }
}
