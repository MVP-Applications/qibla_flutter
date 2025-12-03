import '../repositories/sensor_repository.dart';

class GetDeviceTilt {
  final SensorRepository repository;

  GetDeviceTilt(this.repository);

  Stream<bool> call() {
    return repository.getDeviceTiltStream();
  }
}
