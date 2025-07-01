import 'package:get/get.dart';
import '../services/location_service.dart';
import '../services/socket_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationService>(() => LocationService());
    Get.lazyPut<SocketService>(() => SocketService());
  }
}
