from rest_framework import serializers
from django.contrib.auth import authenticate
from django.contrib.auth.password_validation import validate_password
from .models import User


class UserRegistrationSerializer(serializers.ModelSerializer):
    """Serializer para el registro de nuevos usuarios"""
    password = serializers.CharField(write_only=True, validators=[validate_password])
    password_confirm = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ('username', 'email', 'collector_name', 'password', 'password_confirm')

    def validate(self, attrs):
        if attrs['password'] != attrs['password_confirm']:
            raise serializers.ValidationError("Las contraseñas no coinciden")
        return attrs

    def create(self, validated_data):
        validated_data.pop('password_confirm')
        user = User.objects.create_user(**validated_data)
        return user


class UserLoginSerializer(serializers.Serializer):
    """Serializer para el login de usuarios"""
    email = serializers.EmailField()
    password = serializers.CharField()

    def validate(self, attrs):
        email = attrs.get('email')
        password = attrs.get('password')

        if email and password:
            user = authenticate(request=self.context.get('request'),
                              username=email, password=password)
            if not user:
                raise serializers.ValidationError('Credenciales inválidas')
            if not user.is_active:
                raise serializers.ValidationError('Usuario desactivado')
            attrs['user'] = user
            return attrs
        else:
            raise serializers.ValidationError('Debe incluir email y password')


class UserProfileSerializer(serializers.ModelSerializer):
    """Serializer para el perfil de usuario"""
    total_albums = serializers.SerializerMethodField()
    total_photocards = serializers.SerializerMethodField()
    total_lightsticks = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = ('id', 'username', 'email', 'collector_name', 'profile_pic', 
                 'created_at', 'total_albums', 'total_photocards', 'total_lightsticks')
        read_only_fields = ('id', 'username', 'email', 'created_at')

    def get_total_albums(self, obj):
        from collection.models import UserCollectible
        return UserCollectible.objects.filter(
            user=obj, collectible_type='photocard'
        ).values('photocard__album_version__album').distinct().count()

    def get_total_photocards(self, obj):
        from collection.models import UserCollectible
        return UserCollectible.objects.filter(
            user=obj, collectible_type='photocard'
        ).count()

    def get_total_lightsticks(self, obj):
        from collection.models import UserCollectible
        return UserCollectible.objects.filter(
            user=obj, collectible_type='lightstick'
        ).count()


class UserUpdateSerializer(serializers.ModelSerializer):
    """Serializer para actualizar datos del usuario"""
    
    class Meta:
        model = User
        fields = ('collector_name', 'profile_pic')