import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const TaxyTacApp());
}

class TaxyTacApp extends StatelessWidget {
  const TaxyTacApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaxyTac - Motos Bajaj',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Configuración del backend (ajustar según entorno)
  // Android emulator: ws://10.0.2.2:8080/ws
  // iOS simulator: ws://localhost:8080/ws
  // Dispositivo físico: ws://TU_IP_LOCAL:8080/ws
  static const String wsUrl = 'ws://localhost:8080/ws';
  static const String apiUrl = 'http://localhost:8080/api';

  WebSocketChannel? _channel;
  Timer? _locationTimer;
  final MapController _mapController = MapController();
  
  // Estado
  LatLng _currentPosition = const LatLng(-12.0464, -77.0428); // Lima, Perú
  List<LatLng> _driverMarkers = [];
  bool _isSendingLocation = false;
  String _statusMessage = 'Desconectado';

  // Mock driver ID (en producción vendría del auth)
  final String _driverId = 'driver-demo-1';

  @override
  void initState() {
    super.initState();
  }

  void _connectWebSocket() {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      setState(() {
        _statusMessage = 'Conectado a WebSocket';
      });

      _channel!.stream.listen(
        (data) {
          final response = jsonDecode(data);
          debugPrint('WS Response: $response');
        },
        onError: (error) {
          debugPrint('WS Error: $error');
          setState(() {
            _statusMessage = 'Error de conexión';
          });
        },
        onDone: () {
          debugPrint('WS Closed');
          setState(() {
            _statusMessage = 'Desconectado';
            _isSendingLocation = false;
          });
        },
      );
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: ${e.toString()}';
      });
    }
  }

  void _startSendingLocation() {
    if (_channel == null) {
      _connectWebSocket();
    }

    setState(() {
      _isSendingLocation = true;
      _statusMessage = 'Enviando ubicación...';
    });

    _locationTimer?.cancel();
    _locationTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _sendLocation();
    });
  }

  void _stopSendingLocation() {
    _locationTimer?.cancel();
    setState(() {
      _isSendingLocation = false;
      _statusMessage = 'Detenido';
    });
  }

  void _sendLocation() {
    if (_channel == null) return;

    final payload = {
      'driver_id': _driverId,
      'lat': _currentPosition.latitude,
      'lng': _currentPosition.longitude,
      'ts': DateTime.now().millisecondsSinceEpoch,
      'speed': 0.0,
      'heading': 0.0,
    };

    _channel!.sink.add(jsonEncode(payload));
    debugPrint('Sent location: ${_currentPosition.latitude}, ${_currentPosition.longitude}');
  }

  Future<void> _fetchNearbyDrivers() async {
    try {
      final url = Uri.parse(
        '$apiUrl/drivers/nearby?lat=${_currentPosition.latitude}&lng=${_currentPosition.longitude}&radius=2000',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final drivers = data['drivers'] as List;

        setState(() {
          _driverMarkers = drivers.map((d) {
            return LatLng(d['lat'] as double, d['lng'] as double);
          }).toList();
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Encontrados ${drivers.length} conductores')),
          );
        }
      } else {
        throw Exception('Failed to load drivers');
      }
    } catch (e) {
      debugPrint('Error fetching drivers: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    _channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaxyTac - Demo'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(
              _isSendingLocation ? Icons.location_on : Icons.location_off,
            ),
            onPressed: _isSendingLocation ? _stopSendingLocation : _startSendingLocation,
          ),
        ],
      ),
      body: Column(
        children: [
          // Mapa
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentPosition,
                initialZoom: 14.0,
                onTap: (tapPosition, point) {
                  setState(() {
                    _currentPosition = point;
                  });
                },
              ),
              children: [
                // Capa de tiles (OpenStreetMap)
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                  userAgentPackageName: 'com.taxytac.mobile',
                ),
                // Marcador de posición actual
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentPosition,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                    // Marcadores de drivers cercanos
                    ..._driverMarkers.map((pos) => Marker(
                          point: pos,
                          width: 30,
                          height: 30,
                          child: const Icon(
                            Icons.motorcycle,
                            color: Colors.orange,
                            size: 30,
                          ),
                        )),
                  ],
                ),
              ],
            ),
          ),
          // Panel de controles
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Status
                Text(
                  'Estado: $_statusMessage',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                // Botones
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isSendingLocation
                            ? _stopSendingLocation
                            : _startSendingLocation,
                        icon: Icon(
                          _isSendingLocation ? Icons.stop : Icons.play_arrow,
                        ),
                        label: Text(
                          _isSendingLocation ? 'Detener' : 'Enviar Ubicación',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isSendingLocation
                              ? Colors.red
                              : Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _fetchNearbyDrivers,
                        icon: const Icon(Icons.search),
                        label: const Text('Buscar Drivers'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Instrucciones
                Text(
                  'Toca el mapa para cambiar tu ubicación',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
