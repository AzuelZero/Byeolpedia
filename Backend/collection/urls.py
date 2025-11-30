from django.urls import path
from . import views

app_name = 'collection'

urlpatterns = [
    # Colección personal
    path('collectibles/', views.UserCollectibleListView.as_view(), name='collectible-list'),
    path('collectibles/<uuid:pk>/', views.UserCollectibleDetailView.as_view(), name='collectible-detail'),
    path('collectibles/add/', views.add_to_collection_view, name='add-to-collection'),
    path('collectibles/<str:collectible_type>/', views.user_collection_by_type_view, name='collection-by-type'),
    
    # Wishlist
    path('wishlist/', views.WishlistItemListView.as_view(), name='wishlist-list'),
    path('wishlist/<uuid:pk>/', views.WishlistItemDetailView.as_view(), name='wishlist-detail'),
    path('wishlist/add/', views.add_to_wishlist_view, name='add-to-wishlist'),
    path('wishlist/<str:collectible_type>/', views.user_wishlist_by_type_view, name='wishlist-by-type'),
    
    # Grupos favoritos
    path('favorites/', views.UserFavoriteGroupListView.as_view(), name='favorite-list'),
    path('favorites/<uuid:pk>/', views.UserFavoriteGroupDetailView.as_view(), name='favorite-detail'),
    path('favorites/add/', views.add_favorite_group_view, name='add-favorite-group'),
    
    # Estadísticas
    path('stats/', views.collection_stats_view, name='stats'),
    
    # Machine Learning (comentado hasta que las vistas estén implementadas)
    # path('lightstick-recognition/', views.LightstickRecognitionView.as_view(), name='lightstick-recognition'),
    # path('lightstick-recognition/info/', views.LightstickRecognitionInfoView.as_view(), name='lightstick-recognition-info'),
]