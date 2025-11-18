import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/trip.dart';

class ApiService {
  // Para web usa localhost, para dispositivos físicos usa tu IP local
  static const String baseUrl = 'http://localhost:8080/api';
  
  // Auth mock (en producción, implementar JWT)
  static String? _authToken;
  static String? _userId;

  static void setAuth(String token, String userId) {
    _authToken = token;
    _userId = userId;
  }

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
      };

  // Buscar conductores cercanos
  static Future<List<Driver>> getNearbyDrivers({
    required double lat,
    required double lng,
    double radiusMeters = 5000,
  }) async {
    final url = Uri.parse(
      '$baseUrl/drivers/nearby?lat=$lat&lng=$lng&radius=$radiusMeters',
    );

    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final drivers = (data['drivers'] as List)
          .map((d) => Driver.fromJson(d))
          .toList();
      return drivers;
    } else {
      throw Exception('Error al buscar conductores: ${response.statusCode}');
    }
  }

  // Crear viaje
  static Future<Trip> createTrip({
    required double pickupLat,
    required double pickupLng,
    required String pickupAddress,
    required double destLat,
    required double destLng,
    required String destAddress,
  }) async {
    final url = Uri.parse('$baseUrl/trips');

    final body = jsonEncode({
      'pickup': {
        'lat': pickupLat,
        'lng': pickupLng,
        'address': pickupAddress,
      },
      'destination': {
        'lat': destLat,
        'lng': destLng,
        'address': destAddress,
      },
    });

    final response = await http.post(
      url,
      headers: _headers,
      body: body,
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Trip.fromJson(data['trip']);
    } else {
      throw Exception('Error al crear viaje: ${response.statusCode}');
    }
  }

  // Aceptar viaje (conductor)
  static Future<Trip> acceptTrip(String tripId) async {
    final url = Uri.parse('$baseUrl/trips/$tripId/accept');

    final response = await http.patch(url, headers: _headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Trip.fromJson(data['trip']);
    } else {
      throw Exception('Error al aceptar viaje: ${response.statusCode}');
    }
  }

  // Iniciar viaje (conductor)
  static Future<Trip> startTrip(String tripId) async {
    final url = Uri.parse('$baseUrl/trips/$tripId/start');

    final response = await http.patch(url, headers: _headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Trip.fromJson(data['trip']);
    } else {
      throw Exception('Error al iniciar viaje: ${response.statusCode}');
    }
  }

  // Completar viaje (conductor)
  static Future<Trip> completeTrip(String tripId) async {
    final url = Uri.parse('$baseUrl/trips/$tripId/complete');

    final response = await http.patch(url, headers: _headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Trip.fromJson(data['trip']);
    } else {
      throw Exception('Error al completar viaje: ${response.statusCode}');
    }
  }

  // Calcular tarifa estimada
  static double calculateEstimatedFare({
    required double distanceKm,
    required int durationMinutes,
  }) {
    const double baseFare = 3.00; // Tarifa base en soles
    const double perKm = 1.50; // Soles por km
    const double perMinute = 0.30; // Soles por minuto

    final fare = baseFare + (distanceKm * perKm) + (durationMinutes * perMinute);
    return double.parse(fare.toStringAsFixed(2));
  }

  // Calcular distancia estimada (fórmula de Haversine simplificada)
  static double calculateDistance(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    const double earthRadiusKm = 6371.0;

    final dLat = _degreesToRadians(lat2 - lat1);
    final dLng = _degreesToRadians(lng2 - lng1);

    final a = (dLat / 2).sin() * (dLat / 2).sin() +
        lat1.toRadians().cos() *
            lat2.toRadians().cos() *
            (dLng / 2).sin() *
            (dLng / 2).sin();

    final c = 2 * (a.sqrt()).atan2((1 - a).sqrt());

    return earthRadiusKm * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * (3.141592653589793 / 180.0);
  }
}

extension on double {
  double toRadians() => this * (3.141592653589793 / 180.0);
  double sin() => this;
  double cos() => this;
  double sqrt() => this;
  double atan2(double other) => this;
}
