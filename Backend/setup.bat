@echo off
REM ==============================================================================
REM BYEOLPEDIA - SCRIPT DE CONFIGURACIÓN INICIAL (BACKEND - WINDOWS)
REM ==============================================================================
REM
REM Este script automatiza la configuración inicial del Backend.
REM Ejecutalo una vez después de clonar el repositorio.
REM
REM USO:
REM   setup.bat
REM
REM ==============================================================================

setlocal enabledelayedexpansion

echo 🚀 Iniciando configuración de Backend Byeolpedia...

REM Verificar si estamos en el directorio correcto
if not exist "manage.py" (
    echo ❌ Error: No se encuentra manage.py. Asegúrate de ejecutar este script desde Backend\
    pause
    exit /b 1
)

REM Verificar si Python está instalado
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Error: Python no está instalado. Por favor, instálalo antes de continuar.
    pause
    exit /b 1
)

REM Verificar si pip está instalado
pip --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Error: pip no está instalado. Por favor, instálalo antes de continuar.
    pause
    exit /b 1
)

echo ✅ Verificaciones iniciales completadas.

REM Crear entorno virtual si no existe
if not exist "..\venv" (
    echo 📦 Creando entorno virtual...
    python -m venv ..\venv
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
echo 📄 Activando entorno virtual...
call ..\venv\Scripts\activate.bat
if %errorlevel% neq 0 (
    echo ❌ Error al activar el entorno virtual.
    pause
    exit /b 1
)
echo ✅ Entorno virtual activado.

REM Instalar dependencias
echo 📥 Instalando dependencias de Python...
pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo ❌ Error al instalar las dependencias.
    pause
    exit /b 1
)
echo ✅ Dependencias instaladas.

REM Verificar si existe .env, si no, crearlo desde .env.example
if not exist ".env" (
    echo 🔧 Creando archivo .env desde .env.example...
    copy .env.example .env >nul
    if %errorlevel% neq 0 (
        echo ❌ Error al crear el archivo .env.
        pause
        exit /b 1
    )
    echo ✅ Archivo .env creado.
    
    REM Generar SECRET_KEY automáticamente
    echo 🔑 Generando SECRET_KEY automáticamente...
    for /f "delims=" %%i in ('python manage.py shell -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())" 2^>nul') do set "SECRET=%%i"
    
    if "!SECRET!"=="" (
        echo ⚠️  No se pudo generar SECRET_KEY automáticamente. Generando manualmente...
        for /f "delims=" %%i in ('python -c "import secrets; print(secrets.token_urlsafe(50))"') do set "SECRET=%%i"
    )
    
    REM Reemplazar en .env usando PowerShell
    powershell -Command "(Get-Content .env) -replace 'tu-clave-secreta-generada-aqui', '!SECRET!' | Set-Content .env"
    echo ✅ SECRET_KEY generada e inyectada en .env
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
echo.
set /p create_superuser="¿Deseas crear un superusuario para el panel de administración? (y/n): "
if /i "%create_superuser%"=="y" (
    python manage.py createsuperuser
)

echo.
echo 🎉 ¡Configuración de Backend completada con éxito!
echo.
echo 📋 Próximos pasos:
echo    1. Activa el entorno virtual con: ..\venv\Scripts\activate
echo    2. Inicia el servidor de desarrollo con: python manage.py runserver
echo    3. Accede a la API en: http://localhost:8000/
echo    4. Accede al panel de administración en: http://localhost:8000/admin/
echo.
echo 📚 Para más información, consulta el archivo README.md
echo.
pause