import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/location_data.dart';
import '../../domain/entities/heading_data.dart';
import '../../domain/usecases/calculate_qibla_direction.dart';
import '../../domain/usecases/get_device_heading.dart';
import '../../domain/usecases/get_user_location.dart';
import 'qibla_state.dart';

class QiblaCubit extends Cubit<QiblaState> {
  final GetUserLocation getUserLocation;
  final GetDeviceHeading getDeviceHeading;
  final CalculateQiblaDirection calculateQiblaDirection;

  StreamSubscription? _locationSubscription;
  StreamSubscription? _headingSubscription;
  
  LocationData? _currentLocation;
  HeadingData? _currentHeading;

  QiblaCubit({
    required this.getUserLocation,
    required this.getDeviceHeading,
    required this.calculateQiblaDirection,
  }) : super(QiblaInitial());

  Future<void> startTracking() async {
    emit(QiblaLoading());

    final hasPermission = await getUserLocation.requestPermissions();
    if (!hasPermission) {
      emit(QiblaPermissionDenied());
      return;
    }

    _locationSubscription = getUserLocation().listen(
      (location) {
        _currentLocation = location;
        _updateQiblaData();
      },
      onError: (error) => emit(QiblaError(error.toString())),
    );

    _headingSubscription = getDeviceHeading().listen(
      (heading) {
        _currentHeading = heading;
        _updateQiblaData();
      },
      onError: (error) => emit(QiblaError(error.toString())),
    );
  }

  void _updateQiblaData() {
    if (_currentLocation != null && _currentHeading != null) {
      final qiblaData = calculateQiblaDirection(
        userLocation: _currentLocation!,
        deviceHeading: _currentHeading!.heading,
      );
      emit(QiblaUpdated(qiblaData));
    }
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    _headingSubscription?.cancel();
    return super.close();
  }
}
