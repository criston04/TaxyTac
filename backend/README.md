# Backend - TaxyTac API

Backend en Go para TaxyTac - Sistema de gestión de viajes en motos.

## 🚀 Inicio Rápido

### Con Docker (recomendado)

```bash
# Desde la raíz del proyecto
docker-compose up -d backend
docker-compose logs -f backend
```

### Sin Docker (desarrollo local)

```bash
cd backend

# Instalar dependencias
go mod download

# Configurar variables de entorno
cp .env.example .env
# Editar .env con tus valores

# Ejecutar
go run cmd/main.go

# O compilar y ejecutar
go build -o taxytac ./cmd
./taxytac
```

## 📡 API Endpoints

### Health Check
```bash
GET /health
```

### Autenticación

#### Registrar Usuario
```bash
POST /api/auth/register
Content-Type: application/json

{
  "name": "Juan Pérez",
  "phone": "+51987654321",
  "email": "juan@example.com",
  "role": "rider"  # o "driver"
}

Response 201:
{
  "id": "uuid",
  "name": "Juan Pérez",
  "role": "rider"
}
```

#### Login
```bash
POST /api/auth/login
Content-Type: application/json

{
  "phone": "+51987654321",
  "otp": "123456"
}

Response 200:
{
  "token": "jwt.token.here",
  "refresh_token": "refresh.token.here",
  "expires_in": 900
}
```

### Drivers

#### Buscar Drivers Cercanos
```bash
GET /api/drivers/nearby?lat=-12.0464&lng=-77.0428&radius=1000

Response 200:
{
  "drivers": [
    {
      "driver_id": "uuid",
      "user_id": "uuid",
      "distance_m": 120.5,
      "lat": -12.0464,
      "lng": -77.0428
    }
  ],
  "count": 1
}
```

### Trips

#### Crear Viaje
```bash
POST /api/trips
Content-Type: application/json

{
  "rider_id": "uuid",
  "origin_lat": -12.0464,
  "origin_lng": -77.0428,
  "dest_lat": -12.0500,
  "dest_lng": -77.0400
}

Response 201:
{
  "trip_id": "uuid",
  "status": "requested"
}
```

#### Aceptar Viaje
```bash
PATCH /api/trips/{trip_id}/accept
Content-Type: application/json

{
  "driver_id": "uuid"
}

Response 200:
{
  "trip_id": "uuid",
  "status": "accepted"
}
```

#### Iniciar Viaje
```bash
PATCH /api/trips/{trip_id}/start

Response 200:
{
  "trip_id": "uuid",
  "status": "started"
}
```

#### Finalizar Viaje
```bash
PATCH /api/trips/{trip_id}/end

Response 200:
{
  "trip_id": "uuid",
  "status": "completed"
}
```

### WebSocket - Ubicación en Tiempo Real

```bash
# Conectar
ws://localhost:8080/ws

# Enviar ubicación (cada 3-5 segundos)
{
  "driver_id": "uuid",
  "lat": -12.0464,
  "lng": -77.0428,
  "ts": 1699876543210,
  "speed": 15.5,
  "heading": 180.0
}

# Respuesta (ACK)
{
  "status": "ok",
  "ts": 1699876543
}
```

## 🗄️ Base de Datos

### Migraciones

```bash
# Ejecutar migración inicial
docker exec -i taxytac-db psql -U postgres -d taxytac < migrations/001_init.sql

# Conectar a DB
docker exec -it taxytac-db psql -U postgres -d taxytac

# Ver tablas
\dt

# Ver índices
\di
```

### Esquema Principal

```sql
-- Usuarios (riders y drivers)
users (id, name, phone, email, role, created_at)

-- Información de drivers
drivers (id, user_id, status, rating, total_trips)

-- Vehículos
vehicles (id, driver_id, make, model, plate, photos)

-- Ubicaciones (snapshots + índice geoespacial)
locations (id, driver_id, geom, speed, heading, ts)

-- Viajes
trips (id, rider_id, driver_id, origin, destination, price, status, timestamps)

-- Pagos
payments (id, trip_id, amount, provider, status)
```

### Consultas Útiles

```sql
-- Drivers disponibles
SELECT * FROM drivers WHERE status = 'available';

-- Drivers cercanos (PostGIS)
SELECT 
  d.id,
  ST_Distance(
    l.geom, 
    ST_GeogFromText('SRID=4326;POINT(-77.0428 -12.0464)')
  ) AS distance_m
FROM drivers d
JOIN locations l ON l.driver_id = d.id
WHERE 
  d.status = 'available'
  AND l.ts > now() - INTERVAL '15 seconds'
ORDER BY distance_m
LIMIT 10;

-- Viajes activos
SELECT * FROM trips WHERE status IN ('requested', 'accepted', 'started');

-- Estadísticas por driver
SELECT 
  d.id,
  COUNT(t.id) AS total_trips,
  AVG(t.price) AS avg_price
FROM drivers d
LEFT JOIN trips t ON t.driver_id = d.id
GROUP BY d.id;
```

## 🏗️ Arquitectura

```
cmd/
└── main.go              # Entry point, config, graceful shutdown

internal/
└── server/
    ├── server.go        # Setup Gin, rutas, DB/Redis connections
    └── handlers.go      # Handlers de endpoints

migrations/
└── 001_init.sql         # Schema inicial + índices PostGIS
```

## 🧪 Testing

```bash
# Ejecutar tests
go test ./...

# Con cobertura
go test ./... -coverprofile=coverage.out
go tool cover -html=coverage.out

# Benchmarks
go test -bench=.

# Tests específicos
go test -v ./internal/server -run TestGetDriversNearby
```

## 🔧 Variables de Entorno

```bash
# .env
DATABASE_URL=postgres://postgres:postgres@localhost:5432/taxytac?sslmode=disable
REDIS_URL=localhost:6379
JWT_SECRET=your-secret-here
PORT=8080
LOG_LEVEL=info
```

## 📊 Logging

Logs en formato JSON (structured logging):

```json
{
  "level": "info",
  "msg": "location received",
  "driver": "uuid",
  "lat": -12.0464,
  "lng": -77.0428,
  "time": "2024-11-15T10:30:00Z"
}
```

## 🐛 Troubleshooting

### Error: "failed to connect to database"

```bash
# Verificar que Postgres esté corriendo
docker-compose ps db

# Ver logs de DB
docker-compose logs db

# Reintentar conexión
docker-compose restart db backend
```

### Error: "bind: address already in use"

```bash
# Puerto 8080 ocupado, cambiar en .env:
PORT=8081

# O matar proceso en puerto 8080 (Windows)
netstat -ano | findstr :8080
taskkill /PID <PID> /F
```

## 🚀 Deployment

### Build para producción

```bash
# Build binario optimizado
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o taxytac ./cmd

# Build imagen Docker
docker build -t taxytac-backend:v1.0.0 .

# Push a registry
docker tag taxytac-backend:v1.0.0 registry.example.com/taxytac-backend:v1.0.0
docker push registry.example.com/taxytac-backend:v1.0.0
```

## 🔜 Próximos Features

- [ ] Autenticación JWT completa + refresh tokens
- [ ] Rate limiting por IP
- [ ] Middleware de logging y tracing
- [ ] Algoritmo de matching avanzado
- [ ] Circuit breakers para servicios externos
- [ ] Integración con Stripe/MercadoPago
- [ ] Notificaciones push (FCM)
- [ ] Webhooks para eventos de viajes
- [ ] Admin API para panel de control

## 📚 Dependencias

- `gin-gonic/gin` - HTTP framework
- `jackc/pgx/v5` - PostgreSQL driver
- `go-redis/redis/v8` - Redis client
- `gorilla/websocket` - WebSocket
- `sirupsen/logrus` - Logging estructurado
- `golang-jwt/jwt` - JWT tokens
- `google/uuid` - UUID generation

---

**Versión**: 0.1.0  
**Go**: 1.21+  
**PostgreSQL**: 14+ con PostGIS
