# TaxyTac — Arquitectura del Sistema

## 📐 Visión General

TaxyTac es una plataforma tipo Uber diseñada específicamente para motos (moto bajaj). Este documento describe la arquitectura del sistema, desde el MVP hasta la escalabilidad de producción.

## 🎯 Objetivos Arquitectónicos

1. **Baja latencia**: Matching de drivers en <500ms
2. **Alta disponibilidad**: 99.9% uptime
3. **Escalabilidad horizontal**: Soportar millones de viajes/día
4. **Geoespacial eficiente**: Queries de proximidad optimizadas
5. **Realtime**: Tracking de ubicación en tiempo real (<5s delay)

## 🏛️ Stack Tecnológico

### Frontend/Mobile
- **Flutter 3.10+**: Single codebase para Android/iOS
- **flutter_map**: Mapas con OpenStreetMap/Mapbox
- **web_socket_channel**: Conexión WebSocket persistente
- **Provider/Riverpod**: State management

### Backend
- **Go 1.21**: Alto rendimiento, concurrencia nativa
- **Gin**: HTTP router/framework
- **PostgreSQL 14 + PostGIS**: Base de datos relacional con soporte geoespacial
- **Redis 7**: Cache, pub/sub, distributed locks
- **EMQX 5**: Broker MQTT para telemetría masiva

### Infraestructura (Producción)
- **Kubernetes (EKS/GKE/AKS)**: Orquestación de contenedores
- **Helm**: Package manager para K8s
- **Terraform**: Infrastructure as Code
- **GitHub Actions**: CI/CD
- **Prometheus + Grafana**: Métricas y monitoreo
- **Jaeger**: Distributed tracing
- **ELK Stack**: Logs centralizados

## 🔄 Arquitectura de Alto Nivel (MVP → Producción)

### Fase 1: MVP (Monolito Modular)

```
┌─────────────────┐
│   Flutter App   │
│  (Android/iOS)  │
└────────┬────────┘
         │ HTTP REST + WebSocket
         ▼
┌─────────────────┐
│   Go Backend    │
│   (Monolito)    │
│                 │
│  - Auth         │
│  - Trips        │
│  - Matching     │
│  - Payments     │
└─────┬───┬───┬───┘
      │   │   │
      ▼   ▼   ▼
   ┌────┐┌────┐┌──────┐
   │ PG ││Redis││EMQX │
   └────┘└────┘└──────┘
```

### Fase 2: Microservicios (Producción)

```
                    ┌──────────────┐
                    │ API Gateway  │
                    │  (Kong/NGINX)│
                    └──────┬───────┘
                           │
         ┌─────────────────┼─────────────────┐
         │                 │                 │
         ▼                 ▼                 ▼
   ┌──────────┐     ┌──────────┐     ┌──────────┐
   │  Auth    │     │  Trips   │     │ Matching │
   │ Service  │     │ Service  │     │ Service  │
   └──────────┘     └──────────┘     └──────────┘
         │                 │                 │
         └─────────────────┼─────────────────┘
                           │
                     ┌─────▼──────┐
                     │   Kafka    │
                     │ Event Bus  │
                     └─────┬──────┘
                           │
         ┌─────────────────┼─────────────────┐
         ▼                 ▼                 ▼
   ┌──────────┐     ┌──────────┐     ┌──────────┐
   │Payments  │     │Analytics │     │  Notif.  │
   │ Service  │     │ Service  │     │ Service  │
   └──────────┘     └──────────┘     └──────────┘
```

## 📊 Modelo de Datos (PostgreSQL + PostGIS)

### Entidades Principales

```sql
-- Users (riders y drivers)
users (
  id UUID PRIMARY KEY,
  name TEXT,
  phone TEXT UNIQUE,
  email TEXT,
  role TEXT, -- 'rider' | 'driver'
  created_at TIMESTAMPTZ
)

-- Drivers
drivers (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES users(id),
  status TEXT, -- 'offline' | 'available' | 'busy'
  rating NUMERIC,
  total_trips INTEGER
)

-- Vehicles
vehicles (
  id UUID PRIMARY KEY,
  driver_id UUID REFERENCES drivers(id),
  make TEXT, -- 'Bajaj'
  model TEXT,
  plate TEXT UNIQUE,
  year INTEGER,
  photos JSONB
)

-- Locations (snapshots + realtime cache)
locations (
  id BIGSERIAL PRIMARY KEY,
  driver_id UUID REFERENCES drivers(id),
  geom geography(Point, 4326), -- PostGIS
  speed NUMERIC,
  heading NUMERIC,
  ts TIMESTAMPTZ
)
CREATE INDEX idx_locations_geom ON locations USING GIST (geom);

-- Trips
trips (
  id UUID PRIMARY KEY,
  rider_id UUID REFERENCES users(id),
  driver_id UUID REFERENCES drivers(id),
  origin geography(Point, 4326),
  destination geography(Point, 4326),
  price NUMERIC,
  status TEXT, -- 'requested' | 'accepted' | 'started' | 'completed' | 'cancelled'
  started_at TIMESTAMPTZ,
  ended_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ
)

-- Payments
payments (
  id UUID PRIMARY KEY,
  trip_id UUID REFERENCES trips(id),
  amount NUMERIC,
  provider TEXT, -- 'stripe' | 'mercadopago' | 'cash'
  status TEXT, -- 'pending' | 'completed' | 'failed'
  provider_tx TEXT,
  created_at TIMESTAMPTZ
)
```

### Índices Críticos

```sql
-- Geoespacial (kNN queries)
CREATE INDEX idx_locations_geom ON locations USING GIST (geom);

-- Búsqueda de drivers disponibles
CREATE INDEX idx_drivers_status ON drivers(status) WHERE status = 'available';

-- Trips por usuario
CREATE INDEX idx_trips_rider ON trips(rider_id, created_at DESC);
CREATE INDEX idx_trips_driver ON trips(driver_id, created_at DESC);
```

## 🔄 Flujos Críticos

### 1. Solicitud de Viaje (Trip Request)

```
[Rider App] → POST /api/trips {origin, destination}
                ↓
         [Trips Service]
                ↓
    Query available drivers (PostGIS)
                ↓
         [Matching Service]
                ↓
    Select best driver (distance, rating, ETA)
                ↓
    Lock driver (Redis SETNX)
                ↓
    Send push notification (FCM)
                ↓
         [Driver App] → Accept/Reject
```

### Query PostGIS para drivers cercanos

```sql
SELECT 
  d.id,
  d.user_id,
  ST_Distance(l.geom, ST_GeogFromText('SRID=4326;POINT(:lng :lat)')) AS distance_m
FROM drivers d
JOIN locations l ON l.driver_id = d.id
WHERE 
  d.status = 'available'
  AND l.ts > now() - INTERVAL '15 seconds'
  AND ST_DWithin(
    l.geom, 
    ST_GeogFromText('SRID=4326;POINT(:lng :lat)'),
    :radius_meters
  )
ORDER BY distance_m ASC
LIMIT 20;
```

### 2. Tracking en Tiempo Real

```
[Driver App] → WebSocket /ws
                ↓
    Send location every 3-5s
    {driver_id, lat, lng, ts, speed, heading}
                ↓
         [Backend WS Handler]
                ↓
    Publish to Redis (pub/sub channel "locations")
                ↓
    Async persist snapshot to PostgreSQL
                ↓
         [Rider App] ← Subscribe to driver location
```

### Optimizaciones de Telemetría

- **Frecuencia adaptativa**: 3s durante viaje, 30s en reposo
- **Compresión**: Enviar diffs en lugar de posiciones absolutas
- **Batching**: Agrupar múltiples ubicaciones en un solo mensaje
- **TTL en Redis**: Expirar ubicaciones >30s

### 3. Matching Algorithm (Básico → Avanzado)

#### MVP: Nearest Available Driver

```go
func FindNearestDriver(origin Point, radius float64) (*Driver, error) {
    // 1. Query PostGIS (drivers within radius)
    drivers := queryNearbyDrivers(origin, radius)
    
    // 2. Filter by availability (Redis cache)
    available := filterAvailable(drivers)
    
    // 3. Sort by distance
    sort.Slice(available, func(i, j int) bool {
        return available[i].Distance < available[j].Distance
    })
    
    // 4. Try to lock first driver
    for _, driver := range available {
        if redis.SetNX("lock:driver:"+driver.ID, "locked", 30*time.Second) {
            return driver, nil
        }
    }
    
    return nil, ErrNoDriverAvailable
}
```

#### Producción: ML-based Scoring

```
score = w1 * (1 / distance) 
      + w2 * driver_rating 
      + w3 * (1 / estimated_time_arrival)
      + w4 * acceptance_rate
      - w5 * surge_multiplier
```

## 🚀 Escalabilidad

### Horizontal Scaling

| Componente | Estrategia |
|------------|-----------|
| **Backend** | Stateless pods en K8s, autoscaling por CPU/memoria |
| **PostgreSQL** | Read replicas + Patroni/PgBouncer |
| **Redis** | Redis Cluster (sharding) |
| **EMQX** | Cluster mode (3+ nodes) |
| **Kafka** | Partitioning por `driver_id` o `trip_id` |

### Caching Strategy

```
┌────────────┐
│   Redis    │
│            │
│ - Sessions │
│ - Drivers  │ ← TTL: 15s
│ - Locks    │ ← TTL: 30s
│ - Rate     │
│   Limits   │
└────────────┘
```

### Database Sharding (Futuro)

- **Shard key**: `user_id` (hash-based)
- **Tables sharded**: `trips`, `payments`
- **Tables replicated**: `users`, `drivers` (read-heavy)

## 🔐 Seguridad

### Autenticación y Autorización

```
[App] → POST /auth/login {phone, otp}
          ↓
   Verify OTP (Twilio)
          ↓
   Generate JWT (access token 15m, refresh token 30d)
          ↓
   Store refresh token in Redis
          ↓
   Return tokens to app
```

### JWT Claims

```json
{
  "sub": "user-uuid",
  "role": "driver",
  "exp": 1699876543,
  "iat": 1699876443
}
```

### Middleware Stack

```
Request → Rate Limiter → JWT Validator → CORS → Handler
```

## 📈 Observabilidad

### Métricas (Prometheus)

```
# Latency
http_request_duration_seconds{method="GET", endpoint="/api/drivers/nearby"}

# Throughput
http_requests_total{status="200"}

# Errors
http_requests_total{status="500"}

# Business metrics
trips_created_total
trips_completed_total
drivers_online_gauge
```

### Tracing (Jaeger)

```
Span: POST /api/trips
  ├─ Span: QueryNearbyDrivers (500ms)
  ├─ Span: MatchDriver (120ms)
  ├─ Span: LockDriver (10ms)
  └─ Span: SendPushNotification (200ms)
```

### Logs Estructurados (JSON)

```json
{
  "level": "info",
  "ts": "2024-11-15T10:30:00Z",
  "msg": "location received",
  "driver_id": "uuid",
  "lat": -12.0464,
  "lng": -77.0428,
  "trace_id": "abc123"
}
```

## 🧪 Testing Strategy

```
┌──────────────────────┐
│   Unit Tests         │ → Handlers, business logic
├──────────────────────┤
│   Integration Tests  │ → DB queries, Redis ops
├──────────────────────┤
│   E2E Tests          │ → Full trip flow
├──────────────────────┤
│   Load Tests         │ → 10k concurrent connections
│   (k6, Locust)       │
└──────────────────────┘
```

## 📦 Deployment

### CI/CD Pipeline (GitHub Actions)

```yaml
Build → Test → Docker Build → Push to Registry → Deploy to K8s
```

### Kubernetes Resources

```
- Deployment (backend, matching-service)
- StatefulSet (Redis, Kafka)
- Service (ClusterIP, LoadBalancer)
- Ingress (NGINX + cert-manager)
- HPA (autoscaling)
- ConfigMap, Secrets
```

## 💰 Costos Estimados (AWS)

| Servicio | MVP | Producción |
|----------|-----|------------|
| EC2/EKS | $100/mes | $2,000/mes |
| RDS (Postgres) | $50/mes | $500/mes |
| ElastiCache (Redis) | $30/mes | $300/mes |
| Mapbox/Google Maps | $50/mes | $1,000/mes |
| FCM | Gratis | Gratis |
| Stripe/MercadoPago | 2.9% + $0.30/txn | 2.9% + $0.30/txn |
| **Total** | ~$250/mes | ~$4,000/mes |

## 🛣️ Roadmap Técnico

### Q1 2024 (MVP)
- [x] Backend monolito Go
- [x] Flutter app básica
- [ ] Auth JWT + OTP
- [ ] Matching básico
- [ ] Pagos (Stripe)

### Q2 2024 (Beta)
- [ ] Notificaciones push
- [ ] Panel admin
- [ ] Analytics básico
- [ ] Tests E2E

### Q3-Q4 2024 (Producción)
- [ ] Migración a microservicios
- [ ] Kafka event bus
- [ ] ML para pricing
- [ ] Kubernetes + Helm
- [ ] Observabilidad completa

### 2025 (Escala)
- [ ] Multi-región
- [ ] Data warehouse
- [ ] A/B testing framework
- [ ] Programa de fidelización

---

**Versión**: 1.0.0  
**Última actualización**: 15 de noviembre de 2024
