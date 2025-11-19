import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/presentation/providers/auth_provider.dart';

class AccountSettingsScreen extends ConsumerStatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  ConsumerState<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends ConsumerState<AccountSettingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Cuenta Uber'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Inicio'),
            Tab(text: 'Información personal'),
            Tab(text: 'Seguridad'),
            Tab(text: 'Protección de datos'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInicioTab(authState),
          _buildInformacionPersonalTab(authState),
          _buildSeguridadTab(),
          _buildProteccionDatosTab(),
        ],
      ),
    );
  }

  Widget _buildInicioTab(authState) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 24),
          // Foto de perfil
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey.shade700,
            child: Text(
              authState.userName?.substring(0, 1).toUpperCase() ?? 'U',
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            authState.userName ?? 'Usuario',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            authState.userEmail ?? 'usuario@taxytac.pe',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),

          // Tarjetas de acceso rápido
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildQuickAccessCard(
                    icon: Icons.person_outline,
                    title: 'Información\npersonal',
                    onTap: () => _tabController.animateTo(1),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickAccessCard(
                    icon: Icons.shield_outlined,
                    title: 'Seguridad',
                    onTap: () => _tabController.animateTo(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickAccessCard(
                    icon: Icons.lock_outline,
                    title: 'Protección\nde datos',
                    onTap: () => _tabController.animateTo(3),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Sugerencias
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sugerencias',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade700,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.badge,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Completa la verificación de tu cuenta',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Completa la verificación de tu cuenta para que la app de Uber funcione mejor para ti y te mantengas seguro.',
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
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade800,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Comenzar la revisión'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInformacionPersonalTab(authState) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Información personal',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Foto de perfil
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade700,
                  child: Text(
                    authState.userName?.substring(0, 1).toUpperCase() ?? 'U',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          _buildInfoItem(
            title: 'Nombre',
            value: authState.userName ?? 'Usuario',
            icon: Icons.person_outline,
          ),
          _buildInfoItem(
            title: 'Género',
            value: 'No especificado',
            icon: Icons.wc,
          ),
          _buildInfoItem(
            title: 'Número de teléfono',
            value: authState.userPhone ?? 'Sin teléfono',
            icon: Icons.phone_outlined,
            verified: authState.userPhone != null,
          ),
          _buildInfoItem(
            title: 'Correo electrónico',
            value: authState.userEmail ?? 'usuario@taxytac.pe',
            icon: Icons.email_outlined,
            warning: true,
          ),
          _buildInfoItem(
            title: 'Idioma',
            value: 'Actualizar el idioma del dispositivo',
            icon: Icons.language,
            showExternal: true,
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSeguridadTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Seguridad',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),

          _buildSectionHeader('Iniciar sesión en Uber'),
          _buildSecurityItem(
            title: 'Claves de acceso',
            subtitle: 'Las claves de acceso son más fáciles y seguras que las contraseñas.',
          ),
          _buildSecurityItem(
            title: 'Contraseña',
          ),
          _buildSecurityItem(
            title: 'App de autenticación',
            subtitle: 'Configura la app de autenticación para agregar un nivel de seguridad adicional.',
          ),
          _buildSecurityItem(
            title: 'Verificación en dos pasos',
            subtitle: 'Mejora la seguridad de tu cuenta con la verificación en dos pasos.',
          ),
          _buildSecurityItem(
            title: 'Teléfono para la recuperación',
            subtitle: 'Agrega un número de teléfono alternativo para acceder a tu cuenta.',
          ),

          const Divider(height: 32, color: Colors.grey),

          _buildSectionHeader('Apps sociales conectadas'),
          _buildSecurityItem(
            title: 'Google',
            subtitle: 'Administra las apps de redes sociales conectadas para iniciar sesión en tu cuenta Uber aquí.',
            trailing: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade800,
                foregroundColor: Colors.white,
              ),
              child: const Text('Conectar'),
            ),
          ),

          const Divider(height: 32, color: Colors.grey),

          _buildSectionHeader('Actividad de inicio de sesión'),
          _buildSecurityItem(
            title: 'Iniciaste sesión en estos dispositivos en los últimos 30 días. Puede haber varias sesiones en el mismo dispositivo.',
          ),
          
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.phone_android, color: Colors.white),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Navegador Web',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tu sesión actual',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Ubicación actual',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'App de Uber en la web, Usuario de la app de Uber',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          _buildSecurityItem(
            title: 'Teléfono Android',
          ),
          _buildSecurityItem(
            title: 'Cerrar sesión en todos los dispositivos',
            subtitle: 'De todos excepto de tu sesión actual',
            titleColor: Colors.red,
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildProteccionDatosTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Protección de datos',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),

          _buildSectionHeader('Privacidad'),
          _buildSecurityItem(
            title: 'Centro de privacidad',
            subtitle: 'Controla tu privacidad y conoce cómo la protegemos.',
          ),
          _buildSecurityItem(
            title: 'Preferencias de comunicación',
            subtitle: 'Administra cómo Uber te contacta.',
          ),

          const Divider(height: 32, color: Colors.grey),

          _buildSectionHeader('Apps de terceros con acceso a la cuenta'),
          _buildSecurityItem(
            title: '',
            subtitle: 'Una vez que permitas el acceso a las apps de terceros, las verás aquí. Conoce más',
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildQuickAccessCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required String title,
    required String value,
    required IconData icon,
    bool verified = false,
    bool warning = false,
    bool showExternal = false,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          if (verified)
            const Icon(Icons.check_circle, color: Colors.green, size: 16),
          if (warning)
            const Icon(Icons.warning, color: Colors.orange, size: 16),
        ],
      ),
      trailing: Icon(
        showExternal ? Icons.open_in_new : Icons.chevron_right,
        color: Colors.grey,
      ),
      onTap: () {},
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
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

  Widget _buildSecurityItem({
    required String title,
    String? subtitle,
    Widget? trailing,
    Color? titleColor,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      title: title.isNotEmpty
          ? Text(
              title,
              style: TextStyle(
                color: titleColor ?? Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            )
          : null,
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            )
          : null,
      trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {},
    );
  }
}
