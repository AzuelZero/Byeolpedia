from rest_framework import serializers
from .models import Group, Member, Album, AlbumVersion, Photocard, Lightstick


class MemberSerializer(serializers.ModelSerializer):
    """Serializer para miembros de grupos"""
    
    class Meta:
        model = Member
        fields = ('id', 'stage_name', 'real_name', 'birth_date', 'position', 'is_active', 'profile_image')


class GroupSerializer(serializers.ModelSerializer):
    """Serializer para grupos K-pop"""
    members = MemberSerializer(many=True, read_only=True)
    album_count = serializers.SerializerMethodField()
    
    class Meta:
        model = Group
        fields = ('id', 'name', 'korean_name', 'debut_date', 'agency', 'group_type', 
                 'logo_image', 'members', 'album_count')
    
    def get_album_count(self, obj):
        return obj.albums.count()


class GroupListSerializer(serializers.ModelSerializer):
    """Serializer simplificado para lista de grupos"""
    member_count = serializers.SerializerMethodField()
    
    class Meta:
        model = Group
        fields = ('id', 'name', 'korean_name', 'debut_date', 'agency', 'group_type', 
                 'logo_image', 'member_count')
    
    def get_member_count(self, obj):
        return obj.members.filter(is_active=True).count()


class AlbumVersionSerializer(serializers.ModelSerializer):
    """Serializer para versiones de álbumes"""
    photocards_count = serializers.SerializerMethodField()
    
    class Meta:
        model = AlbumVersion
        fields = ('id', 'version_name', 'cover_image', 'number_of_photocards', 'photocards_count')
    
    def get_photocards_count(self, obj):
        return obj.photocards.count()


class AlbumSerializer(serializers.ModelSerializer):
    """Serializer para álbumes"""
    group = GroupListSerializer(read_only=True)
    versions = AlbumVersionSerializer(many=True, read_only=True)
    total_photocards = serializers.SerializerMethodField()
    
    class Meta:
        model = Album
        fields = ('id', 'title', 'release_date', 'album_type', 'cover_image', 
                 'group', 'versions', 'total_photocards')
    
    def get_total_photocards(self, obj):
        return Photocard.objects.filter(album_version__album=obj).count()


class AlbumListSerializer(serializers.ModelSerializer):
    """Serializer simplificado para lista de álbumes"""
    group_name = serializers.CharField(source='group.name', read_only=True)
    
    class Meta:
        model = Album
        fields = ('id', 'title', 'release_date', 'album_type', 'cover_image', 'group_name')


class PhotocardSerializer(serializers.ModelSerializer):
    """Serializer para photocards"""
    group_name = serializers.CharField(source='group.name', read_only=True)
    member_name = serializers.CharField(source='member.stage_name', read_only=True)
    album_name = serializers.CharField(source='album_version.album.title', read_only=True)
    version_name = serializers.CharField(source='album_version.version_name', read_only=True)
    
    class Meta:
        model = Photocard
        fields = ('id', 'name', 'image', 'release_date', 'photocard_type',
                 'group_name', 'member_name', 'album_name', 'version_name',
                 'group', 'album_version', 'member')


class PhotocardListSerializer(serializers.ModelSerializer):
    """Serializer simplificado para lista de photocards"""
    group_name = serializers.CharField(source='group.name', read_only=True)
    member_name = serializers.CharField(source='member.stage_name', read_only=True)
    
    class Meta:
        model = Photocard
        fields = ('id', 'name', 'image', 'photocard_type', 'group_name', 'member_name')


class LightstickSerializer(serializers.ModelSerializer):
    """Serializer para lightsticks"""
    group_name = serializers.CharField(source='group.name', read_only=True)
    
    class Meta:
        model = Lightstick
        fields = ('id', 'name', 'version', 'image', 'release_date', 'group_name', 'group')


class LightstickListSerializer(serializers.ModelSerializer):
    """Serializer simplificado para lista de lightsticks"""
    group_name = serializers.CharField(source='group.name', read_only=True)
    
    class Meta:
        model = Lightstick
        fields = ('id', 'name', 'version', 'image', 'group_name')