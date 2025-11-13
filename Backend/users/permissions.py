from rest_framework import permissions


class IsOwnerOrReadOnly(permissions.BasePermission):
    """
    Permiso personalizado que solo permite al dueño del objeto editarlo.
    Los usuarios no autenticados solo tienen acceso de lectura.
    """
    
    def has_object_permission(self, request, view, obj):
        # Los permisos de lectura están permitidos para cualquier solicitud
        if request.method in permissions.SAFE_METHODS:
            return True
        
        # Los permisos de escritura solo están permitidos para el dueño del objeto
        return obj.user == request.user


class IsOwner(permissions.BasePermission):
    """
    Permiso personalizado que solo permite al dueño del objeto acceder a él.
    """
    
    def has_object_permission(self, request, view, obj):
        return obj.user == request.user