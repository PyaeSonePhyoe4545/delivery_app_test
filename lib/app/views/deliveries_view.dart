import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/socket_service.dart';
import '../models/delivery_model.dart';

class DeliveriesView extends StatelessWidget {
  const DeliveriesView({super.key});

  @override
  Widget build(BuildContext context) {
    final SocketService socketService = Get.find<SocketService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Deliveries'),
      ),
      body: Obx(() {
        final deliveries = socketService.activeDeliveries;

        if (deliveries.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No active deliveries',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'New deliveries will appear here when assigned',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: deliveries.length,
          itemBuilder: (context, index) {
            final delivery = deliveries[index];
            return _buildDeliveryCard(context, delivery, socketService);
          },
        );
      }),
    );
  }

  Widget _buildDeliveryCard(BuildContext context, DeliveryModel delivery,
      SocketService socketService) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${delivery.orderId}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(delivery.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    delivery.status.name.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.person, 'Customer', delivery.customerName),
            _buildInfoRow(Icons.phone, 'Phone', delivery.customerPhone),
            _buildInfoRow(
                Icons.location_on, 'Address', delivery.deliveryAddress),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showLocationOnMap(delivery),
                    icon: const Icon(Icons.map),
                    label: const Text('View on Map'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatusButton(delivery, socketService),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton(
      DeliveryModel delivery, SocketService socketService) {
    String buttonText;
    DeliveryStatus nextStatus;
    Color buttonColor;

    switch (delivery.status) {
      case DeliveryStatus.assigned:
        buttonText = 'Pick Up';
        nextStatus = DeliveryStatus.pickedUp;
        buttonColor = Colors.orange;
        break;
      case DeliveryStatus.pickedUp:
        buttonText = 'Start Delivery';
        nextStatus = DeliveryStatus.inTransit;
        buttonColor = Colors.blue;
        break;
      case DeliveryStatus.inTransit:
        buttonText = 'Mark Delivered';
        nextStatus = DeliveryStatus.delivered;
        buttonColor = Colors.green;
        break;
      default:
        buttonText = 'Completed';
        nextStatus = delivery.status;
        buttonColor = Colors.grey;
    }

    return ElevatedButton(
      onPressed: delivery.status == DeliveryStatus.delivered
          ? null
          : () => socketService.updateDeliveryStatus(delivery.id, nextStatus),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
      ),
      child: Text(buttonText),
    );
  }

  Color _getStatusColor(DeliveryStatus status) {
    switch (status) {
      case DeliveryStatus.pending:
        return Colors.grey;
      case DeliveryStatus.assigned:
        return Colors.orange;
      case DeliveryStatus.pickedUp:
        return Colors.blue;
      case DeliveryStatus.inTransit:
        return Colors.purple;
      case DeliveryStatus.delivered:
        return Colors.green;
      case DeliveryStatus.cancelled:
        return Colors.red;
      case DeliveryStatus.failed:
        return Colors.red;
    }
  }

  void _showLocationOnMap(DeliveryModel delivery) {
    Get.toNamed('/map', arguments: {
      'destinationLat': delivery.destinationLat,
      'destinationLng': delivery.destinationLng,
      'address': delivery.deliveryAddress,
    });
  }
}
