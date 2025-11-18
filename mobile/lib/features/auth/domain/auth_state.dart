import 'package:equatable/equatable.dart';

/// Representa el estado de autenticación del usuario
class AuthState extends Equatable {
  final bool isAuthenticated;
  final String? userId;
  final String? userName;
  final String? userRole;
  final String? token;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.isAuthenticated = false,
    this.userId,
    this.userName,
    this.userRole,
    this.token,
    this.isLoading = false,
    this.error,
  });

  const AuthState.initial()
      : isAuthenticated = false,
        userId = null,
        userName = null,
        userRole = null,
        token = null,
        isLoading = false,
        error = null;

  const AuthState.authenticated({
    required String userId,
    required String userName,
    required String userRole,
    required String token,
  })  : isAuthenticated = true,
        userId = userId,
        userName = userName,
        userRole = userRole,
        token = token,
        isLoading = false,
        error = null;

  const AuthState.loading()
      : isAuthenticated = false,
        userId = null,
        userName = null,
        userRole = null,
        token = null,
        isLoading = true,
        error = null;

  const AuthState.error(String errorMessage)
      : isAuthenticated = false,
        userId = null,
        userName = null,
        userRole = null,
        token = null,
        isLoading = false,
        error = errorMessage;

  AuthState copyWith({
    bool? isAuthenticated,
    String? userId,
    String? userName,
    String? userRole,
    String? token,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userRole: userRole ?? this.userRole,
      token: token ?? this.token,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        isAuthenticated,
        userId,
        userName,
        userRole,
        token,
        isLoading,
        error,
      ];
}
