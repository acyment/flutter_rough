#!/bin/bash

# Script to push Dart 3 migration to your fork
# Replace YOUR_USERNAME with your actual GitHub username

echo "This script will help you push your changes to your fork"
echo "Please enter your GitHub username:"
read USERNAME

# Add your fork as a remote
echo "Adding your fork as remote..."
git remote add myfork https://github.com/$USERNAME/flutter_rough.git

# Create a new branch
echo "Creating dart3-migration branch..."
git checkout -b dart3-migration

# Add all changes
echo "Adding all changes..."
git add .

# Commit changes
echo "Committing changes..."
git commit -m "Migrate to Dart 3 with full null safety support

- Update SDK constraints to >=3.0.0 <4.0.0
- Implement null safety throughout codebase  
- Add CrossHatchFiller and DotDashFiller implementations
- Update to flutter_lints from extra_pedantic
- Modernize code with latest Dart idioms
- Add comprehensive test coverage
- Update documentation and examples
- Bump version to 2.0.0

Breaking changes:
- Minimum Dart SDK is now 3.0.0
- FillerConfig constructor changed to FillerConfig.build()
- All widget constructors now use required parameters

See MIGRATION_GUIDE.md for upgrade instructions."

# Push to your fork
echo "Pushing to your fork..."
git push -u myfork dart3-migration

echo ""
echo "✅ Done! Your changes have been pushed to your fork."
echo "Now you can create a pull request at:"
echo "https://github.com/$USERNAME/flutter_rough/pull/new/dart3-migration"