#!/usr/bin/env pwsh

Write-Host "Cleaning Flutter project..." -ForegroundColor Green
flutter clean

Write-Host "Getting dependencies..." -ForegroundColor Green
flutter pub get

Write-Host "Building debug APK..." -ForegroundColor Green
flutter build apk --debug

Write-Host "Build completed!" -ForegroundColor Green
