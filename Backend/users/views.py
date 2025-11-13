from rest_framework import generics, status, permissions
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth import get_user_model
from django.db import models
from .serializers import (
    UserRegistrationSerializer,
    UserLoginSerializer,
    UserProfileSerializer,
    UserUpdateSerializer
)

User = get_user_model()


class UserRegistrationView(generics.CreateAPIView):
    """Vista para el registro de nuevos usuarios"""
    queryset = User.objects.all()
    serializer_class = UserRegistrationSerializer
    permission_classes = [permissions.AllowAny]

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()
        
        # Generar tokens para el usuario recién registrado
        refresh = RefreshToken.for_user(user)
        
        return Response({
            'user': UserProfileSerializer(user).data,
            'tokens': {
                'refresh': str(refresh),
                'access': str(refresh.access_token),
            }
        }, status=status.HTTP_201_CREATED)


@api_view(['POST'])
@permission_classes([permissions.AllowAny])
def login_view(request):
    """Vista para el login de usuarios"""
    serializer = UserLoginSerializer(data=request.data, context={'request': request})
    serializer.is_valid(raise_exception=True)
    
    user = serializer.validated_data['user']
    refresh = RefreshToken.for_user(user)
    
    return Response({
        'user': UserProfileSerializer(user).data,
        'tokens': {
            'refresh': str(refresh),
            'access': str(refresh.access_token),
        }
    })


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def logout_view(request):
    """Vista para el logout de usuarios"""
    try:
        refresh_token = request.data.get('refresh')
        if refresh_token:
            token = RefreshToken(refresh_token)
            token.blacklist()
        return Response({'message': 'Logout exitoso'}, status=status.HTTP_200_OK)
    except Exception as e:
        return Response({'error': 'Error al hacer logout'}, status=status.HTTP_400_BAD_REQUEST)


class UserProfileView(generics.RetrieveUpdateAPIView):
    """Vista para ver y actualizar el perfil del usuario"""
    serializer_class = UserProfileSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_object(self):
        return self.request.user

    def get_serializer_class(self):
        if self.request.method == 'PATCH' or self.request.method == 'PUT':
            return UserUpdateSerializer
        return UserProfileSerializer

    def update(self, request, *args, **kwargs):
        partial = kwargs.pop('partial', False)
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=partial)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        
        # Devolver el perfil completo actualizado
        return Response(UserProfileSerializer(instance).data)


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def user_stats_view(request):
    """Vista para obtener estadísticas del usuario"""
    user = request.user
    from collection.models import UserCollectible, WishlistItem, UserFavoriteGroup
    
    # Estadísticas básicas
    total_photocards = UserCollectible.objects.filter(
        user=user, collectible_type='photocard'
    ).count()
    
    total_lightsticks = UserCollectible.objects.filter(
        user=user, collectible_type='lightstick'
    ).count()
    
    # Álbumes únicos (contando por versión de álbum)
    albums = UserCollectible.objects.filter(
        user=user, collectible_type='photocard'
    ).values('photocard__album_version__album').distinct()
    total_albums = albums.count()
    
    # Valor total de la colección
    total_value = UserCollectible.objects.filter(
        user=user
    ).aggregate(
        total=models.Sum('purchase_price')
    )['total'] or 0
    
    # Duplicados
    duplicate_photocards = UserCollectible.objects.filter(
        user=user, collectible_type='photocard', is_duplicate=True
    ).count()
    
    duplicate_lightsticks = UserCollectible.objects.filter(
        user=user, collectible_type='lightstick', is_duplicate=True
    ).count()
    
    # Wishlist y favoritos
    wishlist_items = WishlistItem.objects.filter(user=user).count()
    favorite_groups = UserFavoriteGroup.objects.filter(user=user).count()
    
    # Completitud por grupo
    from django.db.models import Count, Q
    from catalog.models import Group, Photocard
    
    completion_by_group = []
    user_groups = UserFavoriteGroup.objects.filter(user=user).values_list('group', flat=True)
    
    for group_id in user_groups:
        group = Group.objects.get(id=group_id)
        total_photocards_in_group = Photocard.objects.filter(group=group).count()
        user_photocards_in_group = UserCollectible.objects.filter(
            user=user, 
            collectible_type='photocard',
            photocard__group=group
        ).count()
        
        if total_photocards_in_group > 0:
            completion_percentage = (user_photocards_in_group / total_photocards_in_group) * 100
            completion_by_group.append({
                'group_name': group.name,
                'total_photocards': total_photocards_in_group,
                'user_photocards': user_photocards_in_group,
                'completion_percentage': round(completion_percentage, 2)
            })
    
    return Response({
        'total_albums': total_albums,
        'total_photocards': total_photocards,
        'total_lightsticks': total_lightsticks,
        'total_value': total_value,
        'duplicate_photocards': duplicate_photocards,
        'duplicate_lightsticks': duplicate_lightsticks,
        'wishlist_items': wishlist_items,
        'favorite_groups': favorite_groups,
        'completion_by_group': completion_by_group
    })
