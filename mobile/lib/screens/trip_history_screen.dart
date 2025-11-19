import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/app_drawer.dart';
import '../core/widgets/shimmer_loading.dart';
import '../models/trip.dart';

class TripHistoryScreen extends ConsumerStatefulWidget {
  const TripHistoryScreen({super.key});

  @override
  ConsumerState<TripHistoryScreen> createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends ConsumerState<TripHistoryScreen> {
  bool _isLoading = true;
  List<Trip> _trips = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  Future<void> _loadTrips() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Simular carga de viajes (TODO: implementar API real)
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        _trips = [
          Trip(
            id: '1',
            passengerId: 'user123',
            pickup: Location(
              lat: -12.0464,
              lng: -77.0428,
              address: 'Av. Larco 123, Miraflores',
            ),
            destination: Location(
              lat: -12.0975,
              lng: -77.0364,
              address: 'Av. Arequipa 456, San Isidro',
            ),
            fare: 15.50,
            distance: 3.2,
            duration: 12,
            status: TripStatus.completed,
            createdAt: DateTime.now().subtract(const Duration(days: 1)),
          ),
          Trip(
            id: '2',
            passengerId: 'user123',
            pickup: Location(
              lat: -12.0975,
              lng: -77.0364,
              address: 'Av. Arequipa 456, San Isidro',
            ),
            destination: Location(
              lat: -12.1461,
              lng: -77.0211,
              address: 'Av. Bolognesi 789, Barranco',
            ),
            fare: 22.00,
            distance: 5.8,
            duration: 18,
            status: TripStatus.completed,
            createdAt: DateTime.now().subtract(const Duration(days: 2)),
          ),
          Trip(
            id: '3',
            passengerId: 'user123',
            pickup: Location(
              lat: -12.1408,
              lng: -76.9897,
              address: 'Av. Primavera 321, Surco',
            ),
            destination: Location(
              lat: -12.0464,
              lng: -77.0428,
              address: 'Av. Larco 123, Miraflores',
            ),
            fare: 18.00,
            distance: 4.1,
            duration: 15,
            status: TripStatus.cancelled,
            createdAt: DateTime.now().subtract(const Duration(days: 3)),
          ),
        ];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar el historial';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de viajes'),
        backgroundColor: AppTheme.primaryOrange,
        foregroundColor: Colors.white,
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) => const ShimmerTripCard(),
            )
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: AppTheme.error),
                      const SizedBox(height: 16),
                      Text(_error!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadTrips,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : _trips.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.history, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No tienes viajes registrados',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadTrips,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(AppTheme.spacingMd),
                        itemCount: _trips.length,
                        itemBuilder: (context, index) {
                          final trip = _trips[index];
                          return _TripCard(trip: trip);
                        },
                      ),
                    ),
    );
  }
}

class _TripCard extends StatelessWidget {
  final Trip trip;

  const _TripCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      elevation: 2,
      child: InkWell(
        onTap: () => _showTripDetails(context),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fecha y estado
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDate(trip.createdAt),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  _StatusBadge(status: trip.status),
                ],
              ),
              const SizedBox(height: AppTheme.spacingMd),

              // Origen
              _LocationRow(
                icon: Icons.circle,
                color: AppTheme.secondaryGreen,
                text: trip.pickup.address,
              ),
              const SizedBox(height: AppTheme.spacingSm),

              // Destino
              _LocationRow(
                icon: Icons.location_on,
                color: AppTheme.error,
                text: trip.destination.address,
              ),
              const SizedBox(height: AppTheme.spacingMd),

              // Info del viaje
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _InfoChip(
                    icon: Icons.route,
                    text: '${trip.distance?.toStringAsFixed(1) ?? '0.0'} km',
                  ),
                  _InfoChip(
                    icon: Icons.access_time,
                    text: '${trip.duration ?? 0} min',
                  ),
                  Text(
                    'S/ ${trip.fare?.toStringAsFixed(2) ?? '0.00'}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryOrange,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hoy ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Ayer ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} días';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showTripDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingLg),
              const Text(
                'Detalles del viaje',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppTheme.spacingLg),
              _DetailRow(label: 'ID del viaje', value: '#${trip.id}'),
              _DetailRow(label: 'Fecha', value: _formatDate(trip.createdAt)),
              _DetailRow(label: 'Estado', value: trip.status.displayName),
              const Divider(height: 32),
              _DetailRow(label: 'Distancia', value: '${trip.distance?.toStringAsFixed(1) ?? '0.0'} km'),
              _DetailRow(label: 'Duración', value: '${trip.duration ?? 0} min'),
              _DetailRow(
                label: 'Tarifa',
                value: 'S/ ${trip.fare?.toStringAsFixed(2) ?? '0.00'}',
                isHighlighted: true,
              ),
              if (trip.driver != null) ...[
                const Divider(height: 32),
                const Text(
                  'Conductor',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppTheme.spacingMd),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      child: Icon(Icons.person, size: 30),
                    ),
                    const SizedBox(width: AppTheme.spacingMd),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trip.driver!.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 16, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text('${trip.driver!.rating.toStringAsFixed(1)}'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final TripStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case TripStatus.completed:
        color = AppTheme.success;
        break;
      case TripStatus.cancelled:
        color = AppTheme.error;
        break;
      case TripStatus.inProgress:
        color = AppTheme.secondaryBlue;
        break;
      default:
        color = AppTheme.warning;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        border: Border.all(color: color),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _LocationRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _LocationRow({
    required this.icon,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: AppTheme.spacingSm),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoChip({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlighted;

  const _DetailRow({
    required this.label,
    required this.value,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingSm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isHighlighted ? 18 : 14,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
              color: isHighlighted ? AppTheme.primaryOrange : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
