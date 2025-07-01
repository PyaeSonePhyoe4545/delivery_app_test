import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/delivery_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final DeliveryController controller = Get.find<DeliveryController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const _SectionHeader('Delivery Settings'),
          Obx(() => SwitchListTile(
                title: const Text('Auto-accept deliveries'),
                subtitle:
                    const Text('Automatically accept assigned deliveries'),
                value: false, // You can add this to your controller
                onChanged: (value) {
                  // Implement auto-accept feature
                  Get.snackbar('Feature', 'Auto-accept feature coming soon');
                },
              )),
          Obx(() => SwitchListTile(
                title: const Text('Location sharing'),
                subtitle: Text(controller.isLocationSharing
                    ? 'Sharing location with server'
                    : 'Location sharing disabled'),
                value: controller.isLocationSharing,
                onChanged: (value) {
                  if (value) {
                    controller.startLocationSharing();
                  } else {
                    controller.stopLocationSharing();
                  }
                },
              )),
          const _SectionHeader('Notifications'),
          SwitchListTile(
            title: const Text('Push notifications'),
            subtitle: const Text('Receive notifications for new deliveries'),
            value: true, // You can add this to your controller
            onChanged: (value) {
              // Implement notification settings
              Get.snackbar('Feature', 'Notification settings coming soon');
            },
          ),
          SwitchListTile(
            title: const Text('Sound alerts'),
            subtitle: const Text('Play sound for important notifications'),
            value: true, // You can add this to your controller
            onChanged: (value) {
              // Implement sound settings
              Get.snackbar('Feature', 'Sound settings coming soon');
            },
          ),
          const _SectionHeader('Account'),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            subtitle: const Text('View and edit your profile'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Get.snackbar('Feature', 'Profile management coming soon');
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Delivery History'),
            subtitle: const Text('View your past deliveries'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Get.snackbar('Feature', 'Delivery history coming soon');
            },
          ),
          const _SectionHeader('App Info'),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('App Version'),
            subtitle: const Text('1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Get.snackbar(
                  'Support', 'Contact support at support@deliveryapp.com');
            },
          ),
          const _SectionHeader('Connection Status'),
          Obx(() => ListTile(
                leading: Icon(
                  controller.isSocketConnected
                      ? Icons.cloud_done
                      : Icons.cloud_off,
                  color:
                      controller.isSocketConnected ? Colors.green : Colors.red,
                ),
                title: Text(controller.isSocketConnected
                    ? 'Connected'
                    : 'Disconnected'),
                subtitle: const Text('Server connection status'),
              )),
          if (controller.currentLocation != null)
            ListTile(
              leading: const Icon(Icons.location_on, color: Colors.blue),
              title: const Text('Current Location'),
              subtitle: Text(
                'Lat: ${controller.currentLocation!.latitude.toStringAsFixed(6)}\n'
                'Lng: ${controller.currentLocation!.longitude.toStringAsFixed(6)}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: controller.refreshLocation,
              ),
            ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Get.dialog(
                  AlertDialog(
                    title: const Text('Sign Out'),
                    content: const Text('Are you sure you want to sign out?'),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Implementation for sign out
                          Get.back();
                          Get.snackbar(
                              'Signed Out', 'You have been signed out');
                        },
                        child: const Text('Sign Out'),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Sign Out'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
