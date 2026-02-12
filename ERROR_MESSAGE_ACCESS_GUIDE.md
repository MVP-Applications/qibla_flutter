# Error Message Access Guide for Consuming Projects

## Overview
Yes, the error messages are properly exposed and can be caught in consuming projects! Here's how to access them:

---

## 1. QiblaInitializationManager (For Qibla/Compass Features)

### Access Error Message:
```dart
import 'package:qibla_ar_finder/services/qibla_initialization_manager.dart';

// Listen to state changes
QiblaInitializationManager.instance.stateStream.listen((state) {
  if (state.hasFailed) {
    String? errorMessage = state.errorMessage;
    // Show your custom error UI with this message
    showCustomErrorDialog(errorMessage);
  }
});

// Or check current state
final state = QiblaInitializationManager.instance.state;
if (state.hasFailed) {
  String? errorMessage = state.errorMessage;
  // Display error in your custom design
}
```

### Error Message Property:
- **Property**: `state.errorMessage` (String?)
- **Available when**: `state.hasFailed == true` or `state.status == QiblaInitializationStatus.failed`

---

## 2. ARInitializationManager (For AR Features)

### Access Error Message:
```dart
import 'package:qibla_ar_finder/services/ar_initialization_manager.dart';

// Listen to state changes
ARInitializationManager.instance.stateStream.listen((state) {
  if (state.hasFailed) {
    String? errorMessage = state.errorMessage;
    // Show your custom error UI with this message
    showCustomErrorDialog(errorMessage);
  }
});

// Or check current state
final state = ARInitializationManager.instance.state;
if (state.hasFailed) {
  String? errorMessage = state.errorMessage;
  // Display error in your custom design
}
```

### Error Message Property:
- **Property**: `state.errorMessage` (String?)
- **Available when**: `state.hasFailed == true` or `state.status == ARInitializationStatus.failed`

---

## 3. ARCubit (For AR Screen)

### Access Error Message:
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qibla_ar_finder/presentation/cubits/ar_cubit.dart';
import 'package:qibla_ar_finder/presentation/cubits/ar_state.dart';

// In your widget
BlocBuilder<ARCubit, ARState>(
  builder: (context, state) {
    if (state is ARError) {
      String errorMessage = state.message;
      // Show your custom error UI
      return YourCustomErrorWidget(message: errorMessage);
    }
    // ... other states
  },
)
```

### Error Message Property:
- **Property**: `state.message` (String)
- **Available when**: `state is ARError`

---

## Current Error Messages

### Location/GPS Timeout Error:
```
Unable to determine your location.

We're having trouble getting your location right now.

Please move to a different place and make sure location services are enabled, then try again.
```

### Permission Errors:
- Location permission denied
- Camera permission denied (AR only)

---

## Example: Custom Error Dialog

```dart
void showCustomErrorDialog(BuildContext context, String? errorMessage) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Error'),
      content: Text(errorMessage ?? 'An error occurred'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            // Retry initialization
            QiblaInitializationManager.instance.reset();
            QiblaInitializationManager.instance.initialize();
          },
          child: Text('Retry'),
        ),
      ],
    ),
  );
}
```

---

## Example: Custom Error UI Widget

```dart
class CustomErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const CustomErrorWidget({
    Key? key,
    required this.message,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          if (onRetry != null) ...[
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              child: Text('Try Again'),
            ),
          ],
        ],
      ),
    );
  }
}
```

---

## Summary

✅ **YES**, error messages are properly exposed through:

1. **QiblaInitializationState.errorMessage** - For Qibla initialization errors
2. **ARInitializationState.errorMessage** - For AR initialization errors  
3. **ARError.message** - For AR cubit errors

All consuming projects can access these error messages and display them in their own custom UI designs.
