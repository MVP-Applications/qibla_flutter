# Example: Using Qibla AR Finder in External Projects

## Complete Working Example

This shows how developers will use your package in their own projects, with the magnetic interference warning working automatically.

## Step 1: Add Package Dependency

```yaml
# pubspec.yaml
name: my_qibla_app
description: My Qibla finder app

dependencies:
  flutter:
    sdk: flutter
  
  # Add your package
  qibla_ar_finder:
    git:
      url: https://github.com/yourusername/qibla_ar_finder.git
      ref: main  # or specific version tag
  
  # Required peer dependencies
  flutter_bloc: ^8.1.3
  get_it: ^7.6.0
```

## Step 2: Initialize in main.dart

```dart
// main.dart
import 'package:flutter/material.dart';
import 'package:qibla_ar_finder/qibla_ar_finder.dart';

void main() {
  // Initialize the package's dependency injection
  configureDependencies();
  
  runApp(MyQiblaApp());
}

class MyQiblaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Qibla Finder',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomeScreen(),
    );
  }
}
```

## Step 3: Use AR View in Your Screen

```dart
// home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qibla_ar_finder/qibla_ar_finder.dart';
import 'package:get_it/get_it.dart';

class HomeScreen extends StatelessWidget {
  final getIt = GetIt.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Qibla Finder'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to AR Qibla page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => getIt<ARCubit>(),
                  child: ARQiblaPage(),
                ),
              ),
            );
          },
          child: Text('Open AR Qibla Finder'),
        ),
      ),
    );
  }
}
```

## That's It! 🎉

The magnetic interference warning will **automatically appear** when users:
- Hold phone near metal objects
- Use phone near other devices
- Are near electronic equipment

## What Users Will See

### Normal AR View
```
┌─────────────────────────────────────┐
│         Camera View                 │
│                                     │
│         [Kaaba Image]               │
│            ↓                        │
│                                     │
│    ← Move Left  |  Move Right →    │
│                                     │
└─────────────────────────────────────┘
```

### When Interference Detected
```
┌─────────────────────────────────────┐
│ ⚠️ Magnetic Interference Detected   │
│ Keep phone away from metal objects  │
├─────────────────────────────────────┤
│         Camera View                 │
│                                     │
│         [Kaaba Image]               │
│            ↓                        │
│                                     │
│    ← Move Left  |  Move Right →    │
│                                     │
└─────────────────────────────────────┘
```

## Advanced: Custom Implementation

If you want more control, you can use the AR views directly:

```dart
// custom_ar_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qibla_ar_finder/qibla_ar_finder.dart';
import 'package:get_it/get_it.dart';

class CustomARScreen extends StatefulWidget {
  @override
  _CustomARScreenState createState() => _CustomARScreenState();
}

class _CustomARScreenState extends State<CustomARScreen> {
  final getIt = GetIt.instance;
  double? qiblaBearing;
  double? deviceHeading;

  @override
  void initState() {
    super.initState();
    _initializeQibla();
  }

  Future<void> _initializeQibla() async {
    // Get user location and calculate Qibla
    final getUserLocation = getIt<GetUserLocation>();
    final getARQiblaBearing = getIt<GetARQiblaBearing>();
    final getDeviceHeading = getIt<GetDeviceHeading>();

    try {
      // Get location
      final locationStream = getUserLocation();
      final location = await locationStream.first;

      // Calculate Qibla bearing
      final bearing = getARQiblaBearing(location);

      // Get device heading
      final headingStream = getDeviceHeading();
      final heading = await headingStream.first;

      setState(() {
        qiblaBearing = bearing;
        deviceHeading = heading.heading;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (qiblaBearing == null || deviceHeading == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return BlocProvider(
      create: (_) => getIt<ARCubit>(),
      child: Scaffold(
        body: ARViewEnhancedAndroid(
          qiblaBearing: qiblaBearing!,
          deviceHeading: deviceHeading!,
          showOverlay: true,
          primaryColor: Colors.green,
          moveRightText: 'Turn Right',
          moveLeftText: 'Turn Left',
        ),
        // Magnetic interference warning appears automatically!
      ),
    );
  }
}
```

## Advanced: Listen to Interference State

If you want to react to interference detection:

```dart
// interference_aware_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qibla_ar_finder/qibla_ar_finder.dart';

class InterferenceAwareScreen extends StatelessWidget {
  final double qiblaBearing;
  final double deviceHeading;

  const InterferenceAwareScreen({
    required this.qiblaBearing,
    required this.deviceHeading,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<ARCubit, ARState>(
      listener: (context, state) {
        // Listen to interference state
        if (state is ARMagneticInterferenceDetected) {
          if (state.isDetected) {
            print('⚠️ Magnetic interference detected!');
            // Optional: Show additional UI, log analytics, etc.
          } else {
            print('✅ Interference cleared');
          }
        }
      },
      child: Scaffold(
        body: ARViewEnhancedAndroid(
          qiblaBearing: qiblaBearing,
          deviceHeading: deviceHeading,
          showOverlay: true,
          primaryColor: Colors.green,
          moveRightText: 'Move Right',
          moveLeftText: 'Move Left',
        ),
      ),
    );
  }
}
```

## Advanced: Custom Warning Appearance

If you want to customize the warning colors:

```dart
// Note: The warning is automatically shown by AR views,
// but if you want to show it manually with custom colors:

import 'package:qibla_ar_finder/qibla_ar_finder.dart';

MagneticInterferenceWarning(
  backgroundColor: Color(0xFFFF6B6B),  // Red
  textColor: Colors.white,
  iconColor: Colors.yellow,
)
```

## Testing the Feature

### Test Scenario 1: Metal Object
1. Open AR view in your app
2. Place phone near keys or metal table
3. **Expected:** Warning appears within 1 second
4. Move phone away
5. **Expected:** Warning disappears immediately

### Test Scenario 2: Another Phone
1. Open AR view in your app
2. Hold another phone close to your device
3. **Expected:** Warning appears within 1 second
4. Move other phone away
5. **Expected:** Warning disappears immediately

### Test Scenario 3: Electronic Device
1. Open AR view in your app
2. Place phone near laptop or power bank
3. **Expected:** Warning appears within 1 second
4. Move away from device
5. **Expected:** Warning disappears immediately

### Test Scenario 4: Normal Movement
1. Open AR view in your app
2. Move phone normally (rotate, tilt, walk)
3. **Expected:** No warning appears (no false positives)

## Platform-Specific Notes

### Android
- Uses Camera AR with overlay
- Warning appears at top of camera view
- Works on Android 5.0+ (API 21+)

### iOS
- Uses ARKit with 3D models
- Warning appears at top of AR view
- Works on iOS 11.0+

## Troubleshooting

### Warning Not Appearing

**Check:**
1. Are you on a physical device? (Sensors don't work in simulators)
2. Are permissions granted? (Location, Camera)
3. Is the interference strong enough? (Try holding phone very close to metal)

**Debug:**
```dart
// Enable debug logs
import 'package:flutter/foundation.dart';

// Logs will show:
// "MagneticInterference: DETECTED - Magnitude: 45.2µT"
// "MagneticInterference: CLEARED"
```

### False Positives

If warning appears too often:
- This is rare due to multi-signal detection
- May indicate actual environmental interference
- Try testing in different location

### Warning Not Clearing

If warning stays visible:
- Move further from interference source
- Ensure device is in open space
- Restart app if issue persists

## Complete Project Structure

```
my_qibla_app/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── home_screen.dart             # Home screen with button
│   └── custom_ar_screen.dart        # Optional custom implementation
├── pubspec.yaml                     # Dependencies
└── README.md
```

## Minimal pubspec.yaml

```yaml
name: my_qibla_app
description: Qibla finder with AR

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # Your package (automatic interference detection included!)
  qibla_ar_finder:
    git:
      url: https://github.com/yourusername/qibla_ar_finder.git
  
  # Required peer dependencies
  flutter_bloc: ^8.1.3
  get_it: ^7.6.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0
```

## Summary

### What External Projects Get Automatically

✅ **Magnetic interference detection** - No setup required  
✅ **Professional warning UI** - Appears automatically  
✅ **Multi-signal algorithm** - Prevents false positives  
✅ **Cross-platform support** - Android & iOS  
✅ **Zero configuration** - Just use the AR views  
✅ **Zero permissions** - Uses existing sensor access  
✅ **Production-ready** - Industry-standard implementation  

### What External Projects Need to Do

1. Add package to `pubspec.yaml`
2. Call `configureDependencies()` in `main()`
3. Use `ARQiblaPage` or AR views

**That's it!** The magnetic interference warning works automatically. 🎉

---

**Questions?** See the full documentation:
- `MAGNETIC_INTERFERENCE_DETECTION.md` - Technical details
- `MAGNETIC_INTERFERENCE_QUICK_START.md` - Quick start guide
- `EXTERNAL_PROJECT_INTEGRATION.md` - Integration guide
