import '../entities/heading_data.dart';
import '../repositories/location_repository.dart';

class GetDeviceHeading {
  final LocationRepository repository;

  GetDeviceHeading(this.repository);

  Stream<HeadingData> call() {
    return repository.getHeadingStream();
  }
}
