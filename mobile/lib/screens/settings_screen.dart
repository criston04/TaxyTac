import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/app_drawer.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _locationAlways = false;
  String _language = 'es';
  String _theme = 'light';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: AppTheme.primaryOrange,
        foregroundColor: Colors.white,
      ),
      drawer: const AppDrawer(),
      body: ListView(
        children: [
          _buildSection(
            title: 'Notificaciones',
            children: [
              SwitchListTile(
                title: const Text('Activar notificaciones'),
                subtitle: const Text('Recibe alertas de viajes y ofertas'),
                value: _notificationsEnabled,
                onChanged: (value) => setState(() => _notificationsEnabled = value),
                secondary: const Icon(Icons.notifications),
              ),
              SwitchListTile(
                title: const Text('Sonido'),
                subtitle: const Text('Reproducir sonidos de notificación'),
                value: _soundEnabled,
                onChanged: _notificationsEnabled
                    ? (value) => setState(() => _soundEnabled = value)
                    : null,
                secondary: const Icon(Icons.volume_up),
              ),
              SwitchListTile(
                title: const Text('Vibración'),
                subtitle: const Text('Vibrar al recibir notificaciones'),
                value: _vibrationEnabled,
                onChanged: _notificationsEnabled
                    ? (value) => setState(() => _vibrationEnabled = value)
                    : null,
                secondary: const Icon(Icons.vibration),
              ),
            ],
          ),

          _buildSection(
            title: 'Ubicación',
            children: [
              SwitchListTile(
                title: const Text('Ubicación siempre activa'),
                subtitle: const Text('Mejora la precisión de los viajes'),
                value: _locationAlways,
                onChanged: (value) => setState(() => _locationAlways = value),
                secondary: const Icon(Icons.location_on),
              ),
            ],
          ),

          _buildSection(
            title: 'Apariencia',
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Idioma'),
                subtitle: const Text('Español'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showLanguageDialog(),
              ),
              ListTile(
                leading: const Icon(Icons.brightness_6),
                title: const Text('Tema'),
                subtitle: Text(_theme == 'light' ? 'Claro' : 'Oscuro'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showThemeDialog(),
              ),
            ],
          ),

          _buildSection(
            title: 'Privacidad y Seguridad',
            children: [
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text('Política de privacidad'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Mostrar política de privacidad
                },
              ),
              ListTile(
                leading: const Icon(Icons.description),
                title: const Text('Términos y condiciones'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Mostrar términos
                },
              ),
              ListTile(
                leading: const Icon(Icons.block),
                title: const Text('Usuarios bloqueados'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Mostrar usuarios bloqueados
                },
              ),
            ],
          ),

          _buildSection(
            title: 'Datos',
            children: [
              ListTile(
                leading: const Icon(Icons.data_usage),
                title: const Text('Uso de datos'),
                subtitle: const Text('Ver consumo de datos de la app'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Mostrar uso de datos
                },
              ),
              ListTile(
                leading: const Icon(Icons.cleaning_services),
                title: const Text('Limpiar caché'),
                subtitle: const Text('Libera espacio en tu dispositivo'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showClearCacheDialog(),
              ),
            ],
          ),

          _buildSection(
            title: 'Acerca de',
            children: [
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Versión'),
                subtitle: const Text('2.0.0 (Professional Edition)'),
              ),
              ListTile(
                leading: const Icon(Icons.system_update),
                title: const Text('Buscar actualizaciones'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Estás usando la última versión'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.star_rate),
                title: const Text('Calificar app'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Abrir tienda de apps
                },
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spacingXl),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppTheme.spacingMd,
            AppTheme.spacingLg,
            AppTheme.spacingMd,
            AppTheme.spacingSm,
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryOrange,
            ),
          ),
        ),
        ...children,
        const Divider(height: 1),
      ],
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar idioma'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Español'),
              value: 'es',
              groupValue: _language,
              onChanged: (value) {
                setState(() => _language = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: _language,
              onChanged: (value) {
                setState(() => _language = value!);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Próximamente')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar tema'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Claro'),
              value: 'light',
              groupValue: _theme,
              onChanged: (value) {
                setState(() => _theme = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Oscuro'),
              value: 'dark',
              groupValue: _theme,
              onChanged: (value) {
                setState(() => _theme = value!);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Próximamente')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpiar caché'),
        content: const Text(
          '¿Deseas eliminar los archivos temporales? '
          'Esto liberará espacio pero puede hacer que la app sea más lenta la próxima vez que la uses.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Caché limpiada exitosamente'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryOrange,
            ),
            child: const Text('Limpiar'),
          ),
        ],
      ),
    );
  }
}
