import 'package:workmanager/workmanager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_dotenv/flutter_dotenv.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      switch (task) {
        case 'locationUpdate':
          await _sendLocationUpdate();
          break;
        default:
          print('Unknown task: $task');
      }
      return Future.value(true);
    } catch (e) {
      print('Background task error: $e');
      return Future.value(false);
    }
  });
}

Future<void> _sendLocationUpdate() async {
  try {
    // Check if location service is enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location service is disabled');
      return;
    }

    // Get current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Create socket connection
    final serverUrl =
        dotenv.env['SOCKET_SERVER_URL'] ?? 'http://localhost:3000';
    final socket = IO.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    // Connect and send location
    socket.connect();

    socket.on('connect', (_) {
      socket.emit('location_update', {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'accuracy': position.accuracy,
        'timestamp': DateTime.now().toIso8601String(),
        'isBackground': true,
      });

      // Disconnect after sending
      Future.delayed(const Duration(seconds: 2), () {
        socket.disconnect();
      });
    });

    print(
        'Background location update sent: ${position.latitude}, ${position.longitude}');
  } catch (e) {
    print('Error in background location update: $e');
  }
}

class BackgroundService {
  static void startLocationUpdates() {
    Workmanager().registerPeriodicTask(
      'locationUpdate',
      'locationUpdate',
      frequency: const Duration(minutes: 15), // Minimum allowed frequency
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
    );
  }

  static void stopLocationUpdates() {
    Workmanager().cancelByUniqueName('locationUpdate');
  }
}
