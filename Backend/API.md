# API REST de Byeolpedia

Esta documentación describe los endpoints disponibles en la API REST de Byeolpedia para el tracking de colecciones de K-Pop.

## Base URL

```
http://localhost:8000/api/
```

## Autenticación

La API utiliza tokens JWT (JSON Web Tokens) para la autenticación. Para acceder a los endpoints protegidos, incluye el token en el header:

```
Authorization: Bearer <access_token>
```

## Endpoints

### Autenticación y Usuarios (`/api/auth/`)

#### Registro de Usuario
- **POST** `/api/auth/register/`
- **Descripción**: Crea una nueva cuenta de usuario
- **Body**:
```json
{
    "username": "usuario123",
    "email": "usuario@example.com",
    "collector_name": "Nombre Coleccionista",
    "password": "contraseña_segura",
    "password_confirm": "contraseña_segura"
}
```
- **Respuesta**:
```json
{
    "user": {
        "id": "uuid",
        "username": "usuario123",
        "email": "usuario@example.com",
        "collector_name": "Nombre Coleccionista",
        "profile_pic": null,
        "created_at": "2025-01-01T00:00:00Z",
        "total_albums": 0,
        "total_photocards": 0,
        "total_lightsticks": 0
    },
    "tokens": {
        "refresh": "refresh_token",
        "access": "access_token"
    }
}
```

#### Login
- **POST** `/api/auth/login/`
- **Descripción**: Inicia sesión y devuelve tokens JWT
- **Body**:
```json
{
    "email": "usuario@example.com",
    "password": "contraseña_segura"
}
```

#### Logout
- **POST** `/api/auth/logout/`
- **Descripción**: Cierra sesión y invalida el token
- **Headers**: Requiere token de acceso
- **Body**:
```json
{
    "refresh": "refresh_token"
}
```

#### Perfil de Usuario
- **GET** `/api/auth/profile/`
- **Descripción**: Obtiene el perfil del usuario autenticado
- **PATCH** `/api/auth/profile/`
- **Descripción**: Actualiza el perfil del usuario
- **Headers**: Requiere token de acceso

#### Estadísticas del Usuario
- **GET** `/api/auth/stats/`
- **Descripción**: Obtiene estadísticas detalladas de la colección del usuario

#### Refresh Token
- **POST** `/api/auth/token/refresh/`
- **Descripción**: Renueva el token de acceso usando un refresh token

### Catálogo (`/api/catalog/`)

#### Grupos
- **GET** `/api/catalog/groups/`
- **Descripción**: Lista todos los grupos K-Pop
- **Filtros**:
  - `group_type`: boy_group, girl_group, co_ed, etc.
  - `agency`: Nombre de la agencia
  - `search`: Búsqueda por nombre
- **GET** `/api/catalog/groups/{id}/`
- **Descripción**: Obtiene detalles de un grupo específico

#### Miembros
- **GET** `/api/catalog/members/`
- **Descripción**: Lista todos los miembros
- **Filtros**:
  - `group`: ID del grupo
  - `position`: Posición en el grupo
  - `is_active`: true/false

#### Álbumes
- **GET** `/api/catalog/albums/`
- **Descripción**: Lista todos los álbumes
- **Filtros**:
  - `group`: ID del grupo
  - `album_type`: full_album, mini_album, single, etc.
  - `release_year`: Año de lanzamiento

#### Photocards
- **GET** `/api/catalog/photocards/`
- **Descripción**: Lista todas las photocards
- **Filtros**:
  - `group`: ID del grupo
  - `member`: ID del miembro
  - `album_version`: ID de la versión del álbum
  - `photocard_type`: Tipo de photocard

#### Lightsticks
- **GET** `/api/catalog/lightsticks/`
- **Descripción**: Lista todos los lightsticks
- **Filtros**:
  - `group`: ID del grupo
  - `version`: Versión del lightstick

### Colección Personal (`/api/collection/`)

#### Objetos en Colección
- **GET** `/api/collection/collectibles/`
- **Descripción**: Lista los objetos en la colección del usuario
- **POST** `/api/collection/collectibles/`
- **Descripción**: Añade un nuevo objeto a la colección
- **Filtros**:
  - `collectible_type`: photocard, lightstick
  - `condition`: Estado del objeto
  - `is_duplicate`: true/false
  - `min_price`/`max_price`: Rango de precios

#### Wishlist
- **GET** `/api/collection/wishlist/`
- **Descripción**: Lista los items en la wishlist del usuario
- **POST** `/api/collection/wishlist/`
- **Descripción**: Añade un item a la wishlist

#### Grupos Favoritos
- **GET** `/api/collection/favorites/`
- **Descripción**: Lista los grupos favoritos del usuario
- **POST** `/api/collection/favorites/add/`
- **Descripción**: Añade un grupo a favoritos

#### Estadísticas de Colección
- **GET** `/api/collection/stats/`
- **Descripción**: Obtiene estadísticas detalladas de la colección

#### Reconocimiento Visual de Lightsticks
- **POST** `/api/collection/lightstick-recognition/`
- **Descripción**: Reconoce un lightstick a partir de una imagen
- **Headers**: Requiere token de acceso
- **Body**:
```json
{
    "image": "base64_encoded_image_string"
}
```
- **Respuesta**:
```json
{
    "success": true,
    "lightstick": {
        "id": "uuid",
        "name": "Lightstick Ver.2",
        "group": "ITZY",
        "confidence": 0.85
    },
    "alternatives": [
        {
            "id": "uuid2",
            "name": "Lightstick Ver.1",
            "confidence": 0.12
        }
    ]
}
```

#### Información de Reconocimiento
- **GET** `/api/collection/lightstick-recognition/info/`
- **Descripción**: Obtiene información sobre el sistema de reconocimiento

## Paginación

La mayoría de los endpoints que devuelven listas están paginados con 20 items por página. Usa los siguientes parámetros:

- `page`: Número de página (empezando desde 1)
- `page_size`: Cantidad de items por página (máximo 100)

Ejemplo: `/api/catalog/photocards/?page=2&page_size=50`

## Ordenamiento

Muchos endpoints permiten ordenamiento usando el parámetro `ordering`:

- `ordering=field`: Orden ascendente
- `ordering=-field`: Orden descendente

Ejemplo: `/api/catalog/albums/?ordering=-release_date`

## Códigos de Error

- `200`: OK
- `201`: Creado
- `400`: Bad Request (datos inválidos)
- `401`: No autorizado (token inválido o ausente)
- `403`: Prohibido (sin permisos)
- `404`: No encontrado
- `500`: Error del servidor

## Ejemplos de Uso

### Obtener todos los grupos de tipo "boy_group"
```
GET /api/catalog/groups/?group_type=boy_group
```

### Buscar photocards de BTS
```
GET /api/catalog/photocards/?search=BTS
```

### Añadir una photocard a la colección
```
POST /api/collection/collectibles/
Authorization: Bearer <access_token>
{
    "collectible_type": "photocard",
    "photocard": "photocard_uuid",
    "source": "Compra en tienda oficial",
    "acquisition_date": "2025-01-01",
    "purchase_price": "15.00",
    "condition": "excelente",
    "is_duplicate": false
}
```

### Obtener estadísticas del usuario
```
GET /api/collection/stats/
Authorization: Bearer <access_token>
```

## Administración

El panel de administración está disponible en:
- `/admin/`: Administración por defecto de Django
- `/byeolpedia-admin/`: Administración personalizada de Byeolpedia