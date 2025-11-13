from rest_framework import generics, permissions, filters
from django_filters.rest_framework import DjangoFilterBackend
from .models import Group, Member, Album, AlbumVersion, Photocard, Lightstick
from .serializers import (
    GroupSerializer,
    GroupListSerializer,
    MemberSerializer,
    AlbumSerializer,
    AlbumListSerializer,
    AlbumVersionSerializer,
    PhotocardSerializer,
    PhotocardListSerializer,
    LightstickSerializer,
    LightstickListSerializer
)
from .filters import GroupFilter, AlbumFilter, PhotocardFilter, LightstickFilter


class GroupListView(generics.ListAPIView):
    """Vista para listar grupos"""
    queryset = Group.objects.all()
    serializer_class = GroupListSerializer
    permission_classes = [permissions.AllowAny]
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_class = GroupFilter
    search_fields = ['name', 'korean_name']
    ordering_fields = ['name', 'debut_date']
    ordering = ['name']


class GroupDetailView(generics.RetrieveAPIView):
    """Vista para ver detalles de un grupo"""
    queryset = Group.objects.all()
    serializer_class = GroupSerializer
    permission_classes = [permissions.AllowAny]


class MemberListView(generics.ListAPIView):
    """Vista para listar miembros"""
    queryset = Member.objects.all()
    serializer_class = MemberSerializer
    permission_classes = [permissions.AllowAny]
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['group', 'position', 'is_active']
    search_fields = ['stage_name', 'real_name']
    ordering_fields = ['stage_name', 'birth_date']
    ordering = ['group', 'stage_name']


class MemberDetailView(generics.RetrieveAPIView):
    """Vista para ver detalles de un miembro"""
    queryset = Member.objects.all()
    serializer_class = MemberSerializer
    permission_classes = [permissions.AllowAny]


class AlbumListView(generics.ListAPIView):
    """Vista para listar álbumes"""
    queryset = Album.objects.all()
    serializer_class = AlbumListSerializer
    permission_classes = [permissions.AllowAny]
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_class = AlbumFilter
    search_fields = ['title', 'group__name']
    ordering_fields = ['title', 'release_date']
    ordering = ['-release_date']


class AlbumDetailView(generics.RetrieveAPIView):
    """Vista para ver detalles de un álbum"""
    queryset = Album.objects.all()
    serializer_class = AlbumSerializer
    permission_classes = [permissions.AllowAny]


class AlbumVersionListView(generics.ListAPIView):
    """Vista para listar versiones de álbumes"""
    queryset = AlbumVersion.objects.all()
    serializer_class = AlbumVersionSerializer
    permission_classes = [permissions.AllowAny]
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['album']
    search_fields = ['version_name']
    ordering_fields = ['version_name']
    ordering = ['album', 'version_name']


class AlbumVersionDetailView(generics.RetrieveAPIView):
    """Vista para ver detalles de una versión de álbum"""
    queryset = AlbumVersion.objects.all()
    serializer_class = AlbumVersionSerializer
    permission_classes = [permissions.AllowAny]


class PhotocardListView(generics.ListAPIView):
    """Vista para listar photocards"""
    queryset = Photocard.objects.all()
    serializer_class = PhotocardListSerializer
    permission_classes = [permissions.AllowAny]
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_class = PhotocardFilter
    search_fields = ['name', 'group__name', 'member__stage_name']
    ordering_fields = ['name', 'release_date']
    ordering = ['-release_date']


class PhotocardDetailView(generics.RetrieveAPIView):
    """Vista para ver detalles de una photocard"""
    queryset = Photocard.objects.all()
    serializer_class = PhotocardSerializer
    permission_classes = [permissions.AllowAny]


class LightstickListView(generics.ListAPIView):
    """Vista para listar lightsticks"""
    queryset = Lightstick.objects.all()
    serializer_class = LightstickListSerializer
    permission_classes = [permissions.AllowAny]
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_class = LightstickFilter
    search_fields = ['name', 'group__name', 'version']
    ordering_fields = ['name', 'release_date']
    ordering = ['-release_date']


class LightstickDetailView(generics.RetrieveAPIView):
    """Vista para ver detalles de un lightstick"""
    queryset = Lightstick.objects.all()
    serializer_class = LightstickSerializer
    permission_classes = [permissions.AllowAny]


class GroupAlbumsView(generics.ListAPIView):
    """Vista para listar álbumes de un grupo específico"""
    serializer_class = AlbumListSerializer
    permission_classes = [permissions.AllowAny]
    
    def get_queryset(self):
        group_id = self.kwargs['group_id']
        return Album.objects.filter(group_id=group_id)


class GroupPhotocardsView(generics.ListAPIView):
    """Vista para listar photocards de un grupo específico"""
    serializer_class = PhotocardListSerializer
    permission_classes = [permissions.AllowAny]
    
    def get_queryset(self):
        group_id = self.kwargs['group_id']
        return Photocard.objects.filter(group_id=group_id)


class GroupLightsticksView(generics.ListAPIView):
    """Vista para listar lightsticks de un grupo específico"""
    serializer_class = LightstickListSerializer
    permission_classes = [permissions.AllowAny]
    
    def get_queryset(self):
        group_id = self.kwargs['group_id']
        return Lightstick.objects.filter(group_id=group_id)


class AlbumPhotocardsView(generics.ListAPIView):
    """Vista para listar photocards de un álbum específico"""
    serializer_class = PhotocardListSerializer
    permission_classes = [permissions.AllowAny]
    
    def get_queryset(self):
        album_id = self.kwargs['album_id']
        return Photocard.objects.filter(album_version__album_id=album_id)


class AlbumVersionPhotocardsView(generics.ListAPIView):
    """Vista para listar photocards de una versión de álbum específica"""
    serializer_class = PhotocardListSerializer
    permission_classes = [permissions.AllowAny]
    
    def get_queryset(self):
        version_id = self.kwargs['version_id']
        return Photocard.objects.filter(album_version_id=version_id)


class MemberPhotocardsView(generics.ListAPIView):
    """Vista para listar photocards de un miembro específico"""
    serializer_class = PhotocardListSerializer
    permission_classes = [permissions.AllowAny]
    
    def get_queryset(self):
        member_id = self.kwargs['member_id']
        return Photocard.objects.filter(member_id=member_id)
