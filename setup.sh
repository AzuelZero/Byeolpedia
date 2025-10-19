#!/bin/bash

# ==============================================================================
# BYEOLPEDIA - SCRIPT DE CONFIGURACIÓN INICIAL
# ==============================================================================
#
# Este script automatiza la configuración inicial del proyecto Byeolpedia.
# Ejecútalo una vez después de clonar el repositorio.
#
# USO:
#   chmod +x setup.sh
#   ./setup.sh
#
# ==============================================================================

echo "🚀 Iniciando configuración de Byeolpedia..."

# Verificar si estamos en el directorio correcto
if [ ! -f "Backend/manage.py" ]; then
    echo "❌ Error: No se encuentra Backend/manage.py. Asegúrate de ejecutar este script desde la raíz del proyecto."
    exit 1
fi

# Verificar si Python está instalado
if ! command -v python3 &> /dev/null; then
    echo "❌ Error: Python 3 no está instalado. Por favor, instálalo antes de continuar."
    exit 1
fi

# Verificar si pip está instalado
if ! command -v pip &> /dev/null; then
    echo "❌ Error: pip no está instalado. Por favor, instálalo antes de continuar."
    exit 1
fi

echo "✅ Verificaciones iniciales completadas."

# Crear entorno virtual si no existe
if [ ! -d "venv" ]; then
    echo "📦 Creando entorno virtual..."
    python3 -m venv venv
    if [ $? -ne 0 ]; then
        echo "❌ Error al crear el entorno virtual."
        exit 1
    fi
    echo "✅ Entorno virtual creado."
else
    echo "✅ El entorno virtual ya existe."
fi

# Activar entorno virtual
echo "🔄 Activando entorno virtual..."
source venv/bin/activate
if [ $? -ne 0 ]; then
    echo "❌ Error al activar el entorno virtual."
    exit 1
fi
echo "✅ Entorno virtual activado."

# Instalar dependencias
echo "📥 Instalando dependencias de Python..."
cd Backend
pip install -r requirements.txt
if [ $? -ne 0 ]; then
    echo "❌ Error al instalar las dependencias."
    exit 1
fi
echo "✅ Dependencias instaladas."

# Verificar si existe .env, si no, crearlo desde .env.example
if [ ! -f ".env" ]; then
    echo "📝 Creando archivo .env desde .env.example..."
    cp .env.example .env
    if [ $? -ne 0 ]; then
        echo "❌ Error al crear el archivo .env."
        exit 1
    fi
    echo "✅ Archivo .env creado."
    echo "⚠️  IMPORTANTE: Debes editar el archivo Backend/.env y configurar tus variables de entorno."
    echo "   - Genera una SECRET_KEY con: python manage.py shell"
    echo "   - Ejecuta: from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"
else
    echo "✅ El archivo .env ya existe."
fi

# Ejecutar migraciones
echo "🗄️  Ejecutando migraciones de la base de datos..."
python manage.py migrate
if [ $? -ne 0 ]; then
    echo "❌ Error al ejecutar las migraciones."
    exit 1
fi
echo "✅ Migraciones completadas."

# Preguntar si desea crear un superusuario
echo ""
read -p "¿Deseas crear un superusuario para el panel de administración? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    python manage.py createsuperuser
fi

# Volver al directorio raíz
cd ..

echo ""
echo "🎉 ¡Configuración completada con éxito!"
echo ""
echo "📋 Próximos pasos:"
echo "   1. Si aún no lo has hecho, edita Backend/.env con tus variables de entorno"
echo "   2. Activa el entorno virtual con: source venv/bin/activate"
echo "   3. Inicia el servidor de desarrollo con: cd Backend && python manage.py runserver"
echo "   4. Accede a la API en: http://localhost:8000/"
echo "   5. Accede al panel de administración en: http://localhost:8000/admin/"
echo ""
echo "📚 Para más información, consulta el archivo README.md"
echo ""