import 'package:get/get.dart';
import '../bindings/home_binding.dart';
import '../views/home_view.dart';
import '../views/map_view.dart';
import '../views/simple_map_view.dart';
import '../views/deliveries_view.dart';
import '../views/settings_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.MAP,
      page: () => const SimpleMapView(), // Using SimpleMapView as fallback
      binding: HomeBinding(), // Ensure DeliveryController is available
    ),
    GetPage(
      name: _Paths.DELIVERIES,
      page: () => const DeliveriesView(),
      binding: HomeBinding(), // Ensure controller is available
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: HomeBinding(), // Ensure controller is available
    ),
  ];
}
