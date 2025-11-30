#!/bin/bash

# ==============================================================================
# BYEOLPEDIA - SCRIPT ORQUESTADOR DE CONFIGURACIÓN
# ==============================================================================
#
# Este script coordina la instalación del proyecto completo (Backend + Frontend).
# Puedes ejecutarlo desde la raíz para instalar TODO, o navegar a Backend/Frontend
# para instalar solo lo que necesites.
#
# USO:
#   chmod +x setup.sh
#   ./setup.sh
#
# ==============================================================================

set -e  # Salir si hay error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Iniciando configuración de Byeolpedia...${NC}"
echo ""

# Verificar si estamos en el directorio correcto
if [ ! -f "Backend/manage.py" ]; then
    echo -e "${RED}❌ Error: No se encuentra Backend/manage.py${NC}"
    echo "Asegúrate de ejecutar este script desde la raíz del proyecto."
    exit 1
fi

# Función para imprimir secciones
print_section() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Función para imprimir éxito
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Función para imprimir advertencia
print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Función para imprimir error
print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# ==============================================================================
# PARTE 1: CONFIGURAR BACKEND
# ==============================================================================

print_section "PARTE 1: Configurando Backend"

if [ -f "Backend/setup.sh" ]; then
    chmod +x Backend/setup.sh
    if Backend/setup.sh; then
        print_success "Backend configurado correctamente"
    else
        print_error "Backend falló durante la configuración"
        exit 1
    fi
else
    print_error "No se encontró Backend/setup.sh"
    exit 1
fi

# ==============================================================================
# PARTE 2: CONFIGURAR FRONTEND (OPCIONAL)
# ==============================================================================

print_section "PARTE 2: Configurando Frontend (Opcional)"

if [ -d "Frontend" ] && [ -f "Frontend/setup.sh" ]; then
    read -p "¿Deseas configurar el Frontend también? (y/n): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Verificar si Flutter está instalado antes de correr el setup
        if ! command -v flutter &> /dev/null; then
            print_warning "Flutter no está instalado en tu sistema"
            print_warning "Instálalo desde: https://flutter.dev/docs/get-started/install"
            print_warning "Omitiendo configuración del Frontend por ahora"
        else
            chmod +x Frontend/setup.sh
            if Frontend/setup.sh; then
                print_success "Frontend configurado correctamente"
            else
                print_warning "Frontend falló, pero Backend está funcionando"
                echo "Puedes configurar Frontend más tarde con: cd Frontend && ./setup.sh"
            fi
        fi
    else
        print_warning "Frontend omitido. Puedes configurarlo después con: cd Frontend && ./setup.sh"
    fi
else
    print_warning "Frontend no está disponible aún (estado: Próximamente)"
fi

# ==============================================================================
# FINALIZACIÓN
# ==============================================================================

print_section "FINALIZACIÓN"

echo ""
print_success "¡Configuración completada!"
echo ""
echo -e "${BLUE}📋 Próximos pasos:${NC}"
echo ""
echo "1️⃣  Activa el entorno virtual del Backend:"
echo -e "   ${YELLOW}source venv/bin/activate${NC}"
echo ""
echo "2️⃣  Inicia el servidor de desarrollo:"
echo -e "   ${YELLOW}cd Backend && python manage.py runserver${NC}"
echo ""
echo "3️⃣  Accede a la API:"
echo -e "   ${YELLOW}http://localhost:8000/${NC}"
echo ""
echo "4️⃣  Panel de administración:"
echo -e "   ${YELLOW}http://localhost:8000/admin/${NC}"
echo ""

if [ -d "Frontend" ]; then
    echo "5️⃣  Para iniciar el Frontend (cuando esté listo):"
    echo -e "   ${YELLOW}cd Frontend && flutter run${NC}"
    echo ""
fi

echo -e "${BLUE}📚 Para más información:${NC}"
echo "   Backend: Backend/README.md"
echo "   Frontend: Frontend/README.md"
echo "   General: README.md"
echo ""