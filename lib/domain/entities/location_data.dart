import 'package:equatable/equatable.dart';

class LocationData extends Equatable {
  final double latitude;
  final double longitude;
  final double? accuracy;

  const LocationData({
    required this.latitude,
    required this.longitude,
    this.accuracy,
  });

  @override
  List<Object?> get props => [latitude, longitude, accuracy];
}
