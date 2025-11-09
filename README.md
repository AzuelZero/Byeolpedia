# Byeolpedia - K-Pop Tracker MVP

Byeolpedia es una aplicación para seguimiento de grupos de K-Pop, álbumes,
photocards y lightsticks. Este proyecto consiste en un backend con Django REST
API y un frontend con Flutter.

## 🚀 Configuración Rápida

### Requisitos Previos

- Python 3.8+
- pip y virtualenv
- Git

### Instalación

1. **Clona el repositorio**

   ```bash
   git clone https://github.com/tu-usuario/byeolpedia.git
   cd byeolpedia
   ```

2. **Crea y activa un entorno virtual**

   ```bash
   # Windows
   python -m venv venv
   venv\Scripts\activate
   
   # macOS/Linux
   python3 -m venv venv
   source venv/bin/activate
   ```

3. **Instala las dependencias**

   ```bash
   cd Backend
   pip install -r requirements.txt
   ```

4. **Configura las variables de entorno**

   ```bash
   # Copia el archivo de ejemplo
   cp .env.example .env
   
   # Edita el archivo .env con tus valores
   # ¡NO SUBAS ESTE ARCHIVO A GIT!
   ```

5. **Genera una clave secreta para Django**

   ```bash
   python manage.py shell
   >>> from django.core.management.utils import get_random_secret_key
   >>> print(get_random_secret_key())
   ```

   Copia esta clave en tu archivo `.env` en la variable `SECRET_KEY`.

6. **Ejecuta las migraciones de la base de datos**

   ```bash
   python manage.py migrate
   ```

7. **Crea un superusuario (opcional)**

   ```bash
   python manage.py createsuperuser
   ```

8. **Inicia el servidor de desarrollo**

   ```bash
   python manage.py runserver
   ```

La API estará disponible en `http://localhost:8000/` y el panel de administración
en `http://localhost:8000/admin/`.

## 🔐 Configuración de Variables de Entorno

El proyecto utiliza variables de entorno para manejar información sensible como
claves secretas, credenciales de base de datos, etc.

### Archivos Importantes

- **`.env.example`**: Plantilla con las variables necesarias.
- **`.env`**: Configuración personal con valores reales.

### Variables Obligatorias

Las siguientes variables son necesarias para que el proyecto funcione:

```bash
SECRET_KEY=tu-clave-secreta-generada-aqui
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1
```

### Variables Opcionales

Dependiendo de tu configuración, puedes necesitar estas variables adicionales:

- **Base de datos PostgreSQL**: `DB_NAME`, `DB_USER`, `DB_PASSWORD`, `DB_HOST`, `DB_PORT`
- **Configuración de email**: `EMAIL_HOST`, `EMAIL_PORT`, `EMAIL_HOST_USER`, `EMAIL_HOST_PASSWORD`
- **Almacenamiento en la nube**: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_STORAGE_BUCKET_NAME`
- **APIs externas**: `SPOTIFY_CLIENT_ID`, `SPOTIFY_CLIENT_SECRET`, `YOUTUBE_API_KEY`

## 🛠️ Tecnologías Utilizadas

### Backend
- **Django REST Framework**: Framework principal para la API REST
- **PostgreSQL**: Base de datos principal (producción)
- **SQLite**: Base de datos para desarrollo
- **JWT**: Autenticación con JSON Web Tokens
- **Django Filters**: Filtrado avanzado de resultados
- **TensorFlow Lite**: Integración para reconocimiento de imágenes

### Frontend (Próximamente)
- **Flutter**: Framework multiplataforma para el frontend
- **TensorFlow Lite**: Ejecución de modelos de ML en el dispositivo
- **Provider**: Gestión de estado
- **HTTP**: Cliente para comunicaciones API

### DevOps
- **Docker**: Contenerización (opcional)
- **Git**: Control de versiones
- **GitHub**: Hospedaje del código

## 🏗️ Estructura del Proyecto

```text
byeolpedia/
├── Backend/                    # Backend Django REST API
│   ├── byeolpedia_api/        # Configuración principal de Django
│   ├── catalog/               # App de catálogo (grupos, álbumes, etc.)
│   ├── collection/            # App de colección personal y ML
│   │   ├── ml_views.py        # Vistas para Machine Learning
│   │   └── models.py          # Modelos de colección y reconocimiento
│   ├── users/                 # App de gestión de usuarios
│   │   ├── permissions.py     # Permisos personalizados
│   │   └── serializers.py     # Serializers de usuarios
│   ├── manage.py              # Script de gestión de Django
│   ├── requirements.txt       # Dependencias de Python
│   └── README.md              # Documentación del backend
├── Frontend/                  # Frontend Flutter (pendiente)
├── .env.example               # Plantilla de variables de entorno
├── .gitignore                 # Archivos excluidos de Git
├── LICENSE                    # Licencia del proyecto
├── Logo App.png              # Logo de la aplicación
├── README.md                  # Este archivo
├── setup.bat                  # Script de configuración para Windows
└── setup.sh                   # Script de configuración para Unix
```

### Comandos Útiles

```bash
# Crear nuevas migraciones después de cambiar modelos
python manage.py makemigrations

# Aplicar migraciones
python manage.py migrate

# Ejecutar tests
python manage.py test

# Recopilar archivos estáticos (producción)
python manage.py collectstatic

# Iniciar shell de Django
python manage.py shell
```

## 🚀 Despliegue

### Producción

Para desplegar en producción:

1. Cambia `DEBUG=False` en tu archivo `.env`
2. Configura `ALLOWED_HOSTS` con tu dominio real
3. Asegúrate de tener todas las variables de entorno configuradas
4. Ejecuta `python manage.py collectstatic`
5. Configura un servidor WSGI como Gunicorn u uWSGI

### Variables de Producción Adicionales

```bash
DEBUG=False
ALLOWED_HOSTS=byeolpedia.com,www.byeolpedia.com
SECURE_SSL_REDIRECT=True
```

## 📝 Contribuir

1. Fork del proyecto
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit de tus cambios (`git commit -am 'Añadir nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Crea un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - mira el archivo [LICENSE](LICENSE) para
detalles.

## 🙏 Agradecimientos

- Mi familia y amigos
- La música, en todas sus facetas, porque sin ella no sería yo
- Las 4869 veces que me he tropezado

