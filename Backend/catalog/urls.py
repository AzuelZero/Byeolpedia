from django.urls import path
from . import views

app_name = 'catalog'

urlpatterns = [
    # Grupos
    path('groups/', views.GroupListView.as_view(), name='group-list'),
    path('groups/<uuid:pk>/', views.GroupDetailView.as_view(), name='group-detail'),
    path('groups/<uuid:group_id>/albums/', views.GroupAlbumsView.as_view(), name='group-albums'),
    path('groups/<uuid:group_id>/photocards/', views.GroupPhotocardsView.as_view(), name='group-photocards'),
    path('groups/<uuid:group_id>/lightsticks/', views.GroupLightsticksView.as_view(), name='group-lightsticks'),
    
    # Miembros
    path('members/', views.MemberListView.as_view(), name='member-list'),
    path('members/<uuid:pk>/', views.MemberDetailView.as_view(), name='member-detail'),
    path('members/<uuid:member_id>/photocards/', views.MemberPhotocardsView.as_view(), name='member-photocards'),
    
    # Álbumes
    path('albums/', views.AlbumListView.as_view(), name='album-list'),
    path('albums/<uuid:pk>/', views.AlbumDetailView.as_view(), name='album-detail'),
    path('albums/<uuid:album_id>/photocards/', views.AlbumPhotocardsView.as_view(), name='album-photocards'),
    
    # Versiones de álbumes
    path('album-versions/', views.AlbumVersionListView.as_view(), name='album-version-list'),
    path('album-versions/<uuid:pk>/', views.AlbumVersionDetailView.as_view(), name='album-version-detail'),
    path('album-versions/<uuid:version_id>/photocards/', views.AlbumVersionPhotocardsView.as_view(), name='album-version-photocards'),
    
    # Photocards
    path('photocards/', views.PhotocardListView.as_view(), name='photocard-list'),
    path('photocards/<uuid:pk>/', views.PhotocardDetailView.as_view(), name='photocard-detail'),
    
    # Lightsticks
    path('lightsticks/', views.LightstickListView.as_view(), name='lightstick-list'),
    path('lightsticks/<uuid:pk>/', views.LightstickDetailView.as_view(), name='lightstick-detail'),
]