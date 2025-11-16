# Mobile App - TaxyTac

Aplicación móvil Flutter para TaxyTac - Plataforma de transporte en motos Bajaj.

## 🚀 Inicio Rápido

```bash
# Instalar dependencias
flutter pub get

# Ejecutar en modo desarrollo
flutter run

# Ejecutar tests
flutter test

# Build APK de producción
flutter build apk --release
```

## 📱 Features Implementadas

- ✅ Mapa interactivo con OpenStreetMap
- ✅ Envío de ubicación en tiempo real vía WebSocket
- ✅ Consulta de drivers cercanos
- ✅ UI Material Design 3

## 🔧 Configuración

### URLs del Backend

Edita `lib/main.dart` líneas 27-28 según tu entorno:

```dart
// Android emulator
static const String wsUrl = 'ws://10.0.2.2:8080/ws';
static const String apiUrl = 'http://10.0.2.2:8080/api';

// iOS simulator
static const String wsUrl = 'ws://localhost:8080/ws';
static const String apiUrl = 'http://localhost:8080/api';

// Dispositivo físico (reemplaza con tu IP)
static const String wsUrl = 'ws://192.168.1.100:8080/ws';
static const String apiUrl = 'http://192.168.1.100:8080/api';
```

**Encontrar tu IP local (Windows):**

```powershell
ipconfig | Select-String "IPv4"
```

## 📦 Dependencias Principales

- `flutter_map` - Mapas con OpenStreetMap/Mapbox
- `web_socket_channel` - Conexión WebSocket
- `http` - Cliente HTTP
- `latlong2` - Coordenadas geográficas
- `geolocator` - Servicios de ubicación
- `provider` - State management

## 🏗️ Arquitectura (Actual vs. Objetivo)

### Actual (MVP)
```
lib/
└── main.dart    # Todo en un archivo
```

### Objetivo (Producción)
```
lib/
├── main.dart
├── config/
│   ├── routes.dart
│   └── theme.dart
├── screens/
│   ├── home/
│   ├── trip/
│   └── profile/
├── widgets/
│   ├── map/
│   └── cards/
├── services/
│   ├── api_service.dart
│   ├── websocket_service.dart
│   └── location_service.dart
├── models/
│   ├── driver.dart
│   ├── trip.dart
│   └── user.dart
└── providers/
    ├── auth_provider.dart
    └── trip_provider.dart
```

## 🧪 Testing

```bash
# Ejecutar todos los tests
flutter test

# Con cobertura
flutter test --coverage

# Test específico
flutter test test/widget_test.dart
```

## 🐛 Troubleshooting

### Error: "Waiting for another flutter command to release the startup lock"

```powershell
Remove-Item "$env:USERPROFILE\AppData\Local\Temp\flutter_tools_lock" -Force
```

### Error: "Unable to connect to WebSocket"

1. Verifica la URL en `lib/main.dart`
2. Asegúrate de que el backend esté corriendo: `docker-compose ps`
3. En dispositivo físico, usa tu IP local (no localhost)

### Hot reload no funciona

```bash
# Hot restart completo
Presiona 'R' (shift + r)

# O reinicia la app
flutter run
```

## 📱 Permisos (Futuros)

### Android (`android/app/src/main/AndroidManifest.xml`)
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
```

### iOS (`ios/Runner/Info.plist`)
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Necesitamos tu ubicación para mostrarte drivers cercanos</string>
```

## 🎨 Personalización

### Cambiar tema
Edita `lib/main.dart`:

```dart
theme: ThemeData(
  primarySwatch: Colors.orange,  // Color principal
  useMaterial3: true,
),
```

### Cambiar proveedor de mapas
Reemplaza `TileLayer` en `lib/main.dart`:

```dart
// Mapbox
TileLayer(
  urlTemplate: 'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
  additionalOptions: {
    'accessToken': 'TU_MAPBOX_TOKEN',
    'id': 'mapbox/streets-v11',
  },
)
```

## 📚 Recursos

- [Flutter Docs](https://docs.flutter.dev/)
- [flutter_map Docs](https://docs.fleaflet.dev/)
- [Material Design 3](https://m3.material.io/)

## 🔜 Próximos Features

- [ ] State management con Provider/Riverpod
- [ ] Autenticación JWT
- [ ] Notificaciones push (FCM)
- [ ] Tracking de viaje en tiempo real
- [ ] Perfil de usuario
- [ ] Historial de viajes
- [ ] Sistema de ratings
- [ ] Chat driver-rider
- [ ] Pagos in-app

---

**Versión**: 0.1.0  
**Flutter**: 3.10+  
**Dart**: 3.0+
