from rest_framework import generics, permissions, status, filters
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from django_filters.rest_framework import DjangoFilterBackend
from django.db.models import Sum
from .models import UserCollectible, WishlistItem, UserFavoriteGroup
from .serializers import (
    UserCollectibleSerializer,
    UserCollectibleCreateSerializer,
    WishlistItemSerializer,
    WishlistItemCreateSerializer,
    UserFavoriteGroupSerializer,
    CollectionStatsSerializer
)
from .filters import UserCollectibleFilter, WishlistItemFilter
from users.permissions import IsOwnerOrReadOnly, IsOwner


class UserCollectibleListView(generics.ListCreateAPIView):
    """Vista para listar y crear objetos en la colección del usuario"""
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_class = UserCollectibleFilter
    search_fields = ['source', 'photocard__name', 'lightstick__name']
    ordering_fields = ['acquisition_date', 'added_at', 'purchase_price']
    ordering = ['-acquisition_date']

    def get_queryset(self):
        return UserCollectible.objects.filter(user=self.request.user)

    def get_serializer_class(self):
        if self.request.method == 'POST':
            return UserCollectibleCreateSerializer
        return UserCollectibleSerializer


class UserCollectibleDetailView(generics.RetrieveUpdateDestroyAPIView):
    """Vista para ver, actualizar y eliminar objetos de la colección"""
    serializer_class = UserCollectibleSerializer
    permission_classes = [IsOwnerOrReadOnly]

    def get_queryset(self):
        return UserCollectible.objects.filter(user=self.request.user)


class WishlistItemListView(generics.ListCreateAPIView):
    """Vista para listar y crear items en la wishlist del usuario"""
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_class = WishlistItemFilter
    search_fields = ['photocard__name', 'lightstick__name']
    ordering_fields = ['priority', 'added_at']
    ordering = ['-priority', '-added_at']

    def get_queryset(self):
        return WishlistItem.objects.filter(user=self.request.user)

    def get_serializer_class(self):
        if self.request.method == 'POST':
            return WishlistItemCreateSerializer
        return WishlistItemSerializer


class WishlistItemDetailView(generics.RetrieveUpdateDestroyAPIView):
    """Vista para ver, actualizar y eliminar items de la wishlist"""
    serializer_class = WishlistItemSerializer
    permission_classes = [IsOwnerOrReadOnly]

    def get_queryset(self):
        return WishlistItem.objects.filter(user=self.request.user)


class UserFavoriteGroupListView(generics.ListCreateAPIView):
    """Vista para listar y crear grupos favoritos del usuario"""
    serializer_class = UserFavoriteGroupSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return UserFavoriteGroup.objects.filter(user=self.request.user).order_by('-favorited_at')


class UserFavoriteGroupDetailView(generics.RetrieveDestroyAPIView):
    """Vista para eliminar grupos favoritos"""
    serializer_class = UserFavoriteGroupSerializer
    permission_classes = [IsOwner]

    def get_queryset(self):
        return UserFavoriteGroup.objects.filter(user=self.request.user)


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def collection_stats_view(request):
    """Vista para obtener estadísticas de la colección del usuario"""
    user = request.user
    
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
        total=Sum('purchase_price')
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
    from catalog.models import Group, Photocard
    
    completion_by_group = []
    user_groups = UserFavoriteGroup.objects.filter(user=user).select_related('group')
    
    for fav_group in user_groups:
        group = fav_group.group
        total_photocards_in_group = Photocard.objects.filter(group=group).count()
        user_photocards_in_group = UserCollectible.objects.filter(
            user=user, 
            collectible_type='photocard',
            photocard__group=group
        ).count()
        
        if total_photocards_in_group > 0:
            completion_percentage = (user_photocards_in_group / total_photocards_in_group) * 100
            completion_by_group.append({
                'group_id': str(group.id),
                'group_name': group.name,
                'total_photocards': total_photocards_in_group,
                'user_photocards': user_photocards_in_group,
                'completion_percentage': round(completion_percentage, 2)
            })
    
    stats_data = {
        'total_albums': total_albums,
        'total_photocards': total_photocards,
        'total_lightsticks': total_lightsticks,
        'total_value': total_value,
        'duplicate_photocards': duplicate_photocards,
        'duplicate_lightsticks': duplicate_lightsticks,
        'wishlist_items': wishlist_items,
        'favorite_groups': favorite_groups,
        'completion_by_group': completion_by_group
    }
    
    serializer = CollectionStatsSerializer(stats_data)
    return Response(serializer.data)


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def add_to_collection_view(request):
    """Vista para añadir un objeto a la colección"""
    serializer = UserCollectibleCreateSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save(user=request.user)
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def add_to_wishlist_view(request):
    """Vista para añadir un objeto a la wishlist"""
    serializer = WishlistItemCreateSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save(user=request.user)
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def add_favorite_group_view(request):
    """Vista para añadir un grupo favorito"""
    group_id = request.data.get('group_id')
    if not group_id:
        return Response({'error': 'group_id es requerido'}, status=status.HTTP_400_BAD_REQUEST)
    
    from catalog.models import Group
    try:
        group = Group.objects.get(id=group_id)
    except Group.DoesNotExist:
        return Response({'error': 'Grupo no encontrado'}, status=status.HTTP_404_NOT_FOUND)
    
    # Verificar si ya es favorito
    if UserFavoriteGroup.objects.filter(user=request.user, group=group).exists():
        return Response({'error': 'El grupo ya está en favoritos'}, status=status.HTTP_400_BAD_REQUEST)
    
    UserFavoriteGroup.objects.create(user=request.user, group=group)
    return Response({'message': 'Grupo añadido a favoritos'}, status=status.HTTP_201_CREATED)


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def user_collection_by_type_view(request, collectible_type):
    """Vista para obtener la colección del usuario por tipo"""
    if collectible_type not in ['photocard', 'lightstick']:
        return Response({'error': 'Tipo no válido'}, status=status.HTTP_400_BAD_REQUEST)
    
    collectibles = UserCollectible.objects.filter(
        user=request.user, 
        collectible_type=collectible_type
    ).order_by('-acquisition_date')
    
    serializer = UserCollectibleSerializer(collectibles, many=True)
    return Response(serializer.data)


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def user_wishlist_by_type_view(request, collectible_type):
    """Vista para obtener la wishlist del usuario por tipo"""
    if collectible_type not in ['photocard', 'lightstick']:
        return Response({'error': 'Tipo no válido'}, status=status.HTTP_400_BAD_REQUEST)
    
    items = WishlistItem.objects.filter(
        user=request.user, 
        collectible_type=collectible_type
    ).order_by('-priority', '-added_at')
    
    serializer = WishlistItemSerializer(items, many=True)
    return Response(serializer.data)
