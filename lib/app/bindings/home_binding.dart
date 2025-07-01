import 'package:get/get.dart';
import '../controllers/delivery_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeliveryController>(() => DeliveryController());
  }
}
