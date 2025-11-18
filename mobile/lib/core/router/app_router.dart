import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../screens/login_screen.dart';
import '../../screens/mode_selection_screen.dart';
import '../../screens/passenger_screen.dart';
import '../../screens/driver_screen.dart';

class AppRouter {
  static const String login = '/';
  static const String modeSelection = '/mode-selection';
  static const String passenger = '/passenger';
  static const String driver = '/driver';

  static GoRouter router({required bool isAuthenticated}) {
    return GoRouter(
      initialLocation: login,
      redirect: (context, state) {
        final isLoginRoute = state.matchedLocation == login;
        
        if (!isAuthenticated && !isLoginRoute) {
          return login;
        }
        
        if (isAuthenticated && isLoginRoute) {
          return modeSelection;
        }
        
        return null;
      },
      routes: [
        GoRoute(
          path: login,
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: modeSelection,
          name: 'modeSelection',
          builder: (context, state) => const ModeSelectionScreen(),
        ),
        GoRoute(
          path: passenger,
          name: 'passenger',
          builder: (context, state) => const PassengerScreen(),
        ),
        GoRoute(
          path: driver,
          name: 'driver',
          builder: (context, state) => const DriverScreen(),
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 80, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Página no encontrada',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(state.error.toString()),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go(login),
                child: const Text('Ir al inicio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
