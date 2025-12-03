#!/bin/bash

# Setup Kaaba 3D Model for AR
# This script helps you set up a Kaaba model for your AR app

echo "🕋 Kaaba AR Model Setup"
echo "======================="
echo ""

# Create models directory
echo "📁 Creating models directory..."
mkdir -p assets/models

echo ""
echo "📥 Download Options:"
echo ""
echo "1. Sketchfab (Recommended)"
echo "   - Visit: https://sketchfab.com/search?q=kaaba&type=models"
echo "   - Download a model in GLB format"
echo "   - Save as: assets/models/kaaba.glb"
echo ""
echo "2. Free3D"
echo "   - Visit: https://free3d.com/3d-models/kaaba"
echo "   - Download free model"
echo "   - Convert to GLB if needed"
echo ""
echo "3. Use Placeholder"
echo "   - Continue with simple box (current)"
echo "   - Upgrade to real model later"
echo ""

read -p "Have you downloaded a Kaaba model? (y/n): " downloaded

if [ "$downloaded" = "y" ] || [ "$downloaded" = "Y" ]; then
    echo ""
    read -p "Enter path to your GLB file: " model_path
    
    if [ -f "$model_path" ]; then
        cp "$model_path" assets/models/kaaba.glb
        echo "✅ Model copied to assets/models/kaaba.glb"
        
        # Check if we need USDZ for iOS
        echo ""
        read -p "Do you need iOS support (USDZ)? (y/n): " need_ios
        
        if [ "$need_ios" = "y" ] || [ "$need_ios" = "Y" ]; then
            echo ""
            echo "📱 iOS USDZ Conversion:"
            echo ""
            echo "Option 1: Online Converter"
            echo "  - Visit: https://products.aspose.app/3d/conversion/glb-to-usdz"
            echo "  - Upload: assets/models/kaaba.glb"
            echo "  - Download and save as: assets/models/kaaba.usdz"
            echo ""
            echo "Option 2: Reality Converter (Mac only)"
            echo "  - Download from Apple Developer"
            echo "  - Drag kaaba.glb into app"
            echo "  - Export as kaaba.usdz"
            echo ""
            echo "Option 3: Command Line (Mac only)"
            echo "  - Run: xcrun usdz_converter assets/models/kaaba.glb assets/models/kaaba.usdz"
            echo ""
        fi
        
        echo ""
        echo "✅ Setup Complete!"
        echo ""
        echo "Next steps:"
        echo "1. Run: flutter pub get"
        echo "2. Update AR view files to use real model"
        echo "3. Test on real device"
        echo ""
        echo "See HOW_TO_ADD_KAABA_MODEL.md for code updates"
        
    else
        echo "❌ File not found: $model_path"
        echo "Please check the path and try again"
    fi
else
    echo ""
    echo "📝 To add a model later:"
    echo ""
    echo "1. Download Kaaba GLB model"
    echo "2. Copy to: assets/models/kaaba.glb"
    echo "3. For iOS: Convert to USDZ and save as assets/models/kaaba.usdz"
    echo "4. Run: flutter pub get"
    echo "5. Update code (see HOW_TO_ADD_KAABA_MODEL.md)"
    echo ""
    echo "Current app will use placeholder box until you add a real model."
fi

echo ""
echo "🎯 Model Requirements:"
echo "  - Format: GLB (Android) or USDZ (iOS)"
echo "  - Size: Under 10MB recommended"
echo "  - Textures: Embedded in file"
echo ""
echo "📚 Documentation: HOW_TO_ADD_KAABA_MODEL.md"
echo ""
