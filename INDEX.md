# 📖 TaxyTac - Índice de Documentación

Guía rápida para encontrar la información que necesitas.

---

## 🎯 ¿Qué estás buscando?

### 🚀 "Quiero empezar rápido"
👉 **[QUICKSTART.md](QUICKSTART.md)** - Setup en menos de 10 minutos

### 📚 "Quiero entender todo el proyecto"
👉 **[README.md](README.md)** - Documentación completa

### 🏗️ "Quiero entender la arquitectura"
👉 **[ARCHITECTURE.md](ARCHITECTURE.md)** - Diseño del sistema, flujos, escalabilidad

### 📂 "¿Cómo está organizado el código?"
👉 **[PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md)** - Estructura detallada del repositorio

### ⌨️ "¿Qué comandos usar?"
👉 **[COMMANDS.md](COMMANDS.md)** - Referencia rápida de comandos

### 🤝 "Quiero contribuir"
👉 **[CONTRIBUTING.md](CONTRIBUTING.md)** - Guía para contribuidores

### ✅ "¿Está todo listo?"
👉 **[PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)** - Resumen ejecutivo y checklist

---

## 📁 Por Componente

### 🔙 Backend
- **[backend/README.md](backend/README.md)** - Documentación del backend Go
- **[backend/internal/server/](backend/internal/server/)** - Código del servidor
- **[backend/migrations/](backend/migrations/)** - Migraciones SQL
- **[backend/tests/](backend/tests/)** - Tests (por implementar)

### 📱 Mobile
- **[mobile/README.md](mobile/README.md)** - Documentación de Flutter
- **[mobile/lib/main.dart](mobile/lib/main.dart)** - Código principal de la app
- **[mobile/test/](mobile/test/)** - Tests básicos

### 🐳 Infraestructura
- **[docker-compose.yml](docker-compose.yml)** - Definición de servicios
- **[Makefile](Makefile)** - Comandos útiles
- **[setup.ps1](setup.ps1)** - Script de setup para Windows
- **[.github/workflows/ci.yml](.github/workflows/ci.yml)** - CI/CD pipeline

---

## 🎓 Por Nivel de Experiencia

### 👶 Principiante
1. Leer **[QUICKSTART.md](QUICKSTART.md)**
2. Ejecutar `.\setup.ps1`
3. Explorar código en `backend/internal/server/handlers.go`
4. Modificar UI en `mobile/lib/main.dart`

### 🧑‍💻 Intermedio
1. Leer **[ARCHITECTURE.md](ARCHITECTURE.md)**
2. Estudiar queries PostGIS en `backend/internal/server/handlers.go`
3. Implementar nuevos endpoints
4. Agregar screens en Flutter

### 🚀 Avanzado
1. Revisar **[PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md)**
2. Implementar features del roadmap en **[README.md](README.md)**
3. Migrar a microservicios
4. Implementar observabilidad

---

## 📊 Por Tarea

### ⚙️ Setup y Configuración
- **[QUICKSTART.md](QUICKSTART.md)** - Guía de inicio
- **[setup.ps1](setup.ps1)** - Script automático
- **[backend/.env.example](backend/.env.example)** - Variables de entorno
- **[COMMANDS.md](COMMANDS.md)** - Comandos de setup

### 💻 Desarrollo
- **[backend/README.md](backend/README.md)** - Backend: endpoints, DB, testing
- **[mobile/README.md](mobile/README.md)** - Mobile: UI, conectividad, build
- **[COMMANDS.md](COMMANDS.md)** - Comandos de desarrollo

### 🧪 Testing
- **[backend/tests/README.md](backend/tests/README.md)** - Guía de testing backend
- **[mobile/test/](mobile/test/)** - Tests de Flutter
- **[COMMANDS.md](COMMANDS.md)** - Comandos de testing

### 🐛 Debugging
- **[COMMANDS.md](COMMANDS.md)** - Sección de debugging
- **[README.md](README.md)** - Sección de troubleshooting
- **[QUICKSTART.md](QUICKSTART.md)** - Troubleshooting común

### 🚀 Deployment
- **[backend/Dockerfile](backend/Dockerfile)** - Imagen Docker del backend
- **[docker-compose.yml](docker-compose.yml)** - Orquestación local
- **[.github/workflows/ci.yml](.github/workflows/ci.yml)** - CI/CD
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Deployment en producción

### 📚 Aprendizaje
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Conceptos arquitectónicos
- **[README.md](README.md)** - Overview general
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Buenas prácticas

---

## 🔍 Búsqueda Rápida

| Necesitas... | Documento |
|--------------|-----------|
| **Iniciar proyecto** | [QUICKSTART.md](QUICKSTART.md) |
| **API endpoints** | [backend/README.md](backend/README.md) |
| **Schema de DB** | [backend/migrations/001_init.sql](backend/migrations/001_init.sql) |
| **WebSocket protocol** | [backend/README.md](backend/README.md) |
| **Configurar Flutter** | [mobile/README.md](mobile/README.md) |
| **Comandos Docker** | [COMMANDS.md](COMMANDS.md) |
| **Comandos Git** | [COMMANDS.md](COMMANDS.md) |
| **Queries PostGIS** | [backend/README.md](backend/README.md) |
| **Flujos del sistema** | [ARCHITECTURE.md](ARCHITECTURE.md) |
| **Roadmap** | [README.md](README.md) o [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) |
| **Stack tecnológico** | [README.md](README.md) o [ARCHITECTURE.md](ARCHITECTURE.md) |
| **Estructura de código** | [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) |
| **Contribuir** | [CONTRIBUTING.md](CONTRIBUTING.md) |
| **Licencia** | [LICENSE](LICENSE) |

---

## 📄 Todos los Documentos

### 📖 Documentación Principal
- [README.md](README.md) - Documentación completa del proyecto
- [QUICKSTART.md](QUICKSTART.md) - Guía de inicio rápido (< 10 min)
- [ARCHITECTURE.md](ARCHITECTURE.md) - Arquitectura del sistema
- [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) - Estructura del repositorio
- [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) - Resumen ejecutivo
- [CONTRIBUTING.md](CONTRIBUTING.md) - Guía para contribuidores
- [COMMANDS.md](COMMANDS.md) - Referencia de comandos
- **[INDEX.md](INDEX.md)** - Este documento (índice)

### 📂 Documentación de Componentes
- [backend/README.md](backend/README.md) - Backend en Go
- [mobile/README.md](mobile/README.md) - App móvil Flutter
- [backend/tests/README.md](backend/tests/README.md) - Testing backend

### 🔧 Archivos de Configuración
- [docker-compose.yml](docker-compose.yml) - Servicios Docker
- [Makefile](Makefile) - Comandos make
- [setup.ps1](setup.ps1) - Setup para Windows
- [backend/.env.example](backend/.env.example) - Variables de entorno
- [backend/go.mod](backend/go.mod) - Dependencias Go
- [mobile/pubspec.yaml](mobile/pubspec.yaml) - Dependencias Flutter
- [.gitignore](.gitignore) - Archivos ignorados
- [LICENSE](LICENSE) - Licencia MIT

### 🗄️ Base de Datos
- [backend/migrations/001_init.sql](backend/migrations/001_init.sql) - Schema inicial

### 🔄 CI/CD
- [.github/workflows/ci.yml](.github/workflows/ci.yml) - Pipeline de GitHub Actions

---

## 🎯 Flujo de Lectura Recomendado

### Para Nuevos Developers
```
1. PROJECT_SUMMARY.md       (5 min)  ← Vista general
2. QUICKSTART.md            (10 min) ← Setup
3. README.md                (20 min) ← Profundizar
4. backend/README.md        (10 min) ← Backend
5. mobile/README.md         (10 min) ← Mobile
6. ARCHITECTURE.md          (30 min) ← Arquitectura
```

### Para Contribuidores
```
1. CONTRIBUTING.md          (15 min) ← Guías
2. PROJECT_STRUCTURE.md     (10 min) ← Estructura
3. COMMANDS.md              (5 min)  ← Comandos útiles
4. Código relevante         (X min)  ← Implementar feature
```

### Para Arquitectos/Tech Leads
```
1. ARCHITECTURE.md          (30 min) ← Diseño
2. PROJECT_SUMMARY.md       (10 min) ← Estado actual
3. README.md (Roadmap)      (10 min) ← Futuro
4. backend/migrations/*.sql (10 min) ← Modelo de datos
```

---

## 🆘 ¿Aún no encuentras lo que buscas?

1. **Busca en el proyecto**: Usa Ctrl+Shift+F en VS Code
2. **Revisa los comentarios en el código**
3. **Consulta [COMMANDS.md](COMMANDS.md)** para comandos específicos
4. **Abre un issue en GitHub**

---

## 🔄 Última Actualización

**Fecha**: 15 de noviembre de 2024  
**Versión del proyecto**: 0.1.0 (MVP Boilerplate)  
**Documentos totales**: 11 archivos markdown  
**Líneas de documentación**: ~3,500

---

**Happy coding!** 🚀

Si esta es tu primera vez, empieza con **[QUICKSTART.md](QUICKSTART.md)** 👈
