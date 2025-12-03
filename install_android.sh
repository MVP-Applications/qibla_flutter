#!/bin/bash

echo "🚀 Qibla Finder - Android Installation Script"
echo "=============================================="
echo ""

# Check if adb is available
if ! command -v adb &> /dev/null; then
    echo "❌ Error: adb not found. Please install Android SDK Platform Tools."
    exit 1
fi

# Check if device is connected
DEVICES=$(adb devices | grep -v "List" | grep "device" | wc -l)
if [ "$DEVICES" -eq 0 ]; then
    echo "❌ Error: No Android device connected."
    echo "Please connect a device or start an emulator."
    exit 1
fi

echo "✅ Found $DEVICES Android device(s)"
echo ""

# Check if APK exists
APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
if [ ! -f "$APK_PATH" ]; then
    echo "❌ Error: APK not found at $APK_PATH"
    echo "Building APK..."
    flutter build apk --release
    if [ $? -ne 0 ]; then
        echo "❌ Build failed"
        exit 1
    fi
fi

echo "📦 Installing Qibla Finder..."
adb install -r "$APK_PATH"

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Installation successful!"
    echo ""
    echo "📱 Next steps:"
    echo "1. Open 'Qibla Finder' app on your device"
    echo "2. Grant Camera permission when prompted"
    echo "3. Grant Location permission when prompted"
    echo "4. Hold phone vertically and point toward Qibla"
    echo ""
    echo "🎯 Features:"
    echo "- Live camera preview"
    echo "- Real-time Qibla direction"
    echo "- Device orientation guidance"
    echo "- Haptic feedback on alignment"
    echo ""
else
    echo "❌ Installation failed"
    exit 1
fi
