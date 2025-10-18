# byeolpedia_api/settings.py
"""
Configuración completa de Django para Byeolpedia (K-Pop Tracker MVP)

Este archivo gestiona toda la configuración del proyecto Django.
Las variables sensibles (SECRET_KEY, credenciales de BD) se leen desde
variables de entorno usando python-decouple, nunca hardcodeadas aquí.
"""

from pathlib import Path
from datetime import timedelta
from decouple import config
import os

# ==============================================================================
# PATHS DEL PROYECTO
# ==============================================================================

# BASE_DIR apunta a la carpeta raíz del proyecto (donde está manage.py)
# Lo usamos para construir rutas absolutas de forma portable
BASE_DIR = Path(__file__).resolve().parent.parent

# ==============================================================================
# SEGURIDAD
# ==============================================================================

# SECRET_KEY: Cadena aleatoria usada para firmar cookies, tokens JWT, sesiones, etc.
# CRÍTICO: Esta clave NUNCA debe estar hardcodeada en el código.
# Se lee desde el archivo .env usando python-decouple.
# 
# Para generar una nueva: python manage.py shell
# >>> from django.core.management.utils import get_random_secret_key
# >>> print(get_random_secret_key())
SECRET_KEY = config('SECRET_KEY')

# DEBUG: Controla si Django muestra errores detallados o páginas genéricas de error
# True = Desarrollo (muestra stack traces completos)
# False = Producción (muestra páginas de error genéricas)
# Se lee desde .env para poder cambiar sin tocar código
DEBUG = config('DEBUG', default=False, cast=bool)

# ALLOWED_HOSTS: Lista de dominios/IPs desde donde se puede acceder a la app
# En desarrollo: localhost, 127.0.0.1
# En producción: tu dominio real (ej: api.byeolpedia.com)
# Se lee desde .env como string separado por comas y se convierte a lista
ALLOWED_HOSTS = config(
    'ALLOWED_HOSTS', 
    default='localhost,127.0.0.1', 
    cast=lambda v: [s.strip() for s in v.split(',')]
)

# ==============================================================================
# APLICACIONES INSTALADAS
# ==============================================================================

INSTALLED_APPS = [
    # Apps built-in de Django (administración, auth, sesiones, etc.)
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    
    # Apps de terceros (librerías externas)
    'rest_framework',  # Django REST Framework para API REST
    'rest_framework_simplejwt',  # Autenticación JWT
    'rest_framework_simplejwt.token_blacklist',  # Blacklist para logout seguro
    'corsheaders',  # Manejo de CORS para peticiones desde Flutter
    'django_filters',  # Filtros avanzados en endpoints (group_type=boy_group, etc.)
    
    # Nuestras apps personalizadas
    # El orden importa: Django crea migraciones en este orden
    'users.apps.UsersConfig',  # Gestión de usuarios y autenticación
    'catalog.apps.CatalogConfig',  # Catálogo de grupos, álbumes, photocards, lightsticks
    'collection.apps.CollectionConfig',  # Colección personal y wishlist del usuario
]

# ==============================================================================
# MIDDLEWARE
# ==============================================================================

# Middleware son capas que procesan request/response antes/después de llegar a las views
# El ORDEN es CRÍTICO: cada middleware procesa en orden y luego en orden inverso
MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',  # Añade headers de seguridad
    'corsheaders.middleware.CorsMiddleware',  # DEBE ir temprano para procesar OPTIONS
    'django.contrib.sessions.middleware.SessionMiddleware',  # Maneja sesiones de usuario
    'django.middleware.common.CommonMiddleware',  # Funcionalidad común (trailing slash, etc.)
    'django.middleware.csrf.CsrfViewMiddleware',  # Protección CSRF
    'django.contrib.auth.middleware.AuthenticationMiddleware',  # Identifica usuario por sesión/token
    'django.contrib.messages.middleware.MessageMiddleware',  # Sistema de mensajes flash
    'django.middleware.clickjacking.XFrameOptionsMiddleware',  # Protección clickjacking
]

# Archivo principal de configuración de URLs
ROOT_URLCONF = 'byeolpedia_api.urls'

# ==============================================================================
# TEMPLATES
# ==============================================================================

# Configuración del motor de templates de Django
# Aunque usamos API REST (JSON), Django Admin necesita templates
TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],  # Carpetas adicionales de templates (vacío = solo app templates)
        'APP_DIRS': True,  # Buscar templates en carpeta templates/ de cada app
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

# Aplicación WSGI (servidor web)
WSGI_APPLICATION = 'byeolpedia_api.wsgi.application'

# ==============================================================================
# BASE DE DATOS
# ==============================================================================

# OPCIÓN 1: SQLite (RECOMENDADO PARA MVP/DESARROLLO)
# SQLite es un archivo de base de datos local, perfecto para desarrollo.
# Ventajas: Cero configuración, rápido, suficiente para MVP
# Desventajas: No soporta alta concurrencia, menos features avanzados
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',  # Archivo de BD en la raíz del proyecto
    }
}

# OPCIÓN 2: PostgreSQL (PARA PRODUCCIÓN)
# Descomenta esto cuando despliegues a producción o necesites PostgreSQL.
# Necesitarás:
# 1. Instalar PostgreSQL en tu sistema
# 2. Crear la base de datos: createdb byeolpedia_db
# 3. Instalar driver: pip install psycopg2-binary
# 4. Configurar variables en .env: DB_NAME, DB_USER, DB_PASSWORD, DB_HOST, DB_PORT
# 5. Comentar el bloque SQLite de arriba
#
# DATABASES = {
#     'default': {
#         'ENGINE': 'django.db.backends.postgresql',
#         'NAME': config('DB_NAME', default='byeolpedia_db'),
#         'USER': config('DB_USER', default='postgres'),
#         'PASSWORD': config('DB_PASSWORD'),
#         'HOST': config('DB_HOST', default='localhost'),
#         'PORT': config('DB_PORT', default='5432'),
#     }
# }

# ==============================================================================
# AUTENTICACIÓN Y CONTRASEÑAS
# ==============================================================================

# Modelo de usuario personalizado
# CRÍTICO: Esto DEBE configurarse ANTES de la primera migración.
# Una vez que hagas migrate, no puedes cambiar esto fácilmente.
# Usamos nuestro modelo User extendido en lugar del modelo User por defecto de Django.
AUTH_USER_MODEL = 'users.User'

# Validadores de contraseña
# Django valida que las contraseñas cumplan estos requisitos al crear/cambiar contraseña
AUTH_PASSWORD_VALIDATORS = [
    {
        # No permitir contraseñas muy similares a datos del usuario (username, email, etc.)
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        # Mínimo 8 caracteres
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
        'OPTIONS': {
            'min_length': 8,
        }
    },
    {
        # No permitir contraseñas comunes (password123, qwerty, etc.)
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        # No permitir contraseñas puramente numéricas (12345678)
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]

# ==============================================================================
# DJANGO REST FRAMEWORK
# ==============================================================================

# Configuración global de Django REST Framework
REST_FRAMEWORK = {
    # Autenticación: Cómo identificamos al usuario en cada request
    # Usamos JWT (JSON Web Tokens) en header Authorization: Bearer <token>
    'DEFAULT_AUTHENTICATION_CLASSES': [
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    ],
    
    # Permisos: Quién puede acceder a cada endpoint
    # IsAuthenticatedOrReadOnly = Lectura pública, escritura solo autenticados
    'DEFAULT_PERMISSION_CLASSES': [
        'rest_framework.permissions.IsAuthenticatedOrReadOnly',
    ],
    
    # Paginación: Cómo dividir listas largas en páginas
    # Endpoint retorna 20 items por página + links next/previous
    # Ejemplo: /api/photocards/?page=2
    'DEFAULT_PAGINATION_CLASS': 'rest_framework.pagination.PageNumberPagination',
    'PAGE_SIZE': 20,
    
    # Renderers: Cómo formatear la respuesta
    # JSONRenderer = Retorna JSON (para Flutter)
    # BrowsableAPIRenderer = Interfaz web navegable (solo desarrollo, útil para testing)
    'DEFAULT_RENDERER_CLASSES': [
        'rest_framework.renderers.JSONRenderer',
        'rest_framework.renderers.BrowsableAPIRenderer',  # Quitar en producción si quieres
    ],
    
    # Parsers: Qué formatos de entrada aceptamos
    # JSON para datos normales, MultiPart para subida de imágenes
    'DEFAULT_PARSER_CLASSES': [
        'rest_framework.parsers.JSONParser',
        'rest_framework.parsers.MultiPartParser',  # Para upload de imágenes
        'rest_framework.parsers.FormParser',
    ],
    
    # Throttling: Límite de requests por tiempo para evitar abuso
    # Anónimos: 100 requests/hora
    # Autenticados: 1000 requests/hora
    'DEFAULT_THROTTLE_CLASSES': [
        'rest_framework.throttling.AnonRateThrottle',
        'rest_framework.throttling.UserRateThrottle',
    ],
    'DEFAULT_THROTTLE_RATES': {
        'anon': '100/hour',
        'user': '1000/hour',
    },
    
    # Filtros: Capacidades de filtrado automáticas
    # Ejemplo: /api/groups/?group_type=boy_group&search=BTS
    'DEFAULT_FILTER_BACKENDS': [
        'django_filters.rest_framework.DjangoFilterBackend',  # Filtros exactos
        'rest_framework.filters.SearchFilter',  # Búsqueda por texto
        'rest_framework.filters.OrderingFilter',  # Ordenamiento
    ],
}

# ==============================================================================
# JWT (JSON WEB TOKENS)
# ==============================================================================

# Configuración de autenticación con JWT
# JWT es un estándar para tokens de autenticación sin estado
SIMPLE_JWT = {
    # Duración del access token (token principal para hacer requests)
    # 1 hora es suficiente: si expira, Flutter usa refresh token para obtener uno nuevo
    'ACCESS_TOKEN_LIFETIME': timedelta(hours=1),
    
    # Duración del refresh token (token para renovar access tokens)
    # 7 días: el usuario permanece "logueado" una semana sin re-ingresar password
    'REFRESH_TOKEN_LIFETIME': timedelta(days=7),
    
    # Rotación de refresh tokens: más seguro
    # Cada vez que usas un refresh token, obtienes uno nuevo y el viejo se invalida
    'ROTATE_REFRESH_TOKENS': True,
    
    # Añadir refresh tokens viejos a blacklist al rotar
    # Evita que tokens robados puedan reusarse
    'BLACKLIST_AFTER_ROTATION': True,
    
    # Algoritmo de firma de tokens
    'ALGORITHM': 'HS256',
    'SIGNING_KEY': SECRET_KEY,  # Usa nuestra SECRET_KEY para firmar tokens
    
    # Tipo de header de autenticación
    # Flutter enviará: Authorization: Bearer <access_token>
    'AUTH_HEADER_TYPES': ('Bearer',),
    
    # Qué campo del User usar como identificador en el token
    'USER_ID_FIELD': 'id',
    'USER_ID_CLAIM': 'user_id',
    
    # Tipo de token
    'AUTH_TOKEN_CLASSES': ('rest_framework_simplejwt.tokens.AccessToken',),
    'TOKEN_TYPE_CLAIM': 'token_type',
}

# ==============================================================================
# CORS (Cross-Origin Resource Sharing)
# ==============================================================================

# CORS controla qué dominios pueden hacer peticiones a nuestra API
# Necesario porque Flutter (localhost:flutter) hace peticiones a Django (localhost:8000)
# Sin CORS, el navegador bloquearía estas peticiones por seguridad

if DEBUG:
    # En desarrollo: permitir TODOS los orígenes (más cómodo para testing)
    CORS_ALLOW_ALL_ORIGINS = True
else:
    # En producción: solo dominios específicos permitidos
    CORS_ALLOWED_ORIGINS = [
        "https://tudominio.com",  # Tu dominio de producción
        "https://app.byeolpedia.com",  # Si tienes subdominio para la app
    ]

# Headers HTTP que Flutter puede enviar
CORS_ALLOW_HEADERS = [
    'accept',
    'accept-encoding',
    'authorization',  # Crítico: para enviar tokens JWT
    'content-type',
    'dnt',
    'origin',
    'user-agent',
    'x-csrftoken',
    'x-requested-with',
]

# Métodos HTTP permitidos
CORS_ALLOW_METHODS = [
    'DELETE',
    'GET',
    'OPTIONS',  # Crítico: navegadores envían OPTIONS antes de peticiones CORS
    'PATCH',
    'POST',
    'PUT',
]

# Permitir envío de cookies y headers de autenticación
CORS_ALLOW_CREDENTIALS = True

# ==============================================================================
# INTERNACIONALIZACIÓN
# ==============================================================================

# Idioma por defecto de Django Admin y mensajes del sistema
LANGUAGE_CODE = 'es-es'

# Zona horaria para timestamps
# Todos los timestamps en BD se guardan en UTC, pero se muestran en esta zona
TIME_ZONE = 'Europe/Madrid'

# Habilitar traducción de strings (i18n)
USE_I18N = True

# Usar timestamps timezone-aware (recomendado)
# Todos los DateTimeField tendrán zona horaria
USE_TZ = True

# ==============================================================================
# ARCHIVOS ESTÁTICOS (CSS, JavaScript, imágenes del código)
# ==============================================================================

# URL desde donde se sirven archivos estáticos
# Ejemplo: /static/admin/css/base.css
STATIC_URL = '/static/'

# Carpeta donde se recopilan todos los archivos estáticos en producción
# Ejecutar: python manage.py collectstatic
STATIC_ROOT = BASE_DIR / 'staticfiles'

# ==============================================================================
# ARCHIVOS MEDIA (Uploads de usuarios)
# ==============================================================================

# URL desde donde se sirven archivos subidos por usuarios
# Ejemplo: /media/profiles/user123.jpg
MEDIA_URL = '/media/'

# Carpeta física donde se guardan archivos subidos
MEDIA_ROOT = BASE_DIR / 'media'

# Crear carpeta media si no existe (útil en primer setup)
os.makedirs(MEDIA_ROOT, exist_ok=True)

# ==============================================================================
# DEFAULT PRIMARY KEY
# ==============================================================================

# Tipo de clave primaria por defecto para modelos sin PK explícita
# BigAutoField = entero de 64 bits (soporta más registros que AutoField de 32 bits)
DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

# ==============================================================================
# LOGGING (Sistema de logs)
# ==============================================================================

# Configuración de logging para debugging y monitoreo
# Los logs se escriben en consola y en archivo debug.log
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    
    # Formatos de log
    'formatters': {
        'verbose': {
            'format': '{levelname} {asctime} {module} {message}',
            'style': '{',
        },
    },
    
    # Destinos de logs
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',  # Imprimir en terminal
            'formatter': 'verbose',
        },
        'file': {
            'class': 'logging.FileHandler',
            'filename': BASE_DIR / 'debug.log',  # Archivo de logs
            'formatter': 'verbose',
        },
    },
    
    # Logger raíz (por defecto)
    'root': {
        'handlers': ['console'],
        'level': 'INFO',
    },
    
    # Loggers específicos
    'loggers': {
        'django': {
            'handlers': ['console', 'file'],
            'level': 'INFO',
            'propagate': False,
        },
        'django.db.backends': {
            'handlers': ['console'],
            'level': 'WARNING',  # Cambiar a DEBUG para ver todas las queries SQL
            'propagate': False,
        },
    },
}

# ==============================================================================
# CONFIGURACIONES DE SEGURIDAD PARA PRODUCCIÓN
# ==============================================================================

# Estas configuraciones solo se activan cuando DEBUG=False (producción)
if not DEBUG:
    # Forzar redirección de HTTP a HTTPS
    SECURE_SSL_REDIRECT = True
    
    # Solo enviar cookies de sesión por HTTPS
    SESSION_COOKIE_SECURE = True
    
    # Solo enviar CSRF token por HTTPS
    CSRF_COOKIE_SECURE = True
    
    # Activar filtro XSS del navegador
    SECURE_BROWSER_XSS_FILTER = True
    
    # Prevenir sniffing de MIME types
    SECURE_CONTENT_TYPE_NOSNIFF = True
    
    # Prevenir que la página se cargue en iframe (protección clickjacking)
    X_FRAME_OPTIONS = 'DENY'
    
    # HSTS: Forzar HTTPS por 1 año
    # El navegador recordará usar solo HTTPS en este dominio
    SECURE_HSTS_SECONDS = 31536000
    SECURE_HSTS_INCLUDE_SUBDOMAINS = True
    SECURE_HSTS_PRELOAD = True