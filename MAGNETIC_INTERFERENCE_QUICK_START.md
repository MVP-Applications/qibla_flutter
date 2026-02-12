# Magnetic Interference Detection - Quick Start

## What's New

Your Qibla AR Finder package now automatically detects and warns users about magnetic interference that can affect compass accuracy.

## Zero Configuration Required

The feature is **automatically enabled** in both AR views. No code changes needed if you're already using:
- `ARViewEnhancedAndroid`
- `ARViewEnhancedIOS`

## What Users Will See

When magnetic interference is detected (phone near metal, other devices, etc.), a warning banner appears:

```
⚠️ Magnetic Interference Detected

For accurate Qibla direction, keep your phone 
away from metal objects and other devices.
```

## How It Works

The system monitors three signals:
1. **Magnetic field strength** - Detects if outside Earth's normal range (25-65 µT)
2. **Magnetic instability** - Detects rapid fluctuations
3. **False heading jumps** - Detects compass changes without device rotation

Warning shows when **2 or more signals** indicate interference.

## Testing

Try these to see the warning:
- Place phone near keys or metal objects
- Hold phone near another phone
- Use near laptop or power bank
- Test near power outlets

## Customization (Optional)

### Custom Warning Colors

```dart
MagneticInterferenceWarning(
  backgroundColor: Color(0xFFFF6B6B),
  textColor: Colors.white,
  iconColor: Colors.white,
)
```

### Manual Control

```dart
// Start monitoring
context.read<ARCubit>().startInterferenceMonitoring();

// Stop monitoring
context.read<ARCubit>().stopInterferenceMonitoring();

// Listen to state changes
BlocListener<ARCubit, ARState>(
  listener: (context, state) {
    if (state is ARMagneticInterferenceDetected) {
      print('Interference: ${state.isDetected}');
    }
  },
  child: YourWidget(),
)
```

## User Education

Consider adding these tips to your app's help section:

**For Best Results:**
- Keep phone away from metal objects (keys, rings, tables)
- Move away from other electronic devices
- Avoid using near power outlets or chargers
- Hold phone in open space when using AR
- Perform figure-8 calibration if prompted

## Why This Matters

- **Accuracy**: Prevents incorrect Qibla direction due to magnetic interference
- **User Trust**: Shows app is actively monitoring for accuracy issues
- **Industry Standard**: Used by top Qibla apps (Muslim Pro, Athan, etc.)
- **Transparency**: Users understand when readings may be unreliable

## Technical Notes

- **No additional permissions** required
- **Minimal battery impact** (uses existing sensor streams)
- **Works on both platforms** (Android & iOS)
- **Automatic cleanup** when AR view is disposed
- **1-second debounce** prevents UI flicker

## Support

The feature is production-ready and follows industry best practices. For detailed technical documentation, see `MAGNETIC_INTERFERENCE_DETECTION.md`.

---

**That's it!** Your app now has professional-grade magnetic interference detection. 🎉
