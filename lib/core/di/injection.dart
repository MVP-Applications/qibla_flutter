import 'package:get_it/get_it.dart';
import '../../data/repositories/location_repository_impl.dart';
import '../../data/repositories/sensor_repository_impl.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/repositories/sensor_repository.dart';
import '../../domain/usecases/calculate_qibla_direction.dart';
import '../../domain/usecases/get_device_heading.dart';
import '../../domain/usecases/get_device_tilt.dart';
import '../../domain/usecases/get_user_location.dart';
import '../../domain/usecases/get_ar_qibla_bearing.dart';
import '../../domain/usecases/check_location_services.dart';
import '../../presentation/cubits/qibla_cubit.dart';
import '../../presentation/cubits/tilt_cubit.dart';
import '../../presentation/cubits/ar_cubit.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  // Repositories
  getIt.registerLazySingleton<LocationRepository>(() => LocationRepositoryImpl());
  getIt.registerLazySingleton<SensorRepository>(() => SensorRepositoryImpl());
  
  // Use Cases
  getIt.registerLazySingleton(() => GetUserLocation(getIt()));
  getIt.registerLazySingleton(() => GetDeviceHeading(getIt()));
  getIt.registerLazySingleton(() => CalculateQiblaDirection());
  getIt.registerLazySingleton(() => GetDeviceTilt(getIt()));
  getIt.registerLazySingleton(() => GetARQiblaBearing());
  getIt.registerLazySingleton(() => CheckLocationServices());
  
  // Cubits
  getIt.registerFactory(() => QiblaCubit(
    getUserLocation: getIt(),
    getDeviceHeading: getIt(),
    calculateQiblaDirection: getIt(),
  ));
  getIt.registerFactory(() => TiltCubit(getDeviceTilt: getIt()));
  getIt.registerFactory(() => ARCubit(
    getUserLocation: getIt(),
    getARQiblaBearing: getIt(),
    getDeviceHeading: getIt(),
  ));
}
