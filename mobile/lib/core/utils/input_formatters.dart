import 'package:flutter/services.dart';

/// Formatter para teléfonos peruanos (9 dígitos)
class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'\D'), '');
    
    if (text.length > 9) {
      return oldValue;
    }
    
    String formatted = '';
    if (text.isNotEmpty) {
      if (text.length <= 3) {
        formatted = text;
      } else if (text.length <= 6) {
        formatted = '${text.substring(0, 3)} ${text.substring(3)}';
      } else {
        formatted = '${text.substring(0, 3)} ${text.substring(3, 6)} ${text.substring(6)}';
      }
    }
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Formatter para placas de vehículos peruanos (ABC-123)
class PlateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    
    if (text.length > 6) {
      return oldValue;
    }
    
    String formatted = '';
    if (text.isNotEmpty) {
      if (text.length <= 3) {
        formatted = text;
      } else {
        formatted = '${text.substring(0, 3)}-${text.substring(3)}';
      }
    }
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Formatter para montos de dinero
class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'[^\d.]'), '');
    
    // Permitir solo un punto decimal
    final parts = text.split('.');
    if (parts.length > 2) {
      return oldValue;
    }
    
    // Limitar decimales a 2 dígitos
    if (parts.length == 2 && parts[1].length > 2) {
      return oldValue;
    }
    
    return newValue.copyWith(text: text);
  }
}
