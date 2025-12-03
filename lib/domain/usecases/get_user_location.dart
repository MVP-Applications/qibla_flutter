import '../entities/location_data.dart';
import '../repositories/location_repository.dart';

class GetUserLocation {
  final LocationRepository repository;

  GetUserLocation(this.repository);

  Stream<LocationData> call() {
    return repository.getLocationStream();
  }

  Future<bool> requestPermissions() {
    return repository.requestPermissions();
  }
}
