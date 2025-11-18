class AppConstants {
  // API
  static const String baseUrl = 'http://localhost:8080';
  static const String apiBaseUrl = '$baseUrl/api';
  static const String wsUrl = 'ws://localhost:8080/ws';
  
  // Timeout
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Map
  static const double defaultZoom = 14.0;
  static const double defaultLatitude = -12.0464; // Lima, Perú
  static const double defaultLongitude = -77.0428;
  
  // Location
  static const int locationUpdateInterval = 3; // segundos
  static const int locationDistanceFilter = 10; // metros
  static const double nearbyDriversRadius = 5000; // metros
  
  // Trip
  static const double baseFare = 3.00; // S/
  static const double farePerKm = 1.50; // S/
  static const double farePerMinute = 0.30; // S/
  static const int averageSpeedKmh = 30;
  
  // WebSocket
  static const int heartbeatInterval = 30; // segundos
  static const int reconnectDelay = 5; // segundos
  static const int maxReconnectAttempts = 5;
  
  // Storage Keys
  static const String keyAuthToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyUserName = 'user_name';
  static const String keyUserRole = 'user_role';
  static const String keyThemeMode = 'theme_mode';
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 2;
  static const int maxNameLength = 100;
  
  // Ratings
  static const double minRating = 1.0;
  static const double maxRating = 5.0;
  
  // Animation
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);
  static const Duration slowAnimationDuration = Duration(milliseconds: 500);
}
