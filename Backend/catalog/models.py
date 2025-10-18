import uuid
from django.db import models


class Group(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=100)
    korean_name = models.CharField(max_length=100)
    debut_date = models.DateField()
    agency = models.CharField(max_length=100)
    group_type = models.CharField(max_length=50)
    logo_image = models.URLField(blank=True, null=True)

    def __str__(self):
        return self.name

    class Meta:
        db_table = 'groups'


class Member(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    group = models.ForeignKey(Group, on_delete=models.CASCADE, related_name='members')
    stage_name = models.CharField(max_length=100)
    real_name = models.CharField(max_length=100)
    birth_date = models.DateField()
    position = models.CharField(max_length=200)
    is_active = models.BooleanField(default=True)
    profile_image = models.URLField(blank=True, null=True)

    def __str__(self):
        return f"{self.stage_name} ({self.group.name})"

    class Meta:
        db_table = 'members'


class Album(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    group = models.ForeignKey(Group, on_delete=models.CASCADE, related_name='albums')
    title = models.CharField(max_length=200)
    release_date = models.DateField()
    album_type = models.CharField(max_length=50)
    cover_image = models.URLField(blank=True, null=True)

    def __str__(self):
        return f"{self.title} - {self.group.name}"

    class Meta:
        db_table = 'albums'


class AlbumVersion(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    album = models.ForeignKey(Album, on_delete=models.CASCADE, related_name='versions')
    version_name = models.CharField(max_length=100)
    cover_image = models.URLField(blank=True, null=True)
    number_of_photocards = models.IntegerField(default=0)

    def __str__(self):
        return f"{self.album.title} - {self.version_name}"

    class Meta:
        db_table = 'album_versions'


class Photocard(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    group = models.ForeignKey(Group, on_delete=models.CASCADE, related_name='photocards')
    album_version = models.ForeignKey(AlbumVersion, on_delete=models.CASCADE, related_name='photocards')
    member = models.ForeignKey(Member, on_delete=models.SET_NULL, null=True, blank=True, related_name='photocards')
    name = models.CharField(max_length=200)
    image = models.URLField(blank=True, null=True)
    release_date = models.DateField()
    photocard_type = models.CharField(max_length=50)

    def __str__(self):
        return f"{self.name} - {self.group.name}"

    class Meta:
        db_table = 'photocards'


class Lightstick(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    group = models.ForeignKey(Group, on_delete=models.CASCADE, related_name='lightsticks')
    name = models.CharField(max_length=200)
    version = models.CharField(max_length=50)
    image = models.URLField(blank=True, null=True)
    release_date = models.DateField()

    def __str__(self):
        return f"{self.name} - {self.group.name}"

    class Meta:
        db_table = 'lightsticks'
