class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  AppException({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

class AuthException extends AppException {
  AuthException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

class ValidationException extends AppException {
  final Map<String, String>? errors;

  ValidationException({
    required super.message,
    this.errors,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

class NotFoundException extends AppException {
  NotFoundException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

class ServerException extends AppException {
  ServerException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

class LocationException extends AppException {
  LocationException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}
