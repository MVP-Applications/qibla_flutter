# Qibla Finder - Flutter

A cross-platform Qibla direction finder app using AR, compass, and GPS. Converted from native iOS (Swift/SwiftUI) to Flutter.

## Features

- **AR-based Qibla Detection** - Uses ARKit (iOS) and ARCore (Android) for augmented reality
- **Real-time Compass** - Accurate heading detection using device magnetometer
- **GPS Location** - Calculates bearing to Mecca from current location
- **Device Tilt Detection** - Monitors phone orientation using accelerometer/gyroscope
- **Haptic Feedback** - Vibration when aligned with Qibla
- **Visual Indicators** - Arrow guidance and Qibla image overlay
- **Splash Screen** - 2.5 second intro animation

## Architecture

**Clean Architecture** with 3 layers:

### Presentation Layer
- **Cubits** (BLoC pattern): QiblaCubit, TiltCubit
- **Pages**: SplashPage, QiblaCompassPage
- **Widgets**: ARCameraView, DirectionArrow, QiblaImageOverlay, TiltWarningOverlay

### Domain Layer
- **Entities**: QiblaData, LocationData, HeadingData
- **Use Cases**: CalculateQiblaDirection, GetUserLocation, GetDeviceHeading, GetDeviceTilt
- **Repositories** (interfaces): LocationRepository, SensorRepository

### Data Layer
- **Repository Implementations**: LocationRepositoryImpl, SensorRepositoryImpl

## Dependencies

```yaml
flutter_bloc: ^8.1.3          # State management
get_it: ^7.6.4                # Dependency injection
geolocator: ^10.1.0           # GPS location
flutter_compass: ^0.8.0       # Compass/magnetometer
sensors_plus: ^4.0.2          # Accelerometer/gyroscope
ar_flutter_plugin: ^0.7.3     # AR (ARKit/ARCore)
vibration: ^1.8.3             # Haptic feedback
permission_handler: ^11.0.1   # Runtime permissions
```

## Setup

1. **Install dependencies:**
```bash
flutter pub get
```

2. **Add Qibla image assets:**
   - Place `qibla.png` in `assets/images/`
   - Place `phone_icon.png` in `assets/images/`

3. **Run the app:**
```bash
flutter run
```

## Permissions

### Android (AndroidManifest.xml)
- `ACCESS_FINE_LOCATION` - GPS location
- `CAMERA` - AR camera
- `VIBRATE` - Haptic feedback

### iOS (Info.plist)
- `NSCameraUsageDescription` - AR camera
- `NSLocationWhenInUseUsageDescription` - GPS location
- `arkit` capability required

## Qibla Calculation

Uses the **Haversine formula** to calculate bearing from user location to Mecca:
- Mecca coordinates: `21.422504°N, 39.826195°E`
- Alignment threshold: `±6°`

## Project Structure

```
lib/
├── core/
│   └── di/
│       └── injection.dart              # Dependency injection setup
├── data/
│   └── repositories/
│       ├── location_repository_impl.dart
│       └── sensor_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── qibla_data.dart
│   │   ├── location_data.dart
│   │   └── heading_data.dart
│   ├── repositories/
│   │   ├── location_repository.dart
│   │   └── sensor_repository.dart
│   └── usecases/
│       ├── calculate_qibla_direction.dart
│       ├── get_user_location.dart
│       ├── get_device_heading.dart
│       └── get_device_tilt.dart
├── presentation/
│   ├── cubits/
│   │   ├── qibla_cubit.dart
│   │   ├── qibla_state.dart
│   │   ├── tilt_cubit.dart
│   │   └── tilt_state.dart
│   ├── pages/
│   │   ├── splash_page.dart
│   │   └── qibla_compass_page.dart
│   └── widgets/
│       ├── ar_camera_view.dart
│       ├── direction_arrow.dart
│       ├── qibla_image_overlay.dart
│       └── tilt_warning_overlay.dart
└── main.dart
```

## Original iOS Project

Converted from Swift/SwiftUI project with:
- ARKit + RealityKit for AR
- CoreLocation for GPS/compass
- CoreMotion for device tilt
- SwiftUI for UI
- Combine for reactive streams

## License

MIT License
