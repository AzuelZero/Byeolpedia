@echo off
REM ==============================================================================
REM BYEOLPEDIA - SCRIPT DE CONFIGURACIÓN INICIAL (WINDOWS)
REM ==============================================================================
REM
REM Este script automatiza la configuración inicial del proyecto Byeolpedia.
REM Ejecútalo una vez después de clonar el repositorio.
REM
REM USO:
REM   setup.bat
REM
REM ==============================================================================

echo 🚀 Iniciando configuraci�n de Byeolpedia...

REM Verificar si estamos en el directorio correcto
if not exist "Backend\manage.py" (
    echo ❌ Error: No se encuentra Backend\manage.py. Aseg�rate de ejecutar este script desde la ra�z del proyecto.
    pause
    exit /b 1
)

REM Verificar si Python está instalado
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Error: Python no est� instalado. Por favor, inst�lalo antes de continuar.
    pause
    exit /b 1
)

REM Verificar si pip está instalado
pip --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Error: pip no est� instalado. Por favor, inst�lalo antes de continuar.
    pause
    exit /b 1
)

echo ✅ Verificaciones iniciales completadas.

REM Crear entorno virtual si no existe
if not exist "venv" (
    echo 📦 Creando entorno virtual...
    python -m venv venv
    if %errorlevel% neq 0 (
        echo ❌ Error al crear el entorno virtual.
        pause
        exit /b 1
    )
    echo ✅ Entorno virtual creado.
) else (
    echo ✅ El entorno virtual ya existe.
)

REM Activar entorno virtual
echo 🔄 Activando entorno virtual...
call venv\Scripts\activate.bat
if %errorlevel% neq 0 (
    echo ❌ Error al activar el entorno virtual.
    pause
    exit /b 1
)
echo ✅ Entorno virtual activado.

REM Instalar dependencias
echo 📥 Instalando dependencias de Python...
cd Backend
pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo ❌ Error al instalar las dependencias.
    pause
    exit /b 1
)
echo ✅ Dependencias instaladas.

REM Verificar si existe .env, si no, crearlo desde .env.example
if not exist ".env" (
    echo 📝 Creando archivo .env desde .env.example...
    copy .env.example .env >nul
    if %errorlevel% neq 0 (
        echo ❌ Error al crear el archivo .env.
        pause
        exit /b 1
    )
    echo ✅ Archivo .env creado.
    echo ⚠️  IMPORTANTE: Debes editar el archivo Backend\.env y configurar tus variables de entorno.
    echo    - Genera una SECRET_KEY con: python manage.py shell
    echo    - Ejecuta: from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())
) else (
    echo ✅ El archivo .env ya existe.
)

REM Ejecutar migraciones
echo 🗄️  Ejecutando migraciones de la base de datos...
python manage.py migrate
if %errorlevel% neq 0 (
    echo ❌ Error al ejecutar las migraciones.
    pause
    exit /b 1
)
echo ✅ Migraciones completadas.

REM Preguntar si desea crear un superusuario
set /p create_superuser="Deseas crear un superusuario para el panel de admin? (y/n): "
if /i "%create_superuser%"=="y" (
    python manage.py createsuperuser
)

REM Volver al directorio raíz
cd ..

echo.
echo 🎉 Configuración completada con éxito!
echo.
echo 📋 Próximos pasos:
echo    1. Si aún no lo has hecho, edita Backend\.env con tus variables de entorno
echo    2. Activa el entorno virtual con: venv\Scripts\activate
echo    3. Inicia el servidor de desarrollo con: cd Backend && python manage.py runserver
echo    4. Accede a la API en: http://localhost:8000/
echo    5. Accede al panel de administración en: http://localhost:8000/admin/
echo.
echo 📚 Para más información, consulta el archivo README.md
echo.
pause