import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';
import '../../domain/entities/location_data.dart';
import '../../domain/entities/heading_data.dart';
import '../../domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  StreamController<LocationData>? _locationController;
  StreamController<HeadingData>? _headingController;

  @override
  Stream<LocationData> getLocationStream() {
    _locationController ??= StreamController<LocationData>.broadcast();
    
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 1,
      ),
    ).listen((position) {
      _locationController?.add(LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
      ));
    });

    return _locationController!.stream;
  }

  @override
  Stream<HeadingData> getHeadingStream() {
    _headingController ??= StreamController<HeadingData>.broadcast();
    
    FlutterCompass.events?.listen((event) {
      if (event.heading != null) {
        _headingController?.add(HeadingData(
          heading: event.heading!,
          accuracy: event.accuracy,
        ));
      }
    });

    return _headingController!.stream;
  }

  @override
  Future<bool> requestPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    
    return permission == LocationPermission.always || 
           permission == LocationPermission.whileInUse;
  }

  @override
  Future<bool> isLocationServiceEnabled() {
    return Geolocator.isLocationServiceEnabled();
  }

  void dispose() {
    _locationController?.close();
    _headingController?.close();
  }
}
