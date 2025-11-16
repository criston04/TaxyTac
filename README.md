# TaxyTac — Boilerplate MVP (Go backend + Flutter mobile)

Este repositorio contiene un boilerplate inicial para una app tipo Uber para motos (moto bajaj): backend en Go (Gin), Postgres+PostGIS, Redis, broker MQTT (EMQX), y una app Flutter mínima.

> **📖 ¿Primera vez aquí?** Comienza con **[QUICKSTART.md](QUICKSTART.md)** para setup en < 10 minutos  
> **📚 Buscar algo específico?** Ver **[INDEX.md](INDEX.md)** - Índice completo de documentación

## 📦 Contenido

- **`/backend`**: Servicio en Go con endpoints REST y WebSocket para location updates
- **`/mobile`**: App Flutter que envía ubicación y consulta drivers cercanos
- **`docker-compose.yml`**: Stack completo (Postgres+PostGIS, Redis, EMQX, backend)
- **`/backend/migrations`**: Migraciones SQL con PostGIS
- **`.github/workflows`**: CI básico para Go y Flutter

## 🚀 Stack Tecnológico

### Backend
- **Go 1.21** con Gin (HTTP framework)
- **PostgreSQL 14** + PostGIS (queries geoespaciales)
- **Redis** (cache, pub/sub, locks)
- **EMQX** (broker MQTT para telemetría masiva)
- **WebSocket** para ubicación en tiempo real

### Mobile
- **Flutter 3.10+** (single codebase para Android/iOS)
- **flutter_map** (mapas con OpenStreetMap)
- **web_socket_channel** (conexión realtime)

### Infraestructura
- **Docker Compose** para desarrollo local
- **GitHub Actions** para CI/CD
- **Kubernetes-ready** (Dockerfile multi-stage)

## 🏃 Inicio Rápido

### Prerequisitos
- Docker & Docker Compose
- Go 1.21+ (para desarrollo local)
- Flutter 3.10+ (para la app móvil)

### 1. Levantar servicios con Docker Compose

```bash
# Clonar repo y entrar
cd TaxyTac

# Copiar variables de entorno
cp backend/.env.example backend/.env

# Iniciar todos los servicios
docker-compose up -d

# Ver logs
docker-compose logs -f backend
```

Servicios disponibles:
- **Backend API**: http://localhost:8080
- **PostgreSQL**: localhost:5432
- **Redis**: localhost:6379
- **EMQX Dashboard**: http://localhost:18083 (user: admin, pass: public)
- **MQTT WebSocket**: ws://localhost:8083/mqtt

### 2. Ejecutar migraciones

```bash
# Conectar a la base de datos
docker exec -it taxytac-db-1 psql -U postgres -d taxytac

# Ejecutar migración (dentro de psql)
\i /migrations/001_init.sql

# Verificar tablas creadas
\dt
```

O usando el script:

```bash
docker exec -i taxytac-db-1 psql -U postgres -d taxytac < backend/migrations/001_init.sql
```

### 3. Ejecutar app Flutter

```bash
cd mobile

# Instalar dependencias
flutter pub get

# Ejecutar en emulador/dispositivo
flutter run

# O para web (desarrollo)
flutter run -d chrome
```

**Nota**: Ajusta la URL del WebSocket en `mobile/lib/main.dart` según tu entorno:
- Emulador Android: `ws://10.0.2.2:8080/ws`
- iOS Simulator: `ws://localhost:8080/ws`
- Dispositivo físico: `ws://TU_IP_LOCAL:8080/ws`

## 📡 API Endpoints

### Autenticación
- `POST /api/auth/register` - Registrar usuario/driver
- `POST /api/auth/login` - Login (retorna JWT token)

### Drivers
- `GET /api/drivers/nearby?lat={lat}&lng={lng}&radius={meters}` - Buscar drivers cercanos

### Viajes (Trips)
- `POST /api/trips` - Crear solicitud de viaje
- `PATCH /api/trips/:id/accept` - Aceptar viaje (driver)
- `PATCH /api/trips/:id/start` - Iniciar viaje
- `PATCH /api/trips/:id/end` - Finalizar viaje

### WebSocket
- `GET /ws` - Conexión WebSocket para enviar ubicaciones en tiempo real

#### Formato de mensaje (location update)
```json
{
  "driver_id": "uuid-driver",
  "lat": -12.0464,
  "lng": -77.0428,
  "ts": 1699876543210,
  "speed": 15.5,
  "heading": 180.0
}
```

## 🗄️ Esquema de Base de Datos

### Tablas principales

- **`users`**: Usuarios (riders y drivers)
- **`drivers`**: Información específica de conductores
- **`vehicles`**: Vehículos (motos)
- **`locations`**: Snapshots de ubicación (con índice GiST geoespacial)
- **`trips`**: Viajes solicitados/completados
- **`payments`**: Registros de pago (pendiente de implementar)

### Consultas geoespaciales (PostGIS)

Ejemplo para encontrar drivers cercanos:

```sql
SELECT 
  driver_id, 
  ST_Distance(geom, ST_GeogFromText('SRID=4326;POINT(-77.0428 -12.0464)')) AS distance_m
FROM locations
WHERE ts > now() - INTERVAL '15 seconds'
ORDER BY geom <-> ST_GeogFromText('SRID=4326;POINT(-77.0428 -12.0464)')
LIMIT 20;
```

## 🛠️ Desarrollo Local (sin Docker)

### Backend

```bash
cd backend

# Instalar dependencias
go mod download

# Configurar variables de entorno
export DATABASE_URL="postgres://postgres:postgres@localhost:5432/taxytac?sslmode=disable"
export REDIS_URL="localhost:6379"
export JWT_SECRET="your-secret-here"

# Ejecutar
go run cmd/main.go
```

### Mobile

```bash
cd mobile
flutter pub get
flutter run
```

## 🧪 Tests

```bash
# Backend (placeholder)
cd backend
go test ./... -v

# Mobile
cd mobile
flutter test
```

## 📋 Próximos Pasos (Roadmap)

### MVP (2-3 meses)
- [x] Boilerplate backend + mobile
- [ ] Autenticación JWT completa
- [ ] Matching algorithm básico (nearest driver)
- [ ] Integración de pagos (Stripe/MercadoPago)
- [ ] Notificaciones push (FCM)
- [ ] Panel admin básico

### Producción (6-12 meses)
- [ ] Migrar a microservicios
- [ ] Kafka para event streaming
- [ ] ML para pricing dinámico
- [ ] Data warehouse (BigQuery/Redshift)
- [ ] Kubernetes + Helm charts
- [ ] Observabilidad completa (Prometheus, Grafana, Jaeger)
- [ ] Rate limiting y circuit breakers
- [ ] Tests E2E y carga

## 🏗️ Arquitectura

Ver [ARCHITECTURE.md](ARCHITECTURE.md) para detalles completos.

### Flujo básico

```
[App Flutter] --WebSocket--> [Backend Go] --PostgreSQL--> [PostGIS queries]
                                  |
                                  +--> [Redis] (cache, locks)
                                  |
                                  +--> [EMQX] (pub/sub MQTT)
```

## 🔒 Seguridad

- [ ] Implementar JWT con refresh tokens
- [ ] Validación de inputs
- [ ] Rate limiting por IP
- [ ] HTTPS/TLS en producción
- [ ] Secrets management (Vault/AWS KMS)
- [ ] Verificación KYC para drivers

## 📄 Licencia

MIT License - ver [LICENSE](LICENSE)

## 🤝 Contribuir

1. Fork el proyecto
2. Crea tu feature branch (`git checkout -b feat/amazing-feature`)
3. Commit tus cambios (`git commit -m 'feat: add amazing feature'`)
4. Push a la rama (`git push origin feat/amazing-feature`)
5. Abre un Pull Request

## 📞 Soporte

Para preguntas o issues, abre un [GitHub Issue](https://github.com/criston04/TaxyTac/issues).

---

**Hecho con ❤️ para motos Bajaj** 🏍️
