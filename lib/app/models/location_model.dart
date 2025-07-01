class LocationModel {
  final double latitude;
  final double longitude;
  final double? accuracy;
  final double? altitude;
  final double? heading;
  final double? speed;
  final DateTime timestamp;
  final String? address;

  LocationModel({
    required this.latitude,
    required this.longitude,
    this.accuracy,
    this.altitude,
    this.heading,
    this.speed,
    required this.timestamp,
    this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'altitude': altitude,
      'heading': heading,
      'speed': speed,
      'timestamp': timestamp.toIso8601String(),
      'address': address,
    };
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      accuracy: json['accuracy']?.toDouble(),
      altitude: json['altitude']?.toDouble(),
      heading: json['heading']?.toDouble(),
      speed: json['speed']?.toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
      address: json['address'],
    );
  }

  @override
  String toString() {
    return 'LocationModel(lat: $latitude, lng: $longitude, time: $timestamp)';
  }
}
