import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/delivery_controller.dart';

class HomeView extends GetView<DeliveryController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Tracker'),
        actions: [
          Obx(() => Icon(
                controller.isSocketConnected
                    ? Icons.cloud_done
                    : Icons.cloud_off,
                color: controller.isSocketConnected ? Colors.green : Colors.red,
              )),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card
            Obx(() => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Icon(
                          controller.isOnDuty ? Icons.work : Icons.work_off,
                          size: 48,
                          color:
                              controller.isOnDuty ? Colors.green : Colors.grey,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          controller.currentStatus,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: controller.toggleDutyStatus,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                controller.isOnDuty ? Colors.red : Colors.green,
                          ),
                          child: Text(
                            controller.isOnDuty ? 'Go Off Duty' : 'Go On Duty',
                          ),
                        ),
                      ],
                    ),
                  ),
                )),

            const SizedBox(height: 16),

            // Location Card
            Obx(() => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Location Sharing',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Switch(
                              value: controller.isLocationSharing,
                              onChanged: (value) {
                                if (value) {
                                  controller.startLocationSharing();
                                } else {
                                  controller.stopLocationSharing();
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (controller.currentLocation != null) ...[
                          Text(
                              'Latitude: ${controller.currentLocation!.latitude.toStringAsFixed(6)}'),
                          Text(
                              'Longitude: ${controller.currentLocation!.longitude.toStringAsFixed(6)}'),
                          Text(
                              'Accuracy: ${controller.currentLocation!.accuracy?.toStringAsFixed(2)}m'),
                          Text(
                              'Last Update: ${controller.currentLocation!.timestamp.toString().split('.')[0]}'),
                        ] else
                          const Text('No location data available'),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: controller.refreshLocation,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Refresh Location'),
                        ),
                      ],
                    ),
                  ),
                )),

            const SizedBox(height: 16),

            // Navigation Buttons
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildNavigationCard(
                    context,
                    'Map View',
                    Icons.map,
                    () => Get.toNamed('/map'),
                  ),
                  _buildNavigationCard(
                    context,
                    'Deliveries',
                    Icons.local_shipping,
                    () => Get.toNamed('/deliveries'),
                  ),
                  _buildNavigationCard(
                    context,
                    'Settings',
                    Icons.settings,
                    () => Get.toNamed('/settings'),
                  ),
                  _buildNavigationCard(
                    context,
                    'History',
                    Icons.history,
                    () => Get.snackbar('Coming Soon',
                        'History feature will be available soon'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
