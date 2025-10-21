from django.contrib import admin
from django.contrib.admin import AdminSite
from django.utils.translation import gettext_lazy as _

# Personalización del sitio de administración
class ByeolpediaAdminSite(AdminSite):
    site_title = _('Byeolpedia')
    site_header = _('Administración de Byeolpedia')
    index_title = _('Panel de control de Byeolpedia')

# Usar nuestro sitio personalizado
admin_site = ByeolpediaAdminSite(name='byeolpedia_admin')