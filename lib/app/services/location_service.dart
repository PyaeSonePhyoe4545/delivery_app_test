import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../models/location_model.dart';

class LocationService extends GetxService {
  StreamSubscription<Position>? _positionStream;
  final Rx<LocationModel?> _currentLocation = Rx<LocationModel?>(null);
  final RxBool _isTracking = false.obs;
  final RxString _locationError = ''.obs;

  LocationModel? get currentLocation => _currentLocation.value;
  bool get isTracking => _isTracking.value;
  String get locationError => _locationError.value;

  Stream<LocationModel> get locationStream => _locationStream();

  @override
  void onInit() {
    super.onInit();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _locationError.value = 'Location services are disabled.';
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _locationError.value = 'Location permissions are denied';
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _locationError.value =
          'Location permissions are permanently denied, we cannot request permissions.';
      return;
    }

    _locationError.value = '';
  }

  Future<LocationModel?> getCurrentLocation() async {
    try {
      await _checkPermissions();
      if (_locationError.value.isNotEmpty) return null;

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final location = LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
        altitude: position.altitude,
        heading: position.heading,
        speed: position.speed,
        timestamp: DateTime.now(),
      );

      _currentLocation.value = location;
      return location;
    } catch (e) {
      _locationError.value = 'Error getting location: $e';
      return null;
    }
  }

  void startLocationTracking() {
    if (_isTracking.value) return;

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      (Position position) {
        final location = LocationModel(
          latitude: position.latitude,
          longitude: position.longitude,
          accuracy: position.accuracy,
          altitude: position.altitude,
          heading: position.heading,
          speed: position.speed,
          timestamp: DateTime.now(),
        );
        _currentLocation.value = location;
      },
      onError: (error) {
        _locationError.value = 'Location tracking error: $error';
      },
    );

    _isTracking.value = true;
  }

  void stopLocationTracking() {
    _positionStream?.cancel();
    _positionStream = null;
    _isTracking.value = false;
  }

  Stream<LocationModel> _locationStream() async* {
    await for (Position position in Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    )) {
      yield LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
        altitude: position.altitude,
        heading: position.heading,
        speed: position.speed,
        timestamp: DateTime.now(),
      );
    }
  }

  @override
  void onClose() {
    stopLocationTracking();
    super.onClose();
  }
}
