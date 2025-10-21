from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from .models import User


@admin.register(User)
class UserAdmin(BaseUserAdmin):
    # Campos que se mostrarán en la lista de usuarios
    list_display = ('username', 'email', 'collector_name', 'is_staff', 'created_at')
    
    # Campos por los que se puede buscar
    search_fields = ('username', 'email', 'collector_name')
    
    # Filtros laterales
    list_filter = ('is_staff', 'is_superuser', 'is_active', 'created_at')
    
    # Ordenamiento por defecto
    ordering = ('-created_at',)
    
    # Configuración del formulario de edición
    fieldsets = (
        (None, {'fields': ('username', 'password')}),
        ('Información personal', {'fields': ('first_name', 'last_name', 'email', 'collector_name', 'profile_pic')}),
        ('Permisos', {'fields': ('is_active', 'is_staff', 'is_superuser', 'groups', 'user_permissions')}),
        ('Fechas importantes', {'fields': ('last_login', 'date_joined', 'created_at')}),
    )
    
    # Campos que se mostrarán al crear un nuevo usuario
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('username', 'email', 'collector_name', 'password1', 'password2'),
        }),
    )
    
    # Campos de solo lectura
    readonly_fields = ('created_at',)
