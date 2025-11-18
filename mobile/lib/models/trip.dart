class Trip {
  final String id;
  final String passengerId;
  final String? driverId;
  final Location pickup;
  final Location destination;
  final TripStatus status;
  final double? fare;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;

  Trip({
    required this.id,
    required this.passengerId,
    this.driverId,
    required this.pickup,
    required this.destination,
    required this.status,
    this.fare,
    required this.createdAt,
    this.acceptedAt,
    this.startedAt,
    this.completedAt,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'] as String,
      passengerId: json['passenger_id'] as String,
      driverId: json['driver_id'] as String?,
      pickup: Location.fromJson(json['pickup']),
      destination: Location.fromJson(json['destination']),
      status: TripStatus.fromString(json['status'] as String),
      fare: json['fare'] != null ? (json['fare'] as num).toDouble() : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      acceptedAt: json['accepted_at'] != null
          ? DateTime.parse(json['accepted_at'] as String)
          : null,
      startedAt: json['started_at'] != null
          ? DateTime.parse(json['started_at'] as String)
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }
}

class Location {
  final double lat;
  final double lng;
  final String address;

  Location({
    required this.lat,
    required this.lng,
    required this.address,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      address: json['address'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
      'address': address,
    };
  }
}

enum TripStatus {
  pending,
  accepted,
  inProgress,
  completed,
  cancelled;

  static TripStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return TripStatus.pending;
      case 'accepted':
        return TripStatus.accepted;
      case 'in_progress':
        return TripStatus.inProgress;
      case 'completed':
        return TripStatus.completed;
      case 'cancelled':
        return TripStatus.cancelled;
      default:
        return TripStatus.pending;
    }
  }

  String get displayName {
    switch (this) {
      case TripStatus.pending:
        return 'Buscando conductor...';
      case TripStatus.accepted:
        return 'Conductor asignado';
      case TripStatus.inProgress:
        return 'En camino';
      case TripStatus.completed:
        return 'Completado';
      case TripStatus.cancelled:
        return 'Cancelado';
    }
  }
}

class Driver {
  final String id;
  final String name;
  final String phone;
  final String vehiclePlate;
  final String vehicleModel;
  final double rating;
  final int totalTrips;
  final double lat;
  final double lng;
  final double? distanceKm;

  Driver({
    required this.id,
    required this.name,
    required this.phone,
    required this.vehiclePlate,
    required this.vehicleModel,
    required this.rating,
    required this.totalTrips,
    required this.lat,
    required this.lng,
    this.distanceKm,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String? ?? '',
      vehiclePlate: json['vehicle_plate'] as String? ?? '',
      vehicleModel: json['vehicle_model'] as String? ?? 'Bajaj',
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      totalTrips: json['total_trips'] as int? ?? 0,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      distanceKm: json['distance_km'] != null
          ? (json['distance_km'] as num).toDouble()
          : null,
    );
  }
}
