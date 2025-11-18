import 'package:flutter_test/flutter_test.dart';
import 'package:taxytac/core/utils/validators.dart';

void main() {
  group('Email Validator Tests', () {
    test('Valid email should return null', () {
      expect(Validators.validateEmail('test@example.com'), null);
      expect(Validators.validateEmail('user.name+tag@domain.co.uk'), null);
    });

    test('Empty email should return error', () {
      expect(Validators.validateEmail(''), isNotNull);
      expect(Validators.validateEmail(null), isNotNull);
    });

    test('Invalid email format should return error', () {
      expect(Validators.validateEmail('invalidemail'), isNotNull);
      expect(Validators.validateEmail('@example.com'), isNotNull);
      expect(Validators.validateEmail('test@'), isNotNull);
    });
  });

  group('Password Validator Tests', () {
    test('Valid password should return null', () {
      expect(Validators.validatePassword('password123'), null);
      expect(Validators.validatePassword('StrongP@ss!'), null);
    });

    test('Empty password should return error', () {
      expect(Validators.validatePassword(''), isNotNull);
      expect(Validators.validatePassword(null), isNotNull);
    });

    test('Short password should return error', () {
      expect(Validators.validatePassword('12345'), isNotNull);
      expect(Validators.validatePassword('abc'), isNotNull);
    });

    test('Long password should return error', () {
      final longPassword = 'a' * 51;
      expect(Validators.validatePassword(longPassword), isNotNull);
    });
  });

  group('Phone Validator Tests', () {
    test('Valid phone should return null', () {
      expect(Validators.validatePhone('987654321'), null);
      expect(Validators.validatePhone('912345678'), null);
    });

    test('Empty phone should return error', () {
      expect(Validators.validatePhone(''), isNotNull);
      expect(Validators.validatePhone(null), isNotNull);
    });

    test('Invalid phone format should return error', () {
      expect(Validators.validatePhone('12345'), isNotNull);
      expect(Validators.validatePhone('98765432'), isNotNull);
      expect(Validators.validatePhone('9876543210'), isNotNull);
      expect(Validators.validatePhone('abcdefghi'), isNotNull);
    });
  });

  group('Formatters Tests', () {
    test('Currency formatter should format correctly', () {
      expect(Formatters.formatCurrency(10.50), 'S/ 10.50');
      expect(Formatters.formatCurrency(0), 'S/ 0.00');
      expect(Formatters.formatCurrency(1234.56), 'S/ 1,234.56');
    });

    test('Distance formatter should format correctly', () {
      expect(Formatters.formatDistance(500), '500 m');
      expect(Formatters.formatDistance(1000), '1.0 km');
      expect(Formatters.formatDistance(2500), '2.5 km');
    });

    test('Duration formatter should format correctly', () {
      expect(Formatters.formatDuration(30), '30 min');
      expect(Formatters.formatDuration(60), '1h 0min');
      expect(Formatters.formatDuration(90), '1h 30min');
    });

    test('Rating formatter should format correctly', () {
      expect(Formatters.formatRating(4.5), '4.5');
      expect(Formatters.formatRating(5.0), '5.0');
      expect(Formatters.formatRating(3.75), '3.8');
    });
  });
}
