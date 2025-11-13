import django_filters
from .models import Group, Album, Photocard, Lightstick


class GroupFilter(django_filters.FilterSet):
    """Filtros avanzados para grupos"""
    debut_year = django_filters.NumberFilter(field_name='debut_date__year', lookup_expr='exact')
    debut_after = django_filters.DateFilter(field_name='debut_date', lookup_expr='gte')
    debut_before = django_filters.DateFilter(field_name='debut_date', lookup_expr='lte')
    
    class Meta:
        model = Group
        fields = ['group_type', 'agency']


class AlbumFilter(django_filters.FilterSet):
    """Filtros avanzados para álbumes"""
    release_year = django_filters.NumberFilter(field_name='release_date__year', lookup_expr='exact')
    release_after = django_filters.DateFilter(field_name='release_date', lookup_expr='gte')
    release_before = django_filters.DateFilter(field_name='release_date', lookup_expr='lte')
    
    class Meta:
        model = Album
        fields = ['group', 'album_type']


class PhotocardFilter(django_filters.FilterSet):
    """Filtros avanzados para photocards"""
    release_year = django_filters.NumberFilter(field_name='release_date__year', lookup_expr='exact')
    release_after = django_filters.DateFilter(field_name='release_date', lookup_expr='gte')
    release_before = django_filters.DateFilter(field_name='release_date', lookup_expr='lte')
    
    class Meta:
        model = Photocard
        fields = ['group', 'album_version', 'member', 'photocard_type']


class LightstickFilter(django_filters.FilterSet):
    """Filtros avanzados para lightsticks"""
    release_year = django_filters.NumberFilter(field_name='release_date__year', lookup_expr='exact')
    release_after = django_filters.DateFilter(field_name='release_date', lookup_expr='gte')
    release_before = django_filters.DateFilter(field_name='release_date', lookup_expr='lte')
    
    class Meta:
        model = Lightstick
        fields = ['group', 'version']