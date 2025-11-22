import uuid
from django.db import models
from django.conf import settings

# Importamos los modelos del catálogo
from catalog.models import Photocard, Lightstick


class UserCollectible(models.Model):
    COLLECTIBLE_TYPES = [
        ('photocard', 'Photocard'),
        ('lightstick', 'Lightstick'),
    ]

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='collectibles')
    collectible_type = models.CharField(max_length=20, choices=COLLECTIBLE_TYPES)
    photocard = models.ForeignKey(Photocard, on_delete=models.CASCADE, null=True, blank=True, related_name='user_collectibles')
    lightstick = models.ForeignKey(Lightstick, on_delete=models.CASCADE, null=True, blank=True, related_name='user_collectibles')
    source = models.CharField(max_length=100)
    acquisition_date = models.DateField()
    purchase_price = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    quantity = models.PositiveIntegerField(default=1)
    photo = models.URLField(blank=True, null=True)
    added_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        if self.collectible_type == 'photocard' and self.photocard:
            return f"{self.user.username} - {self.photocard.name}"
        elif self.collectible_type == 'lightstick' and self.lightstick:
            return f"{self.user.username} - {self.lightstick.name}"
        return f"{self.user.username} - {self.collectible_type}"

    class Meta:
        db_table = 'collection_collection'


class WishlistItem(models.Model):
    COLLECTIBLE_TYPES = [
        ('photocard', 'Photocard'),
        ('lightstick', 'Lightstick'),
    ]

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='wishlist_items')
    collectible_type = models.CharField(max_length=20, choices=COLLECTIBLE_TYPES)
    photocard = models.ForeignKey(Photocard, on_delete=models.CASCADE, null=True, blank=True, related_name='wishlist_items')
    lightstick = models.ForeignKey(Lightstick, on_delete=models.CASCADE, null=True, blank=True, related_name='wishlist_items')
    priority = models.DecimalField(max_digits=3, decimal_places=1)
    added_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        if self.collectible_type == 'photocard' and self.photocard:
            return f"{self.user.username} wants {self.photocard.name}"
        elif self.collectible_type == 'lightstick' and self.lightstick:
            return f"{self.user.username} wants {self.lightstick.name}"
        return f"{self.user.username} wants {self.collectible_type}"

    class Meta:
        db_table = 'collection_item'


class UserFavoriteGroup(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    group = models.ForeignKey('catalog.Group', on_delete=models.CASCADE)
    favorited_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'collection_collection_favorited_by'
        unique_together = ('user', 'group')  # Asegura que un usuario no pueda favoritar el mismo grupo dos veces

    def __str__(self):
        return f"{self.user.username} - {self.group.name}"
