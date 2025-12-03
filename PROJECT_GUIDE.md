# Qibla AR Finder - Complete Project Guide

## 📖 Overview

A Flutter-based Qibla direction finder using AR, compass, and GPS. This project serves as both a standalone app and a reusable package for finding the direction to Kaaba (Mecca) using augmented reality.

**Core Purpose:** Help Muslims find the Qibla direction for prayer using modern AR technology on both Android and iOS devices.

---

## 🎯 Project Structure

This repository contains:
1. **Main App** (`lib/`) - Full-featured Qibla finder application
2. **Package** (`package_files/`) - Reusable package for other projects
3. **Scripts** - Helper scripts for package management

---

## 🏗️ Architecture

**Clean Architecture** with 3 layers:

### 1. Presentation Layer
- **Cubits** (BLoC pattern): State management for Qibla, AR, and device tilt
- **Pages**: Splash, Compass, AR views
- **Widgets**: AR camera, direction arrows, Kaaba overlay, warnings

### 2. Domain Layer
- **Entities**: QiblaData, LocationData, HeadingData
- **Use Cases**: Calculate Qibla, get location, get heading, get tilt
- **Repositories** (interfaces): Location and Sensor abstractions

### 3. Data Layer
- **Repository Implementations**: GPS, compass, accelerometer integrations

---

## 🚀 Features

- ✅ **AR View** - Camera overlay with Kaaba positioned in Qibla direction
- ✅ **Compass View** - Traditional compass with Qibla indicator
- ✅ **GPS Location** - Automatic location detection
- ✅ **Real-time Tracking** - Device orientation and heading
- ✅ **Vertical Warning** - Alerts when phone is not held vertically
- ✅ **Smooth Animations** - Reduced jitter and vibration
- ✅ **Configurable UI** - Hide/show UI elements from package
- ✅ **Cross-platform** - Android (Camera AR) and iOS (ARKit)

---

## 📦 Using as a Package

### For Your Team (GitHub)

**Step 1: Push to GitHub**
```bash
cd ../qibla_ar_finder
git init
git add .
git commit -m "Qibla AR Finder package"
git remote add origin https://github.com/YOUR_ORG/qibla_ar_finder.git
git push -u origin main
```

**Step 2: Use in Any Project**
```yaml
# pubspec.yaml
dependencies:
  qibla_ar_finder:
    git:
      url: https://github.com/YOUR_ORG/qibla_ar_finder.git
      ref: main
```

**Step 3: Import and Use**
```dart
import 'package:qibla_ar_finder/qibla_ar_finder.dart';

// Basic usage
QiblaARPage()

// Configurable UI
QiblaARPage(
  config: ARPageConfig(
    showTopBar: false,          // Hide title bar
    showInstructions: false,    // Hide bottom instructions
    showCompassIndicators: false, // Hide compass indicators
    customTitle: 'Find Qibla',  // Custom title text
  ),
)
```

### Configuration Options

```dart
ARPageConfig({
  bool showTopBar = true,              // Show "AR Qibla Direction" title
  bool showInstructions = true,        // Show bottom instructions
  bool showCompassIndicators = true,   // Show compass indicators
  String? customTitle,                 // Custom title text
})
```

---

## 🛠️ Development Setup

### Prerequisites
- Flutter SDK (3.0+)
- Android Studio / Xcode
- Physical device (AR requires real device)

### Installation

```bash
# Clone the repository
git clone <your-repo-url>
cd qibla_flutter

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Platform Setup

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.CAMERA" />
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to calculate Qibla direction</string>
<key>NSCameraUsageDescription</key>
<string>Camera is required for AR view</string>
<key>arkit</key>
<string>Required for AR features</string>
```

---

## 📂 Key Files

### Main Application
- `lib/main.dart` - App entry point
- `lib/presentation/pages/qibla_compass_page.dart` - Main compass view
- `lib/presentation/widgets/ar_view_enhanced_android.dart` - Android AR implementation
- `lib/presentation/widgets/ar_view_enhanced_ios.dart` - iOS AR implementation

### Package Files
- `package_files/qibla_ar_page_configurable.dart` - Configurable AR page widget
- `package_files/lib/` - Package source code
- `package_pubspec.yaml` - Package dependencies

### Scripts
- `create_package.sh` - Creates the package structure
- `copy_package_files.sh` - Copies files to package
- `fix_package_imports.sh` - Fixes import paths

---

## 🔧 Maintenance Guide

### Adding New Features

1. **Update Main App First**
   - Implement feature in `lib/`
   - Test thoroughly on both platforms

2. **Update Package**
   - Copy changes to `package_files/`
   - Update imports to use package structure
   - Test in example app

3. **Version Control**
   ```bash
   git tag v1.1.0
   git push origin v1.1.0
   ```

### Common Tasks

**Update Qibla Calculation:**
- Edit `lib/domain/usecases/calculate_qibla_direction.dart`
- Kaaba coordinates: `21.422504°N, 39.826195°E`

**Modify AR Behavior:**
- Android: `lib/presentation/widgets/ar_view_enhanced_android.dart`
- iOS: `lib/presentation/widgets/ar_view_enhanced_ios.dart`

**Change UI Elements:**
- Edit `package_files/qibla_ar_page_configurable.dart`
- Add new config options to `ARPageConfig` class

**Update Dependencies:**
```bash
flutter pub upgrade
# Test thoroughly after upgrades
```

---

## 🧪 Testing

```bash
# Run on Android
flutter run -d android

# Run on iOS
flutter run -d ios

# Build release
flutter build apk --release
flutter build ios --release
```

**Test Checklist:**
- ✅ GPS location detection
- ✅ Compass accuracy
- ✅ AR camera view
- ✅ Kaaba positioning
- ✅ Vertical warning
- ✅ Permission handling
- ✅ Both platforms

---

## 📊 Dependencies

```yaml
flutter_bloc: ^8.1.3          # State management
get_it: ^7.6.4                # Dependency injection
geolocator: ^10.1.0           # GPS location
flutter_compass: ^0.8.0       # Compass/magnetometer
sensors_plus: ^4.0.2          # Accelerometer/gyroscope
camera: ^0.10.5+5             # Camera for AR (Android)
ar_flutter_plugin: ^0.7.3     # ARKit (iOS)
vibration: ^1.8.3             # Haptic feedback
permission_handler: ^11.0.1   # Runtime permissions
```

---

## 🐛 Troubleshooting

### GPS Not Working
- Check location permissions
- Go outdoors for better signal
- Verify location services enabled

### AR View Black Screen
- Verify camera permissions
- Check device supports AR
- Ensure proper platform setup

### Compass Inaccurate
- Calibrate compass (figure-8 motion)
- Keep away from magnetic interference
- Check sensor permissions

### Package Import Errors
- Run `flutter pub get`
- Check import paths
- Verify package structure

---

## 📝 How It Works

1. **GPS Detection** - Gets user's current latitude/longitude
2. **Qibla Calculation** - Calculates bearing to Kaaba using great circle formula
3. **Compass Tracking** - Monitors device heading in real-time
4. **AR Rendering** - Positions Kaaba image in calculated direction
5. **Smoothing** - Applies filters to reduce jitter and vibration

**Formula:** Uses Haversine formula for accurate bearing calculation
**Alignment:** ±6° threshold for "aligned" state

---

## 🎨 Customization

### Change Kaaba Image
Replace `assets/images/qibla.png` with your custom image

### Modify Colors
Edit color values in AR view widgets:
```dart
Colors.green  // Qibla indicator
Colors.blue   // Device heading
Colors.white  // Arrows and text
```

### Adjust Smoothing
In `ar_view_enhanced_android.dart`:
```dart
static const double _smoothingFactor = 0.1; // Lower = smoother
```

---

## 📄 License

MIT License - Free to use and modify

---

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

---

## 📞 Support

For issues or questions:
- Open GitHub issue
- Check existing documentation
- Review example implementations

---

**Made with ❤️ for the Muslim community**
