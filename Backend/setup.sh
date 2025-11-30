#!/bin/bash

# ==============================================================================
# BYEOLPEDIA - SCRIPT DE CONFIGURACIÓN INICIAL (BACKEND)
# ==============================================================================
#
# Este script automatiza la configuración inicial del Backend.
# Ejecutalo una vez después de clonar el repositorio.
#
# USO:
#   chmod +x setup.sh
#   ./setup.sh
#
# ==============================================================================

echo "🚀 Iniciando configuración de Backend Byeolpedia..."

# Verificar si estamos en el directorio correcto
if [ ! -f "manage.py" ]; then
    echo "❌ Error: No se encuentra manage.py. Asegúrate de ejecutar este script desde Backend/"
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
if [ ! -d "../venv" ]; then
    echo "📦 Creando entorno virtual..."
    python3 -m venv ../venv
    if [ $? -ne 0 ]; then
        echo "❌ Error al crear el entorno virtual."
        exit 1
    fi
    echo "✅ Entorno virtual creado."
else
    echo "✅ El entorno virtual ya existe."
fi

# Activar entorno virtual
echo "📄 Activando entorno virtual..."
source ../venv/bin/activate
if [ $? -ne 0 ]; then
    echo "❌ Error al activar el entorno virtual."
    exit 1
fi
echo "✅ Entorno virtual activado."

# Instalar dependencias
echo "📥 Instalando dependencias de Python..."
pip install -r requirements.txt
if [ $? -ne 0 ]; then
    echo "❌ Error al instalar las dependencias."
    exit 1
fi
echo "✅ Dependencias instaladas."

# Verificar si existe .env, si no, crearlo desde .env.example
if [ ! -f ".env" ]; then
    echo "🔧 Creando archivo .env desde .env.example..."
    cp .env.example .env
    if [ $? -ne 0 ]; then
        echo "❌ Error al crear el archivo .env."
        exit 1
    fi
    echo "✅ Archivo .env creado."
    
    # Generar SECRET_KEY automáticamente
    echo "🔑 Generando SECRET_KEY automáticamente..."
    SECRET=$(python manage.py shell -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())" 2>/dev/null)
    if [ -z "$SECRET" ]; then
        echo "⚠️  No se pudo generar SECRET_KEY automáticamente. Generando manualmente..."
        SECRET=$(python -c "import secrets; print(secrets.token_urlsafe(50))")
    fi
    # Escapar caracteres especiales para sed
    SECRET_ESCAPED=$(printf '%s\n' "$SECRET" | sed -e 's/[\/&]/\\&/g')
    sed -i.bak "s/tu-clave-secreta-generada-aqui/$SECRET_ESCAPED/" .env
    rm -f .env.bak
    echo "✅ SECRET_KEY generada e inyectada en .env"
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

echo ""
echo "🎉 ¡Configuración de Backend completada con éxito!"
echo ""
echo "📋 Próximos pasos:"
echo "   1. Activa el entorno virtual con: source ../venv/bin/activate"
echo "   2. Inicia el servidor de desarrollo con: python manage.py runserver"
echo "   3. Accede a la API en: http://localhost:8000/"
echo "   4. Accede al panel de administración en: http://localhost:8000/admin/"
echo ""
echo "📚 Para más información, consulta el archivo README.md"
echo ""