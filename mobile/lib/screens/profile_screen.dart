import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import 'account_settings_screen.dart';
import 'configuration_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con nombre y foto
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.grey.shade300,
                      child: Text(
                        authState.userName?.substring(0, 1).toUpperCase() ?? 'U',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
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
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: const [
                              Icon(Icons.star, size: 16, color: Colors.black),
                              SizedBox(width: 4),
                              Text(
                                'Sin viajes',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Opciones principales
              _buildOption(
                context,
                icon: Icons.help_outline,
                title: 'Ayuda',
                onTap: () {},
              ),
              _buildOption(
                context,
                icon: Icons.payment,
                title: 'Billetera',
                badge: '\u2022',
                onTap: () {},
              ),
              _buildOption(
                context,
                icon: Icons.security,
                title: 'Seguridad',
                onTap: () {},
              ),
              _buildOption(
                context,
                icon: Icons.mail_outline,
                title: 'Bandeja de entrada',
                badge: '\u2022',
                onTap: () {},
              ),

              const SizedBox(height: 16),

              // Banner promocional
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Prueba TaxyTac Plus sin costo',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '2 meses sin costo con el 10% de créditos en viajes',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.card_giftcard,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Control de seguridad
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Control de seguridad',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Conoce cómo hacer que los viajes sean más seguros',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(
                            value: 0.33,
                            strokeWidth: 6,
                            backgroundColor: Colors.grey.shade300,
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        ),
                        const Text(
                          '0/6',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Revisión de privacidad
              _buildOption(
                context,
                icon: Icons.privacy_tip_outlined,
                title: 'Revisión de privacidad',
                subtitle: 'Haz un recorrido interactivo por tu configuración de privacidad',
                onTap: () {},
              ),

              const Divider(height: 32),

              // Sección Familia
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.family_restroom, size: 20),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Familia',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Administra las cuentas para adolescentes, adultos y personas mayores',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 32),

              // Configuración
              _buildOption(
                context,
                icon: Icons.settings,
                title: 'Configuración',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ConfigurationScreen(),
                    ),
                  );
                },
              ),

              // Modo simple
              _buildOption(
                context,
                icon: Icons.phone_android,
                title: 'Modo simple',
                subtitle: 'Una app simplificada para adultos mayores',
                badge: 'NUEVO',
                onTap: () {},
              ),

              // Genera ganancias
              _buildOption(
                context,
                icon: Icons.directions_car,
                title: 'Genera ganancias: conduce o haz entregas',
                onTap: () {},
              ),

              // Grupos guardados
              _buildOption(
                context,
                icon: Icons.group,
                title: 'Grupos guardados',
                badge: 'NUEVO',
                onTap: () {},
              ),

              // Perfil de negocios
              _buildOption(
                context,
                icon: Icons.business,
                title: 'Configura tu perfil de negocios',
                subtitle: 'Automatiza los gastos de viajes y comidas de trabajo',
                onTap: () {},
              ),

              // Administrar cuenta
              _buildOption(
                context,
                icon: Icons.person_outline,
                title: 'Administra la cuenta Uber',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AccountSettingsScreen(),
                    ),
                  );
                },
              ),

              // Legal
              _buildOption(
                context,
                icon: Icons.info_outline,
                title: 'Legal',
                onTap: () {},
              ),

              const SizedBox(height: 16),

              // Versión
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'TaxyTac v1.0.0',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    String? badge,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Icon(icon, size: 28),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            )
          : null,
      trailing: badge != null
          ? (badge == '\u2022'
              ? Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                )
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ))
          : null,
      onTap: onTap,
    );
  }
}
