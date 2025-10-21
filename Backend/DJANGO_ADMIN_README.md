# Django Admin para Byeolpedia

## ¿Qué es Django Admin?

Django Admin es una interfaz web automática que te permite gestionar los datos de tu aplicación sin necesidad de escribir código adicional para operaciones CRUD (Crear, Leer, Actualizar, Eliminar).

## Configuración realizada

### 1. Modelos configurados

Hemos configurado los siguientes modelos en el panel de administración:

#### Usuarios (`users`)
- **User**: Gestión de usuarios con campos personalizados (collector_name, profile_pic)
- Campos visibles: username, email, collector_name, is_staff, created_at
- Búsqueda por: username, email, collector_name
- Filtros por: is_staff, is_superuser, is_active, created_at

#### Catálogo (`catalog`)
- **Group**: Grupos kpop (ITZY, aespa, i-dle, NMIXX, LE SSERAFIM, etc.)
- **Member**: Miembros de los grupos
- **Album**: Álbumes de los grupos
- **AlbumVersion**: Versiones de los álbumes
- **Photocard**: Photocards individuales
- **Lightstick**: Lightsticks oficiales

#### Colección (`collection`)
- **UserCollectible**: Objetos en la colección de los usuarios
- **WishlistItem**: Objetos deseados por los usuarios
- **UserFavoriteGroup**: Grupos favoritos de los usuarios

### 2. Características especiales

- **Inlines**: Al editar un Grupo, puedes añadir/editar sus Miembros, Álbumes y Lightsticks directamente
- **Búsqueda y filtrado**: Todos los modelos tienen campos de búsqueda y filtros relevantes
- **Campos de solo lectura**: Los IDs y timestamps automáticos están protegidos
- **Métodos personalizados**: Para mostrar nombres de objetos relacionados

## Cómo acceder al panel de administración

### 1. Crear un superusuario

Primero, necesitas crear un superusuario que tenga acceso al panel de administración:

#### Opción A: Usar el script personalizado (recomendado)
```bash
cd Backend
python create_superuser.py
```

#### Opción B: Usar el comando de Django
```bash
cd Backend
python manage.py createsuperuser
```

### 2. Acceder al panel

Una vez creado el superusuario, puedes acceder al panel de administración en:

- **Panel estándar**: http://localhost:8000/admin/
- **Panel personalizado**: http://localhost:8000/byeolpedia-admin/

Ambos paneles tienen las mismas funcionalidades, pero el personalizado muestra "Byeolpedia" en el título.

## Uso recomendado

### Para añadir datos iniciales

1. **Crear grupos**: Empieza por añadir los grupos K-Pop básicos
2. **Añadir miembros**: Una vez creado un grupo, puedes añadir sus miembros
3. **Subir álbumes**: Añade los álbumes de cada grupo
4. **Añadir versiones**: Especifica las diferentes versiones de cada álbum
5. **Registrar photocards**: Añade las photocards de cada versión
6. **Lightsticks**: Registra los lightsticks oficiales

### Para gestionar usuarios

- Visualiza los usuarios registrados y sus colecciones
- Revisa las wishlists para entender qué productos son populares
- Consulta los grupos favoritos de cada usuario

### Para moderación

- Revisa las colecciones de los usuarios
- Verifica que los datos sean correctos
- Gestiona usuarios problemáticos si es necesario

## Personalización adicional

Si deseas personalizar aún más el panel de administración, puedes:

1. **Añadir más campos de búsqueda**
2. **Crear filtros personalizados**
3. **Añadir acciones en lote**
4. **Personalizar los formularios de edición**
5. **Añadir visualización de datos**

## Recursos útiles

- [Documentación oficial de Django Admin](https://docs.djangoproject.com/en/stable/ref/contrib/admin/)
- [Tutorial de Django Admin](https://docs.djangoproject.com/en/stable/intro/tutorial07/)