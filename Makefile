.PHONY: help install dev up down logs migrate backend-run flutter-run clean test

# Variables
DOCKER_COMPOSE = docker-compose
GO = go
FLUTTER = flutter
DB_CONTAINER = taxytac-db

help: ## Muestra este mensaje de ayuda
	@echo "Comandos disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

install: ## Instala todas las dependencias (Go + Flutter)
	@echo "Instalando dependencias Go..."
	cd backend && $(GO) mod download
	@echo "Instalando dependencias Flutter..."
	cd mobile && $(FLUTTER) pub get

dev: ## Inicia todos los servicios en modo desarrollo
	$(DOCKER_COMPOSE) up -d

up: ## Inicia todos los servicios
	$(DOCKER_COMPOSE) up

down: ## Detiene todos los servicios
	$(DOCKER_COMPOSE) down

logs: ## Muestra logs de todos los servicios
	$(DOCKER_COMPOSE) logs -f

logs-backend: ## Muestra logs del backend
	$(DOCKER_COMPOSE) logs -f backend

logs-db: ## Muestra logs de la base de datos
	$(DOCKER_COMPOSE) logs -f db

migrate: ## Ejecuta las migraciones de base de datos
	@echo "Ejecutando migraciones..."
	docker exec -i $(DB_CONTAINER) psql -U postgres -d taxytac < backend/migrations/001_init.sql

migrate-down: ## Elimina todas las tablas (CUIDADO)
	@echo "ADVERTENCIA: Esto eliminará todas las tablas."
	@read -p "¿Estás seguro? [y/N]: " confirm && [ "$$confirm" = "y" ]
	docker exec -i $(DB_CONTAINER) psql -U postgres -d taxytac -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"

backend-run: ## Ejecuta el backend localmente (sin Docker)
	cd backend && $(GO) run cmd/main.go

backend-build: ## Compila el backend
	cd backend && $(GO) build -o taxytac ./cmd

backend-test: ## Ejecuta tests del backend
	cd backend && $(GO) test ./... -v

flutter-run: ## Ejecuta la app Flutter en modo desarrollo
	cd mobile && $(FLUTTER) run

flutter-build-apk: ## Compila APK de producción
	cd mobile && $(FLUTTER) build apk --release

flutter-test: ## Ejecuta tests de Flutter
	cd mobile && $(FLUTTER) test

clean: ## Limpia builds y dependencias
	@echo "Limpiando..."
	rm -rf backend/taxytac
	cd mobile && $(FLUTTER) clean
	$(DOCKER_COMPOSE) down -v

db-shell: ## Abre shell de PostgreSQL
	docker exec -it $(DB_CONTAINER) psql -U postgres -d taxytac

redis-cli: ## Abre Redis CLI
	docker exec -it taxytac-redis redis-cli

test: backend-test flutter-test ## Ejecuta todos los tests

rebuild: ## Reconstruye todos los contenedores
	$(DOCKER_COMPOSE) build --no-cache
	$(DOCKER_COMPOSE) up -d

status: ## Muestra el estado de los servicios
	$(DOCKER_COMPOSE) ps
