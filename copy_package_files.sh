#!/bin/bash

# Copy the created package files to the qibla_ar_finder package

echo "📦 Copying package files..."

# Copy core files
cp -r package_files/lib/src/core/* ../qibla_ar_finder/lib/src/core/
cp -r package_files/lib/src/data/models/* ../qibla_ar_finder/lib/src/data/models/
cp -r package_files/lib/src/domain/entities/* ../qibla_ar_finder/lib/src/domain/entities/
cp -r package_files/lib/src/presentation/widgets/* ../qibla_ar_finder/lib/src/presentation/widgets/
cp -r package_files/lib/src/presentation/controllers/* ../qibla_ar_finder/lib/src/presentation/controllers/

# Copy main export file
cp package_files/lib/qibla_ar_finder.dart ../qibla_ar_finder/lib/

echo "✅ Files copied successfully!"
echo ""
echo "Next: Run analysis in the package directory"
echo "cd ../qibla_ar_finder && flutter analyze"
