import uuid
from django.db import models
from django.contrib.auth.models import AbstractUser


class User(AbstractUser):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    email = models.EmailField(unique=True)
    collector_name = models.CharField(max_length=150)
    profile_pic = models.URLField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    
    # Campos requeridos para AbstractUser
    USERNAME_FIELD = 'email'  # Usaremos email para login en lugar de username
    REQUIRED_FIELDS = ['username', 'collector_name']

    def __str__(self):
        return self.username

    class Meta:
        db_table = 'users_user'
