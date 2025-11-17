
# Byeolpedia Frontend

Frontend de Byeolpedia desarrollado con Flutter según las especificaciones del TFG.

## Estado Actual del Proyecto

✅ **Configuración inicial completada**
- Flutter SDK 3.38.1 instalado y configurado
- Proyecto Flutter creado en la carpeta `Frontend/`
- Dependencias configuradas según especificaciones TFG
- Riverpod configurado para gestión de estado
- Estructura de carpetas básica creada
- Pruebas funcionando correctamente

## Dependencias Configuradas

Según las especificaciones técnicas del TFG:

### Gestión de Estado
- **flutter_riverpod**: ^2.5.1 - Gestión de estado reactiva

### Comunicación HTTP
- **dio**: ^5.4.3+1 - Cliente HTTP avanzado con interceptores

### Almacenamiento
- **flutter_secure_storage**: ^9.0.0 - Almacenamiento seguro para tokens
- **sqflite**: ^2.3.3+2 - Persistencia local y caché

### UI y Navegación
- **go_router**: ^14.2.0 - Navegación
- **cached_network_image**: ^3.3.1 - Caché de imágenes
- **flutter_localizations**: SDK - Internacionalización

### Machine Learning
- **tflite_flutter**: ^0.10.4 - Reconocimiento visual (TensorFlow Lite)

## Estructura del Proyecto

```
Frontend/
├── lib/
│   ├── main.dart              # Punto de entrada con ProviderScope configurado
│   ├── models/               # Modelos de datos (según RI01, RI02, RI03)
│   ├── services/             # Servicios y configuración de API
│   ├── screens/              # Pantallas de la aplicación
│   ├── widgets/             # Widgets reutilizables
│   └── utils/               # Utilidades varias
├── test/
│   └── widget_test.dart      # Pruebas básicas funcionando
└── pubspec.yaml            # Dependencias configuradas
```

## Configuración de la API

La configuración de la API se implementará en `lib/services/api_service.dart` 
apuntando al backend Django en `http://localhost:8000`.

## Ejecutar el Proyecto

### Modo Desarrollo (Chrome)
```bash
cd Frontend
flutter run -d chrome
```

### Modo Desarrollo (Windows Desktop)
```bash
cd Frontend
flutter run -d windows
```

### Ejecutar Pruebas
```bash
cd Frontend
flutter test
```

## Notas para el Desarrollo

1. **Arquitectura**: Seguir clean architecture con separación clara entre UI, lógica de negocio y datos
2. **Estado**: Usar Riverpod para gestión reactiva con providers para cada caso de uso
3. **API**: Configurar Dio con interceptores para autenticación y manejo de errores
4. **Testing**: Implementar pruebas unitarias y de widgets para cada componente
5. **Performance**: Optimizar carga de imágenes y consultas a base de datos
