import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final FlutterSecureStorage _storage;
  final Dio _dio;

  AuthNotifier(this._storage, this._dio) : super(const AuthState.initial()) {
    _loadAuthData();
  }

  Future<void> _loadAuthData() async {
    try {
      final token = await _storage.read(key: AppConstants.keyAuthToken);
      final userId = await _storage.read(key: AppConstants.keyUserId);
      final userName = await _storage.read(key: AppConstants.keyUserName);
      final userEmail = await _storage.read(key: 'userEmail');
      final userPhone = await _storage.read(key: 'userPhone');
      final userRole = await _storage.read(key: AppConstants.keyUserRole);

      if (token != null && userId != null && userName != null && userRole != null) {
        state = AuthState.authenticated(
          userId: userId,
          userName: userName,
          userEmail: userEmail,
          userPhone: userPhone,
          userRole: userRole,
          token: token,
        );
        AppLogger.info('Auth data cargada: usuario $userName ($userRole)');
      }
    } catch (e, stack) {
      AppLogger.error('Error al cargar auth data', e, stack);
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();

    try {
      final response = await _dio.post(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      final data = response.data;
      final token = data['token'] as String;
      final user = data['user'] as Map<String, dynamic>;

      await _saveAuthData(
        token: token,
        userId: user['id'].toString(),
        userName: user['name'] as String,
        userEmail: user['email'] as String?,
        userPhone: user['phone'] as String?,
        userRole: user['role'] as String? ?? 'passenger',
      );

      state = AuthState.authenticated(
        userId: user['id'].toString(),
        userName: user['name'] as String,
        userEmail: user['email'] as String?,
        userPhone: user['phone'] as String?,
        userRole: user['role'] as String? ?? 'passenger',
        token: token,
      );

      AppLogger.info('Usuario registrado exitosamente: ${user['name']}');
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? 'Error al registrar usuario';
      state = AuthState.error(errorMessage);
      AppLogger.error('Error en registro', e);
    } catch (e, stack) {
      state = const AuthState.error('Error inesperado al registrar');
      AppLogger.error('Error inesperado en registro', e, stack);
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();

    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = response.data;
      final token = data['token'] as String;
      final user = data['user'] as Map<String, dynamic>;

      await _saveAuthData(
        token: token,
        userId: user['id'].toString(),
        userName: user['name'] as String,
        userEmail: user['email'] as String?,
        userPhone: user['phone'] as String?,
        userRole: user['role'] as String? ?? 'passenger',
      );

      state = AuthState.authenticated(
        userId: user['id'].toString(),
        userName: user['name'] as String,
        userEmail: user['email'] as String?,
        userPhone: user['phone'] as String?,
        userRole: user['role'] as String? ?? 'passenger',
        token: token,
      );

      AppLogger.info('Usuario autenticado: ${user['name']}');
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? 'Error al iniciar sesión';
      state = AuthState.error(errorMessage);
      AppLogger.error('Error en login', e);
    } catch (e, stack) {
      state = const AuthState.error('Error inesperado al iniciar sesión');
      AppLogger.error('Error inesperado en login', e, stack);
    }
  }

  Future<void> logout() async {
    try {
      await _storage.deleteAll();
      state = const AuthState.initial();
      AppLogger.info('Usuario deslogueado');
    } catch (e, stack) {
      AppLogger.error('Error al desloguear', e, stack);
    }
  }

  Future<void> _saveAuthData({
    required String token,
    required String userId,
    required String userName,
    String? userEmail,
    String? userPhone,
    required String userRole,
  }) async {
    await _storage.write(key: AppConstants.keyAuthToken, value: token);
    await _storage.write(key: AppConstants.keyUserId, value: userId);
    await _storage.write(key: AppConstants.keyUserName, value: userName);
    if (userEmail != null) {
      await _storage.write(key: 'userEmail', value: userEmail);
    }
    if (userPhone != null) {
      await _storage.write(key: 'userPhone', value: userPhone);
    }
    await _storage.write(key: AppConstants.keyUserRole, value: userRole);
  }
}

// Provider de AuthNotifier
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    const FlutterSecureStorage(),
    DioClient.instance,
  );
});
