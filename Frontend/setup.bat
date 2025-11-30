@echo off
REM ==============================================================================
REM BYEOLPEDIA - SCRIPT DE CONFIGURACIÓN INICIAL (FRONTEND - WINDOWS)
REM ==============================================================================
REM
REM Este script automatiza la configuración inicial del Frontend Flutter.
REM Ejecutalo una vez después de clonar el repositorio.
REM
REM USO:
REM   setup.bat
REM
REM ==============================================================================

setlocal enabledelayedexpansion

echo 🚀 Iniciando configuración de Frontend Byeolpedia...

REM Verificar si estamos en el directorio correcto
if not exist "pubspec.yaml" (
    echo ❌ Error: No se encuentra pubspec.yaml. Asegúrate de ejecutar este script desde Frontend\
    pause
    exit /b 1
)

REM Verificar si Flutter está instalado
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Error: Flutter no está instalado. Por favor, instálalo antes de continuar.
    echo 📥 Descarga desde: https://flutter.dev/docs/get-started/install
    pause
    exit /b 1
)

REM Verificar si Dart está instalado
dart --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Error: Dart no está instalado. Asegúrate de que Flutter está correctamente instalado.
    pause
    exit /b 1
)

echo ✅ Flutter y Dart detectados correctamente

REM Mostrar versiones
echo.
echo 📦 Versiones detectadas:
flutter --version | findstr /R "^Flutter"
dart --version

REM Descargar dependencias
echo.
echo 📥 Descargando dependencias...
flutter pub get
if %errorlevel% neq 0 (
    echo ❌ Error al descargar dependencias con flutter pub get
    pause
    exit /b 1
)
echo ✅ Dependencias descargadas

REM Limpiar build anterior
echo.
echo 🧹 Limpiando builds anteriores...
flutter clean
if %errorlevel% neq 0 (
    echo ⚠️  Advertencia: flutter clean falló (no crítico)
)
echo ✅ Build limpiado

REM Generar código si es necesario
echo.
echo ⚙️  Generando código (si es necesario^)...
flutter pub run build_runner build --delete-conflicting-outputs >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  build_runner no encontrado (opcional)
) else (
    echo ✅ Código generado
)

echo.
echo 🎉 ¡Configuración de Frontend completada con éxito!
echo.
echo 📋 Próximos pasos:
echo    1. Para ejecutar en emulador/dispositivo:
echo       flutter run
echo.
echo    2. Para ejecutar en navegador:
echo       flutter run -d chrome
echo.
echo    3. Para compilar APK (Android):
echo       flutter build apk
echo.
echo    4. Para compilar iOS:
echo       flutter build ios
echo.
echo 📚 Para más información:
echo    - Flutter Docs: https://flutter.dev/docs
echo    - Byeolpedia README: ..\README.md
echo.
pause