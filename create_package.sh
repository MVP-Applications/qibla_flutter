#!/bin/bash

# Qibla AR Finder - Package Creation Script
# This script helps convert the current project into a Flutter package

set -e

echo "🕌 Qibla AR Finder - Package Creation Script"
echo "=============================================="
echo ""

# Configuration
PACKAGE_NAME="qibla_ar_finder"
PACKAGE_DIR="../$PACKAGE_NAME"

# Step 1: Create package structure
echo "📦 Step 1: Creating package structure..."
if [ -d "$PACKAGE_DIR" ]; then
    echo "⚠️  Package directory already exists. Remove it? (y/n)"
    read -r response
    if [ "$response" = "y" ]; then
        rm -rf "$PACKAGE_DIR"
    else
        echo "❌ Aborted."
        exit 1
    fi
fi

flutter create --template=package "$PACKAGE_DIR"
cd "$PACKAGE_DIR"

# Step 2: Create directory structure
echo "📁 Step 2: Creating directory structure..."
mkdir -p lib/src/{core/{constants,utils},data/{models,repositories},domain/{entities,repositories,usecases},presentation/{controllers,widgets/{internal},pages}}
mkdir -p assets/images
mkdir -p example/lib
mkdir -p test

# Step 3: Copy files
echo "📋 Step 3: Copying files from current project..."
cd -

# Copy core files
cp -r lib/core/* "$PACKAGE_DIR/lib/src/core/" 2>/dev/null || true
cp -r lib/data/* "$PACKAGE_DIR/lib/src/data/" 2>/dev/null || true
cp -r lib/domain/* "$PACKAGE_DIR/lib/src/domain/" 2>/dev/null || true

# Copy presentation files (excluding splash)
cp lib/presentation/cubits/* "$PACKAGE_DIR/lib/src/presentation/controllers/" 2>/dev/null || true
cp lib/presentation/widgets/ar_view_enhanced_android.dart "$PACKAGE_DIR/lib/src/presentation/widgets/internal/ar_view_android.dart" 2>/dev/null || true
cp lib/presentation/widgets/ar_view_enhanced_ios.dart "$PACKAGE_DIR/lib/src/presentation/widgets/internal/ar_view_ios.dart" 2>/dev/null || true
cp lib/presentation/widgets/vertical_position_warning.dart "$PACKAGE_DIR/lib/src/presentation/widgets/internal/" 2>/dev/null || true
cp lib/presentation/pages/ar_qibla_page.dart "$PACKAGE_DIR/lib/src/presentation/pages/qibla_ar_page.dart" 2>/dev/null || true

# Copy assets
cp assets/images/qibla.png "$PACKAGE_DIR/assets/images/" 2>/dev/null || true

# Step 4: Copy package files
echo "📄 Step 4: Setting up package files..."
cp package_pubspec.yaml "$PACKAGE_DIR/pubspec.yaml"
cp PACKAGE_README.md "$PACKAGE_DIR/README.md"
cp PACKAGE_CHANGELOG.md "$PACKAGE_DIR/CHANGELOG.md"
cp PACKAGE_LICENSE.md "$PACKAGE_DIR/LICENSE"
cp package_lib_qibla_ar_finder.dart "$PACKAGE_DIR/lib/qibla_ar_finder.dart"
cp PACKAGE_EXAMPLE_MAIN.dart "$PACKAGE_DIR/example/lib/main.dart"

# Step 5: Update example pubspec
echo "📝 Step 5: Configuring example app..."
cat > "$PACKAGE_DIR/example/pubspec.yaml" << EOF
name: qibla_ar_finder_example
description: Example app for qibla_ar_finder package
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  qibla_ar_finder:
    path: ../

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0

flutter:
  uses-material-design: true
EOF

# Step 6: Create analysis options
echo "🔍 Step 6: Setting up analysis options..."
cat > "$PACKAGE_DIR/analysis_options.yaml" << EOF
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - always_declare_return_types
    - always_put_required_named_parameters_first
    - avoid_print
    - prefer_const_constructors
    - prefer_const_declarations
    - prefer_final_fields
    - prefer_single_quotes
    - sort_constructors_first
    - sort_unnamed_constructors_first
    - use_key_in_widget_constructors

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
  errors:
    invalid_annotation_target: ignore
EOF

# Step 7: Create .gitignore
echo "🚫 Step 7: Creating .gitignore..."
cat > "$PACKAGE_DIR/.gitignore" << EOF
# Miscellaneous
*.class
*.log
*.pyc
*.swp
.DS_Store
.atom/
.buildlog/
.history
.svn/

# IntelliJ related
*.iml
*.ipr
*.iws
.idea/

# Flutter/Dart/Pub related
**/doc/api/
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
build/
pubspec.lock

# Android related
**/android/**/gradle-wrapper.jar
**/android/.gradle
**/android/captures/
**/android/gradlew
**/android/gradlew.bat
**/android/local.properties
**/android/**/GeneratedPluginRegistrant.java

# iOS/XCode related
**/ios/**/*.mode1v3
**/ios/**/*.mode2v3
**/ios/**/*.moved-aside
**/ios/**/*.pbxuser
**/ios/**/*.perspectivev3
**/ios/**/*sync/
**/ios/**/.sconsign.dblite
**/ios/**/.tags*
**/ios/**/.vagrant/
**/ios/**/DerivedData/
**/ios/**/Icon?
**/ios/**/Pods/
**/ios/**/.symlinks/
**/ios/**/profile
**/ios/**/xcuserdata
**/ios/.generated/
**/ios/Flutter/App.framework
**/ios/Flutter/Flutter.framework
**/ios/Flutter/Flutter.podspec
**/ios/Flutter/Generated.xcconfig
**/ios/Flutter/app.flx
**/ios/Flutter/app.zip
**/ios/Flutter/flutter_assets/
**/ios/Flutter/flutter_export_environment.sh
**/ios/ServiceDefinitions.json
**/ios/Runner/GeneratedPluginRegistrant.*

# Coverage
coverage/

# Exceptions to above rules.
!**/ios/**/default.mode1v3
!**/ios/**/default.mode2v3
!**/ios/**/default.pbxuser
!**/ios/**/default.perspectivev3
!/packages/flutter_tools/test/data/dart_dependencies_test/**/.packages
EOF

# Step 8: Run flutter pub get
echo "📦 Step 8: Getting dependencies..."
cd "$PACKAGE_DIR"
flutter pub get

cd example
flutter pub get
cd ..

# Step 9: Format code
echo "✨ Step 9: Formatting code..."
dart format lib/ -l 80

# Step 10: Analyze
echo "🔍 Step 10: Running analysis..."
flutter analyze || echo "⚠️  Some analysis issues found. Please review."

echo ""
echo "✅ Package creation complete!"
echo ""
echo "📍 Package location: $PACKAGE_DIR"
echo ""
echo "Next steps:"
echo "1. Review and update the generated files"
echo "2. Add proper dartdoc comments to public APIs"
echo "3. Create wrapper widgets for public API"
echo "4. Test the example app: cd $PACKAGE_DIR/example && flutter run"
echo "5. Run tests: cd $PACKAGE_DIR && flutter test"
echo "6. Publish dry-run: flutter pub publish --dry-run"
echo "7. Publish: flutter pub publish"
echo ""
echo "📚 See PACKAGE_CONVERSION_GUIDE.md for detailed instructions"
