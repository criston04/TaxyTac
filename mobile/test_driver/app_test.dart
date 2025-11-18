import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('TaxyTac Integration Tests', () {
    late FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      await driver.close();
    });

    test('Login flow should work correctly', () async {
      // Esperar a que aparezca la pantalla de login
      await driver.waitFor(find.text('Bienvenido a TaxyTac'));

      // Ingresar email
      await driver.tap(find.byValueKey('email_field'));
      await driver.enterText('test@example.com');

      // Ingresar password
      await driver.tap(find.byValueKey('password_field'));
      await driver.enterText('password123');

      // Tap en botón de login
      await driver.tap(find.text('Iniciar Sesión'));

      // Verificar navegación a mode selection
      await driver.waitFor(find.text('Selecciona tu modo'));
    });

    test('Mode selection should navigate correctly', () async {
      // Tap en modo pasajero
      await driver.tap(find.text('Pasajero'));

      // Verificar navegación a pantalla de pasajero
      await driver.waitFor(find.text('Buscar Viaje'));
    });
  });
}
