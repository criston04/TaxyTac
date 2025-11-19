import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/app_drawer.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final List<PaymentMethod> _paymentMethods = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Métodos de pago'),
        backgroundColor: AppTheme.primaryOrange,
        foregroundColor: Colors.white,
      ),
      drawer: const AppDrawer(),
      body: _paymentMethods.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.credit_card_off,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No tienes métodos de pago registrados',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showAddPaymentDialog(),
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar método de pago'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryOrange,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              itemCount: _paymentMethods.length,
              itemBuilder: (context, index) {
                final method = _paymentMethods[index];
                return _PaymentCard(
                  method: method,
                  onDelete: () => _deletePaymentMethod(index),
                );
              },
            ),
      floatingActionButton: _paymentMethods.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => _showAddPaymentDialog(),
              backgroundColor: AppTheme.primaryOrange,
              icon: const Icon(Icons.add),
              label: const Text('Agregar método'),
            )
          : null,
    );
  }

  void _showAddPaymentDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) => SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingLg),
                const Text(
                  'Agregar método de pago',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppTheme.spacingLg),
                
                _PaymentOptionTile(
                  icon: Icons.credit_card,
                  title: 'Tarjeta de crédito/débito',
                  subtitle: 'Visa, Mastercard, American Express',
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Próximamente')),
                    );
                  },
                ),
                const SizedBox(height: AppTheme.spacingMd),
                _PaymentOptionTile(
                  icon: Icons.account_balance_wallet,
                  title: 'Yape',
                  subtitle: 'Pago con Yape del BCP',
                  color: const Color(0xFF6A1B9A),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Próximamente')),
                    );
                  },
                ),
                const SizedBox(height: AppTheme.spacingMd),
                _PaymentOptionTile(
                  icon: Icons.phone_android,
                  title: 'Plin',
                  subtitle: 'Pago con Plin interbancario',
                  color: const Color(0xFF00B0FF),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Próximamente')),
                    );
                  },
                ),
                const SizedBox(height: AppTheme.spacingMd),
                _PaymentOptionTile(
                  icon: Icons.money,
                  title: 'Efectivo',
                  subtitle: 'Paga al conductor al final del viaje',
                  color: AppTheme.secondaryGreen,
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Método de efectivo disponible por defecto')),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _deletePaymentMethod(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar método'),
        content: const Text('¿Estás seguro de que deseas eliminar este método de pago?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _paymentMethods.removeAt(index));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Método de pago eliminado')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

class PaymentMethod {
  final String type;
  final String last4;
  final String brand;
  final bool isDefault;

  PaymentMethod({
    required this.type,
    required this.last4,
    required this.brand,
    this.isDefault = false,
  });
}

class _PaymentCard extends StatelessWidget {
  final PaymentMethod method;
  final VoidCallback onDelete;

  const _PaymentCard({
    required this.method,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      child: ListTile(
        leading: Icon(
          _getIcon(),
          color: AppTheme.primaryOrange,
          size: 32,
        ),
        title: Text(method.brand),
        subtitle: Text('**** **** **** ${method.last4}'),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'default',
              child: Row(
                children: [
                  Icon(Icons.check_circle, size: 20),
                  SizedBox(width: 8),
                  Text('Predeterminada'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: AppTheme.error),
                  SizedBox(width: 8),
                  Text('Eliminar', style: TextStyle(color: AppTheme.error)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'delete') onDelete();
          },
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (method.type.toLowerCase()) {
      case 'yape':
        return Icons.account_balance_wallet;
      case 'plin':
        return Icons.phone_android;
      case 'cash':
        return Icons.money;
      default:
        return Icons.credit_card;
    }
  }
}

class _PaymentOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _PaymentOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.color = AppTheme.primaryOrange,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
