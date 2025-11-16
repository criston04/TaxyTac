# TaxyTac Backend - Tests

Este directorio contiene los tests unitarios e integración del backend.

## Estructura

```
tests/
├── unit/          # Tests unitarios de handlers y lógica
├── integration/   # Tests de integración con DB/Redis
└── e2e/          # Tests end-to-end
```

## Ejecutar tests

```bash
# Todos los tests
go test ./...

# Con cobertura
go test ./... -coverprofile=coverage.out
go tool cover -html=coverage.out

# Test específico
go test -v ./internal/server -run TestGetDriversNearby
```

## TODO
- [ ] Tests unitarios de handlers
- [ ] Tests de integración con PostgreSQL
- [ ] Tests de WebSocket
- [ ] Mocks de Redis
