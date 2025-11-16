# 📁 Estructura del Proyecto TaxyTac

```
TaxyTac/
│
├── 📄 README.md                    # Documentación principal
├── 📄 QUICKSTART.md                # Guía de inicio rápido (< 10 min)
├── 📄 ARCHITECTURE.md              # Arquitectura del sistema
├── 📄 CONTRIBUTING.md              # Guía para contribuidores
├── 📄 LICENSE                      # Licencia MIT
├── 📄 Makefile                     # Comandos útiles (make dev, make migrate, etc.)
├── 📄 docker-compose.yml           # Orquestación de servicios
├── 📄 setup.ps1                    # Script de setup para Windows
├── 📄 .gitignore                   # Archivos ignorados por Git
│
├── 🔧 .github/
│   └── workflows/
│       └── ci.yml                  # CI/CD pipeline (GitHub Actions)
│
├── 🔙 backend/                     # Backend en Go
│   ├── 📄 Dockerfile               # Imagen Docker multi-stage
│   ├── 📄 go.mod                   # Dependencias Go
│   ├── 📄 go.sum                   # Checksums de dependencias
│   ├── 📄 .env.example             # Variables de entorno ejemplo
│   ├── 📄 .env                     # Variables de entorno local (ignorado por git)
│   │
│   ├── 📂 cmd/
│   │   └── main.go                 # Entry point del backend
│   │
│   ├── 📂 internal/
│   │   └── server/
│   │       ├── server.go           # Setup del servidor, rutas, middleware
│   │       └── handlers.go         # Handlers de endpoints HTTP y WebSocket
│   │
│   ├── 📂 migrations/
│   │   └── 001_init.sql            # Schema inicial (PostGIS, tablas, índices)
│   │
│   └── 📂 tests/
│       └── README.md               # Guía de testing
│
└── 📱 mobile/                      # App móvil Flutter
    ├── 📄 pubspec.yaml             # Dependencias Flutter
    │
    ├── 📂 lib/
    │   └── main.dart               # Entry point + UI principal
    │
    └── 📂 test/
        └── widget_test.dart        # Tests básicos
```

## 🗂️ Descripción de Componentes

### 📄 Archivos Raíz

| Archivo | Propósito |
|---------|-----------|
| **README.md** | Documentación completa: stack, endpoints, instalación |
| **QUICKSTART.md** | Guía paso a paso para empezar en < 10 minutos |
| **ARCHITECTURE.md** | Diseño del sistema, flujos, escalabilidad |
| **CONTRIBUTING.md** | Cómo contribuir, estilo de código, PR process |
| **docker-compose.yml** | Define servicios: Postgres+PostGIS, Redis, EMQX, Backend |
| **Makefile** | Comandos útiles: `make dev`, `make migrate`, `make test` |
| **setup.ps1** | Script PowerShell para setup automático en Windows |

### 🔙 Backend (`backend/`)

```
backend/
├── Dockerfile              # Build multi-stage optimizado
├── go.mod / go.sum         # Gestión de dependencias
├── .env.example            # Template de variables de entorno
├── cmd/main.go             # Entry point: config, logger, graceful shutdown
├── internal/server/
│   ├── server.go           # Setup Gin, rutas, conexiones DB/Redis
│   └── handlers.go         # Lógica de endpoints y WebSocket
├── migrations/
│   └── 001_init.sql        # Schema: users, drivers, locations (PostGIS), trips
└── tests/
    └── README.md           # Guía para escribir tests
```

**Endpoints principales:**
- `POST /api/auth/register` - Registro de usuarios
- `POST /api/auth/login` - Login (JWT mock)
- `GET /api/drivers/nearby` - Buscar drivers cercanos (PostGIS)
- `POST /api/trips` - Crear viaje
- `PATCH /api/trips/:id/accept` - Aceptar viaje
- `GET /ws` - WebSocket para ubicación en tiempo real

**Tecnologías:**
- Go 1.21 + Gin
- PostgreSQL 14 + PostGIS
- Redis 7
- WebSocket (gorilla/websocket)

### 📱 Mobile (`mobile/`)

```
mobile/
├── pubspec.yaml            # Dependencias: flutter_map, web_socket_channel, http
├── lib/
│   └── main.dart           # UI principal: mapa, botones, WebSocket client
└── test/
    └── widget_test.dart    # Tests básicos
```

**Features:**
- Mapa interactivo (OpenStreetMap vía flutter_map)
- Envío de ubicación por WebSocket cada 3s
- Consulta de drivers cercanos vía HTTP
- UI Material Design 3

**Tecnologías:**
- Flutter 3.10+
- flutter_map (mapas)
- web_socket_channel (realtime)
- http (REST calls)

### 🐳 Docker Compose

**Servicios definidos:**

| Servicio | Puerto | Propósito |
|----------|--------|-----------|
| **db** | 5432 | PostgreSQL 14 + PostGIS |
| **redis** | 6379 | Cache, pub/sub, locks |
| **emqx** | 1883, 8083, 18083 | Broker MQTT (telemetría) |
| **backend** | 8080 | API Go + WebSocket |

### 🔧 CI/CD (`.github/workflows/ci.yml`)

**Pipeline automático:**
1. **backend-build**: Go test + build
2. **flutter-build**: Flutter analyze + test
3. **docker-build**: Construir imagen Docker (solo en push a main)

## 📊 Flujo de Datos

```
┌─────────────┐
│ Flutter App │
└──────┬──────┘
       │ HTTP REST
       ├────────────────┐
       │                │
       ▼                ▼
  ┌─────────┐    ┌──────────┐
  │ Backend │────│ WebSocket│
  │   Go    │    │  /ws     │
  └────┬────┘    └─────┬────┘
       │               │
       ├───────┬───────┼──────┐
       │       │       │      │
       ▼       ▼       ▼      ▼
   ┌────┐  ┌────┐  ┌────┐  ┌────┐
   │ PG │  │Redis│  │EMQX│  │FCM │
   └────┘  └────┘  └────┘  └────┘
```

## 🚀 Comandos Rápidos

```powershell
# Setup completo automático
.\setup.ps1

# Comandos manuales
docker-compose up -d              # Iniciar servicios
docker-compose logs -f backend    # Ver logs
make migrate                      # Ejecutar migraciones
cd mobile && flutter run          # Ejecutar app móvil
docker-compose down               # Detener servicios
```

## 📈 Tamaño del Proyecto

| Componente | Archivos | Líneas de Código |
|------------|----------|------------------|
| Backend Go | 4 | ~800 |
| Flutter | 2 | ~300 |
| SQL | 1 | ~200 |
| Docker/Infra | 3 | ~150 |
| Docs | 6 | ~2000 |
| **Total** | **16+** | **~3500** |

## 🔐 Archivos Sensibles (No commitear)

```
backend/.env                # Variables locales (DB passwords, JWT secret)
backend/taxytac            # Binario compilado
mobile/build/              # Builds de Flutter
*.log                      # Logs
data/                      # Datos de desarrollo
```

## 📚 Documentos Clave por Audiencia

| Si eres... | Lee esto primero |
|------------|------------------|
| **Nuevo developer** | QUICKSTART.md → README.md |
| **Arquitecto/Tech Lead** | ARCHITECTURE.md |
| **Contributor** | CONTRIBUTING.md → README.md |
| **DevOps** | docker-compose.yml → Makefile |
| **Mobile dev** | mobile/lib/main.dart → README.md |
| **Backend dev** | backend/internal/server/ → ARCHITECTURE.md |

## 🎯 Próximos Archivos a Crear (Roadmap)

- [ ] `backend/internal/auth/` - Autenticación JWT completa
- [ ] `backend/internal/matching/` - Algoritmo de matching avanzado
- [ ] `backend/internal/payments/` - Integración Stripe/MercadoPago
- [ ] `mobile/lib/screens/` - Screens separadas (Home, Trip, Profile)
- [ ] `mobile/lib/services/` - Services layer (API, WebSocket, etc.)
- [ ] `mobile/lib/models/` - Modelos de datos
- [ ] `k8s/` - Manifiestos Kubernetes
- [ ] `terraform/` - Infrastructure as Code
- [ ] `.vscode/` - Settings recomendados VS Code

---

**Última actualización**: 15 de noviembre de 2024  
**Versión del proyecto**: 0.1.0 (MVP Boilerplate)
