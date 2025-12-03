abstract class SensorRepository {
  Stream<bool> getDeviceTiltStream();
  void dispose();
}
