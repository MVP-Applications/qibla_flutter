# 🕋 Kaaba 3D Models for AR

## 📥 Add Your Kaaba Model Here

### Quick Setup

1. **Download a Kaaba 3D model**
   - Visit: https://sketchfab.com/search?q=kaaba&type=models
   - Download in GLB format
   - Save as: `kaaba.glb`

2. **For Android (GLB)**
   ```bash
   # Copy your downloaded model here
   cp ~/Downloads/kaaba.glb assets/models/kaaba.glb
   ```

3. **For iOS (USDZ)**
   - Convert GLB to USDZ: https://products.aspose.app/3d/conversion/glb-to-usdz
   - Save as: `kaaba.usdz`
   ```bash
   # Copy converted model here
   cp ~/Downloads/kaaba.usdz assets/models/kaaba.usdz
   ```

4. **Update dependencies**
   ```bash
   flutter pub get
   ```

5. **Test on device**
   ```bash
   flutter run
   ```

## 📁 Expected Files

```
assets/models/
  ├── kaaba.glb    ← For Android (required)
  ├── kaaba.usdz   ← For iOS (required)
  └── README.md    ← This file
```

## 🎯 Model Requirements

- **Format**: GLB (Android) or USDZ (iOS)
- **Size**: Under 10MB recommended
- **Textures**: Embedded in file
- **Scale**: Will be adjusted in code (0.01 scale)

## 🔍 Where to Find Models

### Free Models
- **Sketchfab**: https://sketchfab.com/search?q=kaaba&type=models
- **Free3D**: https://free3d.com/3d-models/kaaba
- **CGTrader**: https://www.cgtrader.com/free-3d-models/kaaba

### Paid Models (Higher Quality)
- **TurboSquid**: https://www.turbosquid.com/Search/3D-Models/kaaba
- **CGTrader Premium**: https://www.cgtrader.com/3d-models/kaaba

## 🔄 Convert GLB to USDZ

### Online (Easiest)
https://products.aspose.app/3d/conversion/glb-to-usdz

### Mac Only
```bash
# Using Reality Converter (download from Apple)
# Or command line:
xcrun usdz_converter kaaba.glb kaaba.usdz
```

## ⚙️ Adjust Model Size

If model is too big/small, edit the scale in:
- `lib/presentation/widgets/ar_view_ios.dart`
- `lib/presentation/widgets/ar_view_android.dart`

```dart
scale: vector.Vector3(0.001, 0.001, 0.001), // Very small
scale: vector.Vector3(0.01, 0.01, 0.01),    // Small (default)
scale: vector.Vector3(0.1, 0.1, 0.1),       // Medium
scale: vector.Vector3(1.0, 1.0, 1.0),       // Original size
```

## ✅ Current Status

- [ ] kaaba.glb added (Android)
- [ ] kaaba.usdz added (iOS)
- [ ] Tested on Android device
- [ ] Tested on iOS device

## 🐛 Troubleshooting

### Model doesn't appear
```bash
# Make sure files are in correct location
ls -la assets/models/

# Rebuild
flutter clean
flutter pub get
flutter run --uninstall-first
```

### Model is wrong size
- Adjust `scale` parameter in AR view files
- Try: 0.001, 0.01, 0.1, 1.0

### Model has no textures
- Ensure textures are embedded in GLB/USDZ
- Try different model from Sketchfab
- Look for "PBR" or "Textured" models

## 📚 Documentation

- **Quick Guide**: `KAABA_MODEL_QUICK_GUIDE.md`
- **Detailed Guide**: `HOW_TO_ADD_KAABA_MODEL.md`
- **Setup Script**: `setup_kaaba_model.sh`

## 🎉 What You'll Get

Once you add a real Kaaba model:
- ✅ Realistic Kaaba in AR
- ✅ Black cloth covering (Kiswah)
- ✅ Gold door details
- ✅ Proper textures
- ✅ Faces actual Qibla direction
- ✅ Professional appearance

---

**Need help?** Check `KAABA_MODEL_QUICK_GUIDE.md` for step-by-step instructions!
