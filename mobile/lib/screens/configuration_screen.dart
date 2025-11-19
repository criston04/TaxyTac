import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/providers/auth_provider.dart';

class ConfigurationScreen extends ConsumerWidget {
  const ConfigurationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Configuración'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header de usuario
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.grey.shade700,
                    child: Text(
                      authState.userName?.substring(0, 1).toUpperCase() ?? 'U',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          authState.userName ?? 'Usuario',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          authState.userPhone ?? 'Sin teléfono',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          authState.userEmail ?? 'usuario@taxytac.pe',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),

            // Alerta de verificación
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade900.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade800),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange, size: 28),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Verifica tu correo electrónico',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Para mayor seguridad',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: Colors.grey),

            // Sección Configuración
            _buildSectionHeader('Configuración'),
            _buildConfigItem(
              icon: Icons.home_outlined,
              title: 'Agrega tu dirección particular',
              onTap: () {},
            ),
            _buildConfigItem(
              icon: Icons.work_outline,
              title: 'Agrega tu dirección laboral',
              onTap: () {},
            ),
            _buildConfigItem(
              icon: Icons.location_on_outlined,
              title: 'Accesos directos',
              onTap: () {},
            ),
            _buildConfigItem(
              icon: Icons.lock_outline,
              title: 'Privacidad',
              subtitle: 'Administra la información que compartes con nosotros',
              onTap: () {},
            ),
            _buildConfigItem(
              icon: Icons.diamond_outlined,
              title: 'Apariencia',
              subtitle: 'Usa la configuración del dispositivo',
              onTap: () {},
            ),
            _buildConfigItem(
              icon: Icons.receipt_long_outlined,
              title: 'Información de la factura',
              subtitle: 'Administra la información de tus facturas de impuestos',
              onTap: () {},
            ),

            const Divider(height: 32, color: Colors.grey),

            // Sección Accesibilidad
            _buildSectionHeader('Accesibilidad'),
            _buildConfigItem(
              icon: Icons.accessibility_new,
              title: 'Accesibilidad',
              subtitle: 'Administra tu configuración de accesibilidad',
              onTap: () {},
            ),

            const Divider(height: 32, color: Colors.grey),

            // Sección Comunicación
            _buildSectionHeader('Comunicación'),
            _buildConfigItem(
              icon: Icons.notifications_outlined,
              title: 'Comunicación',
              subtitle: 'Elige tus métodos de contacto preferidos y administra tu configuración de notificaciones.',
              onTap: () {},
            ),

            const Divider(height: 32, color: Colors.grey),

            // Sección Seguridad
            _buildSectionHeader('Seguridad'),
            _buildConfigItem(
              icon: Icons.shield_outlined,
              title: 'Preferencias de seguridad',
              subtitle: 'Elige y programa tus herramientas de seguridad favoritas',
              onTap: () {},
            ),
            _buildConfigItem(
              icon: Icons.people_outline,
              title: 'Administra tus contactos de confianza',
              subtitle: 'Comparte el estado de tu viaje con familiares y amigos fácilmente',
              onTap: () {},
            ),
            _buildConfigItem(
              icon: Icons.car_crash_outlined,
              title: 'RideCheck',
              subtitle: 'Administra las notificaciones de RideCheck',
              onTap: () {},
            ),

            const Divider(height: 32, color: Colors.grey),

            // Sección Preferencias de viaje
            _buildSectionHeader('Preferencias de viaje'),
            _buildConfigItem(
              icon: Icons.attach_money,
              title: 'Deja un monto extra automáticamente.',
              subtitle: 'Establece un monto extra predeterminado para cada viaje.',
              onTap: () {},
            ),
            _buildConfigItem(
              icon: Icons.calendar_today_outlined,
              title: 'Reservar',
              subtitle: 'Elige de qué forma se te asignan los socios de la App al reservar con anticipación',
              onTap: () {},
            ),
            _buildConfigItem(
              icon: Icons.notifications_active_outlined,
              title: 'Alerta por socio de la App cerca de ti',
              subtitle: 'Administra cómo deseas recibir notificaciones durante los inicios de viaje con esperas largas',
              onTap: () {},
            ),
            _buildConfigItem(
              icon: Icons.alarm_outlined,
              title: 'Alertas de traslado diario',
              subtitle: 'Recibe notificaciones para solicitar viajes en el momento indicado',
              onTap: () {},
            ),

            const Divider(height: 32, color: Colors.grey),

            // Sección Cambiar de cuenta
            _buildSectionHeader('Cambiar de cuenta'),

            const SizedBox(height: 16),

            // Cerrar sesión
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.grey.shade900,
                      title: const Text(
                        'Cerrar sesión',
                        style: TextStyle(color: Colors.white),
                      ),
                      content: const Text(
                        '¿Estás seguro que deseas cerrar sesión?',
                        style: TextStyle(color: Colors.grey),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ref.read(authProvider.notifier).logout();
                            context.go('/');
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          child: const Text('Cerrar sesión'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text(
                  'Cerrar sesión',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildConfigItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Icon(icon, color: Colors.white, size: 28),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            )
          : null,
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
