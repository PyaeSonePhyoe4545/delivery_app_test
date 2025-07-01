import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';

import 'app/bindings/initial_binding.dart';
import 'app/routes/app_pages.dart';
import 'app/services/background_service.dart';
import 'app/utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize WorkManager for background tasks
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );

  // Request permissions
  await _requestPermissions();

  runApp(const DeliveryApp());
}

Future<void> _requestPermissions() async {
  await [
    Permission.location,
    Permission.locationAlways,
    Permission.locationWhenInUse,
  ].request();
}

class DeliveryApp extends StatelessWidget {
  const DeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Delivery Tracker',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialBinding: InitialBinding(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
