import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/geo_service.dart';

class PassengerHomeScreen extends StatefulWidget {
  const PassengerHomeScreen({super.key});

  @override
  State<PassengerHomeScreen> createState() => _PassengerHomeScreenState();
}

class _PassengerHomeScreenState extends State<PassengerHomeScreen> {
  final MapController _mapController = MapController();
  LatLng _currentLocation = const LatLng(-12.0464, -77.0428); // Lima por defecto
  bool _isLoadingLocation = true;
  String _locationStatus = 'Obteniendo ubicación...';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _startLocationTracking();
  }

  // Obtener ubicación actual al iniciar
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _locationStatus = 'Detectando tu ubicación...';
    });

    final location = await GeoService.getCurrentLocation();
    
    if (location != null) {
      setState(() {
        _currentLocation = location;
        _isLoadingLocation = false;
        _locationStatus = 'Ubicación actualizada';
      });
      
      // Centrar el mapa en la ubicación actual
      _mapController.move(_currentLocation, 15.0);
    } else {
      setState(() {
        _isLoadingLocation = false;
        _locationStatus = 'No se pudo obtener la ubicación';
      });
      
      // Mostrar diálogo de permisos
      _showLocationPermissionDialog();
    }
  }

  // Rastreo en tiempo real de la ubicación
  void _startLocationTracking() {
    GeoService.getLocationStream().listen((location) {
      if (mounted) {
        setState(() {
          _currentLocation = location;
        });
      }
    });
  }

  // Diálogo para solicitar permisos
  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permiso de Ubicación'),
        content: const Text(
          'TaxyTac necesita acceso a tu ubicación para mostrarte conductores cercanos y calcular rutas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _getCurrentLocation();
            },
            child: const Text('Permitir'),
          ),
        ],
      ),
    );
  }

  // Botón para volver a centrar en la ubicación actual
  void _centerOnCurrentLocation() {
    _mapController.move(_currentLocation, 15.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Mapa de fondo
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation,
              initialZoom: 14.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.taxytac.mobile',
              ),
              MarkerLayer(
                markers: [
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
                ],
              ),
            ],
          ),

          // Header con logo y estado de ubicación
          Positioned(
            top: 40,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    'T',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (_isLoadingLocation)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _locationStatus,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Botón para centrar mapa en ubicación actual
          Positioned(
            bottom: 400,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: _centerOnCurrentLocation,
              child: const Icon(Icons.my_location, color: Colors.blue),
            ),
          ),

          // Barra de búsqueda
          Positioned(
            top: 100,
            left: 16,
            right: 16,
            child: GestureDetector(
              onTap: () {
                _showSearchSheet();
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, size: 28),
                    const SizedBox(width: 12),
                    const Text(
                      '¿A dónde vas?',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time, size: 16),
                          const SizedBox(width: 4),
                          const Text('Ahora'),
                          const Icon(Icons.keyboard_arrow_down, size: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Panel de sugerencias
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Sugerencias',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Tarjetas de sugerencias
                  SizedBox(
                    height: 200,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _buildSuggestionCard(
                          icon: Icons.directions_car,
                          title: 'Viaje',
                          subtitle: '',
                          discount: '50%',
                        ),
                        _buildSuggestionCard(
                          icon: Icons.person,
                          title: 'Personas mayores',
                          subtitle: '',
                        ),
                      ],
                    ),
                  ),

                  // Banner promocional
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.pink.shade100, Colors.white],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '¿Quieres viajar? ¡Vamos!',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Image.network(
                          'https://via.placeholder.com/100',
                          width: 100,
                          height: 100,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey.shade300,
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // Botón "Viajar con la app"
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    child: ElevatedButton(
                      onPressed: () {
                        _showSearchSheet();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Viajar con la app',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    String? discount,
  }) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 32),
                ),
                const Spacer(),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (discount != null)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  discount,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showSearchSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Campos de búsqueda
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSearchField(
                    icon: Icons.location_on,
                    hint: 'Punto de recogida',
                    iconColor: Colors.black,
                  ),
                  const SizedBox(height: 12),
                  _buildSearchField(
                    icon: Icons.search,
                    hint: 'Destino',
                    iconColor: Colors.black,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.add, size: 20),
                      const SizedBox(width: 8),
                      const Text('Agregar parada'),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(),

            // Lugares guardados
            Expanded(
              child: ListView(
                children: [
                  _buildSavedPlace(
                    icon: Icons.access_time,
                    title: 'Búsquedas recientes',
                    subtitle: 'No hay búsquedas recientes',
                  ),
                  const Divider(),
                  _buildSavedPlace(
                    icon: Icons.home,
                    title: 'Agregar casa',
                    subtitle: '',
                  ),
                  _buildSavedPlace(
                    icon: Icons.work,
                    title: 'Agregar trabajo',
                    subtitle: '',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField({
    required IconData icon,
    required String hint,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedPlace({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20),
      ),
      title: Text(title),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      onTap: () {
        Navigator.pop(context);
        // Seleccionar ubicación
      },
    );
  }
}
