from django.contrib import admin
from django.contrib.admin import AdminSite
from django.utils.translation import gettext_lazy as _

# Importar modelos y admins personalizados
from users.admin import UserAdmin
from catalog.admin import (
    GroupAdmin, MemberAdmin, AlbumAdmin,
    AlbumVersionAdmin, PhotocardAdmin, LightstickAdmin
)
from collection.admin import (
    UserCollectibleAdmin, WishlistItemAdmin, UserFavoriteGroupAdmin
)
from users.models import User
from catalog.models import Group, Member, Album, AlbumVersion, Photocard, Lightstick
from collection.models import UserCollectible, WishlistItem, UserFavoriteGroup

# Personalización del sitio de administración
class ByeolpediaAdminSite(AdminSite):
    site_title = _('Byeolpedia')
    site_header = _('Administración de Byeolpedia')
    index_title = _('Panel de control de Byeolpedia')

# Usar nuestro sitio personalizado
admin_site = ByeolpediaAdminSite(name='byeolpedia_admin')

# Registrar modelos en el admin personalizado
admin_site.register(User, UserAdmin)
admin_site.register(Group, GroupAdmin)
admin_site.register(Member, MemberAdmin)
admin_site.register(Album, AlbumAdmin)
admin_site.register(AlbumVersion, AlbumVersionAdmin)
admin_site.register(Photocard, PhotocardAdmin)
admin_site.register(Lightstick, LightstickAdmin)
admin_site.register(UserCollectible, UserCollectibleAdmin)
admin_site.register(WishlistItem, WishlistItemAdmin)
admin_site.register(UserFavoriteGroup, UserFavoriteGroupAdmin)