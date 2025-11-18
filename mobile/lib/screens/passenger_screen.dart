import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/trip.dart';
import '../services/api_service.dart';

class PassengerScreen extends StatefulWidget {
  const PassengerScreen({super.key});

  @override
  State<PassengerScreen> createState() => _PassengerScreenState();
}

class _PassengerScreenState extends State<PassengerScreen> {
  final MapController _mapController = MapController();
  
  // Ubicaciones (Lima, Perú por defecto)
  LatLng _currentLocation = const LatLng(-12.0464, -77.0428); // Miraflores
  LatLng? _pickupLocation;
  LatLng? _destinationLocation;
  
  // Estado de la UI
  bool _selectingPickup = false;
  bool _selectingDestination = false;
  bool _searchingDriver = false;
  List<Driver> _nearbyDrivers = [];
  Trip? _currentTrip;
  
  // Info del viaje
  double? _estimatedFare;
  double? _distanceKm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitar Viaje'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Mapa
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation,
              initialZoom: 14.0,
              onTap: _handleMapTap,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.taxytac.mobile',
              ),
              MarkerLayer(
                markers: [
                  // Ubicación actual
                  Marker(
                    point: _currentLocation,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.blue,
                      size: 40,
                    ),
                  ),
                  // Punto de recogida
                  if (_pickupLocation != null)
                    Marker(
                      point: _pickupLocation!,
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.green,
                        size: 50,
                      ),
                    ),
                  // Destino
                  if (_destinationLocation != null)
                    Marker(
                      point: _destinationLocation!,
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.flag,
                        color: Colors.red,
                        size: 50,
                      ),
                    ),
                  // Conductores cercanos
                  ..._nearbyDrivers.map(
                    (driver) => Marker(
                      point: LatLng(driver.lat, driver.lng),
                      width: 40,
                      height: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.motorcycle,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Panel inferior
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomSheet(),
          ),

          // Mensaje de selección
          if (_selectingPickup || _selectingDestination)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Card(
                color: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _selectingPickup
                        ? '📍 Toca el mapa para seleccionar el punto de recogida'
                        : '🏁 Toca el mapa para seleccionar el destino',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomSheet() {
    if (_currentTrip != null) {
      return _buildTripInProgress();
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '¿A dónde vamos?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Punto de recogida
          _buildLocationButton(
            icon: Icons.location_on,
            label: _pickupLocation == null
                ? 'Seleccionar punto de recogida'
                : 'Punto de recogida seleccionado',
            color: Colors.green,
            isSelected: _pickupLocation != null,
            onTap: () {
              setState(() {
                _selectingPickup = true;
                _selectingDestination = false;
              });
            },
            onClear: _pickupLocation != null
                ? () => setState(() => _pickupLocation = null)
                : null,
          ),

          const SizedBox(height: 12),

          // Destino
          _buildLocationButton(
            icon: Icons.flag,
            label: _destinationLocation == null
                ? 'Seleccionar destino'
                : 'Destino seleccionado',
            color: Colors.red,
            isSelected: _destinationLocation != null,
            onTap: () {
              setState(() {
                _selectingPickup = false;
                _selectingDestination = true;
              });
            },
            onClear: _destinationLocation != null
                ? () => setState(() => _destinationLocation = null)
                : null,
          ),

          if (_estimatedFare != null) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tarifa estimada',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        'S/ ${_estimatedFare!.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Distancia',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        '${_distanceKm!.toStringAsFixed(1)} km',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 20),

          // Botón principal
          ElevatedButton(
            onPressed: _canRequestTrip ? _requestTrip : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              disabledBackgroundColor: Colors.grey.shade300,
            ),
            child: _searchingDriver
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Solicitar Moto Bajaj',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),

          if (_nearbyDrivers.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              '${_nearbyDrivers.length} conductores cerca de ti',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTripInProgress() {
    final trip = _currentTrip!;
    
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Estado del viaje
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getTripStatusColor(trip.status),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  _getTripStatusIcon(trip.status),
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    trip.status.displayName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Botón cancelar
          if (trip.status == TripStatus.pending)
            OutlinedButton(
              onPressed: () {
                setState(() => _currentTrip = null);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Cancelar Viaje'),
            ),
        ],
      ),
    );
  }

  Widget _buildLocationButton({
    required IconData icon,
    required String label,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
    VoidCallback? onClear,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected ? color : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (onClear != null)
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: onClear,
                color: Colors.grey,
              ),
          ],
        ),
      ),
    );
  }

  void _handleMapTap(TapPosition tapPosition, LatLng point) {
    setState(() {
      if (_selectingPickup) {
        _pickupLocation = point;
        _selectingPickup = false;
        _calculateFare();
      } else if (_selectingDestination) {
        _destinationLocation = point;
        _selectingDestination = false;
        _calculateFare();
      }
    });

    if (_pickupLocation != null) {
      _loadNearbyDrivers();
    }
  }

  void _calculateFare() {
    if (_pickupLocation != null && _destinationLocation != null) {
      final distance = ApiService.calculateDistance(
        _pickupLocation!.latitude,
        _pickupLocation!.longitude,
        _destinationLocation!.latitude,
        _destinationLocation!.longitude,
      );

      final estimatedMinutes = (distance / 0.5).round(); // ~30 km/h promedio

      setState(() {
        _distanceKm = distance;
        _estimatedFare = ApiService.calculateEstimatedFare(
          distanceKm: distance,
          durationMinutes: estimatedMinutes,
        );
      });
    }
  }

  Future<void> _loadNearbyDrivers() async {
    if (_pickupLocation == null) return;

    try {
      final drivers = await ApiService.getNearbyDrivers(
        lat: _pickupLocation!.latitude,
        lng: _pickupLocation!.longitude,
        radiusMeters: 5000,
      );

      setState(() {
        _nearbyDrivers = drivers;
      });
    } catch (e) {
      debugPrint('Error loading nearby drivers: $e');
    }
  }

  Future<void> _requestTrip() async {
    if (!_canRequestTrip) return;

    setState(() => _searchingDriver = true);

    try {
      final trip = await ApiService.createTrip(
        pickupLat: _pickupLocation!.latitude,
        pickupLng: _pickupLocation!.longitude,
        pickupAddress: 'Punto de recogida',
        destLat: _destinationLocation!.latitude,
        destLng: _destinationLocation!.longitude,
        destAddress: 'Destino',
      );

      setState(() {
        _currentTrip = trip;
        _searchingDriver = false;
      });
    } catch (e) {
      setState(() => _searchingDriver = false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  bool get _canRequestTrip =>
      _pickupLocation != null &&
      _destinationLocation != null &&
      !_searchingDriver;

  Color _getTripStatusColor(TripStatus status) {
    switch (status) {
      case TripStatus.pending:
        return Colors.orange;
      case TripStatus.accepted:
        return Colors.blue;
      case TripStatus.inProgress:
        return Colors.green;
      case TripStatus.completed:
        return Colors.purple;
      case TripStatus.cancelled:
        return Colors.red;
    }
  }

  IconData _getTripStatusIcon(TripStatus status) {
    switch (status) {
      case TripStatus.pending:
        return Icons.search;
      case TripStatus.accepted:
        return Icons.check_circle;
      case TripStatus.inProgress:
        return Icons.motorcycle;
      case TripStatus.completed:
        return Icons.done_all;
      case TripStatus.cancelled:
        return Icons.cancel;
    }
  }
}
