import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:latlong2/latlong.dart';

class LocationService {
  static const String wsUrl = 'ws://localhost:8080/ws';
  
  WebSocketChannel? _channel;
  StreamController<Map<String, dynamic>>? _locationUpdates;
  Timer? _heartbeatTimer;
  
  bool _isConnected = false;
  String? _driverId;

  // Stream de actualizaciones de ubicación
  Stream<Map<String, dynamic>>? get locationUpdates =>
      _locationUpdates?.stream;

  bool get isConnected => _isConnected;

  // Conectar al WebSocket
  Future<void> connect({required String driverId}) async {
    if (_isConnected) return;

    try {
      _driverId = driverId;
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      _locationUpdates = StreamController<Map<String, dynamic>>.broadcast();

      _isConnected = true;

      // Escuchar mensajes del servidor
      _channel!.stream.listen(
        (data) {
          try {
            final message = jsonDecode(data as String);
            _locationUpdates?.add(message);
          } catch (e) {
            print('Error parsing WebSocket message: $e');
          }
        },
        onError: (error) {
          print('WebSocket error: $error');
          disconnect();
        },
        onDone: () {
          print('WebSocket connection closed');
          disconnect();
        },
      );

      // Heartbeat cada 30 segundos para mantener conexión
      _heartbeatTimer = Timer.periodic(
        const Duration(seconds: 30),
        (_) => sendHeartbeat(),
      );

      print('WebSocket connected');
    } catch (e) {
      print('Failed to connect WebSocket: $e');
      _isConnected = false;
      rethrow;
    }
  }

  // Enviar ubicación actual
  void sendLocation({
    required LatLng position,
    double speed = 0.0,
    double heading = 0.0,
  }) {
    if (!_isConnected || _channel == null || _driverId == null) return;

    final payload = {
      'type': 'location_update',
      'driver_id': _driverId,
      'lat': position.latitude,
      'lng': position.longitude,
      'speed': speed,
      'heading': heading,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    try {
      _channel!.sink.add(jsonEncode(payload));
    } catch (e) {
      print('Error sending location: $e');
    }
  }

  // Enviar heartbeat
  void sendHeartbeat() {
    if (!_isConnected || _channel == null || _driverId == null) return;

    final payload = {
      'type': 'heartbeat',
      'driver_id': _driverId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    try {
      _channel!.sink.add(jsonEncode(payload));
    } catch (e) {
      print('Error sending heartbeat: $e');
    }
  }

  // Desconectar
  void disconnect() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;

    _channel?.sink.close();
    _channel = null;

    _locationUpdates?.close();
    _locationUpdates = null;

    _isConnected = false;
    _driverId = null;

    print('WebSocket disconnected');
  }

  // Cleanup
  void dispose() {
    disconnect();
  }
}
