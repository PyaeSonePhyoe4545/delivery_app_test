class DeliveryModel {
  final String id;
  final String orderId;
  final String customerName;
  final String customerPhone;
  final String deliveryAddress;
  final double destinationLat;
  final double destinationLng;
  final DeliveryStatus status;
  final DateTime createdAt;
  final DateTime? assignedAt;
  final DateTime? pickedUpAt;
  final DateTime? deliveredAt;

  DeliveryModel({
    required this.id,
    required this.orderId,
    required this.customerName,
    required this.customerPhone,
    required this.deliveryAddress,
    required this.destinationLat,
    required this.destinationLng,
    required this.status,
    required this.createdAt,
    this.assignedAt,
    this.pickedUpAt,
    this.deliveredAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'deliveryAddress': deliveryAddress,
      'destinationLat': destinationLat,
      'destinationLng': destinationLng,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'assignedAt': assignedAt?.toIso8601String(),
      'pickedUpAt': pickedUpAt?.toIso8601String(),
      'deliveredAt': deliveredAt?.toIso8601String(),
    };
  }

  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
      id: json['id'],
      orderId: json['orderId'],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      deliveryAddress: json['deliveryAddress'],
      destinationLat: json['destinationLat']?.toDouble() ?? 0.0,
      destinationLng: json['destinationLng']?.toDouble() ?? 0.0,
      status: DeliveryStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => DeliveryStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      assignedAt: json['assignedAt'] != null
          ? DateTime.parse(json['assignedAt'])
          : null,
      pickedUpAt: json['pickedUpAt'] != null
          ? DateTime.parse(json['pickedUpAt'])
          : null,
      deliveredAt: json['deliveredAt'] != null
          ? DateTime.parse(json['deliveredAt'])
          : null,
    );
  }
}

enum DeliveryStatus {
  pending,
  assigned,
  pickedUp,
  inTransit,
  delivered,
  cancelled,
  failed
}
