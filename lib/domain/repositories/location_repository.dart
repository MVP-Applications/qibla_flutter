import '../entities/location_data.dart';
import '../entities/heading_data.dart';

abstract class LocationRepository {
  Stream<LocationData> getLocationStream();
  Stream<HeadingData> getHeadingStream();
  Future<bool> requestPermissions();
  Future<bool> isLocationServiceEnabled();
}
