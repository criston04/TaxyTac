import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:8080/api';
  
  static String? _token;
  static String? _userId;
  static String? _userName;

  static Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/auth/register');
    
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _saveAuthData(
        token: data['token'] as String,
        userId: data['user']['id'] as String,
        userName: data['user']['name'] as String,
      );
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Error al registrarse');
    }
  }

  static Future<void> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/auth/login');
    
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _saveAuthData(
        token: data['token'] as String,
        userId: data['user']['id'] as String,
        userName: data['user']['name'] as String,
      );
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Error al iniciar sesión');
    }
  }

  static Future<void> _saveAuthData({
    required String token,
    required String userId,
    required String userName,
  }) async {
    _token = token;
    _userId = userId;
    _userName = userName;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('user_id', userId);
    await prefs.setString('user_name', userName);
  }

  static Future<bool> loadAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    _userId = prefs.getString('user_id');
    _userName = prefs.getString('user_name');
    
    return _token != null;
  }

  static Future<void> logout() async {
    _token = null;
    _userId = null;
    _userName = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
    await prefs.remove('user_name');
  }

  static bool get isAuthenticated => _token != null;
  static String? get token => _token;
  static String? get userId => _userId;
  static String? get userName => _userName;

  static Map<String, String> get authHeaders => {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };
}
