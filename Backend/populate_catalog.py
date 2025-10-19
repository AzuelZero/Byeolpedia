# populate_catalog.py
"""
Script para poblar el catálogo con grupos kpop:
ITZY, aespa, i-dle, NMIXX, LE SSERAFIM
"""

import os
import django
from datetime import date

# Configurar Django para que el script pueda acceder a los modelos
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'byeolpedia_api.settings')
django.setup()

from django.db import connection


def clean_tables():
    """Limpia las tablas principales"""
    print("Limpiando tablas...")
    
    with connection.cursor() as cursor:
        # Tablas a limpiar (en orden correcto para evitar problemas de claves foráneas)
        tables = [
            'catalog_photocard',
            'catalog_lightstick',
            'catalog_album',
            'catalog_membership',
            'catalog_idol',
            'catalog_group'
        ]
        
        for table in tables:
            try:
                cursor.execute(f"DELETE FROM {table}")
                print(f"  Tabla {table} limpiada")
            except Exception as e:
                print(f"  Error al limpiar {table}: {str(e)}")


def reset_sequences():
    """Reinicia las secuencias de IDs de todas las tablas principales"""
    print("\nReiniciando secuencias de IDs...")
    
    with connection.cursor() as cursor:
        # Tablas a reiniciar
        tables = [
            'catalog_group',
            'catalog_idol',
            'catalog_album',
            'catalog_photocard',
            'catalog_lightstick'
        ]
        
        for table in tables:
            try:
                cursor.execute(f"ALTER SEQUENCE {table}_id_seq RESTART WITH 1")
                print(f"  Secuencia de {table} reiniciada")
            except Exception as e:
                print(f"  Error al reiniciar {table}: {str(e)}")


def populate():
    """Puebla la base de datos con datos de kpop"""
    print("\nPoblando base de datos con grupos kpop...")
    
    try:
        with connection.cursor() as cursor:
            # =========================================================================
            # GRUPO 1: ITZY
            # =========================================================================
            print("\nCreando grupo: ITZY")
            cursor.execute("""
                INSERT INTO catalog_group (name, korean_name, romanized_name, debut_date, company, group_type, status, image, description, created_at, updated_at)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, NOW(), NOW())
                RETURNING id
            """, [
                "ITZY",
                "있지",
                "ITZY",
                date(2019, 2, 12),
                "JYP Entertainment",
                "girl_group",
                "active",
                "",
                "Girl group from JYP Entertainment"
            ])
            
            result = cursor.fetchone()
            if result:
                itzy_id = result[0]
                print(f"  Grupo ITZY creado con ID: {itzy_id}")
                
                # Miembros de ITZY
                members_itzy = [
                    ("Yeji", "Hwang Yeji (황예지)", date(2000, 5, 26), "Leader"),
                    ("Lia", "Choi Jisu (최지수)", date(2000, 7, 21), "Main Vocalist"),
                    ("Ryujin", "Shin Ryujin (신류진)", date(2001, 4, 17), "Main Rapper"),
                    ("Chaeryeong", "Lee Chaeryeong (이채령)", date(2001, 6, 5), "Main Dancer"),
                    ("Yuna", "Shin Yuna (신유나)", date(2003, 12, 9), "Lead Dancer"),
                ]
                
                itzy_members = []
                for member in members_itzy:
                    # Insertar en catalog_idol
                    cursor.execute("""
                        INSERT INTO catalog_idol (stage_name, real_name, korean_name, birthday, gender, nationality, image, description, created_at, updated_at)
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, NOW(), NOW())
                        RETURNING id
                    """, [
                        member[0],
                        member[1],
                        member[1],
                        member[2],
                        "Female",
                        "Korean",
                        "",
                        f"{member[3]} of ITZY"
                    ])
                    
                    idol_result = cursor.fetchone()
                    if idol_result:
                        idol_id = idol_result[0]
                        
                        # Insertar en catalog_membership
                        cursor.execute("""
                            INSERT INTO catalog_membership (group_id, idol_id, position, join_date, is_active)
                            VALUES (%s, %s, %s, %s, %s)
                        """, [
                            itzy_id,
                            idol_id,
                            member[3],
                            date(2019, 2, 12),
                            True
                        ])
                        
                        itzy_members.append(idol_id)
                        print(f"    Miembro: {member[0]} (ID: {idol_id})")
                
                # Album de ITZY
                cursor.execute("""
                    INSERT INTO catalog_album (title, korean_title, release_date, album_type, tracks, cover_image, description, group_id, created_at, updated_at)
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, NOW(), NOW())
                    RETURNING id
                """, [
                    "KILL MY DOUBT",
                    "KILL MY DOUBT",
                    date(2023, 7, 31),
                    "mini",
                    7,
                    "",
                    "Mini album by ITZY",
                    itzy_id
                ])
                
                album_result = cursor.fetchone()
                if album_result:
                    album_id = album_result[0]
                    print(f"  Album KILL MY DOUBT creado con ID: {album_id}")
                    
                    # Photocards
                    for idol_id in itzy_members:
                        cursor.execute("""
                            INSERT INTO catalog_photocard (idol_id, album_id, name, collection_name, release_date, photocard_type, image, description, is_limited, created_at, updated_at)
                            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, NOW(), NOW())
                        """, [
                            idol_id,
                            album_id,
                            f"Photocard - KILL MY DOUBT",
                            f"KILL MY DOUBT",
                            date(2023, 7, 31),
                            "standard",
                            "",
                            f"Photocard from KILL MY DOUBT album",
                            False
                        ])
                
                # Lightstick de ITZY
                cursor.execute("""
                    INSERT INTO catalog_lightstick (group_id, name, version, release_date, price, image, description, created_at, updated_at)
                    VALUES (%s, %s, %s, %s, %s, %s, %s, NOW(), NOW())
                """, [
                    itzy_id,
                    "LIGHT RING",
                    "Ver. 1",
                    date(2020, 3, 13),
                    45.00,
                    "",
                    "Official lightstick of ITZY"
                ])
                print("  Lightstick LIGHT RING creado")
            
            # =========================================================================
            # GRUPO 2: aespa
            # =========================================================================
            print("\nCreando grupo: aespa")
            cursor.execute("""
                INSERT INTO catalog_group (name, korean_name, romanized_name, debut_date, company, group_type, status, image, description, created_at, updated_at)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, NOW(), NOW())
                RETURNING id
            """, [
                "aespa",
                "에스파",
                "aespa",
                date(2020, 11, 17),
                "SM Entertainment",
                "girl_group",
                "active",
                "",
                "Girl group from SM Entertainment"
            ])
            
            result = cursor.fetchone()
            if result:
                aespa_id = result[0]
                print(f"  Grupo aespa creado con ID: {aespa_id}")
                
                # Miembros de aespa
                members_aespa = [
                    ("Karina", "Yoo Jimin (유지민)", date(2000, 4, 11), "Leader"),
                    ("Giselle", "Uchinaga Aeri (内永枝利)", date(2000, 10, 30), "Main Rapper"),
                    ("Winter", "Kim Minjeong (김민정)", date(2001, 1, 1), "Main Vocalist"),
                    ("Ningning", "Ning Yizhuo (宁艺卓)", date(2002, 10, 23), "Main Vocalist"),
                ]
                
                aespa_members = []
                for member in members_aespa:
                    # Insertar en catalog_idol
                    cursor.execute("""
                        INSERT INTO catalog_idol (stage_name, real_name, korean_name, birthday, gender, nationality, image, description, created_at, updated_at)
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, NOW(), NOW())
                        RETURNING id
                    """, [
                        member[0],
                        member[1],
                        member[1],
                        member[2],
                        "Female",
                        "Korean/Chinese",
                        "",
                        f"{member[3]} of aespa"
                    ])
                    
                    idol_result = cursor.fetchone()
                    if idol_result:
                        idol_id = idol_result[0]
                        
                        # Insertar en catalog_membership
                        cursor.execute("""
                            INSERT INTO catalog_membership (group_id, idol_id, position, join_date, is_active)
                            VALUES (%s, %s, %s, %s, %s)
                        """, [
                            aespa_id,
                            idol_id,
                            member[3],
                            date(2020, 11, 17),
                            True
                        ])
                        
                        aespa_members.append(idol_id)
                        print(f"    Miembro: {member[0]} (ID: {idol_id})")
                
                # Album de aespa
                cursor.execute("""
                    INSERT INTO catalog_album (title, korean_title, release_date, album_type, tracks, cover_image, description, group_id, created_at, updated_at)
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, NOW(), NOW())
                    RETURNING id
                """, [
                    "MY WORLD",
                    "MY WORLD",
                    date(2023, 5, 8),
                    "mini",
                    9,
                    "",
                    "Mini album by aespa",
                    aespa_id
                ])
                
                album_result = cursor.fetchone()
                if album_result:
                    album_id = album_result[0]
                    print(f"  Album MY WORLD creado con ID: {album_id}")
                    
                    # Photocards
                    for idol_id in aespa_members:
                        cursor.execute("""
                            INSERT INTO catalog_photocard (idol_id, album_id, name, collection_name, release_date, photocard_type, image, description, is_limited, created_at, updated_at)
                            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, NOW(), NOW())
                        """, [
                            idol_id,
                            album_id,
                            f"Photocard - MY WORLD",
                            f"MY WORLD",
                            date(2023, 5, 8),
                            "standard",
                            "",
                            f"Photocard from MY WORLD album",
                            False
                        ])
                
                # Lightstick de aespa
                cursor.execute("""
                    INSERT INTO catalog_lightstick (group_id, name, version, release_date, price, image, description, created_at, updated_at)
                    VALUES (%s, %s, %s, %s, %s, %s, %s, NOW(), NOW())
                """, [
                    aespa_id,
                    "nævis",
                    "Ver. 1",
                    date(2023, 6, 1),
                    55.00,
                    "",
                    "Official lightstick of aespa"
                ])
                print("  Lightstick nævis creado")
            
            # ESTADÍSTICAS FINALES
            cursor.execute("SELECT COUNT(*) FROM catalog_group")
            groups_count = cursor.fetchone()[0]
            
            cursor.execute("SELECT COUNT(*) FROM catalog_idol")
            idols_count = cursor.fetchone()[0]
            
            cursor.execute("SELECT COUNT(*) FROM catalog_album")
            albums_count = cursor.fetchone()[0]
            
            cursor.execute("SELECT COUNT(*) FROM catalog_photocard")
            photocards_count = cursor.fetchone()[0]
            
            cursor.execute("SELECT COUNT(*) FROM catalog_lightstick")
            lightsticks_count = cursor.fetchone()[0]
            
            print("\nCatalogo poblado exitosamente!")
            print(f"\nEstadísticas finales:")
            print(f"   Grupos: {groups_count}")
            print(f"   Idolos: {idols_count}")
            print(f"   Albumes: {albums_count}")
            print(f"   Photocards: {photocards_count}")
            print(f"   Lightsticks: {lightsticks_count}")
            print(f"\nTotal de coleccionables: {photocards_count + lightsticks_count}")
            
            print("\nGrupos creados:")
            cursor.execute("SELECT id, name FROM catalog_group ORDER BY id")
            for group in cursor.fetchall():
                print(f"   - ID {group[0]}: {group[1]}")
    
    except Exception as e:
        print(f"Error: {str(e)}")
        raise


if __name__ == '__main__':
    clean_tables()
    reset_sequences()
    populate()