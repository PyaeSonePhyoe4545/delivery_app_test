# Delivery Tracker App

A Flutter application for delivery personnel to track and share their location in real-time using Socket.IO, GetX state management, and Mapbox for mapping services.

## Images For Demo
![Screenshot_2025-07-06-01-22-24-742_com example latlong](https://github.com/user-attachments/assets/eb3fce7e-a5be-43d7-a838-06ecc5faab0c)
![Screenshot_2025-07-06-01-22-28-568_com example latlong](https://github.com/user-attachments/assets/e5e7738e-33cf-459d-8188-b7d0b10939bb)
![Screenshot_2025-07-06-01-22-35-573_com example latlong](https://github.com/user-attachments/assets/6d82df4c-b6f4-44b3-afb8-d427ed3e0dde)
![Screenshot_2025-07-06-01-22-41-068_com example latlong](https://github.com/user-attachments/assets/c5f5d35f-4fdc-4f5c-abc2-122b8b204e5b)


## Features

- 🚚 Real-time location tracking and sharing
- 📡 Socket.IO integration for live communication
- 🗺️ OpenStreetMap integration for maps
- 📱 GetX state management
- 🔔 Delivery management system
- 🎯 Background location updates
- 📊 Delivery status tracking
- ⚙️ Settings and configuration

## Tech Stack

- **Frontend**: Flutter
- **State Management**: GetX
- **Maps**: OpenStreetMap with Flutter Map
- **Real-time Communication**: Socket.IO
- **Location Services**: Geolocator
- **Background Tasks**: WorkManager
- **Backend**: Node.js + Express + Socket.IO (example server included)

## Setup Instructions

### 1. Flutter App Setup

#### Prerequisites
- Flutter SDK (3.3.0 or higher)
- Dart SDK
- Android Studio / VS Code
- A device or emulator for testing

#### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd latlong
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment variables**
   - Create a `.env` file in the root directory
   - Add your server configuration:
   ```env
   SOCKET_SERVER_URL=http://your-server-url.com
   SERVER_PORT=3000
   APP_NAME=Delivery Tracker
   LOCATION_UPDATE_INTERVAL=5000
   ```

4. **No API Keys Required**
   - The app now uses OpenStreetMap which doesn't require API keys
   - Just configure your server URL and you're ready to go!

### 2. Server Setup (Node.js)

#### Prerequisites
- Node.js (14.0 or higher)
- npm or yarn

#### Installation Steps

1. **Install server dependencies**
   ```bash
   npm install
   ```

2. **Start the server**
   ```bash
   # For development
   npm run dev
   
   # For production
   npm start
   ```

3. **Server will run on**
   - Local: http://localhost:3000
   - The server provides Socket.IO endpoints and REST API for testing

### 3. App Configuration

#### Android Permissions
The app includes the following permissions in `android/app/src/main/AndroidManifest.xml`:
- Internet access
- Fine and coarse location
- Background location
- Foreground service
- Wake lock

#### iOS Configuration (if needed)
Add location permissions to `ios/Runner/Info.plist`:
```xml
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>This app needs location access to track delivery routes.</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs location access to track delivery routes.</string>
```

## App Structure

```
lib/
├── app/
│   ├── bindings/          # GetX bindings
│   │   ├── initial_binding.dart
│   │   └── home_binding.dart
│   ├── controllers/       # GetX controllers
│   │   └── delivery_controller.dart
│   ├── models/           # Data models
│   │   ├── location_model.dart
│   │   └── delivery_model.dart
│   ├── routes/           # App routing
│   │   ├── app_pages.dart
│   │   └── app_routes.dart
│   ├── services/         # Business logic services
│   │   ├── location_service.dart
│   │   ├── socket_service.dart
│   │   ├── mapbox_service.dart
│   │   └── background_service.dart
│   ├── utils/           # Utilities
│   │   └── app_theme.dart
│   └── views/           # UI screens
│       ├── home_view.dart
│       ├── map_view.dart
│       ├── deliveries_view.dart
│       └── settings_view.dart
└── main.dart
```

## Key Features Explained

### 1. Location Tracking
- Uses `geolocator` package for precise location tracking
- Implements background location updates using `workmanager`
- Configurable update intervals
- Location accuracy and error handling

### 2. Socket.IO Integration
- Real-time communication with server
- Automatic reconnection handling
- Location updates sent to server
- Delivery status synchronization

### 3. Map Integration
- Interactive maps with current location using OpenStreetMap
- No API key required (uses free OpenStreetMap tiles)
- Real-time location marker updates
- Map navigation and centering

### 4. State Management (GetX)
- Reactive state management
- Dependency injection
- Route management
- Easy-to-use controllers

### 5. Delivery Management
- Accept/reject deliveries
- Status tracking (Assigned → Picked Up → In Transit → Delivered)
- Customer information display
- Real-time delivery updates

## API Endpoints (Server)

### Socket.IO Events

#### Client to Server
- `authenticate` - Authenticate delivery man
- `location_update` - Send location update
- `delivery_status_update` - Update delivery status
- `message` - Send message

#### Server to Client
- `authenticated` - Authentication confirmation
- `new_delivery` - New delivery assigned
- `delivery_updated` - Delivery status changed
- `location_update_ack` - Location update acknowledged

### REST API
- `GET /api/delivery-men` - Get connected delivery men
- `POST /api/create-delivery` - Create test delivery
- `GET /api/deliveries` - Get active deliveries
- `GET /` - Server status

## Usage

1. **Start the app**
   ```bash
   flutter run
   ```

2. **Go on duty**
   - Tap "Go On Duty" button
   - Enable location sharing
   - App will start sending location updates

3. **View deliveries**
   - Navigate to "Deliveries" tab
   - View assigned deliveries
   - Update delivery status

4. **Use map view**
   - View current location on map
   - See delivery destinations
   - Get directions

## Testing

### 1. Test Location Updates
- Enable location sharing
- Check server logs for location updates
- Use server API to view connected delivery men

### 2. Test Deliveries
- Create test deliveries using server API:
  ```bash
  curl -X POST http://localhost:3000/api/create-delivery \
    -H "Content-Type: application/json" \
    -d '{"customerName":"Test Customer","deliveryAddress":"123 Test St"}'
  ```

### 3. Test Socket Connection
- Check connection status in app
- Monitor server logs for connections
- Test offline/online scenarios

## Deployment

### Flutter App
1. Build for Android:
   ```bash
   flutter build apk --release
   ```

2. Build for iOS:
   ```bash
   flutter build ios --release
   ```

### Server
1. Deploy to your preferred hosting service (Heroku, AWS, etc.)
2. Update `SOCKET_SERVER_URL` in `.env` with your server URL
3. Configure environment variables on your hosting platform

## Troubleshooting

### Common Issues

1. **Gradle Build Failed with exit code 1**
   - **Solution 1**: Clean and rebuild
     ```bash
     flutter clean
     flutter pub get
     flutter build apk --debug
     ```
   - **Solution 2**: Check Android SDK requirements
     - Ensure you have Android SDK 21 or higher
     - Update build.gradle files if needed
   - **Solution 3**: Check dependency conflicts
     ```bash
     flutter pub deps
     flutter pub outdated
     ```

2. **Location not updating**
   - Check location permissions
   - Ensure location services are enabled
   - Check device location accuracy settings

3. **Socket connection fails**
   - Verify server URL in `.env`
   - Check network connectivity
   - Ensure server is running

4. **Map not working**
   - The app now uses OpenStreetMap instead of Mapbox for better compatibility
   - No API key required for basic map functionality
   - Ensure internet connectivity

5. **Background location not working**
   - Check background app permissions
   - Verify WorkManager setup
   - Test on physical device (not simulator)

### Build Configuration Updates

If you encounter build issues, ensure these configurations:

**android/app/build.gradle:**
```gradle
android {
    compileSdk 34
    
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
        multiDexEnabled true
    }
}

dependencies {
    implementation 'androidx.multidex:multidex:2.0.1'
}
```

**android/app/src/main/AndroidManifest.xml:**
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
```

### Debug Tips

1. **Enable debugging**
   ```bash
   flutter run --debug
   ```

2. **Check logs**
   - Flutter: `flutter logs`
   - Server: Check console output
   - Android: `adb logcat`

3. **Network debugging**
   - Use network inspector in browser dev tools
   - Check server API endpoints manually

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License.

## Support

For support, please contact:
- Email: pyaesonephyoe.utycc@gmail.com.com
- Issues: [GitHub Issues](your-repo-issues-url)

---

**Note**: This is a development version. For production use, implement proper authentication, security measures, and error handling.
