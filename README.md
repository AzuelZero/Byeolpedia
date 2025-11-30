# Byeolpedia - Kpop Tracker MVP

Byeolpedia es una aplicación para seguimiento de grupos de kpop, álbumes,
photocards y lightsticks. Este proyecto consiste en un backend con Django REST
API y un frontend con Flutter.

## 🚀 Instalación Automatizada

### Requisitos Previos

- Python 3.8+
- pip y virtualenv
- Git
- Flutter (solo para el frontend)

### Instalación con un solo comando

Hemos creado scripts automatizados para configurar todo el proyecto de forma sencilla:

#### Para Windows:

```bash
git clone https://github.com/tu-usuario/byeolpedia.git
cd byeolpedia
setup.bat
```

#### Para macOS/Linux:

```bash
git clone https://github.com/tu-usuario/byeolpedia.git
cd byeolpedia
chmod +x setup.sh
./setup.sh
```

Estos scripts realizarán automáticamente:
- ✅ Creación del entorno virtual
- ✅ Instalación de dependencias de Python
- ✅ Configuración de variables de entorno (.env)
- ✅ Generación automática de SECRET_KEY
- ✅ Ejecución de migraciones de la base de datos
- ✅ Opción para crear superusuario
- ✅ Configuración del frontend (opcional)

### Pasos posteriores a la instalación

Una vez completada la instalación automatizada:

1. **Activa el entorno virtual** (si no está activado):
   ```bash
   # Windows
   venv\Scripts\activate
   
   # macOS/Linux
   source venv/bin/activate
   ```

2. **Inicia el servidor backend**:
   ```bash
   cd Backend
   python manage.py runserver
   ```

3. **Inicia el frontend** (si lo configuraste):
   ```bash
   cd Frontend
   flutter run
   ```

### Acceso a la aplicación

- **API Backend**: http://localhost:8000/
- **Panel de administración**: http://localhost:8000/admin/
- **Frontend Flutter**: Se ejecutará en tu dispositivo/emulador o navegador

## 🔧 Instalación Manual (Opcional)

Si prefieres realizar la instalación manualmente o necesitas más control sobre el proceso:

### Backend

1. **Crea y activa un entorno virtual**

   ```bash
   # Windows
   python -m venv venv
   venv\Scripts\activate
   
   # macOS/Linux
   python3 -m venv venv
   source venv/bin/activate
   ```

2. **Instala las dependencias**

   ```bash
   cd Backend
   pip install -r requirements.txt
   ```

3. **Configura las variables de entorno**

   ```bash
   # Copia el archivo de ejemplo
   cp .env.example .env
   
   # Edita el archivo .env con tus valores
   # ¡NO SUBAS ESTE ARCHIVO A GIT!
   ```

4. **Genera una clave secreta para Django**

   ```bash
   python manage.py shell
   >>> from django.core.management.utils import get_random_secret_key
   >>> print(get_random_secret_key())
   ```

   Copia esta clave en tu archivo `.env` en la variable `SECRET_KEY`.

5. **Ejecuta las migraciones de la base de datos**

   ```bash
   python manage.py migrate
   ```

6. **Crea un superusuario (opcional)**

   ```bash
   python manage.py createsuperuser
   ```

7. **Inicia el servidor de desarrollo**

   ```bash
   python manage.py runserver
   ```

### Frontend

1. **Asegúrate de tener Flutter instalado**
   - Descarga desde: https://flutter.dev/docs/get-started/install

2. **Instala las dependencias**

   ```bash
   cd Frontend
   flutter pub get
   ```

3. **Ejecuta la aplicación**

   ```bash
   # En emulador/dispositivo
   flutter run
   
   # En navegador
   flutter run -d chrome
   ```

## 🔐 Configuración de Variables de Entorno

El proyecto utiliza variables de entorno para manejar información sensible como
claves secretas, credenciales de base de datos, etc.

### Archivos Importantes

- **`.env.example`**: Plantilla con las variables necesarias.
- **`.env`**: Configuración personal con valores reales (generado automáticamente por el script de instalación).

### Variables Obligatorias

Las siguientes variables son necesarias para que el proyecto funcione:

```bash
SECRET_KEY=tu-clave-secreta-generada-aqui
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1
```

> **Nota**: El script de instalación genera automáticamente la `SECRET_KEY` y crea el archivo `.env` por ti.

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

### Frontend
- **Flutter**: Framework multiplataforma para el frontend
- **TensorFlow Lite**: Ejecución de modelos de ML en el dispositivo
- **Provider**: Gestión de estado reactiva con ChangeNotifier para manejar el estado de la aplicación de manera eficiente y escalable
- **Dio**: Cliente HTTP robusto para comunicaciones API con soporte para interceptores, timeout y manejo de errores

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
│   ├── setup.bat              # Script de configuración para Windows
│   ├── setup.sh               # Script de configuración para Unix
│   └── README.md              # Documentación del backend
├── Frontend/                  # Frontend Flutter
│   ├── lib/                   # Código fuente de la aplicación
│   │   ├── app/               # Configuración principal de la app
│   │   ├── core/              # Utilidades y configuración global
│   │   ├── features/          # Módulos de funcionalidades
│   │   ├── shared/            # Componentes compartidos
│   │   └── main.dart          # Punto de entrada
│   ├── assets/                # Recursos (imágenes, fuentes, etc.)
│   ├── android/               # Configuración para Android
│   ├── ios/                   # Configuración para iOS
│   ├── pubspec.yaml           # Dependencias y configuración
│   ├── setup.bat              # Script de configuración para Windows
│   ├── setup.sh               # Script de configuración para Unix
│   └── README.md              # Documentación del frontend
├── .env.example               # Plantilla de variables de entorno
├── .gitignore                 # Archivos excluidos de Git
├── LICENSE                    # Licencia del proyecto
├── Logo App.png              # Logo de la aplicación
├── README.md                  # Este archivo
├── setup.bat                  # Script orquestador para Windows
└── setup.sh                   # Script orquestador para Unix
```

## 📚 Comandos Útiles

### Backend

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

# Crear superusuario
python manage.py createsuperuser
```

### Frontend

```bash
# Obtener dependencias
flutter pub get

# Limpiar compilación anterior
flutter clean

# Ejecutar en modo depuración
flutter run

# Ejecutar en navegador web
flutter run -d chrome

# Compilar APK para Android
flutter build apk

# Compilar para iOS
flutter build ios
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

## 🔧 Solución de Problemas (Troubleshooting)

### Problemas Comunes

#### El script de instalación falla

1. **Asegúrate de tener los requisitos previos instalados**:
   - Python 3.8+ con pip
   - Git
   - Flutter (solo para frontend)

2. **Permisos en Linux/macOS**:
   ```bash
   chmod +x setup.sh
   chmod +x Backend/setup.sh
   chmod +x Frontend/setup.sh
   ```

3. **Problemas con el entorno virtual**:
   ```bash
   # Eliminar entorno virtual existente y recrear
   rm -rf venv
   cd Backend && python -m venv ../venv
   ```

#### Error de SECRET_KEY

Si el script no puede generar la SECRET_KEY automáticamente:

```bash
# Generar manualmente
python manage.py shell
>>> from django.core.management.utils import get_random_secret_key
>>> print(get_random_secret_key())
```

Luego edita el archivo `Backend/.env` y reemplaza `tu-clave-secreta-generada-aqui` con la clave generada.

#### Problemas con Flutter

1. **Flutter no encontrado**:
   - Asegúrate de que Flutter esté en tu PATH
   - Reinicia tu terminal después de instalar Flutter

2. **Dependencias de Flutter**:
   ```bash
   cd Frontend
   flutter doctor
   flutter pub get
   ```

#### Problemas con la base de datos

```bash
# Si las migraciones fallan
cd Backend
python manage.py migrate --fake-initial
python manage.py migrate
```

### Obtener Ayuda

Si encuentras problemas no cubiertos aquí:

1. Revisa los README específicos:
   - [`Backend/README.md`](Backend/README.md) para problemas del backend
   - [`Frontend/README.md`](Frontend/README.md) para problemas del frontend

2. Crea un issue en el repositorio con:
   - Descripción detallada del problema
   - Sistema operativo y versión
   - Versión de Python/Flutter
   - Mensaje de error completo

## 📝 Contribuir

1. 🍴 Fork del proyecto
2. 🌿 Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. 💾 Commit de tus cambios (`git commit -am 'Añadir nueva funcionalidad'`)
4. 📤 Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. 🔃 Crea un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - mira el archivo [LICENSE](LICENSE) para
detalles.

## 🙏 Agradecimientos

- 「零は私のすべての始まりだ」 🐺
- Mi familia y amigos 💙
- La música, en todas sus facetas, porque sin ella no sería yo 🎼
- Las 4869 veces que me he tropezado 🥹
