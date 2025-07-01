import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/delivery_controller.dart';

class SimpleMapView extends StatelessWidget {
  const SimpleMapView({super.key});

  @override
  Widget build(BuildContext context) {
    // Try to get the controller
    DeliveryController? controller;
    try {
      controller = Get.find<DeliveryController>();
    } catch (e) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Map View'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Controller not initialized',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Please go back to Home first',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map View'),
        actions: [
          Obx(() => Icon(
            controller!.isSocketConnected 
                ? Icons.cloud_done 
                : Icons.cloud_off,
            color: controller.isSocketConnected 
                ? Colors.green 
                : Colors.red,
          )),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Location Status Card
            Obx(() => Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          controller!.isLocationSharing
                              ? Icons.gps_fixed
                              : Icons.gps_off,
                          color: controller.isLocationSharing
                              ? Colors.green
                              : Colors.red,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Location Tracking',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                controller.isLocationSharing
                                    ? 'Active - Sharing location'
                                    : 'Inactive - Not sharing',
                                style: TextStyle(
                                  color: controller.isLocationSharing
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (controller.currentLocation != null) ...[
                      const Divider(),
                      const SizedBox(height: 8),
                      _buildLocationRow(
                        'Latitude',
                        controller.currentLocation!.latitude.toStringAsFixed(6),
                        Icons.explore,
                      ),
                      _buildLocationRow(
                        'Longitude',
                        controller.currentLocation!.longitude.toStringAsFixed(6),
                        Icons.explore,
                      ),
                      if (controller.currentLocation!.accuracy != null)
                        _buildLocationRow(
                          'Accuracy',
                          '${controller.currentLocation!.accuracy!.toStringAsFixed(1)}m',
                          Icons.my_location,
                        ),
                      if (controller.currentLocation!.speed != null)
                        _buildLocationRow(
                          'Speed',
                          '${(controller.currentLocation!.speed! * 3.6).toStringAsFixed(1)} km/h',
                          Icons.speed,
                        ),
                      _buildLocationRow(
                        'Last Update',
                        _formatDateTime(controller.currentLocation!.timestamp),
                        Icons.schedule,
                      ),
                    ] else ...[
                      const Divider(),
                      const SizedBox(height: 16),
                      const Center(
                        child: Column(
                          children: [
                            Icon(Icons.location_off, size: 48, color: Colors.grey),
                            SizedBox(height: 8),
                            Text(
                              'No location data available',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            )),
            
            const SizedBox(height: 16),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: controller.refreshLocation,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh Location'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (controller!.isLocationSharing) {
                        controller.stopLocationSharing();
                      } else {
                        controller.startLocationSharing();
                      }
                    },
                    icon: Icon(
                      controller.isLocationSharing
                          ? Icons.stop
                          : Icons.play_arrow,
                    ),
                    label: Text(
                      controller.isLocationSharing
                          ? 'Stop Sharing'
                          : 'Start Sharing',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.isLocationSharing
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Map Placeholder
            Expanded(
              child: Card(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blue.shade50,
                        Colors.green.shade50,
                      ],
                    ),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.map,
                        size: 64,
                        color: Colors.blue,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Interactive Map',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Map functionality available\nonce dependencies are fully loaded',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
