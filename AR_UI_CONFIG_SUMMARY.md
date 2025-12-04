# AR View UI Configuration - Complete ✅

## Feature Added
Added configurable UI elements to the AR Qibla Page, allowing you to hide/show the top bar, bottom instructions, and compass indicators.

## What Changed

### 1. New Configuration Class

Added `ARPageConfig` class in `lib/presentation/pages/ar_qibla_page.dart`:

```dart
class ARPageConfig {
  final bool showTopBar;              // Show title bar at top
  final bool showInstructions;        // Show instructions at bottom
  final bool showCompassIndicators;   // Show compass indicators
  final String? customTitle;          // Custom title text
  
  const ARPageConfig({
    this.showTopBar = false,          // Hidden by default
    this.showInstructions = false,    // Hidden by default
    this.showCompassIndicators = true, // Visible by default
    this.customTitle,
  });
}
```

### 2. Updated ARQiblaPage

The `ARQiblaPage` now accepts a `config` parameter:

```dart
class ARQiblaPage extends StatefulWidget {
  final ARPageConfig config;

  const ARQiblaPage({
    super.key,
    this.config = const ARPageConfig(),
  });
}
```

## Usage Examples

### Clean AR View (Default - Hidden UI)

```dart
ARQiblaPage(
  config: ARPageConfig(
    showTopBar: false,
    showInstructions: false,
    showCompassIndicators: true,
  ),
)
```

**Result:** Only compass indicators visible, clean AR experience

### Full UI View

```dart
ARQiblaPage(
  config: ARPageConfig(
    showTopBar: true,
    showInstructions: true,
    showCompassIndicators: true,
    customTitle: 'Find Qibla',
  ),
)
```

**Result:** All UI elements visible with custom title

### Minimal View (No UI)

```dart
ARQiblaPage(
  config: ARPageConfig(
    showTopBar: false,
    showInstructions: false,
    showCompassIndicators: false,
  ),
)
```

**Result:** Pure AR view with no overlays

## Configuration Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `showTopBar` | `bool` | `false` | Show "AR Qibla Direction" title bar at top |
| `showInstructions` | `bool` | `false` | Show instructions overlay at bottom |
| `showCompassIndicators` | `bool` | `true` | Show Qibla bearing and device heading indicators |
| `customTitle` | `String?` | `null` | Custom title text (if showTopBar is true) |

## UI Elements

### Top Bar (showTopBar)
- Black gradient background
- Title text (default: "AR Qibla Direction")
- Can be customized with `customTitle`

### Bottom Instructions (showInstructions)
- Black semi-transparent background
- Kaaba icon
- Instructions text
- Appears when AR is ready

### Compass Indicators (showCompassIndicators)
- **Green indicator (right):** Qibla bearing
- **Blue indicator (left):** Device heading
- Shows degrees and direction

## Example App Updated

The example app now demonstrates both modes:

1. **AR View (Clean)** - Hidden UI (default)
2. **AR View (Full UI)** - All elements visible
3. **Compass View** - Traditional compass
4. **Panorama View** - 360° view

## Testing

```bash
cd example
flutter run
```

Try both AR view options to see the difference!

## For Package Consumers

When using this package in your app:

```dart
import 'package:qibla_ar_finder/qibla_ar_finder.dart';

// Clean AR view (recommended for immersive experience)
ARQiblaPage()

// Or with custom config
ARQiblaPage(
  config: ARPageConfig(
    showTopBar: true,
    customTitle: 'Prayer Direction',
  ),
)
```

---

**Status:** Implemented and tested! 🎉

**Default behavior:** Top bar and instructions are **hidden** by default for a clean AR experience.
