# Contribuir a TaxyTac 🤝

¡Gracias por tu interés en contribuir a TaxyTac! Este documento proporciona guías para contribuir al proyecto.

## 📋 Código de Conducta

- Sé respetuoso y constructivo
- Acepta críticas constructivas
- Enfócate en lo mejor para la comunidad
- Muestra empatía hacia otros miembros

## 🚀 Cómo Contribuir

### 1. Fork y Clone

```bash
# Fork el repositorio en GitHub, luego:
git clone https://github.com/TU_USUARIO/TaxyTac.git
cd TaxyTac
git remote add upstream https://github.com/criston04/TaxyTac.git
```

### 2. Crear una Rama

```bash
# Actualizar main
git checkout main
git pull upstream main

# Crear rama para tu feature/fix
git checkout -b feat/tu-feature
# o
git checkout -b fix/tu-bugfix
```

**Convención de nombres de ramas:**
- `feat/nombre` - Nueva funcionalidad
- `fix/nombre` - Corrección de bug
- `docs/nombre` - Documentación
- `refactor/nombre` - Refactorización
- `test/nombre` - Tests

### 3. Hacer Cambios

Sigue las guías de estilo:

#### Backend (Go)
```bash
# Formatear código
cd backend
go fmt ./...

# Ejecutar linters
go vet ./...

# Ejecutar tests
go test ./... -v
```

#### Mobile (Flutter)
```bash
cd mobile
flutter analyze
flutter format .
flutter test
```

### 4. Commit

Usa [Conventional Commits](https://www.conventionalcommits.org/):

```bash
git add .
git commit -m "feat: agregar endpoint de pagos"
git commit -m "fix: corregir query PostGIS en drivers cercanos"
git commit -m "docs: actualizar README con ejemplos de API"
```

**Formato de commits:**
- `feat:` - Nueva funcionalidad
- `fix:` - Corrección de bug
- `docs:` - Documentación
- `style:` - Formato (sin cambios de código)
- `refactor:` - Refactorización
- `test:` - Tests
- `chore:` - Tareas de mantenimiento

### 5. Push y Pull Request

```bash
git push origin feat/tu-feature
```

Luego abre un Pull Request en GitHub con:
- **Título claro**: `feat: agregar autenticación JWT`
- **Descripción detallada**: Qué cambia, por qué, cómo probarlo
- **Screenshots/videos** si aplica

## 🎯 Áreas donde Contribuir

### Alta Prioridad
- [ ] Tests unitarios e integración
- [ ] Autenticación JWT completa
- [ ] Algoritmo de matching mejorado
- [ ] Integración de pagos (Stripe/MercadoPago)
- [ ] Notificaciones push (FCM)

### Media Prioridad
- [ ] Panel admin
- [ ] Analytics básico
- [ ] Logs estructurados
- [ ] Métricas (Prometheus)
- [ ] CI/CD mejorado

### Documentación
- [ ] Tutoriales
- [ ] Ejemplos de uso
- [ ] Diagramas de arquitectura
- [ ] Traducciones

## 📝 Guías de Estilo

### Go (Backend)

```go
// ✅ Bueno
func GetDriversNearby(ctx context.Context, lat, lng float64) ([]Driver, error) {
    // Validación de inputs
    if lat < -90 || lat > 90 {
        return nil, ErrInvalidLatitude
    }
    
    // Lógica clara y comentada
    query := buildNearbyQuery(lat, lng)
    return executeQuery(ctx, query)
}

// ❌ Malo
func getNearby(l1, l2 float64) []Driver {
    // Sin validación, sin manejo de errores
}
```

### Flutter (Mobile)

```dart
// ✅ Bueno
class DriverCard extends StatelessWidget {
  const DriverCard({
    super.key,
    required this.driver,
    required this.onTap,
  });

  final Driver driver;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(driver.name),
        onTap: onTap,
      ),
    );
  }
}

// ❌ Malo
Widget card(d) {
  return Card(child: Text(d.name));
}
```

## 🧪 Testing

Todos los PRs deben incluir tests:

```bash
# Backend
cd backend
go test ./... -coverprofile=coverage.out
go tool cover -func=coverage.out

# Mobile
cd mobile
flutter test --coverage
```

**Mínimo de cobertura**: 60%

## 🔍 Code Review

Los PRs serán revisados en base a:
- ✅ Funcionalidad correcta
- ✅ Tests incluidos y pasando
- ✅ Código limpio y legible
- ✅ Documentación actualizada
- ✅ Sin breaking changes (a menos que sea necesario)

## 📦 Versionado

Seguimos [Semantic Versioning](https://semver.org/):
- `MAJOR.MINOR.PATCH`
- `1.0.0` - Primera release estable
- `1.1.0` - Nueva funcionalidad (compatible)
- `1.1.1` - Corrección de bugs
- `2.0.0` - Cambios no compatibles

## 🐛 Reportar Bugs

Usa [GitHub Issues](https://github.com/criston04/TaxyTac/issues) con:

```markdown
**Descripción del Bug**
Descripción clara y concisa.

**Pasos para Reproducir**
1. Ir a '...'
2. Hacer click en '...'
3. Ver error

**Comportamiento Esperado**
Lo que debería pasar.

**Screenshots**
Si aplica.

**Entorno**
- OS: [e.g. Windows 11]
- Flutter: [e.g. 3.16.0]
- Go: [e.g. 1.21]
- Docker: [e.g. 24.0.6]
```

## 💡 Proponer Features

Usa [GitHub Discussions](https://github.com/criston04/TaxyTac/discussions) o Issues con:

```markdown
**Problema que Resuelve**
Describe el problema o necesidad.

**Solución Propuesta**
Cómo lo resolverías.

**Alternativas Consideradas**
Otras opciones que evaluaste.

**Contexto Adicional**
Cualquier otra información relevante.
```

## 📞 Contacto

- GitHub Issues: [TaxyTac Issues](https://github.com/criston04/TaxyTac/issues)
- Discussions: [TaxyTac Discussions](https://github.com/criston04/TaxyTac/discussions)

---

¡Gracias por contribuir a TaxyTac! 🎉
