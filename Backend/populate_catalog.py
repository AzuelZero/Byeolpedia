# populate_catalog.py
"""
Script para poblar el catálogo con grupos kpop:
ITZY, aespa, Stray Kids, NMIXX, TWICE, LE SSERAFIM, IZ*ONE, IVE, i-dle
Y solistas: Kwon Eunbi, Lee Chaeyeon, Choi Yena
"""

import os
import django
from datetime import date
import logging
from typing import Dict, List, Tuple

# Configurar Django para que el script pueda acceder a los modelos
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'byeolpedia_api.settings')
django.setup()

# Ahora que Django está configurado, podemos importar los modelos
from catalog.models import Group, Member, Album, AlbumVersion, Photocard, Lightstick

# Configurar logging para mejor manejo de errores
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# Constantes para los tipos de grupo
GIRL_GROUP = "girl_group"
BOY_GROUP = "boy_group"
SOLO = "solo"

# Constantes para los tipos de álbum
MINI_ALBUM = "mini_album"
STUDIO_ALBUM = "studio_album"
SINGLE_ALBUM = "single_album"

# Constantes para los tipos de photocard
MEMBER_CARD = "member"


def get_catalog_statistics() -> Dict[str, int]:
    """
    Obtiene las estadísticas del catálogo de la base de datos.
    
    Returns:
        Dict[str, int]: Diccionario con las estadísticas del catálogo
    """
    try:
        return {
            'groups': Group.objects.count(),
            'idols': Member.objects.count(),
            'albums': Album.objects.count(),
            'photocards': Photocard.objects.count(),
            'lightsticks': Lightstick.objects.count()
        }
    except Exception as e:
        logger.error(f"Error al obtener estadísticas del catálogo: {str(e)}")
        raise


def get_groups_with_status() -> List[Tuple[str, str]]:
    """
    Obtiene la lista de grupos con su estado (Activo/Disuelto).
    
    Returns:
        List[Tuple[str, str]]: Lista de tuplas con (nombre_grupo, estado)
    """
    try:
        groups = []
        for group in Group.objects.all().order_by('name'):
            status = "Disuelto" if group.name == "IZ*ONE" else "Activo"
            groups.append((group.name, status))
        return groups
    except Exception as e:
        logger.error(f"Error al obtener grupos con estado: {str(e)}")
        raise


def display_final_statistics():
    """
    Muestra las estadísticas finales del catálogo de forma estructurada.
    """
    try:
        # Obtener estadísticas
        stats = get_catalog_statistics()
        groups = get_groups_with_status()
        
        # Calcular total de coleccionables
        total_collectibles = stats['photocards'] + stats['lightsticks']
        
        # Mostrar mensaje de éxito
        print("\n" + "="*50)
        print("Catálogo poblado exitosamente".center(50))
        print("="*50)
        
        # Mostrar estadísticas
        print("\nEstadísticas finales:")
        print(f"   • Grupos/Solistas: {stats['groups']}")
        print(f"   • Ídolos: {stats['idols']}")
        print(f"   • Álbumes: {stats['albums']}")
        print(f"   • Photocards: {stats['photocards']}")
        print(f"   • Lightsticks: {stats['lightsticks']}")
        print(f"\n   • Total de coleccionables: {total_collectibles}")
        
        # Mostrar lista de grupos
        print("\nGrupos/Solistas en la base de datos:")
        for name, status in groups:
            print(f"   - {name} ({status})")
        
        print("\n" + "="*50)
        
    except Exception as e:
        logger.error(f"Error al mostrar estadísticas finales: {str(e)}")
        print(f"\nError al mostrar estadísticas: {str(e)}")


def check_existing_groups() -> List[str]:
    """
    Verifica qué grupos ya existen en la base de datos.
    
    Returns:
        List[str]: Lista de nombres de grupos existentes
    """
    try:
        existing_groups = list(Group.objects.values_list('name', flat=True))
        logger.info(f"Grupos existentes en la base de datos: {existing_groups}")
        return existing_groups
    except Exception as e:
        logger.error(f"Error al verificar grupos existentes: {str(e)}")
        raise


def create_group_with_members(group_data: Dict, members_data: List[Tuple]) -> Tuple[Group, List[Member]]:
    """
    Crea un grupo y sus miembros en la base de datos.
    
    Args:
        group_data: Diccionario con datos del grupo
        members_data: Lista de tuplas con datos de los miembros
        
    Returns:
        Tuple[Group, List[Member]]: Grupo creado y lista de miembros creados
    """
    try:
        # Validar datos del grupo
        validate_group_data(group_data)
        
        # Validar datos de los miembros
        for member_data in members_data:
            validate_member_data(member_data)
        
        # Crear grupo
        group = Group.objects.create(**group_data)
        logger.info(f"Grupo {group.name} creado con ID: {group.id}")
        
        # Preparar miembros para creación en lote
        members_to_create = []
        for member_data in members_data:
            members_to_create.append(
                Member(
                    group=group,
                    stage_name=member_data[0],
                    real_name=member_data[1],
                    birth_date=member_data[2],
                    position=member_data[3],
                    is_active=member_data[4] if len(member_data) > 4 else True
                )
            )
        
        # Crear todos los miembros en una sola operación
        members = Member.objects.bulk_create(members_to_create)
        
        # Registrar los miembros creados
        for member in members:
            logger.info(f"  Miembro: {member.stage_name} (ID: {member.id})")
        
        return group, members
    except Exception as e:
        logger.error(f"Error al crear grupo y miembros: {str(e)}")
        raise


def create_album_with_version_and_photocards(group: Group, members: List[Member],
                                             album_data: Dict, version_name: str = "Standard") -> Album:
    """
    Crea un álbum, su versión y photocards para todos los miembros.
    
    Args:
        group: Grupo al que pertenece el álbum
        members: Lista de miembros del grupo
        album_data: Diccionario con datos del álbum
        version_name: Nombre de la versión del álbum
        
    Returns:
        Album: Álbum creado
        
    Raises:
        ValueError: Si no hay miembros para crear photocards
        Exception: Si ocurre un error en la creación de objetos
    """
    if not members:
        raise ValueError("No se pueden crear photocards sin miembros")
    
    try:
        # Crear álbum
        album = Album.objects.create(group=group, **album_data)
        logger.info(f"  Álbum {album.title} creado con ID: {album.id}")
        
        # Crear versión del álbum
        album_version = AlbumVersion.objects.create(
            album=album,
            version_name=version_name,
            number_of_photocards=len(members)
        )
        
        # Crear photocards para cada miembro
        photocards_to_create = []
        for member in members:
            photocards_to_create.append(
                Photocard(
                    group=group,
                    album_version=album_version,
                    member=member,
                    name=f"{member.stage_name} - {album.title}",
                    release_date=album_data.get('release_date'),
                    photocard_type=MEMBER_CARD
                )
            )
        
        # Crear todas las photocards en una sola operación
        Photocard.objects.bulk_create(photocards_to_create)
        logger.info(f"  Creadas {len(photocards_to_create)} photocards para el álbum {album.title}")
        
        return album
    except Exception as e:
        logger.error(f"Error al crear álbum y photocards: {str(e)}")
        raise


def create_lightstick_for_group(group: Group, lightstick_data: Dict) -> Lightstick:
    """
    Crea un lightstick para un grupo.
    
    Args:
        group: Grupo al que pertenece el lightstick
        lightstick_data: Diccionario con datos del lightstick
        
    Returns:
        Lightstick: Lightstick creado
    """
    try:
        lightstick = Lightstick.objects.create(group=group, **lightstick_data)
        logger.info(f"  Lightstick {lightstick.name} creado")
        return lightstick
    except Exception as e:
        logger.error(f"Error al crear lightstick: {str(e)}")
        raise


def process_group_data(group_name: str, existing_groups: List[str]) -> bool:
    """
    Procesa los datos de un grupo específico si no existe en la base de datos.
    
    Args:
        group_name: Nombre del grupo a procesar
        existing_groups: Lista de grupos existentes
        
    Returns:
        bool: True si se procesó el grupo, False si ya existía
    """
    if group_name in existing_groups:
        print(f"\n{group_name} ya existe en la base de datos, omitiendo...")
        return False
    
    print(f"\nCreando grupo: {group_name}")
    return True


def validate_member_data(member_data: Tuple) -> bool:
    """
    Valida los datos de un miembro antes de crearlo.
    
    Args:
        member_data: Tupla con datos del miembro
        
    Returns:
        bool: True si los datos son válidos, False en caso contrario
        
    Raises:
        ValueError: Si los datos no son válidos
    """
    if len(member_data) < 4:
        raise ValueError("Los datos del miembro deben contener al menos 4 elementos")
    
    stage_name, real_name, birth_date, position = member_data[:4]
    
    if not stage_name or not real_name:
        raise ValueError("El nombre artístico y el nombre real son obligatorios")
    
    if not birth_date:
        raise ValueError("La fecha de nacimiento es obligatoria")
    
    if not position:
        raise ValueError("La posición en el grupo es obligatoria")
    
    return True


def validate_group_data(group_data: Dict) -> bool:
    """
    Valida los datos de un grupo antes de crearlo.
    
    Args:
        group_data: Diccionario con datos del grupo
        
    Returns:
        bool: True si los datos son válidos, False en caso contrario
        
    Raises:
        ValueError: Si los datos no son válidos
    """
    required_fields = ['name', 'korean_name', 'debut_date', 'agency', 'group_type']
    
    for field in required_fields:
        if field not in group_data or not group_data[field]:
            raise ValueError(f"El campo '{field}' es obligatorio en los datos del grupo")
    
    if group_data['group_type'] not in [GIRL_GROUP, BOY_GROUP, SOLO]:
        raise ValueError(f"Tipo de grupo no válido: {group_data['group_type']}")
    
    return True


def populate():
    """
    Puebla la base de datos con datos de kpop.
    
    Esta función crea grupos, miembros, álbumes, versiones, photocards y lightsticks
    para varios grupos de K-pop y solistas.
    
    Optimizado para reducir consultas a la base de datos y mejorar el rendimiento.
    """
    logger.info("Iniciando población de la base de datos con grupos kpop...")
    
    try:
        # Verificar grupos existentes (una sola consulta)
        existing_groups = check_existing_groups()
                
        # Contador para estadísticas
        created_groups = 0
        # =========================================================================
        # GRUPO 1: ITZY
        # =========================================================================
        if process_group_data("ITZY", existing_groups):
            # Datos del grupo
            group_data = {
                "name": "ITZY",
                "korean_name": "있지",
                "debut_date": date(2019, 2, 12),
                "agency": "JYP Entertainment",
                "group_type": GIRL_GROUP
            }
            
            # Datos de los miembros
            members_data = [
                ("Yeji (예지)", "황 예지 (Hwang Yeji)", date(2000, 5, 26), "Leader, Main Dancer, Lead Vocalist, Sub Rapper"),
                ("Lia (리아)", "최 지수 (Choi Jisu)", date(2000, 7, 21), "Main Vocalist, Sub Rapper"),
                ("Ryujin (류진)", "신 류진 (Shin Ryujin)", date(2001, 4, 17), "Main Rapper, Lead Dancer, Sub Vocalist, Center"),
                ("Chaeryeong (채령)", "이채령 (Lee Chaeryeong)", date(2001, 6, 5), "Main Dancer, Sub Vocalist, Sub Rapper"),
                ("Yuna (유나)", "신 유나 (Shin Yuna)", date(2003, 12, 9), "Lead Dancer, Lead Rapper, Sub Vocalist, Visual, Maknae"),
            ]
            
            # Crear grupo y miembros
            itzy, itzy_members = create_group_with_members(group_data, members_data)
            
            # Crear álbum, versión y photocards
            album_data = {
                "title": "KILL MY DOUBT",
                "release_date": date(2023, 7, 31),
                "album_type": MINI_ALBUM
            }
            create_album_with_version_and_photocards(itzy, itzy_members, album_data)
            
            # Crear lightstick
            lightstick_data = {
                "name": "LIGHT RING",
                "version": "Ver. 1",
                "release_date": date(2020, 3, 13)
            }
            create_lightstick_for_group(itzy, lightstick_data)
            
            created_groups += 1
        
        # =========================================================================
        # GRUPO 2: aespa
        # =========================================================================
        if process_group_data("aespa", existing_groups):
            # Datos del grupo
            group_data = {
                "name": "aespa",
                "korean_name": "에스파",
                "debut_date": date(2020, 11, 17),
                "agency": "SM Entertainment",
                "group_type": GIRL_GROUP
            }
            
            # Datos de los miembros
            members_data = [
                ("Karina (카리나)", "유 지민 (Yoo Jimin)", date(2000, 4, 11), "Leader, Main Dancer, Lead Rapper, Sub Vocalist, Visual, Center"),
                ("Giselle (지젤)", "内永 枝利 (Uchinaga Eri)", date(2000, 10, 30), "Main Rapper, Sub Vocalist"),
                ("Winter (윈터)", "김 민정 (Kim Minjeong)", date(2001, 1, 1), "Main Vocalist, Lead Dancer, Visual"),
                ("Ningning (닝닝)", "宁 艺卓 (Níng Yìzhuó)", date(2002, 10, 23), "Main Vocalist, Maknae"),
            ]
            
            # Crear grupo y miembros
            aespa, aespa_members = create_group_with_members(group_data, members_data)
            
            # Crear álbum, versión y photocards
            album_data = {
                "title": "MY WORLD",
                "release_date": date(2023, 5, 8),
                "album_type": MINI_ALBUM
            }
            create_album_with_version_and_photocards(aespa, aespa_members, album_data)
            
            # Crear lightstick
            lightstick_data = {
                "name": "nævis",
                "version": "Ver. 1",
                "release_date": date(2023, 6, 1)
            }
            create_lightstick_for_group(aespa, lightstick_data)
        else:
            print("\naespa ya existe en la base de datos, omitiendo...")
        
        # =========================================================================
        # GRUPO 3: Stray Kids
        # =========================================================================
        if process_group_data("Stray Kids", existing_groups):
            # Datos del grupo
            group_data = {
                "name": "Stray Kids",
                "korean_name": "스트레이 키즈",
                "debut_date": date(2018, 3, 25),
                "agency": "JYP Entertainment",
                "group_type": BOY_GROUP
            }
            
            # Datos de los miembros
            members_data = [
                ("Bang Chan (방찬)", "방찬 (Bang Chan) / Christopher Bang", date(1997, 10, 3), "Leader, Producer, Vocalist, Rapper"),
                ("Lee Know (리노)", "이 민호 (Lee Minho)", date(1998, 10, 25), "Main Dancer, Vocalist, Sub Rapper"),
                ("Changbin (창빈)", "서 창빈 (Seo Changbin)", date(1999, 8, 11), "Main Rapper, Sub Vocalist, Producer"),
                ("Hyunjin (현진)", "황 현진 (Hwang Hyunjin)", date(2000, 3, 20), "Main Dancer, Sub Rapper, Visual"),
                ("Han (한)", "한 지성 (Han Jisung)", date(2000, 9, 14), "Main Rapper, Lead Vocalist, Producer"),
                ("Felix (필릭스)", "이 용복 (Lee Yongbok) / Lee Felix", date(2000, 9, 15), "Lead Dancer, Lead Rapper, Sub Vocalist"),
                ("Seungmin (승민)", "김 승민 (Kim Seungmin)", date(2000, 9, 22), "Main Vocalist"),
                ("I.N (아이엔)", "양 정인 (Yang Jeongin)", date(2001, 2, 8), "Vocalist, Maknae"),
            ]
            
            # Crear grupo y miembros
            stray_kids, stray_kids_members = create_group_with_members(group_data, members_data)
            
            # Crear álbum, versión y photocards
            album_data = {
                "title": "★★★★★ (5-STAR)",
                "release_date": date(2023, 6, 2),
                "album_type": STUDIO_ALBUM
            }
            create_album_with_version_and_photocards(stray_kids, stray_kids_members, album_data)
            
            # Crear lightstick
            lightstick_data = {
                "name": "NOVY",
                "version": "Ver. 1",
                "release_date": date(2019, 8, 1)
            }
            create_lightstick_for_group(stray_kids, lightstick_data)
            
            created_groups += 1
        else:
            print("\nStray Kids ya existe en la base de datos, omitiendo...")
        
        # =========================================================================
        # GRUPO 4: NMIXX
        # =========================================================================
        if process_group_data("NMIXX", existing_groups):
            # Datos del grupo
            group_data = {
                "name": "NMIXX",
                "korean_name": "엔믹스",
                "debut_date": date(2022, 2, 22),
                "agency": "JYP Entertainment",
                "group_type": GIRL_GROUP
            }
            
            # Datos de los miembros
            members_data = [
                ("Lily (릴리)", "Lily Jin Park Morrow", date(2002, 10, 17), "Main Vocalist"),
                ("Haewon (해원)", "오 해원 (Oh Haewon)", date(2003, 2, 25), "Leader, Main Vocalist"),
                ("Sullyoon (설윤)", "설 윤아 (Seol Yoona)", date(2004, 1, 26), "Vocalist, Visual, Face of the Group"),
                ("Bae (배)", "배 진솔 (Bae Jinsol)", date(2004, 12, 28), "Main Dancer, Vocalist, Rapper"),
                ("Jiwoo (지우)", "김 지우 (Kim Jiwoo)", date(2005, 4, 13), "Lead Dancer, Lead Rapper, Vocalist"),
                ("Kyujin (규진)", "장 규진 (Jang Kyujin)", date(2006, 5, 26), "Main Dancer, Main Rapper, Vocalist, Maknae"),
            ]
            
            # Crear grupo y miembros
            nmixx, nmixx_members = create_group_with_members(group_data, members_data)
            
            # Crear álbum, versión y photocards
            album_data = {
                "title": "expérgo",
                "release_date": date(2023, 5, 23),
                "album_type": MINI_ALBUM
            }
            create_album_with_version_and_photocards(nmixx, nmixx_members, album_data)
            
            # Crear lightstick
            lightstick_data = {
                "name": "NKONK",
                "version": "Ver. 1",
                "release_date": date(2023, 7, 31)
            }
            create_lightstick_for_group(nmixx, lightstick_data)
            
            created_groups += 1
        else:
            print("\nNMIXX ya existe en la base de datos, omitiendo...")
        
        # =========================================================================
        # GRUPO 5: TWICE
        # =========================================================================
        if process_group_data("TWICE", existing_groups):
            # Datos del grupo
            group_data = {
                "name": "TWICE",
                "korean_name": "트와이스",
                "debut_date": date(2015, 10, 20),
                "agency": "JYP Entertainment",
                "group_type": GIRL_GROUP
            }
            
            # Datos de los miembros
            members_data = [
                ("Nayeon (나연)", "임 나연 (Im Nayeon)", date(1995, 9, 22), "Lead Vocalist, Lead Dancer, Center"),
                ("Jeongyeon (정연)", "유 정연 (Yoo Jeongyeon)", date(1996, 11, 1), "Lead Vocalist"),
                ("Momo (모모)", "平井 もも (Hirai Momo)", date(1996, 11, 9), "Main Dancer, Sub Vocalist, Sub Rapper"),
                ("Sana (사나)", "湊崎 紗夏 (Minatozaki Sana)", date(1996, 12, 29), "Sub Vocalist"),
                ("Jihyo (지효)", "박 지효 (Park Jihyo)", date(1997, 2, 1), "Leader, Main Vocalist"),
                ("Mina (미나)", "名井 南 (Myoi Mina)", date(1997, 3, 24), "Main Dancer, Sub Vocalist"),
                ("Dahyun (다현)", "김 다현 (Kim Dahyun)", date(1998, 5, 28), "Lead Rapper, Sub Vocalist"),
                ("Chaeyoung (채영)", "손 채영 (Son Chaeyoung)", date(1999, 4, 23), "Main Rapper, Sub Vocalist"),
                ("Tzuyu (쯔위)", "周 子瑜 (Zhōu Zǐyú)", date(1999, 6, 14), "Lead Dancer, Sub Vocalist, Visual, Maknae"),
            ]
            
            # Crear grupo y miembros
            twice, twice_members = create_group_with_members(group_data, members_data)
            
            # Crear álbum, versión y photocards
            album_data = {
                "title": "READY TO BE",
                "release_date": date(2023, 3, 10),
                "album_type": MINI_ALBUM
            }
            create_album_with_version_and_photocards(twice, twice_members, album_data)
            
            # Crear lightstick
            lightstick_data = {
                "name": "Candy Bong",
                "version": "Ver. Z",
                "release_date": date(2022, 8, 26)
            }
            create_lightstick_for_group(twice, lightstick_data)
            
            created_groups += 1
        else:
            print("\nTWICE ya existe en la base de datos, omitiendo...")
        
        # =========================================================================
        # GRUPO 6: LE SSERAFIM
        # =========================================================================
        if process_group_data("LE SSERAFIM", existing_groups):
            # Datos del grupo
            group_data = {
                "name": "LE SSERAFIM",
                "korean_name": "르세라핌",
                "debut_date": date(2022, 5, 2),
                "agency": "Source Music",
                "group_type": GIRL_GROUP
            }
            
            # Datos de los miembros
            members_data = [
                ("Sakura (사쿠라)", "宮脇 咲良 (Miyawaki Sakura)", date(1998, 3, 19), "Vocalist"),
                ("Kim Chaewon (김채원)", "김 채원 (Kim Chaewon)", date(2000, 8, 1), "Leader, Vocalist"),
                ("Huh Yunjin (허윤진)", "허 윤진 (Huh Yunjin)", date(2001, 10, 8), "Main Vocalist, Rapper"),
                ("Kazuha (카즈하)", "中村 一葉 (Nakamura Kazuha)", date(2003, 8, 9), "Lead Dancer, Sub Vocalist"),
                ("Hong Eunchae (홍은채)", "홍 은채 (Hong Eunchae)", date(2006, 11, 10), "Vocalist, Maknae"),
            ]
            
            # Crear grupo y miembros
            le_sserafim, le_sserafim_members = create_group_with_members(group_data, members_data)
            
            # Crear álbum, versión y photocards
            album_data = {
                "title": "UNFORGIVEN",
                "release_date": date(2023, 5, 1),
                "album_type": STUDIO_ALBUM
            }
            create_album_with_version_and_photocards(le_sserafim, le_sserafim_members, album_data)
            
            # Crear lightstick
            lightstick_data = {
                "name": "Fim-antler",
                "version": "Ver. 1",
                "release_date": date(2023, 1, 9)
            }
            create_lightstick_for_group(le_sserafim, lightstick_data)
            
            created_groups += 1
        else:
            print("\nLE SSERAFIM ya existe en la base de datos, omitiendo...")
        
        # =========================================================================
        # GRUPO 7: IZ*ONE (disuelto)
        # =========================================================================
        if process_group_data("IZ*ONE", existing_groups):
            # Datos del grupo
            group_data = {
                "name": "IZ*ONE",
                "korean_name": "아이즈원",
                "debut_date": date(2018, 10, 29),
                "agency": "Off The Record Entertainment",
                "group_type": GIRL_GROUP
            }
            
            # Datos de los miembros
            members_data = [
                ("Kwon Eunbi (권은비)", "권 은비 (Kwon Eunbi)", date(1995, 9, 27), "Leader, Main Dancer, Lead Vocalist"),
                ("Sakura (사쿠라)", "宮脇 咲良 (Miyawaki Sakura)", date(1998, 3, 19), "Sub Vocalist"),
                ("Kang Hyewon (강혜원)", "강 혜원 (Kang Hyewon)", date(1999, 7, 5), "Sub Vocalist, Visual"),
                ("Choi Yena (최예나)", "최 예나 (Choi Yena)", date(1999, 9, 29), "Lead Dancer, Sub Vocalist, Sub Rapper"),
                ("Lee Chaeyeon (이채연)", "이 채연 (Lee Chaeyeon)", date(2000, 1, 11), "Main Dancer, Lead Vocalist, Lead Rapper"),
                ("Kim Chaewon (김채원)", "김 채원 (Kim Chaewon)", date(2000, 8, 1), "Lead Vocalist, Lead Dancer"),
                ("Kim Minju (김민주)", "김 민주 (Kim Minju)", date(2001, 2, 5), "Lead Vocalist, Visual, Center"),
                ("Nako (나코)", "矢吹 奈子 (Yabuki Nako)", date(2001, 6, 18), "Lead Vocalist"),
                ("Hitomi (히토미)", "本田 仁美 (Honda Hitomi)", date(2001, 10, 6), "Sub Vocalist"),
                ("Jo Yuri (조유리)", "조 유리 (Jo Yuri)", date(2001, 10, 22), "Main Vocalist"),
                ("An Yujin (안유진)", "안 유진 (An Yujin)", date(2003, 9, 1), "Lead Vocalist, Lead Dancer"),
                ("Jang Wonyoung (장원영)", "장 원영 (Jang Wonyoung)", date(2004, 8, 31), "Center, Sub Vocalist, Visual, Maknae"),
            ]
            
            # Crear grupo y miembros
            izone, izone_members = create_group_with_members(group_data, members_data)
            
            # Crear álbum, versión y photocards
            album_data = {
                "title": "One-reeler / Act IV",
                "release_date": date(2020, 12, 7),
                "album_type": MINI_ALBUM
            }
            create_album_with_version_and_photocards(izone, izone_members, album_data)
            
            # Crear lightstick
            lightstick_data = {
                "name": "Color",
                "version": "Ver. 1",
                "release_date": date(2019, 4, 1)
            }
            create_lightstick_for_group(izone, lightstick_data)
            
            created_groups += 1
        else:
            print("\nIZ*ONE ya existe en la base de datos, omitiendo...")
        
        # =========================================================================
        # GRUPO 8: IVE
        # =========================================================================
        if process_group_data("IVE", existing_groups):
            # Datos del grupo
            group_data = {
                "name": "IVE",
                "korean_name": "아이브",
                "debut_date": date(2021, 12, 1),
                "agency": "Starship Entertainment",
                "group_type": GIRL_GROUP
            }
            
            # Datos de los miembros
            members_data = [
                ("Gaeul (가을)", "김 가을 (Kim Gaeul)", date(2002, 9, 24), "Main Dancer, Lead Rapper, Sub Vocalist"),
                ("Yujin (유진)", "안 유진 (An Yujin)", date(2003, 9, 1), "Leader, Lead Vocalist, Lead Dancer"),
                ("Rei (레이)", "直井 怜 (Naoi Rei)", date(2004, 2, 3), "Lead Rapper, Sub Vocalist"),
                ("Wonyoung (원영)", "장 원영 (Jang Wonyoung)", date(2004, 8, 31), "Center, Sub Vocalist, Visual"),
                ("Liz (리즈)", "김 지원 (Kim Jiwon)", date(2004, 11, 21), "Main Vocalist"),
                ("Leeseo (리세)", "이 현서 (Lee Hyunseo)", date(2007, 2, 21), "Sub Vocalist, Maknae"),
            ]
            
            # Crear grupo y miembros
            ive, ive_members = create_group_with_members(group_data, members_data)
            
            # Crear álbum, versión y photocards
            album_data = {
                "title": "I've MINE",
                "release_date": date(2023, 4, 10),
                "album_type": SINGLE_ALBUM
            }
            create_album_with_version_and_photocards(ive, ive_members, album_data)
            
            # Crear lightstick
            lightstick_data = {
                "name": "DIVE",
                "version": "Ver. 1",
                "release_date": date(2023, 1, 24)
            }
            create_lightstick_for_group(ive, lightstick_data)
            
            created_groups += 1
        else:
            print("\nIVE ya existe en la base de datos, omitiendo...")
        
        # =========================================================================
        # GRUPO 9: i-dle
        # =========================================================================
        if process_group_data("I-DLE", existing_groups):
            # Datos del grupo
            group_data = {
                "name": "I-DLE",
                "korean_name": "아이들",
                "debut_date": date(2018, 5, 2),
                "agency": "Cube Entertainment",
                "group_type": GIRL_GROUP
            }
            
            # Datos de los miembros
            members_data = [
                ("Miyeon (미연)", "조 미연 (Cho Miyeon)", date(1997, 1, 31), "Main Vocalist, Visual"),
                ("Minnie (민니)", "ณิชา ยนตรรักษ์ (Nicha Yontararak)", date(1997, 10, 23), "Main Vocalist, Sub Rapper"),
                ("Soyeon (소연)", "전 소연 (Jeon Soyeon)", date(1998, 8, 26), "Leader, Main Rapper, Sub Vocalist, Center"),
                ("Yuqi (우기)", "宋 雨琦 (Sòng Yǔqí)", date(1999, 9, 23), "Lead Dancer, Sub Vocalist, Sub Rapper"),
                ("Shuhua (슈화)", "葉 舒華 (Yè Shūhuá)", date(2000, 1, 6), "Sub Vocalist, Maknae, Visual"),
            ]
            
            # Crear grupo y miembros
            idle, idle_members = create_group_with_members(group_data, members_data)
            
            # Crear álbum, versión y photocards
            album_data = {
                "title": "I feel",
                "release_date": date(2023, 5, 15),
                "album_type": MINI_ALBUM
            }
            create_album_with_version_and_photocards(idle, idle_members, album_data)
            
            # Crear lightstick
            lightstick_data = {
                "name": "MOLAE",
                "version": "Ver. 2",
                "release_date": date(2023, 5, 14)
            }
            create_lightstick_for_group(idle, lightstick_data)
            
            created_groups += 1
        else:
            print("\ni-dle ya existe en la base de datos, omitiendo...")
        
        # =========================================================================
        # SOLISTA 1: Kwon Eunbi
        # =========================================================================
        if process_group_data("Kwon Eunbi", existing_groups):
            # Datos del grupo
            group_data = {
                "name": "Kwon Eunbi",
                "korean_name": "권 은비",
                "debut_date": date(2021, 8, 24),
                "agency": "Woollim Entertainment",
                "group_type": SOLO
            }
            
            # Datos de los miembros
            members_data = [
                ("Kwon Eunbi (권은비)", "권은비 (Kwon Eunbi)", date(1995, 9, 27), "Soloist"),
            ]
            
            # Crear grupo y miembros
            kwon_eunbi, eunbi_members = create_group_with_members(group_data, members_data)
            
            # Crear álbum, versión y photocards
            album_data = {
                "title": "Color",
                "release_date": date(2021, 8, 24),
                "album_type": MINI_ALBUM
            }
            create_album_with_version_and_photocards(kwon_eunbi, eunbi_members, album_data)
            
            created_groups += 1
        else:
            print("\nKwon Eunbi ya existe en la base de datos, omitiendo...")
        
        # =========================================================================
        # SOLISTA 2: Lee Chaeyeon
        # =========================================================================
        if process_group_data("Lee Chaeyeon", existing_groups):
            # Datos del grupo
            group_data = {
                "name": "Lee Chaeyeon",
                "korean_name": "이 채연",
                "debut_date": date(2022, 10, 12),
                "agency": "WM Entertainment",
                "group_type": SOLO
            }
            
            # Datos de los miembros
            members_data = [
                ("Lee Chaeyeon (이채연)", "이채연 (Lee Chaeyeon)", date(2000, 1, 11), "Soloist"),
            ]
            
            # Crear grupo y miembros
            lee_chaeyeon, chaeyeon_members = create_group_with_members(group_data, members_data)
            
            # Crear álbum, versión y photocards
            album_data = {
                "title": "HUSH RUSH",
                "release_date": date(2022, 10, 12),
                "album_type": SINGLE_ALBUM
            }
            create_album_with_version_and_photocards(lee_chaeyeon, chaeyeon_members, album_data)
            
            created_groups += 1
        else:
            print("\nLee Chaeyeon ya existe en la base de datos, omitiendo...")
        
        # =========================================================================
        # SOLISTA 3: Choi Yena
        # =========================================================================
        if process_group_data("Choi Yena", existing_groups):
            # Datos del grupo
            group_data = {
                "name": "Choi Yena",
                "korean_name": "최예나",
                "debut_date": date(2022, 1, 17),
                "agency": "Yuehua Entertainment",
                "group_type": SOLO
            }
            
            # Datos de los miembros
            members_data = [
                ("Choi Yena (최예나)", "최 예나 (Choi Yena)", date(1999, 9, 29), "Soloist"),
            ]
            
            # Crear grupo y miembros
            choi_yena, yena_members = create_group_with_members(group_data, members_data)
            
            # Crear álbum, versión y photocards
            album_data = {
                "title": "SMiLEY",
                "release_date": date(2022, 1, 17),
                "album_type": SINGLE_ALBUM
            }
            create_album_with_version_and_photocards(choi_yena, yena_members, album_data)
            
            created_groups += 1
        else:
            print("\nChoi Yena ya existe en la base de datos, omitiendo...")
        
        # ESTADÍSTICAS FINALES
        display_final_statistics()
    
    except ValueError as ve:
        # Error de validación específico
        logger.error(f"Error de validación: {str(ve)}")
        print(f"\nError de validación: {str(ve)}")
    except django.db.DatabaseError as de:
        # Error de base de datos específico
        logger.error(f"Error de base de datos: {str(de)}")
        print(f"\nError de base de datos: {str(de)}")
    except Exception as e:
        # Error genérico no controlado
        logger.error(f"Error inesperado durante la población del catálogo: {str(e)}")
        print(f"\nError inesperado durante la población del catálogo: {str(e)}")
        raise


if __name__ == '__main__':
    populate()