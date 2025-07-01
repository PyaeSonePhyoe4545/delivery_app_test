@echo off
echo Cleaning Flutter project...
flutter clean

echo Getting dependencies...
flutter pub get

echo Building debug APK...
flutter build apk --debug

echo Build complete! Check the build/app/outputs/flutter-apk/ directory for the APK file.
pause
