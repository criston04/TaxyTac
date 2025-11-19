import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../core/theme/app_theme.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Drawer(
      child: Column(
        children: [
          // Header del drawer
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryOrange,
                  AppTheme.primaryDark,
                ],
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                authState.userName?.substring(0, 1).toUpperCase() ?? 'U',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryOrange,
                ),
              ),
            ),
            accountName: Text(
              authState.userName ?? 'Usuario',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              authState.userRole == 'driver' ? 'Conductor' : 'Pasajero',
              style: const TextStyle(fontSize: 14),
            ),
          ),

          // Menú items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _DrawerItem(
                  icon: Icons.home,
                  title: 'Inicio',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/mode-selection');
                  },
                ),
                _DrawerItem(
                  icon: Icons.history,
                  title: 'Historial de viajes',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/trip-history');
                  },
                ),
                _DrawerItem(
                  icon: Icons.person,
                  title: 'Mi perfil',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/profile');
                  },
                ),
                _DrawerItem(
                  icon: Icons.credit_card,
                  title: 'Métodos de pago',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/payment-methods');
                  },
                ),
                if (authState.userRole == 'driver') ...[
                  const Divider(),
                  _DrawerItem(
                    icon: Icons.directions_car,
                    title: 'Mi vehículo',
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/vehicle');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.attach_money,
                    title: 'Ganancias',
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/earnings');
                    },
                  ),
                ],
                const Divider(),
                _DrawerItem(
                  icon: Icons.settings,
                  title: 'Configuración',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/settings');
                  },
                ),
                _DrawerItem(
                  icon: Icons.help,
                  title: 'Ayuda y soporte',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/support');
                  },
                ),
                _DrawerItem(
                  icon: Icons.info,
                  title: 'Acerca de',
                  onTap: () {
                    Navigator.pop(context);
                    _showAboutDialog(context);
                  },
                ),
              ],
            ),
          ),

          // Logout
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: AppTheme.error),
            title: const Text(
              'Cerrar sesión',
              style: TextStyle(color: AppTheme.error),
            ),
            onTap: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Cerrar sesión'),
                  content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.error,
                      ),
                      child: const Text('Cerrar sesión'),
                    ),
                  ],
                ),
              );

              if (shouldLogout == true && context.mounted) {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) {
                  context.go('/');
                }
              }
            },
          ),
          const SizedBox(height: AppTheme.spacingSm),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'TaxyTac',
      applicationVersion: '2.0.0',
      applicationIcon: const Icon(
        Icons.two_wheeler,
        size: 48,
        color: AppTheme.primaryOrange,
      ),
      children: [
        const Text('Plataforma de motos bajaj en Perú'),
        const SizedBox(height: 16),
        const Text('Conectamos pasajeros con conductores de forma rápida y segura.'),
        const SizedBox(height: 16),
        const Text('© 2025 TaxyTac. Todos los derechos reservados.'),
      ],
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryOrange),
      title: Text(title),
      onTap: onTap,
      trailing: const Icon(Icons.chevron_right, size: 16),
    );
  }
}
