import 'dart:async';
import 'package:get/get.dart';
import '../services/location_service.dart';
import '../services/socket_service.dart';
import '../services/background_service.dart';
import '../models/location_model.dart';

class DeliveryController extends GetxController {
  final LocationService _locationService = Get.find<LocationService>();
  final SocketService _socketService = Get.find<SocketService>();

  final RxBool _isOnDuty = false.obs;
  final RxBool _isLocationSharing = false.obs;
  final RxString _currentStatus = 'Offline'.obs;
  Timer? _locationTimer;

  bool get isOnDuty => _isOnDuty.value;
  bool get isLocationSharing => _isLocationSharing.value;
  String get currentStatus => _currentStatus.value;
  LocationModel? get currentLocation => _locationService.currentLocation;
  bool get isSocketConnected => _socketService.isConnected;

  @override
  void onInit() {
    super.onInit();
    _initializeServices();
  }

  void _initializeServices() {
    // Connect to socket when controller initializes
    _socketService.connect();

    // Start listening to location updates
    _locationService.locationStream.listen((LocationModel location) {
      if (_isLocationSharing.value) {
        _socketService.sendLocationUpdate(location);
      }
    });
  }

  void toggleDutyStatus() {
    _isOnDuty.value = !_isOnDuty.value;

    if (_isOnDuty.value) {
      _goOnDuty();
    } else {
      _goOffDuty();
    }
  }

  void _goOnDuty() {
    _currentStatus.value = 'Available';
    startLocationSharing();
    _socketService.sendMessage('Delivery man went on duty');
    Get.snackbar('Status', 'You are now on duty');
  }

  void _goOffDuty() {
    _currentStatus.value = 'Offline';
    stopLocationSharing();
    _socketService.sendMessage('Delivery man went off duty');
    Get.snackbar('Status', 'You are now off duty');
  }

  void startLocationSharing() {
    if (_isLocationSharing.value) return;

    _isLocationSharing.value = true;
    _locationService.startLocationTracking();

    // Start background location updates
    BackgroundService.startLocationUpdates();

    // Send location updates every 5 seconds
    _locationTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _sendCurrentLocation();
    });

    Get.snackbar('Location', 'Location sharing started');
  }

  void stopLocationSharing() {
    if (!_isLocationSharing.value) return;

    _isLocationSharing.value = false;
    _locationService.stopLocationTracking();
    _locationTimer?.cancel();
    _locationTimer = null;

    // Stop background location updates
    BackgroundService.stopLocationUpdates();

    Get.snackbar('Location', 'Location sharing stopped');
  }

  Future<void> _sendCurrentLocation() async {
    if (!_isLocationSharing.value || !_socketService.isConnected) return;

    final location = await _locationService.getCurrentLocation();
    if (location != null) {
      _socketService.sendLocationUpdate(location);
    }
  }

  Future<void> refreshLocation() async {
    final location = await _locationService.getCurrentLocation();
    if (location != null) {
      Get.snackbar('Location', 'Location updated successfully');
    } else {
      Get.snackbar('Error', _locationService.locationError,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void onClose() {
    _locationTimer?.cancel();
    stopLocationSharing();
    super.onClose();
  }
}
