# 🚀 TaxyTac - Referencia Rápida de Comandos

Guía de referencia rápida para comandos comunes en TaxyTac.

---

## 🎯 Setup Inicial

```powershell
# Setup automático (recomendado)
.\setup.ps1

# Manual
docker-compose up -d
docker exec -i taxytac-db psql -U postgres -d taxytac < backend/migrations/001_init.sql
cd mobile && flutter pub get && flutter run
```

---

## 🐳 Docker

### Servicios

```powershell
# Iniciar todos los servicios
docker-compose up -d

# Iniciar en foreground (ver logs directos)
docker-compose up

# Detener todos los servicios
docker-compose down

# Detener y eliminar volúmenes (CUIDADO: borra datos)
docker-compose down -v

# Ver estado de servicios
docker-compose ps

# Reiniciar un servicio específico
docker-compose restart backend
docker-compose restart db
```

### Logs

```powershell
# Ver logs de todos los servicios
docker-compose logs -f

# Logs de un servicio específico
docker-compose logs -f backend
docker-compose logs -f db
docker-compose logs -f redis
docker-compose logs -f emqx

# Últimas 100 líneas
docker-compose logs --tail=100 backend
```

### Reconstruir

```powershell
# Reconstruir imagen específica
docker-compose build backend

# Reconstruir todo sin cache
docker-compose build --no-cache

# Reconstruir y reiniciar
docker-compose up -d --build
```

---

## 🗄️ Base de Datos

### Conexión

```powershell
# Conectar a PostgreSQL
docker exec -it taxytac-db psql -U postgres -d taxytac

# Ejecutar query desde archivo
docker exec -i taxytac-db psql -U postgres -d taxytac < archivo.sql

# Dump de la base de datos
docker exec taxytac-db pg_dump -U postgres taxytac > backup.sql

# Restore
docker exec -i taxytac-db psql -U postgres -d taxytac < backup.sql
```

### Comandos psql útiles

```sql
-- Listar tablas
\dt

-- Describir tabla
\d users
\d+ trips

-- Listar índices
\di

-- Ver queries lentas
\x
SELECT * FROM pg_stat_statements ORDER BY total_time DESC LIMIT 10;

-- Tamaño de tablas
SELECT 
  schemaname,
  tablename,
  pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;

-- Salir
\q
```

### Migraciones

```powershell
# Ejecutar migración
make migrate
# O:
docker exec -i taxytac-db psql -U postgres -d taxytac < backend/migrations/001_init.sql

# Verificar tablas creadas
docker exec taxytac-db psql -U postgres -d taxytac -c "\dt"
```

---

## 🔴 Redis

```powershell
# Conectar a Redis CLI
docker exec -it taxytac-redis redis-cli

# Dentro de redis-cli:
# Ver todas las keys
KEYS *

# Ver valor
GET key

# Pub/sub: Subscribirse a canal
SUBSCRIBE locations

# Monitorear todos los comandos
MONITOR

# Info del servidor
INFO

# Salir
EXIT
```

---

## 🔙 Backend (Go)

### Desarrollo local

```powershell
cd backend

# Descargar dependencias
go mod download

# Ejecutar
go run cmd/main.go

# Con hot reload (requiere air: go install github.com/cosmtrek/air@latest)
air

# Build
go build -o taxytac.exe ./cmd

# Ejecutar binario
./taxytac.exe
```

### Tests

```powershell
cd backend

# Todos los tests
go test ./...

# Con verbose
go test ./... -v

# Con cobertura
go test ./... -coverprofile=coverage.out
go tool cover -html=coverage.out

# Test específico
go test ./internal/server -run TestGetDriversNearby -v

# Benchmarks
go test -bench=. ./...
```

### Linting y formato

```powershell
# Formatear código
go fmt ./...

# Linter
go vet ./...

# golangci-lint (requiere instalación)
golangci-lint run
```

---

## 📱 Flutter

### Desarrollo

```powershell
cd mobile

# Instalar dependencias
flutter pub get

# Ejecutar en emulador/dispositivo
flutter run

# Hot reload: presiona 'r'
# Hot restart: presiona 'R'

# Ejecutar en dispositivo específico
flutter devices
flutter run -d <device-id>

# Ejecutar en Chrome (web)
flutter run -d chrome
```

### Build

```powershell
# APK debug
flutter build apk

# APK release
flutter build apk --release

# App Bundle (para Play Store)
flutter build appbundle --release

# iOS (requiere Mac)
flutter build ios --release
```

### Tests

```powershell
# Todos los tests
flutter test

# Con cobertura
flutter test --coverage
# Ver cobertura en: coverage/lcov.info

# Test específico
flutter test test/widget_test.dart
```

### Análisis

```powershell
# Analizar código
flutter analyze

# Formatear código
flutter format .
flutter format lib/

# Verificar dependencias
flutter pub outdated
```

---

## 🧪 Testing API

### Con curl (PowerShell)

```powershell
# Health check
curl http://localhost:8080/health

# Registrar usuario
curl -X POST http://localhost:8080/api/auth/register `
  -H "Content-Type: application/json" `
  -d '{"name":"Juan","phone":"+51987654321","email":"juan@test.com","role":"rider"}'

# Login
curl -X POST http://localhost:8080/api/auth/login `
  -H "Content-Type: application/json" `
  -d '{"phone":"+51987654321","otp":"123456"}'

# Drivers cercanos
curl "http://localhost:8080/api/drivers/nearby?lat=-12.0464&lng=-77.0428&radius=1000"

# Crear viaje
curl -X POST http://localhost:8080/api/trips `
  -H "Content-Type: application/json" `
  -d '{"rider_id":"uuid","origin_lat":-12.0464,"origin_lng":-77.0428,"dest_lat":-12.0500,"dest_lng":-77.0400}'
```

### Con Postman/Insomnia

Importar colección desde `docs/api-collection.json` (crear si necesario).

---

## 🔍 Debugging

### Ver logs en tiempo real

```powershell
# Todos los servicios
docker-compose logs -f

# Solo backend
docker-compose logs -f backend | Select-String "error|warn|fatal"

# Logs con timestamp
docker-compose logs -f --timestamps backend
```

### Inspeccionar contenedores

```powershell
# Ver procesos en contenedor
docker exec taxytac-backend ps aux

# Ver variables de entorno
docker exec taxytac-backend env

# Shell interactivo
docker exec -it taxytac-backend sh

# Ver uso de recursos
docker stats
```

### Network debugging

```powershell
# Verificar conectividad a backend
Test-NetConnection localhost -Port 8080

# Ver puertos ocupados
netstat -ano | findstr :8080
netstat -ano | findstr :5432

# Matar proceso en puerto
taskkill /PID <PID> /F

# IP local (para dispositivos físicos)
ipconfig | Select-String "IPv4"
```

---

## 📊 Monitoreo

### PostgreSQL

```sql
-- Conexiones activas
SELECT count(*) FROM pg_stat_activity;

-- Queries en ejecución
SELECT pid, query, state FROM pg_stat_activity WHERE state = 'active';

-- Tamaño de base de datos
SELECT pg_size_pretty(pg_database_size('taxytac'));

-- Cache hit ratio (debe ser > 95%)
SELECT 
  sum(heap_blks_read) as heap_read,
  sum(heap_blks_hit) as heap_hit,
  sum(heap_blks_hit) / (sum(heap_blks_hit) + sum(heap_blks_read)) as ratio
FROM pg_statio_user_tables;
```

### Redis

```bash
# Dentro de redis-cli
INFO stats
INFO memory
DBSIZE
CLIENT LIST
```

### Docker

```powershell
# Uso de recursos
docker stats

# Espacio en disco
docker system df

# Limpiar recursos no usados
docker system prune -a
```

---

## 🛠️ Troubleshooting Común

### Backend no inicia

```powershell
# Ver logs detallados
docker-compose logs backend

# Verificar que DB esté lista
docker-compose ps db

# Reiniciar en orden
docker-compose restart db
Start-Sleep -Seconds 5
docker-compose restart backend
```

### App móvil no conecta

```powershell
# 1. Verificar URL en lib/main.dart
# Android emulator: ws://10.0.2.2:8080/ws
# iOS simulator: ws://localhost:8080/ws
# Dispositivo físico: ws://TU_IP:8080/ws

# 2. Verificar backend responde
curl http://localhost:8080/health

# 3. Verificar firewall (Windows)
# Permitir puerto 8080 entrante
```

### Migraciones fallan

```powershell
# Ver log exacto del error
docker exec -i taxytac-db psql -U postgres -d taxytac < backend/migrations/001_init.sql 2>&1

# Si ya existen las tablas, ignorar o hacer drop (CUIDADO)
docker exec taxytac-db psql -U postgres -d taxytac -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
```

---

## 🚀 Makefile (si tienes Make instalado)

```powershell
make help         # Ver todos los comandos
make dev          # Iniciar servicios
make down         # Detener servicios
make logs         # Ver logs
make migrate      # Ejecutar migraciones
make backend-run  # Ejecutar backend local
make flutter-run  # Ejecutar Flutter
make clean        # Limpiar builds
make test         # Ejecutar todos los tests
```

---

## 📚 Git

```powershell
# Ver cambios
git status

# Agregar archivos
git add .

# Commit
git commit -m "feat: agregar feature X"

# Push
git push origin main

# Ver historial
git log --oneline -10

# Crear rama
git checkout -b feat/nueva-feature

# Cambiar de rama
git checkout main
```

---

## 🎯 Atajos Útiles

| Comando | Descripción |
|---------|-------------|
| `.\setup.ps1` | Setup completo automático |
| `docker-compose up -d` | Iniciar todo |
| `docker-compose logs -f backend` | Ver logs backend |
| `make migrate` | Ejecutar migraciones |
| `flutter run` | Ejecutar app móvil |
| `go run cmd/main.go` | Ejecutar backend local |
| `docker-compose down -v` | Reset completo |

---

**Última actualización**: 15 de noviembre de 2024  
**Versión**: 1.0.0

Para más detalles, ver documentación completa en `README.md`.
