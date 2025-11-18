import 'package:dio/dio.dart';
import '../../errors/exceptions.dart';
import '../../utils/logger.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppException exception;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        exception = NetworkException(
          message: 'Tiempo de espera agotado. Verifica tu conexión a internet.',
          code: 'TIMEOUT',
          originalError: err,
          stackTrace: err.stackTrace,
        );
        break;

      case DioExceptionType.connectionError:
        exception = NetworkException(
          message: 'No se puede conectar al servidor. Verifica tu conexión a internet.',
          code: 'CONNECTION_ERROR',
          originalError: err,
          stackTrace: err.stackTrace,
        );
        break;

      case DioExceptionType.badResponse:
        exception = _handleBadResponse(err);
        break;

      case DioExceptionType.cancel:
        exception = NetworkException(
          message: 'Solicitud cancelada',
          code: 'CANCELLED',
          originalError: err,
          stackTrace: err.stackTrace,
        );
        break;

      default:
        exception = NetworkException(
          message: 'Error de red inesperado',
          code: 'UNKNOWN',
          originalError: err,
          stackTrace: err.stackTrace,
        );
    }

    AppLogger.error('Interceptor Error', exception);
    handler.next(err);
  }

  AppException _handleBadResponse(DioException err) {
    final statusCode = err.response?.statusCode;
    final data = err.response?.data;

    String message = 'Error del servidor';
    if (data is Map && data.containsKey('message')) {
      message = data['message'].toString();
    } else if (data is Map && data.containsKey('error')) {
      message = data['error'].toString();
    }

    switch (statusCode) {
      case 400:
        return ValidationException(
          message: message.isNotEmpty ? message : 'Solicitud inválida',
          errors: data is Map && data.containsKey('errors')
              ? Map<String, String>.from(data['errors'])
              : null,
          code: 'BAD_REQUEST',
          originalError: err,
          stackTrace: err.stackTrace,
        );

      case 401:
        return AuthException(
          message: 'No autorizado. Por favor inicia sesión nuevamente.',
          code: 'UNAUTHORIZED',
          originalError: err,
          stackTrace: err.stackTrace,
        );

      case 403:
        return AuthException(
          message: 'No tienes permiso para realizar esta acción.',
          code: 'FORBIDDEN',
          originalError: err,
          stackTrace: err.stackTrace,
        );

      case 404:
        return NotFoundException(
          message: message.isNotEmpty ? message : 'Recurso no encontrado',
          code: 'NOT_FOUND',
          originalError: err,
          stackTrace: err.stackTrace,
        );

      case 422:
        return ValidationException(
          message: message.isNotEmpty ? message : 'Datos de validación incorrectos',
          errors: data is Map && data.containsKey('errors')
              ? Map<String, String>.from(data['errors'])
              : null,
          code: 'VALIDATION_ERROR',
          originalError: err,
          stackTrace: err.stackTrace,
        );

      case 500:
      case 502:
      case 503:
        return ServerException(
          message: 'Error del servidor. Por favor intenta más tarde.',
          code: 'SERVER_ERROR',
          originalError: err,
          stackTrace: err.stackTrace,
        );

      default:
        return ServerException(
          message: message.isNotEmpty ? message : 'Error del servidor desconocido',
          code: statusCode?.toString(),
          originalError: err,
          stackTrace: err.stackTrace,
        );
    }
  }
}
