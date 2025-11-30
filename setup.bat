@echo off
REM ==============================================================================
REM BYEOLPEDIA - SCRIPT ORQUESTADOR DE CONFIGURACIÓN (WINDOWS)
REM ==============================================================================
REM
REM Este script coordina la instalación del proyecto completo (Backend + Frontend).
REM Puedes ejecutarlo desde la raíz para instalar TODO, o navegar a Backend/Frontend
REM para instalar solo lo que necesites.
REM
REM USO:
REM   setup.bat
REM
REM ==============================================================================

setlocal enabledelayedexpansion

REM Verificar si estamos en el directorio correcto
if not exist "Backend\manage.py" (
    echo ❌ Error: No se encuentra Backend\manage.py
    echo Asegúrate de ejecutar este script desde la raíz del proyecto.
    pause
    exit /b 1
)

echo 🚀 Iniciando configuración de Byeolpedia...
echo.

REM ==============================================================================
REM PARTE 1: CONFIGURAR BACKEND
REM ==============================================================================

echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo PARTE 1: Configurando Backend
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

if exist "Backend\setup.bat" (
    call Backend\setup.bat
    if %errorlevel% neq 0 (
        echo ❌ Backend falló durante la configuración
        pause
        exit /b 1
    )
    echo ✅ Backend configurado correctamente
) else (
    echo ❌ No se encontró Backend\setup.bat
    pause
    exit /b 1
)

echo.

REM ==============================================================================
REM PARTE 2: CONFIGURAR FRONTEND (OPCIONAL)
REM ==============================================================================

echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo PARTE 2: Configurando Frontend (Opcional)
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

if exist "Frontend" (
    if exist "Frontend\setup.bat" (
        set /p frontend_setup="¿Deseas configurar el Frontend también? (y/n): "
        
        if /i "!frontend_setup!"=="y" (
            REM Verificar si Flutter está instalado
            flutter --version >nul 2>&1
            if %errorlevel% neq 0 (
                echo ⚠️  Flutter no está instalado en tu sistema
                echo Instálalo desde: https://flutter.dev/docs/get-started/install
                echo ⚠️  Omitiendo configuración del Frontend por ahora
            ) else (
                call Frontend\setup.bat
                if %errorlevel% neq 0 (
                    echo ⚠️  Frontend falló, pero Backend está funcionando
                    echo Puedes configurar Frontend más tarde con: cd Frontend ^&^& setup.bat
                ) else (
                    echo ✅ Frontend configurado correctamente
                )
            )
        ) else (
            echo ⚠️  Frontend omitido. Puedes configurarlo después con: cd Frontend ^&^& setup.bat
        )
    ) else (
        echo ⚠️  Frontend no está disponible aún (estado: Próximamente)
    )
) else (
    echo ⚠️  Carpeta Frontend no existe
)

echo.

REM ==============================================================================
REM FINALIZACIÓN
REM ==============================================================================

echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo FINALIZACIÓN
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

echo ✅ ¡Configuración completada!
echo.
echo 📋 Próximos pasos:
echo.
echo 1️⃣  Activa el entorno virtual del Backend:
echo    venv\Scripts\activate
echo.
echo 2️⃣  Inicia el servidor de desarrollo:
echo    cd Backend ^&^& python manage.py runserver
echo.
echo 3️⃣  Accede a la API:
echo    http://localhost:8000/
echo.
echo 4️⃣  Panel de administración:
echo    http://localhost:8000/admin/
echo.

if exist "Frontend" (
    echo 5️⃣  Para iniciar el Frontend (cuando esté listo):
    echo    cd Frontend ^&^& flutter run
    echo.
)

echo 📚 Para más información:
echo    Backend: Backend\README.md
echo    Frontend: Frontend\README.md
echo    General: README.md
echo.

pause