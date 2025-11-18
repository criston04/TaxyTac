# Arquitectura del Proyecto TaxyTac Mobile

## 📁 Estructura de Carpetas

```
lib/
├── core/                          # Funcionalidades compartidas
│   ├── constants/                 # Constantes de la aplicación
│   │   └── app_constants.dart     # URLs, timeouts, configuración
│   ├── errors/                    # Manejo de errores
│   │   ├── exceptions.dart        # Excepciones personalizadas
│   │   └── failures.dart          # Failures para Either pattern
│   ├── network/                   # Configuración de red
│   │   ├── dio_client.dart        # Cliente HTTP Dio configurado
│   │   └── interceptors/          # Interceptores de Dio
│   │       ├── auth_interceptor.dart      # Agrega token JWT
│   │       ├── logging_interceptor.dart   # Logs de requests
│   │       └── error_interceptor.dart     # Manejo de errores HTTP
│   ├── theme/                     # Sistema de theming
│   │   └── app_theme.dart         # Colores, espaciado, temas
│   ├── utils/                     # Utilidades
│   │   ├── logger.dart            # Logger wrapper
│   │   └── validators.dart        # Validadores y formatters
│   └── widgets/                   # Widgets reutilizables
│       ├── buttons.dart           # PrimaryButton, SecondaryButton
│       ├── shimmer_loading.dart   # Skeleton screens
│       └── states.dart            # EmptyState, ErrorState, LoadingState
│
├── features/                      # Features de la app
│   └── auth/                      # Feature de autenticación
│       ├── data/                  # Capa de datos (repositorios)
│       ├── domain/                # Capa de dominio (entidades, casos de uso)
│       │   └── auth_state.dart    # Estado de autenticación
│       └── presentation/          # Capa de presentación (UI)
│           └── providers/
│               └── auth_provider.dart  # Riverpod provider
│
├── models/                        # Modelos legacy (migrar a features)
│   └── trip.dart
│
├── screens/                       # Pantallas legacy (migrar a features)
│   ├── driver_screen.dart
│   ├── login_screen.dart
│   ├── mode_selection_screen.dart
│   └── passenger_screen.dart
│
├── services/                      # Servicios legacy (migrar a features)
│   ├── api_service.dart
│   ├── auth_service.dart
│   ├── geo_service.dart
│   └── location_service.dart
│
└── main.dart                      # Entry point con ProviderScope
```

## 🏗️ Arquitectura Clean Architecture

### Capas:

1. **Presentation Layer** (UI)
   - Widgets y Screens
   - Providers de Riverpod
   - Maneja el estado de la UI

2. **Domain Layer** (Lógica de negocio)
   - Entidades
   - Casos de uso (use cases)
   - Interfaces de repositorios

3. **Data Layer** (Acceso a datos)
   - Implementaciones de repositorios
   - Data sources (API, local storage)
   - Mappers de DTO a entidades

## 🔧 Tecnologías

### State Management
- **Riverpod 2.6.1**: State management moderno y testeable
- Provider pattern con StateNotifier

### Networking
- **Dio 5.9.0**: Cliente HTTP profesional
- Interceptores para auth, logging y errores
- Retry automático y timeout configurables

### Storage
- **flutter_secure_storage**: Almacenamiento encriptado para tokens
- **shared_preferences**: Preferencias del usuario

### UI/UX
- **shimmer**: Skeleton screens durante carga
- **lottie**: Animaciones complejas
- **google_fonts**: Tipografía profesional
- **cached_network_image**: Caché de imágenes

### Code Generation
- **freezed**: Modelos inmutables con copyWith
- **json_serializable**: Serialización JSON
- **build_runner**: Generación de código

### Navigation
- **go_router**: Routing declarativo (próximamente)

### Testing
- **mockito**: Mocking para unit tests
- **integration_test**: Tests de integración

## 🚀 Mejoras Implementadas

### 1. Sistema de Theme Profesional
- Paleta de colores consistente
- Espaciado estandarizado (xs, sm, md, lg, xl, 2xl)
- Border radius configurables
- Soporte para modo claro/oscuro

### 2. Manejo Robusto de Errores
- Excepciones tipadas (NetworkException, AuthException, etc.)
- Interceptor de errores HTTP con mensajes amigables
- Logging centralizado con categorías

### 3. Loading States
- Shimmer loading para mejor UX
- Estados de vacío y error con ilustraciones
- Indicadores de carga contextuales

### 4. Networking Profesional
- Cliente Dio con configuración centralizada
- Auth interceptor que agrega JWT automáticamente
- Logging interceptor para debugging
- Error interceptor que convierte errores HTTP en excepciones tipadas
- Timeouts configurables

### 5. Validaciones y Formatters
- Validadores de email, password, nombre, teléfono
- Formatters de moneda, distancia, duración, ratings
- Mensajes de error en español

## 📝 Próximos Pasos

### Alta Prioridad
- [ ] Migrar screens a features con Clean Architecture
- [ ] Implementar go_router para navegación declarativa
- [ ] Migrar api_service.dart a usar Dio
- [ ] Crear providers de Riverpod para trips y drivers
- [ ] Implementar testing suite

### Media Prioridad
- [ ] Agregar animaciones Lottie en estados de carga
- [ ] Implementar pull-to-refresh
- [ ] Agregar soporte para dark mode completo
- [ ] Crear componentes de UI reutilizables

### Baja Prioridad
- [ ] Internacionalización (i18n)
- [ ] Analytics y crash reporting
- [ ] Optimización de rendimiento
- [ ] Documentación de componentes

## 🧪 Testing

```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 🔨 Code Generation

```bash
# Generar código Freezed y JSON
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode durante desarrollo
flutter pub run build_runner watch
```

## 📚 Recursos

- [Riverpod Docs](https://riverpod.dev/)
- [Dio Package](https://pub.dev/packages/dio)
- [Flutter Clean Architecture](https://resocoder.com/flutter-clean-architecture-tdd/)
- [Material Design 3](https://m3.material.io/)
