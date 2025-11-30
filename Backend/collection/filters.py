import django_filters
from .models import UserCollectible, WishlistItem


class UserCollectibleFilter(django_filters.FilterSet):
    """Filtros avanzados para la colección del usuario"""
    acquisition_year = django_filters.NumberFilter(field_name='acquisition_date__year', lookup_expr='exact')
    acquisition_after = django_filters.DateFilter(field_name='acquisition_date', lookup_expr='gte')
    acquisition_before = django_filters.DateFilter(field_name='acquisition_date', lookup_expr='lte')
    min_price = django_filters.NumberFilter(field_name='purchase_price', lookup_expr='gte')
    max_price = django_filters.NumberFilter(field_name='purchase_price', lookup_expr='lte')
    
    class Meta:
        model = UserCollectible
        fields = ['collectible_type', 'source']


class WishlistItemFilter(django_filters.FilterSet):
    """Filtros avanzados para la wishlist del usuario"""
    min_priority = django_filters.NumberFilter(field_name='priority', lookup_expr='gte')
    max_priority = django_filters.NumberFilter(field_name='priority', lookup_expr='lte')
    added_after = django_filters.DateFilter(field_name='added_at', lookup_expr='gte')
    added_before = django_filters.DateFilter(field_name='added_at', lookup_expr='lte')
    
    class Meta:
        model = WishlistItem
        fields = ['collectible_type']