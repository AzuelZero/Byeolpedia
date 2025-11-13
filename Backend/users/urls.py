from django.urls import path
from . import views

app_name = 'users'

urlpatterns = [
    # Autenticación
    path('register/', views.UserRegistrationView.as_view(), name='register'),
    path('login/', views.login_view, name='login'),
    path('logout/', views.logout_view, name='logout'),
    
    # Perfil de usuario
    path('profile/', views.UserProfileView.as_view(), name='profile'),
    path('stats/', views.user_stats_view, name='stats'),
]