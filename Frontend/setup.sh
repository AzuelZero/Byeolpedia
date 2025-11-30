#!/bin/bash

# ==============================================================================
# BYEOLPEDIA - SCRIPT DE CONFIGURACIÓN INICIAL (FRONTEND)
# ==============================================================================
#
# Este script automatiza la configuración inicial del Frontend Flutter.
# Ejecutalo una vez después de clonar el repositorio.
#
# USO:
#   chmod +x setup.sh
#   ./setup.sh
#
# ==============================================================================

echo "🚀 Iniciando configuración de Frontend Byeolpedia..."

# Verificar si estamos en el directorio correcto
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: No se encuentra pubspec.yaml. Asegúrate de ejecutar este script desde Frontend/"
    exit 1
fi

# Verificar si Flutter está instalado
if ! command -v flutter &> /dev/null; then
    echo "❌ Error: Flutter no está instalado. Por favor, instálalo antes de continuar."
    echo "📥 Descarga desde: https://flutter.dev/docs/get-started/install"
    exit 1
fi

# Verificar si Dart está instalado (viene con Flutter, pero double-check)
if ! command -v dart &> /dev/null; then
    echo "❌ Error: Dart no está instalado. Asegúrate de que Flutter está correctamente instalado."
    exit 1
fi

echo "✅ Flutter y Dart detectados correctamente"

# Mostrar versiones
echo ""
echo "📦 Versiones detectadas:"
flutter --version | head -n 1
dart --version

echo ""
echo "📥 Descargando dependencias..."
flutter pub get
if [ $? -ne 0 ]; then
    echo "❌ Error al descargar dependencias con flutter pub get"
    exit 1
fi
echo "✅ Dependencias descargadas"

# Limpiar build anterior
echo ""
echo "🧹 Limpiando builds anteriores..."
flutter clean
if [ $? -ne 0 ]; then
    echo "⚠️  Advertencia: flutter clean falló (no crítico)"
fi
echo "✅ Build limpiado"

# Generar código si es necesario (build_runner, etc.)
echo ""
echo "⚙️  Generando código (si es necesario)..."
flutter pub run build_runner build --delete-conflicting-outputs 2>/dev/null || echo "⚠️  build_runner no encontrado (opcional)"

echo ""
echo "🎉 ¡Configuración de Frontend completada con éxito!"
echo ""
echo "📋 Próximos pasos:"
echo "   1. Para ejecutar en emulador/dispositivo:"
echo "      flutter run"
echo ""
echo "   2. Para ejecutar en navegador:"
echo "      flutter run -d chrome"
echo ""
echo "   3. Para compilar APK (Android):"
echo "      flutter build apk"
echo ""
echo "   4. Para compilar iOS:"
echo "      flutter build ios"
echo ""
echo "📚 Para más información:"
echo "   - Flutter Docs: https://flutter.dev/docs"
echo "   - Byeolpedia README: ../README.md"
echo ""