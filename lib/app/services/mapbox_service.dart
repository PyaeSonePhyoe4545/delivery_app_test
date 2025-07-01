import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapboxService {
  static final String _accessToken = dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? '';
  static const String _baseUrl = 'https://api.mapbox.com';

  static Future<String?> getAddressFromCoordinates(
      double lat, double lng) async {
    if (_accessToken.isEmpty) {
      print('Mapbox access token not found');
      return null;
    }

    try {
      final url =
          '$_baseUrl/geocoding/v5/mapbox.places/$lng,$lat.json?access_token=$_accessToken';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final features = data['features'] as List?;

        if (features != null && features.isNotEmpty) {
          return features[0]['place_name'] as String?;
        }
      }
    } catch (e) {
      print('Error getting address from coordinates: $e');
    }

    return null;
  }

  static Future<Map<String, double>?> getCoordinatesFromAddress(
      String address) async {
    if (_accessToken.isEmpty) {
      print('Mapbox access token not found');
      return null;
    }

    try {
      final encodedAddress = Uri.encodeComponent(address);
      final url =
          '$_baseUrl/geocoding/v5/mapbox.places/$encodedAddress.json?access_token=$_accessToken';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final features = data['features'] as List?;

        if (features != null && features.isNotEmpty) {
          final coordinates = features[0]['center'] as List?;
          if (coordinates != null && coordinates.length >= 2) {
            return {
              'longitude': coordinates[0].toDouble(),
              'latitude': coordinates[1].toDouble(),
            };
          }
        }
      }
    } catch (e) {
      print('Error getting coordinates from address: $e');
    }

    return null;
  }

  static Future<Map<String, dynamic>?> getDirections(
      double startLat, double startLng, double endLat, double endLng) async {
    if (_accessToken.isEmpty) {
      print('Mapbox access token not found');
      return null;
    }

    try {
      final url =
          '$_baseUrl/directions/v5/mapbox/driving/$startLng,$startLat;$endLng,$endLat'
          '?geometries=geojson&access_token=$_accessToken';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final routes = data['routes'] as List?;

        if (routes != null && routes.isNotEmpty) {
          return routes[0] as Map<String, dynamic>;
        }
      }
    } catch (e) {
      print('Error getting directions: $e');
    }

    return null;
  }
}
