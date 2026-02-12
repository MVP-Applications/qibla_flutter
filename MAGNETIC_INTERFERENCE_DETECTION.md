# Magnetic Interference Detection

## Overview

The Qibla AR Finder package now includes automatic magnetic interference detection to warn users when nearby objects are affecting compass accuracy. This is a critical feature for AR-based Qibla apps since the magnetometer (digital compass) is extremely sensitive to interference.

## Why This Matters

When using AR to show Qibla direction, the app relies on the phone's magnetometer to detect magnetic north. However, nearby objects can distort these readings:

### Common Sources of Interference
- 📱 **Other mobile phones** - Speakers, vibration motors, wireless charging coils
- 🔩 **Metal objects** - Keys, rings, tables, stands, jewelry
- ⚡ **Electronic devices** - Power banks, chargers, laptops, speakers
- 🔌 **Electrical currents** - Power outlets, cables, transformers

### Impact on AR
Even a 2-5° error in compass readings becomes visually amplified in AR because:
- AR places objects relative to real-world orientation
- Small sensor noise = large visual movement
- The Kaaba arrow appears to "jump" or rotate incorrectly

## How It Works

The magnetic interference detector uses a multi-signal approach based on production Qibla app best practices:

### Detection Signals

1. **Magnetic Field Strength Check** (PRIMARY)
   - Earth's normal magnetic field: 25-65 µT (microtesla)
   - Triggers when: magnitude < 20 µT or > 70 µT
   - Most reliable indicator of nearby metal/electronics

2. **Magnetic Instability Detection**
   - Monitors rapid fluctuations in magnetic field
   - Triggers when: magnitude changes > 5 µT between readings
   - Detects moving metal objects or electronics

3. **Heading Jump Without Rotation**
   - Compares compass heading changes with gyroscope rotation
   - Triggers when: heading jumps > 10° but device rotation < 0.5°/sec
   - Identifies false compass rotations

### Decision Logic

The warning is shown when **at least 2 conditions are true**:
- (Magnetic distortion AND Instability) OR
- (Magnetic distortion AND Heading jump) OR
- (Instability AND Heading jump)

This multi-signal approach prevents false positives while ensuring real interference is detected.

### Debouncing

To avoid UI flicker, the warning:
- Requires conditions to persist for 1 second before showing
- Clears immediately when interference stops

## Implementation

### Automatic Integration

The magnetic interference detection is automatically integrated into both Android and iOS AR views:

```dart
// Android
ARViewEnhancedAndroid(
  qiblaBearing: qiblaBearing,
  deviceHeading: deviceHeading,
  showOverlay: true,
  primaryColor: Colors.green,
  moveRightText: 'Move Right',
  moveLeftText: 'Move Left',
)

// iOS
ARViewEnhancedIOS(
  qiblaBearing: qiblaBearing,
  deviceHeading: deviceHeading,
  showOverlay: true,
  primaryColor: Colors.green,
  moveRightText: 'Move Right',
  moveLeftText: 'Move Left',
)
```

No additional setup required - the AR views automatically start monitoring when displayed.

### Manual Control (Advanced)

If you need manual control over interference monitoring:

```dart
// Start monitoring
context.read<ARCubit>().startInterferenceMonitoring();

// Stop monitoring
context.read<ARCubit>().stopInterferenceMonitoring();

// Listen to interference state
BlocListener<ARCubit, ARState>(
  listener: (context, state) {
    if (state is ARMagneticInterferenceDetected) {
      if (state.isDetected) {
        print('Magnetic interference detected!');
      } else {
        print('Interference cleared');
      }
    }
  },
  child: YourWidget(),
)
```

### Custom Warning Widget

You can customize the warning appearance:

```dart
MagneticInterferenceWarning(
  backgroundColor: Color(0xFFFF6B6B),
  textColor: Colors.white,
  iconColor: Colors.white,
)
```

## User Experience

### Warning Message

When interference is detected, users see:

```
⚠️ Magnetic Interference Detected

For accurate Qibla direction, keep your phone 
away from metal objects and other devices.
```

### Best Practices for Users

Educate your users to:
1. Keep phone away from metal objects (keys, rings, tables)
2. Move away from other electronic devices
3. Avoid using near power outlets or chargers
4. Hold phone in open space when using AR
5. Perform figure-8 calibration if prompted by OS

## Technical Details

### Thresholds

Based on production Qibla apps and industry standards:

```dart
// Magnetic field strength (Earth's normal range)
minNormalMagnitude: 20.0 µT
maxNormalMagnitude: 70.0 µT

// Instability detection
magnitudeChangeDelta: 5.0 µT

// Heading jump detection
headingJumpThreshold: 10.0 degrees
gyroStillThreshold: 0.5 degrees/sec

// Debounce timing
debounceMilliseconds: 1000 ms (1 second)
```

### Sensor Fusion

The detector uses three sensors:
- **Magnetometer** - Measures magnetic field strength and direction
- **Compass** - Provides heading (derived from magnetometer + accelerometer)
- **Gyroscope** - Measures device rotation rate

### Performance

- Minimal battery impact (uses existing sensor streams)
- No additional permissions required
- Works on both Android and iOS
- Automatic cleanup when AR view is disposed

## Architecture

### Components

1. **MagneticInterferenceDetector** (`lib/services/magnetic_interference_detector.dart`)
   - Singleton service that monitors sensors
   - Emits interference detection events
   - Handles debouncing and multi-signal logic

2. **MagneticInterferenceData** (`lib/domain/entities/magnetic_interference_data.dart`)
   - Entity representing interference state
   - Includes magnitude, stability, and timing data

3. **ARMagneticInterferenceDetected** (`lib/presentation/cubits/ar_state.dart`)
   - BLoC state for interference detection
   - Triggers UI updates

4. **MagneticInterferenceWarning** (`lib/presentation/widgets/magnetic_interference_warning.dart`)
   - Reusable warning widget
   - Customizable appearance

### Data Flow

```
Sensors (Magnetometer, Compass, Gyroscope)
    ↓
MagneticInterferenceDetector
    ↓
Stream<MagneticInterferenceData>
    ↓
ARCubit
    ↓
ARMagneticInterferenceDetected State
    ↓
AR View (Android/iOS)
    ↓
MagneticInterferenceWarning Widget
```

## Testing

### Simulate Interference

To test the feature:

1. **Metal objects**: Place phone near keys, coins, or metal table
2. **Electronics**: Hold phone near another phone or laptop
3. **Magnets**: Use a small magnet (carefully!)
4. **Power sources**: Test near chargers or power banks

### Expected Behavior

- Warning appears within 1 second of interference
- Warning clears immediately when interference stops
- No false positives during normal phone movement
- Smooth transitions (no flickering)

## Limitations

This is a **hardware and physics limitation**, not a software bug:

- Google Maps Live View has the same issue
- Apple Compass behaves identically
- Professional navigation devices are also affected
- Cannot be "fixed" - only detected and warned about

## References

- [Android SensorManager Documentation](https://developer.android.com/reference/android/hardware/SensorManager)
- [iOS Core Motion Framework](https://developer.apple.com/documentation/coremotion)
- Earth's magnetic field: 25-65 µT (varies by location)
- Production Qibla apps: Muslim Pro, Athan, Qibla Compass

## Support

For issues or questions about magnetic interference detection:
1. Check that sensors are working: `flutter doctor`
2. Verify permissions are granted (location, camera)
3. Test on physical device (not simulator)
4. Review debug logs for sensor readings

---

**Note**: This feature follows industry best practices used by top Qibla and navigation apps. The detection thresholds and logic are based on real-world testing and production app behavior.
