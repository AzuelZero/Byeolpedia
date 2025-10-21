from django.contrib import admin
from .models import Group, Member, Album, AlbumVersion, Photocard, Lightstick


@admin.register(Group)
class GroupAdmin(admin.ModelAdmin):
    list_display = ('name', 'korean_name', 'agency', 'group_type', 'debut_date')
    search_fields = ('name', 'korean_name', 'agency')
    list_filter = ('group_type', 'debut_date')
    ordering = ('name',)
    readonly_fields = ('id',)


class MemberInline(admin.TabularInline):
    model = Member
    extra = 1


class AlbumInline(admin.TabularInline):
    model = Album
    extra = 1


class LightstickInline(admin.TabularInline):
    model = Lightstick
    extra = 1


@admin.register(Group)
class GroupAdmin(admin.ModelAdmin):
    list_display = ('name', 'korean_name', 'agency', 'group_type', 'debut_date')
    search_fields = ('name', 'korean_name', 'agency')
    list_filter = ('group_type', 'debut_date')
    ordering = ('name',)
    readonly_fields = ('id',)
    inlines = [MemberInline, AlbumInline, LightstickInline]


@admin.register(Member)
class MemberAdmin(admin.ModelAdmin):
    list_display = ('stage_name', 'real_name', 'group', 'position', 'is_active', 'birth_date')
    search_fields = ('stage_name', 'real_name', 'group__name')
    list_filter = ('is_active', 'position', 'group')
    ordering = ('group', 'stage_name')
    readonly_fields = ('id',)


class AlbumVersionInline(admin.TabularInline):
    model = AlbumVersion
    extra = 1


@admin.register(Album)
class AlbumAdmin(admin.ModelAdmin):
    list_display = ('title', 'group', 'album_type', 'release_date')
    search_fields = ('title', 'group__name')
    list_filter = ('album_type', 'release_date', 'group')
    ordering = ('-release_date',)
    readonly_fields = ('id',)
    inlines = [AlbumVersionInline]


@admin.register(AlbumVersion)
class AlbumVersionAdmin(admin.ModelAdmin):
    list_display = ('album', 'version_name', 'number_of_photocards')
    search_fields = ('album__title', 'version_name')
    list_filter = ('album',)
    ordering = ('album', 'version_name')
    readonly_fields = ('id',)


@admin.register(Photocard)
class PhotocardAdmin(admin.ModelAdmin):
    list_display = ('name', 'group', 'member', 'album_version', 'photocard_type', 'release_date')
    search_fields = ('name', 'group__name', 'member__stage_name', 'album_version__version_name')
    list_filter = ('photocard_type', 'release_date', 'group')
    ordering = ('-release_date',)
    readonly_fields = ('id',)


@admin.register(Lightstick)
class LightstickAdmin(admin.ModelAdmin):
    list_display = ('name', 'group', 'version', 'release_date')
    search_fields = ('name', 'group__name', 'version')
    list_filter = ('release_date', 'group')
    ordering = ('-release_date',)
    readonly_fields = ('id',)
