from django.contrib import admin
from .models import UserCollectible, WishlistItem, UserFavoriteGroup


@admin.register(UserCollectible)
class UserCollectibleAdmin(admin.ModelAdmin):
    list_display = ('user', 'get_collectible_name', 'collectible_type', 'source', 'acquisition_date', 'purchase_price')
    search_fields = ('user__username', 'user__collector_name', 'source')
    list_filter = ('collectible_type', 'acquisition_date')
    ordering = ('-acquisition_date',)
    readonly_fields = ('id', 'added_at')
    
    def get_collectible_name(self, obj):
        if obj.collectible_type == 'photocard' and obj.photocard:
            return obj.photocard.name
        elif obj.collectible_type == 'lightstick' and obj.lightstick:
            return obj.lightstick.name
        return f"Objeto {obj.collectible_type}"
    get_collectible_name.short_description = 'Nombre del objeto'


@admin.register(WishlistItem)
class WishlistItemAdmin(admin.ModelAdmin):
    list_display = ('user', 'get_collectible_name', 'collectible_type', 'priority', 'added_at')
    search_fields = ('user__username', 'user__collector_name')
    list_filter = ('collectible_type', 'priority', 'added_at')
    ordering = ('-priority', '-added_at')
    readonly_fields = ('id', 'added_at')
    
    def get_collectible_name(self, obj):
        if obj.collectible_type == 'photocard' and obj.photocard:
            return obj.photocard.name
        elif obj.collectible_type == 'lightstick' and obj.lightstick:
            return obj.lightstick.name
        return f"Objeto {obj.collectible_type}"
    get_collectible_name.short_description = 'Nombre del objeto'


@admin.register(UserFavoriteGroup)
class UserFavoriteGroupAdmin(admin.ModelAdmin):
    list_display = ('user', 'group', 'favorited_at')
    search_fields = ('user__username', 'user__collector_name', 'group__name')
    list_filter = ('favorited_at', 'group')
    ordering = ('-favorited_at',)
    readonly_fields = ('favorited_at',)
