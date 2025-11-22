# Backend de Byeolpedia

Este es el backend de la aplicación Byeolpedia para el tracking de colecciones de K-Pop, desarrollado con Django REST Framework.

## Requisitos

- Python 3.8+
- PostgreSQL (recomendado) o SQLite (para desarrollo)
- pip o poetry para gestión de dependencias

## Instalación

1. **Clonar el repositorio**
```bash
git clone <repository-url>
cd Backend
```

2. **Crear entorno virtual**
```bash
python -m venv venv
source venv/bin/activate  # Linux/Mac
# o
venv\Scripts\activate  # Windows
```

3. **Instalar dependencias**
```bash
pip install -r requirements.txt
```

4. **Configurar variables de entorno**
```bash
cp .env.example .env
```

Edita el archivo `.env` con tus configuraciones:
```env
SECRET_KEY=tu-secreto-aqui
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1

# Para PostgreSQL (opcional)
DB_NAME=byeolpedia
DB_USER=postgres
DB_PASSWORD=tu-contraseña
DB_HOST=localhost
DB_PORT=5432
```

5. **Configurar base de datos**
```bash
# Para SQLite (por defecto, sin configuración adicional)
python manage.py makemigrations
python manage.py migrate

# Para PostgreSQL (si configuraste las variables de entorno)
# Asegúrate de que PostgreSQL está corriendo y la base de datos existe
python manage.py makemigrations
python manage.py migrate
```

6. **Crear superusuario**
```bash
python manage.py createsuperuser
```

7. **Cargar datos de ejemplo (opcional)**
```bash
python populate_catalog.py
```

## Ejecución

### Modo Desarrollo
```bash
python manage.py runserver
```

La API estará disponible en `http://localhost:8000/api/`

### Panel de Administración
- Admin por defecto: `http://localhost:8000/admin/`
- Admin personalizado: `http://localhost:8000/byeolpedia-admin/`

## Pruebas

### Probar la API automáticamente
```bash
# Asegúrate de que el servidor está corriendo
python test_api.py
```

### Probar la API manualmente
Usar Postman, Insomnia o curl para probar los endpoints:

```bash
# Ejemplo: Obtener lista de grupos
curl http://localhost:8000/api/catalog/groups/

# Ejemplo: Registrar usuario
curl -X POST http://localhost:8000/api/auth/register/ \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","email":"test@example.com","collector_name":"Test","password":"Test123!","password_confirm":"Test123!"}'
```

## Estructura del Proyecto

```
Backend/
├── byeolpedia_api/          # Configuración principal del proyecto
│   ├── settings.py          # Configuración de Django
│   ├── urls.py             # URLs principales
│   └── admin.py            # Admin personalizado
├── users/                  # Gestión de usuarios
│   ├── models.py           # Modelo User personalizado
│   ├── views.py            # Vistas de autenticación
│   ├── serializers.py      # Serializers de usuarios
│   ├── urls.py            # URLs de usuarios
│   └── permissions.py      # Permisos personalizados
├── catalog/                # Catálogo de productos
│   ├── models.py           # Modelos (Group, Album, etc.)
│   ├── views.py            # Vistas del catálogo
│   ├── serializers.py      # Serializers del catálogo
│   ├── urls.py            # URLs del catálogo
│   ├── filters.py          # Filtros avanzados
│   └── admin.py           # Configuración del admin
├── collection/             # Colección personal
│   ├── models.py           # Modelos (UserCollectible, etc.)
│   ├── views.py            # Vistas de colección
│   ├── serializers.py      # Serializers de colección
│   ├── urls.py            # URLs de colección
│   ├── filters.py          # Filtros avanzados
│   └── admin.py           # Configuración del admin
├── requirements.txt         # Dependencias
├── API_README.md          # Documentación de la API
├── test_api.py            # Script para probar la API
```

## Endpoints Principales

### Autenticación
- `POST /api/auth/register/` - Registro de usuario
- `POST /api/auth/login/` - Login
- `POST /api/auth/logout/` - Logout
- `GET /api/auth/profile/` - Perfil de usuario
- `GET /api/auth/stats/` - Estadísticas del usuario

### Catálogo
- `GET /api/catalog/groups/` - Lista de grupos
- `GET /api/catalog/albums/` - Lista de álbumes
- `GET /api/catalog/photocards/` - Lista de photocards
- `GET /api/catalog/lightsticks/` - Lista de lightsticks

### Colección Personal
- `GET /api/collection/collectibles/` - Objetos en colección
- `POST /api/collection/collectibles/` - Añadir objeto a colección
- `GET /api/collection/wishlist/` - Wishlist
- `GET /api/collection/favorites/` - Grupos favoritos

## Características Implementadas

### ✅ Completadas
- **Autenticación JWT**: Registro, login, logout con tokens seguros
- **Catálogo completo**: Grupos, miembros, álbumes, photocards, lightsticks
- **Colección personal**: Gestión de objetos poseídos
- **Wishlist**: Gestión de objetos deseados
- **Grupos favoritos**: Seguimiento de grupos preferidos
- **Estadísticas**: Métricas detalladas de la colección
- **Filtros avanzados**: Búsqueda y filtrado por múltiples criterios
- **Paginación**: Manejo eficiente de listas grandes
- **Permisos**: Control de acceso seguro a recursos
- **Admin personalizado**: Panel de administración intuitivo

### 🔄 Próximas mejoras
- Sistema de trading entre usuarios
- Notificaciones push
- Integración con redes sociales

### 🤖 Machine Learning
- **Reconocimiento visual de lightsticks**: Estructura básica implementada para integración con TensorFlow Lite en Flutter
- **Endpoint**: `/api/collection/lightstick-recognition/`
- **Funcionalidad**: Recibe imágenes base64 y devuelve lightsticks reconocidos con confianza
- **Integración**: El modelo TensorFlow Lite se ejecuta en el frontend Flutter para procesamiento local

## Desarrollo

### Migraciones
```bash
# Crear nuevas migraciones
python manage.py makemigrations

# Aplicar migraciones
python manage.py migrate
```

### Tests
```bash
# Ejecutar tests
python manage.py test

# Ejecutar tests con cobertura
python manage.py test --coverage
```

### Documentación
La documentación completa de la API está disponible en `API.md`

## Despliegue

### Producción
1. Configurar `DEBUG=False` en `.env`
2. Configurar base de datos PostgreSQL
3. Configurar `ALLOWED_HOSTS` con dominios reales
4. Recolectar archivos estáticos:
```bash
python manage.py collectstatic
```
5. Usar servidor WSGI como Gunicorn:
```bash
gunicorn byeolpedia_api.wsgi:application
```

### Docker
```bash
# Construir imagen
docker build -t byeolpedia-backend .

# Ejecutar contenedor
docker run -p 8000:8000 byeolpedia-backend
```

## Contribución

1. Fork el proyecto
2. Crear rama de feature: `git checkout -b feature/nueva-funcionalidad`
3. Commit cambios: `git commit -am 'Agregar nueva funcionalidad'`
4. Push a la rama: `git push origin feature/nueva-funcionalidad`
5. Crear Pull Request

## Licencia

Este proyecto está bajo licencia Creative Commons Attribution-ShareAlike 3.0 Spain.

## Soporte

Para preguntas o soporte:
- Revisar `API_README.md` para documentación de la API.
- Ejecutar `test_api.py` para verificar funcionamiento.
- Revisar logs en `debug.log`.