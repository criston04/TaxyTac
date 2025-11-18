@echo off
cd /d "%~dp0"
set PATH=C:\Windows\System32\WindowsPowerShell\v1.0;%PATH%

echo.
echo ========================================
echo  TaxyTac - Instalando dependencias...
echo ========================================
echo.

C:\flutter\bin\flutter.bat pub get 2>&1

echo.
echo ERRORLEVEL: %ERRORLEVEL%
echo.

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Fallo al instalar dependencias
    echo Presiona cualquier tecla para continuar de todos modos...
    pause
)

echo.
echo ========================================
echo  Dependencias instaladas
echo ========================================
echo.
echo Verificando dispositivos disponibles...
echo.

C:\flutter\bin\flutter.bat devices 2>&1

echo.
echo ========================================
echo  Ejecutando la aplicacion...
echo ========================================
echo.

C:\flutter\bin\flutter.bat run 2>&1

echo.
echo.
echo ========================================
echo  PROCESO TERMINADO
echo ========================================
echo Presiona cualquier tecla para cerrar...
pause > nul
