# Byeolpedia Frontend

Frontend de la aplicación Byeolpedia - Kpop Tracker MVP desarrollado con Flutter.

## 🚀 Configuración Rápida

### Requisitos Previos

- Flutter SDK (3.10.1 o superior)
- Dart SDK
- Un editor de código (VS Code recomendado con extensión Flutter)

### Instalación y Ejecución

1. **Navegar a la carpeta del frontend**

   ```bash
   cd Frontend
   ```

2. **Instalar dependencias**

   ```bash
   flutter pub get
   ```

3. **Generar archivos JSON serializados** (si se modifican los modelos)

   ```bash
   flutter packages pub run build_runner build
   ```

4. **Ejecutar la aplicación**

   ```bash
   flutter run
   ```

   O para ejecutar en un navegador web:
   ```bash
   flutter run -d chrome
   ```

## 🏗️ Estructura del Proyecto

```
lib/
├── core/                          # Configuración y utilidades principales
│   ├── config/                     # Configuraciones de la aplicación
│   │   └── api_config.dart        # Configuración de URLs de API
│   ├── constants/                   # Constantes de la aplicación
│   └── utils/                      # Utilidades generales
├── data/                          # Capa de datos
│   ├── models/                      # Modelos de datos
│   │   ├── user.dart               # Modelo de usuario
│   │   └── group.dart              # Modelo de grupos K-Pop
│   ├── repositories/                 # Repositorios (implementación de datos)
│   └── services/                    # Servicios de API
│       ├── api_service.dart         # Servicio HTTP base con Dio
│       └── auth_service.dart        # Servicio de autenticación
└── features/                       # Características de la aplicación
    ├── auth/                        # Autenticación
    │   ├── screens/                  # Pantallas de auth
    │   │   └── login_screen.dart   # Pantalla de login
    │   └── widgets/                  # Widgets de auth
    │       └── login_form.dart      # Formulario de login
    ├── catalog/                     # Catálogo de K-Pop
    ├── collection/                   # Colección personal
    └── common/                      # Componentes compartidos
        ├── screens/                  # Pantallas comunes
        │   └── home_screen.dart    # Pantalla principal
        └── widgets/                  # Widgets comunes
```

## 🛠️ Tecnologías Utilizadas

- **Flutter**: Framework principal para el frontend
- **Dio**: Cliente HTTP para llamadas a la API
- **Provider**: Gestión de estado
- **Go Router**: Navegación (configurado para uso futuro)
- **Shared Preferences**: Almacenamiento local
- **JSON Annotation**: Serialización de datos
- **TensorFlow Lite**: Reconocimiento de imágenes (futuro)

## 🔧 Configuración de la API

La configuración de la API se encuentra en `lib/core/config/api_config.dart`. Por defecto apunta a:

```
http://localhost:8000/api
```

Para cambiar la URL base, modifica la constante `baseUrl` en el archivo mencionado.

## 📱 Funcionalidades Implementadas

### Autenticación
- ✅ Login de usuario
- ✅ Gestión de tokens JWT
- ✅ Almacenamiento local de sesión
- ✅ Logout

### Pantallas
- ✅ Pantalla de login
- ✅ Pantalla principal (home)
- ✅ Navegación inferior

### Servicios
- ✅ Servicio de API base con Dio
- ✅ Servicio de autenticación
- ✅ Manejo de errores HTTP
- ✅ Interceptores para logging

## 🧪 Pruebas

Para ejecutar las pruebas:

```bash
flutter test
```

Para analizar el código en busca de problemas:

```bash
flutter analyze
```

## 🔄 Desarrollo

### Generar archivos JSON serializados

Cuando se modifican los modelos de datos (archivos en `lib/data/models/`), es necesario regenerar los archivos JSON:

```bash
flutter packages pub run build_runner build
```

### Limpiar y reconstruir

Si encuentras problemas de dependencias:

```bash
flutter clean
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## 📝 Notas para el Desarrollo

1. **Estado de la Aplicación**: Se utiliza Provider para la gestión de estado global
2. **Navegación**: Configurada con Go Router para expansión futura
3. **API**: Integración completa con el backend Django REST API
4. **Autenticación**: Implementación completa con JWT tokens
5. **UI**: Diseño Material 3 con tema personalizado

## 🚀 Próximos Pasos

Las siguientes funcionalidades están planificadas para desarrollo futuro:

- [ ] Registro de usuarios
- [ ] Recuperación de contraseña
- [ ] Catálogo completo de grupos, álbumes, photocards y lightsticks
- [ ] Gestión de colección personal
- [ ] Sistema de wishlist
- [ ] Reconocimiento de lightsticks con TensorFlow Lite
- [ ] Perfil de usuario
- [ ] Configuración de la aplicación

## 🐛 Problemas Conocidos

- Los warnings sobre variables no utilizadas en los bloques catch son menores y no afectan el funcionamiento
- El método `_refreshAccessToken` en AuthService está implementado pero no utilizado actualmente

## 📄 Licencia

Este proyecto está bajo la Licencia MIT.
