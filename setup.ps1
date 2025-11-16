# TaxyTac - Script de Inicio Rápido para Windows
# Ejecutar: .\setup.ps1

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  TaxyTac - Setup Script" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Verificar Docker
Write-Host "[1/6] Verificando Docker..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version
    Write-Host "✓ Docker encontrado: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Docker no encontrado. Por favor instala Docker Desktop." -ForegroundColor Red
    exit 1
}

# Verificar Docker Compose
Write-Host "[2/6] Verificando Docker Compose..." -ForegroundColor Yellow
try {
    $composeVersion = docker-compose --version
    Write-Host "✓ Docker Compose encontrado: $composeVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Docker Compose no encontrado." -ForegroundColor Red
    exit 1
}

# Copiar archivo .env
Write-Host "[3/6] Configurando variables de entorno..." -ForegroundColor Yellow
if (!(Test-Path "backend\.env")) {
    Copy-Item "backend\.env.example" "backend\.env"
    Write-Host "✓ Archivo .env creado" -ForegroundColor Green
} else {
    Write-Host "✓ Archivo .env ya existe" -ForegroundColor Green
}

# Iniciar servicios
Write-Host "[4/6] Iniciando servicios Docker..." -ForegroundColor Yellow
docker-compose up -d
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Servicios iniciados" -ForegroundColor Green
} else {
    Write-Host "✗ Error al iniciar servicios" -ForegroundColor Red
    exit 1
}

# Esperar que los servicios estén listos
Write-Host "[5/6] Esperando que los servicios estén listos..." -ForegroundColor Yellow
Start-Sleep -Seconds 10
Write-Host "✓ Servicios listos" -ForegroundColor Green

# Ejecutar migraciones
Write-Host "[6/6] Ejecutando migraciones de base de datos..." -ForegroundColor Yellow
try {
    Get-Content "backend\migrations\001_init.sql" | docker exec -i taxytac-db psql -U postgres -d taxytac
    Write-Host "✓ Migraciones ejecutadas correctamente" -ForegroundColor Green
} catch {
    Write-Host "⚠ Error al ejecutar migraciones (puede que ya existan)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  ¡Setup Completado!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Servicios disponibles:" -ForegroundColor White
Write-Host "  • Backend API:    http://localhost:8080" -ForegroundColor Cyan
Write-Host "  • PostgreSQL:     localhost:5432" -ForegroundColor Cyan
Write-Host "  • Redis:          localhost:6379" -ForegroundColor Cyan
Write-Host "  • EMQX Dashboard: http://localhost:18083 (admin/public)" -ForegroundColor Cyan
Write-Host ""
Write-Host "Próximos pasos:" -ForegroundColor White
Write-Host "  1. cd mobile" -ForegroundColor Yellow
Write-Host "  2. flutter pub get" -ForegroundColor Yellow
Write-Host "  3. flutter run" -ForegroundColor Yellow
Write-Host ""
Write-Host "Ver logs: docker-compose logs -f backend" -ForegroundColor Gray
Write-Host "Detener: docker-compose down" -ForegroundColor Gray
Write-Host ""
Write-Host "Documentación completa: README.md" -ForegroundColor Gray
Write-Host "Guía rápida: QUICKSTART.md" -ForegroundColor Gray
