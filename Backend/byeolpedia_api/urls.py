"""
URL configuration for byeolpedia_api project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include
from .admin import admin_site
from rest_framework_simplejwt.views import TokenRefreshView

from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status

@api_view(['GET'])
def home_view(request):
    """Vista principal de la API"""
    return Response({
        'message': 'Bienvenido a Byeolpedia API',
        'version': '1.0.0',
        'endpoints': {
            'auth': '/api/auth/',
            'catalog': '/api/catalog/',
            'collection': '/api/collection/',
            'admin': '/admin/',
            'docs': '/api/docs/'
        }
    }, status=status.HTTP_200_OK)

urlpatterns = [
    # Página principal
    path('', home_view, name='home'),
    
    # Admin
    path('admin/', admin.site.urls),  # Admin por defecto
    path('byeolpedia-admin/', admin_site.urls),  # Admin personalizado
    
    # API REST
    path('api/auth/', include('users.urls')),  # Autenticación y usuarios
    path('api/auth/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),  # Refresh token
    path('api/catalog/', include('catalog.urls')),  # Catálogo de productos
    path('api/collection/', include('collection.urls')),  # Colección personal
    
    # API Root (opcional, para documentación)
    path('api/', include('rest_framework.urls')),
]
