# populate_catalog.py
"""
Script para poblar el catálogo con mis grupos favoritos:
ITZY, aespa, i-dle, NMIXX, LE SSERAFIM

"""
import os
import django
from datetime import date
# Ahora sí podemos importar los modelos
from catalog.models import Group, Member, Album, AlbumVersion, Photocard, Lightstick

# Configurar Django para que el script pueda acceder a los modelos
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'byeolpedia_api.settings')
django.setup()


def populate():
    print("🎵 Poblando catálogo de K-Pop con tus grupos favoritos...")
    
    # =========================================================================
    # GRUPO 1: ITZY
    # =========================================================================
    print("\n📀 Creando grupo: ITZY")
    itzy, _ = Group.objects.get_or_create(
        name="ITZY",
        defaults={
            'korean_name': '있지',
            'debut_date': date(2019, 2, 12),
            'agency': 'JYP Entertainment',
            'group_type': 'girl_group'
        }
    )
    
    # Miembros
    members_itzy_data = [
        {'stage_name': 'Yeji', 'real_name': 'Hwang Yeji (황예지)', 'birth_date': date(2000, 5, 26), 'position': 'Leader, Main Dancer, Lead Vocalist'},
        {'stage_name': 'Lia', 'real_name': 'Choi Jisu (최지수)', 'birth_date': date(2000, 7, 21), 'position': 'Main Vocalist'},
        {'stage_name': 'Ryujin', 'real_name': 'Shin Ryujin (신류진)', 'birth_date': date(2001, 4, 17), 'position': 'Main Rapper, Lead Dancer, Center'},
        {'stage_name': 'Chaeryeong', 'real_name': 'Lee Chaeryeong (이채령)', 'birth_date': date(2001, 6, 5), 'position': 'Main Dancer, Sub Vocalist'},
        {'stage_name': 'Yuna', 'real_name': 'Shin Yuna (신유나)', 'birth_date': date(2003, 12, 9), 'position': 'Lead Dancer, Sub Vocalist, Visual, Maknae'},
    ]
    
    itzy_members = []
    for member_data in members_itzy_data:
        member, _ = Member.objects.get_or_create(
            group=itzy,
            stage_name=member_data['stage_name'],
            defaults=member_data
        )
        itzy_members.append(member)
        print(f"  ✓ Miembro: {member.stage_name}")
    
    # Álbum: KILL MY DOUBT
    print("\n💿 Creando álbum: KILL MY DOUBT")
    kill_my_doubt, _ = Album.objects.get_or_create(
        group=itzy,
        title="KILL MY DOUBT",
        defaults={
            'release_date': date(2023, 7, 31),
            'album_type': 'mini'
        }
    )
    
    # Versiones
    for version_name in ['BORN ver.', 'KILL ver.', 'DOUBT ver.']:
        version, _ = AlbumVersion.objects.get_or_create(
            album=kill_my_doubt,
            version_name=version_name,
            defaults={
                'number_of_photocards': 1
            }
        )
        print(f"  ✓ Versión: {version.version_name}")
        
        # Photocards
        for member in itzy_members:
            Photocard.objects.get_or_create(
                group=itzy,
                album_version=version,
                member=member,
                photocard_type='standard',
                defaults={
                    'name': f'{member.stage_name} - {version_name}',
                    'release_date': kill_my_doubt.release_date
                }
            )
    
    # Lightstick
    print("\n💡 Creando lightstick: LIGHT RING")
    Lightstick.objects.get_or_create(
        group=itzy,
        name="LIGHT RING",
        version="Ver. 1",
        defaults={
            'release_date': date(2020, 3, 13)
        }
    )
    
    # =========================================================================
    # GRUPO 2: aespa
    # =========================================================================
    print("\n📀 Creando grupo: aespa")
    aespa, _ = Group.objects.get_or_create(
        name="aespa",
        defaults={
            'korean_name': '에스파',
            'debut_date': date(2020, 11, 17),
            'agency': 'SM Entertainment',
            'group_type': 'girl_group'
        }
    )
    
    # Miembros
    members_aespa_data = [
        {'stage_name': 'Karina', 'real_name': 'Yoo Jimin (유지민)', 'birth_date': date(2000, 4, 11), 'position': 'Leader, Main Dancer, Sub Vocalist'},
        {'stage_name': 'Giselle', 'real_name': 'Uchinaga Aeri (内永枝利)', 'birth_date': date(2000, 10, 30), 'position': 'Main Rapper, Sub Vocalist'},
        {'stage_name': 'Winter', 'real_name': 'Kim Minjeong (김민정)', 'birth_date': date(2001, 1, 1), 'position': 'Main Vocalist, Lead Dancer'},
        {'stage_name': 'Ningning', 'real_name': 'Ning Yizhuo (宁艺卓)', 'birth_date': date(2002, 10, 23), 'position': 'Main Vocalist, Maknae'},
    ]
    
    aespa_members = []
    for member_data in members_aespa_data:
        member, _ = Member.objects.get_or_create(
            group=aespa,
            stage_name=member_data['stage_name'],
            defaults=member_data
        )
        aespa_members.append(member)
        print(f"  ✓ Miembro: {member.stage_name}")
    
    # Álbum: MY WORLD
    print("\n💿 Creando álbum: MY WORLD")
    my_world, _ = Album.objects.get_or_create(
        group=aespa,
        title="MY WORLD",
        defaults={
            'release_date': date(2023, 5, 8),
            'album_type': 'mini'
        }
    )
    
    # Versiones
    for version_name in ['REAL ver.', 'SYNK ver.']:
        version, _ = AlbumVersion.objects.get_or_create(
            album=my_world,
            version_name=version_name,
            defaults={
                'number_of_photocards': 1
            }
        )
        print(f"  ✓ Versión: {version.version_name}")
        
        # Photocards
        for member in aespa_members:
            Photocard.objects.get_or_create(
                group=aespa,
                album_version=version,
                member=member,
                photocard_type='standard',
                defaults={
                    'name': f'{member.stage_name} - {version_name}',
                    'release_date': my_world.release_date
                }
            )
    
    # Lightstick
    print("\n💡 Creando lightstick: nævis")
    Lightstick.objects.get_or_create(
        group=aespa,
        name="nævis",
        version="Ver. 1",
        defaults={
            'release_date': date(2023, 6, 1)
        }
    )
    
    # =========================================================================
    # GRUPO 3: i-dle
    # =========================================================================
    print("\n📀 Creando grupo: i-dle")
    gidle, _ = Group.objects.get_or_create(
        name="i-dle",
        defaults={
            'korean_name': '(여자)아이들',
            'debut_date': date(2018, 5, 2),
            'agency': 'CUBE Entertainment',
            'group_type': 'girl_group'
        }
    )
    
    # Miembros
    members_gidle_data = [
        {'stage_name': 'Miyeon', 'real_name': 'Cho Miyeon (조미연)', 'birth_date': date(1997, 1, 31), 'position': 'Main Vocalist, Visual'},
        {'stage_name': 'Minnie', 'real_name': 'Nicha Yontararak (ณิชา ยนตรรักษ์)', 'birth_date': date(1997, 10, 23), 'position': 'Main Vocalist'},
        {'stage_name': 'Soyeon', 'real_name': 'Jeon Soyeon (전소연)', 'birth_date': date(1998, 8, 26), 'position': 'Leader, Main Rapper, Center'},
        {'stage_name': 'Yuqi', 'real_name': 'Song Yuqi (宋雨琦)', 'birth_date': date(1999, 9, 23), 'position': 'Lead Dancer, Sub Vocalist'},
        {'stage_name': 'Shuhua', 'real_name': 'Yeh Shuhua (葉舒華)', 'birth_date': date(2000, 1, 6), 'position': 'Sub Vocalist, Visual, Maknae'},
    ]
    
    gidle_members = []
    for member_data in members_gidle_data:
        member, _ = Member.objects.get_or_create(
            group=gidle,
            stage_name=member_data['stage_name'],
            defaults=member_data
        )
        gidle_members.append(member)
        print(f"  ✓ Miembro: {member.stage_name}")
    
    # Álbum: I feel
    print("\n💿 Creando álbum: I feel")
    i_feel, _ = Album.objects.get_or_create(
        group=gidle,
        title="I feel",
        defaults={
            'release_date': date(2023, 5, 15),
            'album_type': 'mini'
        }
    )
    
    # Versiones
    for version_name in ['HEAT ver.', 'WAVE ver.']:
        version, _ = AlbumVersion.objects.get_or_create(
            album=i_feel,
            version_name=version_name,
            defaults={
                'number_of_photocards': 1
            }
        )
        print(f"  ✓ Versión: {version.version_name}")
        
        # Photocards
        for member in gidle_members:
            Photocard.objects.get_or_create(
                group=gidle,
                album_version=version,
                member=member,
                photocard_type='standard',
                defaults={
                    'name': f'{member.stage_name} - {version_name}',
                    'release_date': i_feel.release_date
                }
            )
    
    # Lightstick
    print("\n💡 Creando lightstick: I-LIGHT")
    Lightstick.objects.get_or_create(
        group=gidle,
        name="I-LIGHT",
        version="Ver. 1",
        defaults={
            'release_date': date(2019, 8, 20)
        }
    )
    
    # =========================================================================
    # GRUPO 4: NMIXX
    # =========================================================================
    print("\n📀 Creando grupo: NMIXX")
    nmixx, _ = Group.objects.get_or_create(
        name="NMIXX",
        defaults={
            'korean_name': '엔믹스',
            'debut_date': date(2022, 2, 22),
            'agency': 'JYP Entertainment',
            'group_type': 'girl_group'
        }
    )
    
    # Miembros
    members_nmixx_data = [
        {'stage_name': 'Lily', 'real_name': 'Lily Jin Morrow (릴리 진 모로우)', 'birth_date': date(2002, 10, 17), 'position': 'Main Vocalist'},
        {'stage_name': 'Haewon', 'real_name': 'Oh Haewon (오해원)', 'birth_date': date(2003, 2, 25), 'position': 'Leader, Main Vocalist'},
        {'stage_name': 'Sullyoon', 'real_name': 'Seol Yoon-ah (설윤아)', 'birth_date': date(2004, 1, 26), 'position': 'Lead Vocalist, Visual'},
        {'stage_name': 'Bae', 'real_name': 'Lee Jinsol (이진솔)', 'birth_date': date(2004, 12, 28), 'position': 'Main Dancer, Sub Vocalist'},
        {'stage_name': 'Jiwoo', 'real_name': 'Kim Jiwoo (김지우)', 'birth_date': date(2005, 4, 20), 'position': 'Lead Dancer, Lead Rapper'},
        {'stage_name': 'Kyujin', 'real_name': 'Jang Kyujin (장규진)', 'birth_date': date(2006, 5, 26), 'position': 'Main Dancer, Main Rapper, Maknae'},
    ]
    
    nmixx_members = []
    for member_data in members_nmixx_data:
        member, _ = Member.objects.get_or_create(
            group=nmixx,
            stage_name=member_data['stage_name'],
            defaults=member_data
        )
        nmixx_members.append(member)
        print(f"  ✓ Miembro: {member.stage_name}")
    
    # Álbum: expergo
    print("\n💿 Creando álbum: expergo")
    expergo, _ = Album.objects.get_or_create(
        group=nmixx,
        title="expergo",
        defaults={
            'release_date': date(2023, 3, 20),
            'album_type': 'mini'
        }
    )
    
    # Versiones
    for version_name in ['REAL ver.', 'UNKNOWN ver.']:
        version, _ = AlbumVersion.objects.get_or_create(
            album=expergo,
            version_name=version_name,
            defaults={
                'number_of_photocards': 1
            }
        )
        print(f"  ✓ Versión: {version.version_name}")
        
        # Photocards
        for member in nmixx_members:
            Photocard.objects.get_or_create(
                group=nmixx,
                album_version=version,
                member=member,
                photocard_type='standard',
                defaults={
                    'name': f'{member.stage_name} - {version_name}',
                    'release_date': expergo.release_date
                }
            )
    
    # Lightstick
    print("\n💡 Creando lightstick: NSWER")
    Lightstick.objects.get_or_create(
        group=nmixx,
        name="NSWER",
        version="Ver. 1",
        defaults={
            'release_date': date(2023, 7, 15)
        }
    )
    
    # =========================================================================
    # GRUPO 5: LE SSERAFIM
    # =========================================================================
    print("\n📀 Creando grupo: LE SSERAFIM")
    le_sserafim, _ = Group.objects.get_or_create(
        name="LE SSERAFIM",
        defaults={
            'korean_name': '르세라핌',
            'debut_date': date(2022, 5, 2),
            'agency': 'Source Music (HYBE)',
            'group_type': 'girl_group'
        }
    )
    
    # Miembros
    members_lsf_data = [
        {'stage_name': 'Sakura', 'real_name': 'Miyawaki Sakura (宮脇咲良)', 'birth_date': date(1998, 3, 19), 'position': 'Vocalist'},
        {'stage_name': 'Chaewon', 'real_name': 'Kim Chaewon (김채원)', 'birth_date': date(2000, 8, 1), 'position': 'Leader, Main Vocalist'},
        {'stage_name': 'Yunjin', 'real_name': 'Huh Yunjin (허윤진)', 'birth_date': date(2001, 10, 8), 'position': 'Main Vocalist'},
        {'stage_name': 'Kazuha', 'real_name': 'Nakamura Kazuha (中村一葉)', 'birth_date': date(2003, 8, 9), 'position': 'Lead Dancer, Sub Vocalist'},
        {'stage_name': 'Eunchae', 'real_name': 'Hong Eunchae (홍은채)', 'birth_date': date(2006, 11, 10), 'position': 'Vocalist, Maknae'},
    ]
    
    lsf_members = []
    for member_data in members_lsf_data:
        member, _ = Member.objects.get_or_create(
            group=le_sserafim,
            stage_name=member_data['stage_name'],
            defaults=member_data
        )
        lsf_members.append(member)
        print(f"  ✓ Miembro: {member.stage_name}")
    
    # Álbum: UNFORGIVEN
    print("\n💿 Creando álbum: UNFORGIVEN")
    unforgiven, _ = Album.objects.get_or_create(
        group=le_sserafim,
        title="UNFORGIVEN",
        defaults={
            'release_date': date(2023, 5, 1),
            'album_type': 'full'
        }
    )
    
    # Versiones
    for version_name in ['COMPACT ver.', 'CRIMSON ver.', 'SILVER ver.']:
        version, _ = AlbumVersion.objects.get_or_create(
            album=unforgiven,
            version_name=version_name,
            defaults={
                'number_of_photocards': 1
            }
        )
        print(f"  ✓ Versión: {version.version_name}")
        
        # Photocards
        for member in lsf_members:
            Photocard.objects.get_or_create(
                group=le_sserafim,
                album_version=version,
                member=member,
                photocard_type='standard',
                defaults={
                    'name': f'{member.stage_name} - {version_name}',
                    'release_date': unforgiven.release_date
                }
            )
    
    # Lightstick
    print("\n💡 Creando lightstick: FEARNOT BONG")
    Lightstick.objects.get_or_create(
        group=le_sserafim,
        name="FEARNOT BONG",
        version="Ver. 1",
        defaults={
            'release_date': date(2023, 10, 20)
        }
    )
    
    # =========================================================================
    # ESTADÍSTICAS FINALES
    # =========================================================================
    print("\n✅ ¡Catálogo poblado exitosamente!")
    print(f"\n📊 Estadísticas finales:")
    print(f"   Grupos: {Group.objects.count()}")
    print(f"   Miembros: {Member.objects.count()}")
    print(f"   Álbumes: {Album.objects.count()}")
    print(f"   Versiones de álbumes: {AlbumVersion.objects.count()}")
    print(f"   Photocards: {Photocard.objects.count()}")
    print(f"   Lightsticks: {Lightstick.objects.count()}")
    print(f"\n💾 Total de coleccionables: {Photocard.objects.count() + Lightstick.objects.count()}")
    
    print("\n🎵 Tus grupos favoritos están listos:")
    for group in Group.objects.all():
        print(f"   ✨ {group.name} ({group.members.count()} miembros)")

if __name__ == '__main__':
    populate()