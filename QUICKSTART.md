# TaxyTac - Guía de Inicio Rápido 🚀

Esta guía te llevará desde cero hasta tener la app funcionando en tu máquina local en **menos de 10 minutos**.

## 📋 Prerequisitos

Antes de comenzar, asegúrate de tener instalado:

- ✅ **Docker Desktop** (Windows/Mac) o **Docker + Docker Compose** (Linux)
- ✅ **Flutter SDK 3.10+** (para la app móvil)
- ✅ **Go 1.21+** (solo si quieres desarrollo backend local sin Docker)

### Verificar instalaciones

```powershell
# Docker
docker --version
docker-compose --version

# Flutter
flutter --version
flutter doctor

# Go (opcional)
go version
```

## 🎯 Paso 1: Clonar y configurar

```powershell
# Si ya clonaste el repo, navega a la carpeta
cd TaxyTac

# Copiar variables de entorno
Copy-Item backend\.env.example backend\.env
```

## 🐳 Paso 2: Levantar servicios con Docker

```powershell
# Iniciar todos los servicios (Postgres, Redis, EMQX, Backend)
docker-compose up -d

# Ver logs
docker-compose logs -f backend
```

**Servicios disponibles:**
- 🔌 Backend API: http://localhost:8080
- 🐘 PostgreSQL: localhost:5432
- 🔴 Redis: localhost:6379
- 📡 EMQX Dashboard: http://localhost:18083 (admin/public)

## 🗄️ Paso 3: Ejecutar migraciones

```powershell
# Opción 1: Usando comando directo
docker exec -i taxytac-db psql -U postgres -d taxytac < backend/migrations/001_init.sql

# Opción 2: Usando Makefile (si tienes Make instalado)
make migrate
```

**Verificar que las tablas se crearon:**

```powershell
docker exec -it taxytac-db psql -U postgres -d taxytac

# Dentro de psql:
\dt
# Deberías ver: users, drivers, vehicles, locations, trips, payments

# Salir
\q
```

## 📱 Paso 4: Ejecutar app Flutter

### En emulador/simulador

```powershell
cd mobile

# Instalar dependencias
flutter pub get

# Ejecutar en emulador Android/iOS
flutter run
```

### Configurar URL del backend

Edita `mobile/lib/main.dart` línea 27-28:

```dart
// Android emulator
static const String wsUrl = 'ws://10.0.2.2:8080/ws';
static const String apiUrl = 'http://10.0.2.2:8080/api';

// iOS simulator
static const String wsUrl = 'ws://localhost:8080/ws';
static const String apiUrl = 'http://localhost:8080/api';

// Dispositivo físico (reemplaza con tu IP local)
static const String wsUrl = 'ws://192.168.1.100:8080/ws';
static const String apiUrl = 'http://192.168.1.100:8080/api';
```

**Encontrar tu IP local (Windows):**

```powershell
ipconfig | Select-String "IPv4"
```

## 🧪 Paso 5: Probar la app

1. **En la app Flutter:**
   - Toca el mapa para cambiar tu ubicación
   - Presiona "Enviar Ubicación" para conectar vía WebSocket
   - Presiona "Buscar Drivers" para consultar drivers cercanos

2. **Verificar en logs del backend:**

```powershell
docker-compose logs -f backend
```

Deberías ver mensajes como:
```
INFO[0001] location received  driver=driver-demo-1 lat=-12.0464 lng=-77.0428
```

## 🔧 Comandos útiles

```powershell
# Ver estado de servicios
docker-compose ps

# Detener servicios
docker-compose down

# Reiniciar backend
docker-compose restart backend

# Ver logs de PostgreSQL
docker-compose logs -f db

# Conectar a Redis CLI
docker exec -it taxytac-redis redis-cli

# Reconstruir todo desde cero
docker-compose down -v
docker-compose build --no-cache
docker-compose up -d
```

## 🐛 Troubleshooting

### Backend no se conecta a la base de datos

```powershell
# Verificar que Postgres esté corriendo
docker-compose ps db

# Ver logs de DB
docker-compose logs db

# Intentar reiniciar
docker-compose restart db backend
```

### App móvil no se conecta al backend

1. Verifica la URL en `mobile/lib/main.dart`
2. Si usas dispositivo físico, asegúrate de estar en la misma red WiFi
3. Verifica que el backend responda:

```powershell
# Desde PowerShell
curl http://localhost:8080/health

# Debería retornar: {"status":"ok","time":...}
```

### Error de migraciones "relation already exists"

```powershell
# Las tablas ya existen, puedes continuar
# O si quieres empezar de cero (CUIDADO: borra datos):
docker-compose down -v
docker-compose up -d
# Espera 10 segundos y ejecuta migraciones de nuevo
```

### Flutter: "Waiting for another flutter command to release the startup lock"

```powershell
# Eliminar lock
Remove-Item "$env:USERPROFILE\AppData\Local\Temp\flutter_tools_lock" -Force
```

## 📚 Siguientes pasos

Ahora que tienes todo corriendo:

1. **Experimenta con la API**: Ver `README.md` para lista completa de endpoints
2. **Lee la arquitectura**: Ver `ARCHITECTURE.md` para entender el diseño
3. **Implementa features**: Ver roadmap en `README.md`
4. **Agrega tests**: Ver `backend/tests/README.md`

## 💡 Tips de desarrollo

### Desarrollo sin Docker (backend)

```powershell
# Asegúrate de tener Postgres y Redis corriendo localmente
# O solo levanta DB y Redis con Docker:
docker-compose up -d db redis emqx

cd backend
go run cmd/main.go
```

### Hot reload en Flutter

```powershell
cd mobile
flutter run
# Presiona 'r' para hot reload
# Presiona 'R' para hot restart
```

### Ver consultas SQL en logs

Edita `backend/cmd/main.go` y cambia el log level:

```go
log.SetLevel(logrus.DebugLevel)
```

## 🎉 ¡Listo!

Ahora tienes TaxyTac corriendo localmente. Cualquier duda, revisa:
- 📖 [README.md](README.md) - Documentación completa
- 🏗️ [ARCHITECTURE.md](ARCHITECTURE.md) - Arquitectura del sistema
- 🐛 [GitHub Issues](https://github.com/criston04/TaxyTac/issues) - Reportar problemas

---

**¿Necesitas ayuda?** Abre un issue en GitHub o contacta al equipo.
