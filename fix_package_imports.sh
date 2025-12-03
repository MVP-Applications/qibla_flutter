#!/bin/bash

echo "🔧 Fixing package imports..."

# Fix qibla_ar_page.dart imports
sed -i '' 's|../cubits/ar_cubit.dart|../controllers/ar_cubit.dart|g' ../qibla_ar_finder/lib/src/presentation/pages/qibla_ar_page.dart
sed -i '' 's|../cubits/ar_state.dart|../controllers/ar_state.dart|g' ../qibla_ar_finder/lib/src/presentation/pages/qibla_ar_page.dart
sed -i '' 's|../cubits/qibla_cubit.dart|../controllers/qibla_cubit.dart|g' ../qibla_ar_finder/lib/src/presentation/pages/qibla_ar_page.dart
sed -i '' 's|../cubits/qibla_state.dart|../controllers/qibla_state.dart|g' ../qibla_ar_finder/lib/src/presentation/pages/qibla_ar_page.dart
sed -i '' 's|../cubits/tilt_cubit.dart|../controllers/tilt_cubit.dart|g' ../qibla_ar_finder/lib/src/presentation/pages/qibla_ar_page.dart
sed -i '' 's|../cubits/tilt_state.dart|../controllers/tilt_state.dart|g' ../qibla_ar_finder/lib/src/presentation/pages/qibla_ar_page.dart
sed -i '' 's|../widgets/ar_view_enhanced_android.dart|../widgets/internal/ar_view_enhanced_android.dart|g' ../qibla_ar_finder/lib/src/presentation/pages/qibla_ar_page.dart
sed -i '' 's|../widgets/ar_view_enhanced_ios.dart|../widgets/internal/ar_view_enhanced_ios.dart|g' ../qibla_ar_finder/lib/src/presentation/pages/qibla_ar_page.dart
sed -i '' 's|../widgets/vertical_position_warning.dart|../widgets/internal/vertical_position_warning.dart|g' ../qibla_ar_finder/lib/src/presentation/pages/qibla_ar_page.dart

# Fix injection.dart imports
sed -i '' 's|../../presentation/cubits/qibla_cubit.dart|../../presentation/controllers/qibla_cubit.dart|g' ../qibla_ar_finder/lib/src/core/di/injection.dart
sed -i '' 's|../../presentation/cubits/tilt_cubit.dart|../../presentation/controllers/tilt_cubit.dart|g' ../qibla_ar_finder/lib/src/core/di/injection.dart
sed -i '' 's|../../presentation/cubits/ar_cubit.dart|../../presentation/controllers/ar_cubit.dart|g' ../qibla_ar_finder/lib/src/core/di/injection.dart

echo "✅ Import paths fixed!"

# Move AR widgets to internal folder
echo "📁 Moving AR widgets to internal folder..."
mkdir -p ../qibla_ar_finder/lib/src/presentation/widgets/internal

# Move if they exist in widgets folder
if [ -f "../qibla_ar_finder/lib/src/presentation/widgets/ar_view_enhanced_android.dart" ]; then
    mv ../qibla_ar_finder/lib/src/presentation/widgets/ar_view_enhanced_android.dart ../qibla_ar_finder/lib/src/presentation/widgets/internal/
fi

if [ -f "../qibla_ar_finder/lib/src/presentation/widgets/ar_view_enhanced_ios.dart" ]; then
    mv ../qibla_ar_finder/lib/src/presentation/widgets/ar_view_enhanced_ios.dart ../qibla_ar_finder/lib/src/presentation/widgets/internal/
fi

if [ -f "../qibla_ar_finder/lib/src/presentation/widgets/vertical_position_warning.dart" ]; then
    mv ../qibla_ar_finder/lib/src/presentation/widgets/vertical_position_warning.dart ../qibla_ar_finder/lib/src/presentation/widgets/internal/
fi

echo "✅ Widgets moved to internal folder!"

echo ""
echo "🎉 All fixes applied!"
