# Qibla AR Finder

A Flutter-based Qibla direction finder using AR, compass, and GPS for both Android and iOS.

## 🎯 What is This?

Find the direction to Kaaba (Mecca) for prayer using:
- 📱 **AR View** - Camera overlay with Kaaba positioned in real direction
- 🧭 **Compass** - Traditional compass with Qibla indicator  
- 📍 **GPS** - Automatic location detection
- ✅ **Cross-platform** - Works on Android and iOS

## 🚀 Quick Start

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run
```

## 📦 Use as Package

This can be used as a reusable package in other Flutter projects:

```yaml
dependencies:
  qibla_ar_finder:
    git:
      url: https://github.com/YOUR_ORG/qibla_ar_finder.git
```

```dart
import 'package:qibla_ar_finder/qibla_ar_finder.dart';

// Use with configurable UI
QiblaARPage(
  config: ARPageConfig(
    showTopBar: false,
    showInstructions: false,
  ),
)
```

## 📖 Complete Documentation

**See [PROJECT_GUIDE.md](PROJECT_GUIDE.md) for:**
- Architecture details
- Package usage guide
- Development setup
- Maintenance guide
- Troubleshooting
- Customization options

## 🛠️ Key Features

- ✅ AR-based Qibla detection
- ✅ Real-time compass tracking
- ✅ GPS location calculation
- ✅ Vertical position warnings
- ✅ Smooth animations (reduced jitter)
- ✅ Configurable UI elements
- ✅ Permission handling

## 📄 License

MIT License

---

**Made with ❤️ for the Muslim community**
