import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/location_model.dart';
import '../models/delivery_model.dart';

class SocketService extends GetxService {
  IO.Socket? _socket;
  final RxBool _isConnected = false.obs;
  final RxString _connectionStatus = 'Disconnected'.obs;
  final RxList<DeliveryModel> _activeDeliveries = <DeliveryModel>[].obs;

  bool get isConnected => _isConnected.value;
  String get connectionStatus => _connectionStatus.value;
  List<DeliveryModel> get activeDeliveries => _activeDeliveries;

  @override
  void onInit() {
    super.onInit();
    _initSocket();
  }

  void _initSocket() {
    final serverUrl =
        dotenv.env['SOCKET_SERVER_URL'] ?? 'http://localhost:3000';

    _socket = IO.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _setupSocketListeners();
  }

  void _setupSocketListeners() {
    _socket?.on('connect', (_) {
      print('Connected to server');
      _isConnected.value = true;
      _connectionStatus.value = 'Connected';
      _authenticateDeliveryMan();
    });

    _socket?.on('disconnect', (_) {
      print('Disconnected from server');
      _isConnected.value = false;
      _connectionStatus.value = 'Disconnected';
    });

    _socket?.on('connect_error', (error) {
      print('Connection error: $error');
      _connectionStatus.value = 'Connection Error';
    });

    _socket?.on('new_delivery', (data) {
      try {
        final delivery = DeliveryModel.fromJson(data);
        _activeDeliveries.add(delivery);
      } catch (e) {
        print('Error parsing new delivery: $e');
      }
    });

    _socket?.on('delivery_updated', (data) {
      try {
        final updatedDelivery = DeliveryModel.fromJson(data);
        final index =
            _activeDeliveries.indexWhere((d) => d.id == updatedDelivery.id);
        if (index != -1) {
          _activeDeliveries[index] = updatedDelivery;
        }
      } catch (e) {
        print('Error parsing delivery update: $e');
      }
    });

    _socket?.on('location_update_ack', (data) {
      print('Location update acknowledged: $data');
    });
  }

  void connect() {
    if (_socket?.connected != true) {
      _socket?.connect();
      _connectionStatus.value = 'Connecting...';
    }
  }

  void disconnect() {
    _socket?.disconnect();
  }

  void _authenticateDeliveryMan() {
    // In a real app, you would send actual authentication data
    _socket?.emit('authenticate', {
      'userType': 'delivery_man',
      'userId': 'delivery_001', // This should come from user authentication
      'name': 'John Doe',
    });
  }

  void sendLocationUpdate(LocationModel location) {
    if (_socket?.connected == true) {
      _socket?.emit('location_update', location.toJson());
      print('Location sent: ${location.latitude}, ${location.longitude}');
    } else {
      print('Socket not connected, cannot send location');
    }
  }

  void updateDeliveryStatus(String deliveryId, DeliveryStatus status) {
    if (_socket?.connected == true) {
      _socket?.emit('delivery_status_update', {
        'deliveryId': deliveryId,
        'status': status.name,
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  void sendMessage(String message) {
    if (_socket?.connected == true) {
      _socket?.emit('message', {
        'message': message,
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  @override
  void onClose() {
    _socket?.dispose();
    super.onClose();
  }
}
