from rest_framework import serializers
from django.contrib.auth import get_user_model
from .models import UserCollectible, WishlistItem, UserFavoriteGroup
from catalog.serializers import PhotocardListSerializer, LightstickListSerializer

User = get_user_model()


class UserCollectibleSerializer(serializers.ModelSerializer):
    """Serializer para objetos en la colección del usuario"""
    photocard_details = PhotocardListSerializer(source='photocard', read_only=True)
    lightstick_details = LightstickListSerializer(source='lightstick', read_only=True)
    collectible_name = serializers.SerializerMethodField()
    
    class Meta:
        model = UserCollectible
        fields = ('id', 'collectible_type', 'photocard', 'lightstick', 'source',
                 'acquisition_date', 'purchase_price', 'quantity',
                 'photo', 'added_at', 'photocard_details', 'lightstick_details',
                 'collectible_name')
        read_only_fields = ('id', 'added_at', 'user')
    
    def get_collectible_name(self, obj):
        if obj.collectible_type == 'photocard' and obj.photocard:
            return obj.photocard.name
        elif obj.collectible_type == 'lightstick' and obj.lightstick:
            return obj.lightstick.name
        return f"Objeto {obj.collectible_type}"
    
    def validate(self, attrs):
        collectible_type = attrs.get('collectible_type')
        photocard = attrs.get('photocard')
        lightstick = attrs.get('lightstick')
        
        if collectible_type == 'photocard' and not photocard:
            raise serializers.ValidationError("Debe especificar una photocard para tipo 'photocard'")
        if collectible_type == 'lightstick' and not lightstick:
            raise serializers.ValidationError("Debe especificar un lightstick para tipo 'lightstick'")
        
        return attrs
    
    def create(self, validated_data):
        validated_data['user'] = self.context['request'].user
        return super().create(validated_data)


class UserCollectibleCreateSerializer(serializers.ModelSerializer):
    """Serializer simplificado para crear objetos en la colección"""
    
    class Meta:
        model = UserCollectible
        fields = ('collectible_type', 'photocard', 'lightstick', 'source',
                 'acquisition_date', 'purchase_price', 'quantity', 'photo')
    
    def validate(self, attrs):
        collectible_type = attrs.get('collectible_type')
        photocard = attrs.get('photocard')
        lightstick = attrs.get('lightstick')
        
        if collectible_type == 'photocard' and not photocard:
            raise serializers.ValidationError("Debe especificar una photocard para tipo 'photocard'")
        if collectible_type == 'lightstick' and not lightstick:
            raise serializers.ValidationError("Debe especificar un lightstick para tipo 'lightstick'")
        
        return attrs


class WishlistItemSerializer(serializers.ModelSerializer):
    """Serializer para items en la wishlist del usuario"""
    photocard_details = PhotocardListSerializer(source='photocard', read_only=True)
    lightstick_details = LightstickListSerializer(source='lightstick', read_only=True)
    collectible_name = serializers.SerializerMethodField()
    
    class Meta:
        model = WishlistItem
        fields = ('id', 'collectible_type', 'photocard', 'lightstick', 'priority',
                 'added_at', 'photocard_details', 'lightstick_details', 'collectible_name')
        read_only_fields = ('id', 'added_at', 'user')
    
    def get_collectible_name(self, obj):
        if obj.collectible_type == 'photocard' and obj.photocard:
            return obj.photocard.name
        elif obj.collectible_type == 'lightstick' and obj.lightstick:
            return obj.lightstick.name
        return f"Objeto {obj.collectible_type}"
    
    def validate(self, attrs):
        collectible_type = attrs.get('collectible_type')
        photocard = attrs.get('photocard')
        lightstick = attrs.get('lightstick')
        
        if collectible_type == 'photocard' and not photocard:
            raise serializers.ValidationError("Debe especificar una photocard para tipo 'photocard'")
        if collectible_type == 'lightstick' and not lightstick:
            raise serializers.ValidationError("Debe especificar un lightstick para tipo 'lightstick'")
        
        return attrs
    
    def create(self, validated_data):
        validated_data['user'] = self.context['request'].user
        return super().create(validated_data)


class WishlistItemCreateSerializer(serializers.ModelSerializer):
    """Serializer simplificado para crear items en la wishlist"""
    
    class Meta:
        model = WishlistItem
        fields = ('collectible_type', 'photocard', 'lightstick', 'priority')
    
    def validate(self, attrs):
        collectible_type = attrs.get('collectible_type')
        photocard = attrs.get('photocard')
        lightstick = attrs.get('lightstick')
        
        if collectible_type == 'photocard' and not photocard:
            raise serializers.ValidationError("Debe especificar una photocard para tipo 'photocard'")
        if collectible_type == 'lightstick' and not lightstick:
            raise serializers.ValidationError("Debe especificar un lightstick para tipo 'lightstick'")
        
        return attrs


class UserFavoriteGroupSerializer(serializers.ModelSerializer):
    """Serializer para grupos favoritos del usuario"""
    group_details = serializers.SerializerMethodField()
    
    class Meta:
        model = UserFavoriteGroup
        fields = ('id', 'group', 'favorited_at', 'group_details')
        read_only_fields = ('id', 'favorited_at', 'user')
    
    def get_group_details(self, obj):
        from catalog.serializers import GroupListSerializer
        return GroupListSerializer(obj.group).data
    
    def create(self, validated_data):
        validated_data['user'] = self.context['request'].user
        return super().create(validated_data)


class CollectionStatsSerializer(serializers.Serializer):
    """Serializer para estadísticas de la colección del usuario"""
    total_albums = serializers.IntegerField()
    total_photocards = serializers.IntegerField()
    total_lightsticks = serializers.IntegerField()
    total_value = serializers.DecimalField(max_digits=12, decimal_places=2)
    duplicate_photocards = serializers.IntegerField()
    duplicate_lightsticks = serializers.IntegerField()
    wishlist_items = serializers.IntegerField()
    favorite_groups = serializers.IntegerField()
    completion_by_group = serializers.ListField()