import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../screens/login_screen.dart';
import '../../screens/mode_selection_screen.dart';
import '../../screens/uber_style_main_screen.dart';
import '../../screens/driver_screen.dart';
import '../../screens/trip_history_screen.dart';
import '../../screens/profile_screen.dart';
import '../../screens/payment_methods_screen.dart';
import '../../screens/settings_screen.dart';
import '../../screens/support_screen.dart';

class AppRouter {
  static const String login = '/';
  static const String modeSelection = '/mode-selection';
  static const String passenger = '/passenger';
  static const String driver = '/driver';
  static const String tripHistory = '/trip-history';
  static const String profile = '/profile';
  static const String paymentMethods = '/payment-methods';
  static const String vehicle = '/vehicle';
  static const String earnings = '/earnings';
  static const String settings = '/settings';
  static const String support = '/support';

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
          builder: (context, state) => const UberStyleMainScreen(),
        ),
        GoRoute(
          path: driver,
          name: 'driver',
          builder: (context, state) => const DriverScreen(),
        ),
        GoRoute(
          path: tripHistory,
          name: 'tripHistory',
          builder: (context, state) => const TripHistoryScreen(),
        ),
        GoRoute(
          path: profile,
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: paymentMethods,
          name: 'paymentMethods',
          builder: (context, state) => const PaymentMethodsScreen(),
        ),
        GoRoute(
          path: settings,
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: support,
          name: 'support',
          builder: (context, state) => const SupportScreen(),
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
