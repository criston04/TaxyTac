import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart'; // TODO: Agregar dependencia
import '../core/theme/app_theme.dart';
import '../core/widgets/app_drawer.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayuda y soporte'),
        backgroundColor: AppTheme.primaryOrange,
        foregroundColor: Colors.white,
      ),
      drawer: const AppDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        children: [
          // Contacto rápido
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Column(
                children: [
                  const Icon(
                    Icons.support_agent,
                    size: 64,
                    color: AppTheme.primaryOrange,
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  const Text(
                    '¿Necesitas ayuda?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingSm),
                  const Text(
                    'Nuestro equipo está disponible 24/7',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: AppTheme.spacingLg),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _launchPhone('tel:+51987654321'),
                          icon: const Icon(Icons.phone),
                          label: const Text('Llamar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryOrange,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingMd),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _launchWhatsApp('+51987654321'),
                          icon: const Icon(Icons.chat),
                          label: const Text('WhatsApp'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppTheme.spacingLg),

          const Text(
            'Preguntas frecuentes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingMd),

          // FAQ
          _FAQItem(
            question: '¿Cómo solicito un viaje?',
            answer:
                'Para solicitar un viaje, ingresa tu ubicación de recojo y destino en la pantalla principal. '
                'La app te mostrará el precio estimado y conductores disponibles cerca de ti.',
          ),
          _FAQItem(
            question: '¿Cuánto cuesta el servicio?',
            answer:
                'El precio se calcula automáticamente según la distancia y tiempo estimado del viaje. '
                'Verás el precio exacto antes de confirmar tu solicitud.',
          ),
          _FAQItem(
            question: '¿Cómo puedo pagar?',
            answer:
                'Aceptamos efectivo, tarjetas de crédito/débito, Yape y Plin. '
                'Puedes configurar tu método de pago preferido en "Métodos de pago".',
          ),
          _FAQItem(
            question: '¿Qué hago si el conductor cancela?',
            answer:
                'Si un conductor cancela tu viaje, automáticamente se buscará otro conductor disponible. '
                'No se te cobrará ninguna comisión por cancelaciones del conductor.',
          ),
          _FAQItem(
            question: '¿Puedo calificar al conductor?',
            answer:
                'Sí, al finalizar cada viaje podrás calificar al conductor de 1 a 5 estrellas '
                'y dejar comentarios sobre tu experiencia.',
          ),
          _FAQItem(
            question: '¿Cómo me convierto en conductor?',
            answer:
                'Para ser conductor de TaxyTac necesitas: licencia de conducir vigente, '
                'motocar en buen estado, documentos del vehículo y pasar una verificación. '
                'Contacta a soporte para más información.',
          ),

          const SizedBox(height: AppTheme.spacingLg),

          // Otros recursos
          const Text(
            'Otros recursos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingMd),

          _ResourceTile(
            icon: Icons.article,
            title: 'Centro de ayuda',
            subtitle: 'Artículos y guías completas',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Próximamente')),
              );
            },
          ),
          _ResourceTile(
            icon: Icons.email,
            title: 'Enviar email',
            subtitle: 'soporte@taxytac.pe',
            onTap: () => _launchEmail('soporte@taxytac.pe'),
          ),
          _ResourceTile(
            icon: Icons.bug_report,
            title: 'Reportar un problema',
            subtitle: 'Ayúdanos a mejorar',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Próximamente')),
              );
            },
          ),
          _ResourceTile(
            icon: Icons.feedback,
            title: 'Enviar sugerencias',
            subtitle: 'Comparte tus ideas con nosotros',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Próximamente')),
              );
            },
          ),
        ],
      ),
    );
  }

  void _launchPhone(String url) async {
    // TODO: Implementar cuando se agregue url_launcher
    /* final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } */
  }

  void _launchWhatsApp(String phone) async {
    // TODO: Implementar cuando se agregue url_launcher
    /* final url = 'https://wa.me/$phone';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } */
  }

  void _launchEmail(String email) async {
    // TODO: Implementar cuando se agregue url_launcher
    /* final url = 'mailto:$email';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } */
  }
}

class _FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const _FAQItem({
    required this.question,
    required this.answer,
  });

  @override
  State<_FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<_FAQItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: InkWell(
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: AppTheme.primaryOrange,
                  ),
                ],
              ),
              if (_isExpanded) ...[
                const SizedBox(height: AppTheme.spacingMd),
                Text(
                  widget.answer,
                  style: TextStyle(
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ResourceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ResourceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryOrange),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
