#!/usr/bin/env python
"""
Script para probar la API de Byeolpedia
Ejecuta este script para verificar que los endpoints básicos funcionan correctamente
"""

import os
import django
import requests
import json
import random
from datetime import datetime, timedelta

# Configurar Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'byeolpedia_api.settings')
django.setup()

# Configuración
BASE_URL = 'http://localhost:8000/api'
TEST_USER = {
    'username': 'testuser',
    'email': 'test@example.com',
    'collector_name': 'Test Collector',
    'password': 'TestPassword123!',
    'password_confirm': 'TestPassword123!'
}

def test_endpoint(method, endpoint, data=None, headers=None, expected_status=200):
    """Función helper para probar endpoints"""
    url = f"{BASE_URL}{endpoint}"
    
    try:
        if method == 'GET':
            response = requests.get(url, headers=headers)
        elif method == 'POST':
            response = requests.post(url, json=data, headers=headers)
        elif method == 'PATCH':
            response = requests.patch(url, json=data, headers=headers)
        
        print(f"\n{method} {endpoint}")
        print(f"Status: {response.status_code} (Expected: {expected_status})")
        
        if response.status_code == expected_status:
            print("✅ SUCCESS")
            if response.content:
                try:
                    print(f"Response: {json.dumps(response.json(), indent=2)[:200]}...")
                except:
                    print(f"Response: {response.text[:200]}...")
        else:
            print("❌ FAILED")
            print(f"Response: {response.text}")
        
        return response
    except requests.exceptions.ConnectionError:
        print(f"\n❌ Connection Error: No se pudo conectar a {url}")
        print("Asegúrate de que el servidor Django está corriendo en http://localhost:8000")
        return None
    except Exception as e:
        print(f"\n❌ Error: {e}")
        return None

def create_collectible_data(test_item, collectible_type="photocard", source="Test de API", days_ago=0, include_price=False, quantity=1):
    """
    Crea datos de prueba para un coleccionable con validaciones y valores por defecto.
    
    Args:
        test_item: Diccionario con datos del item de prueba (photocard o lightstick)
        collectible_type: Tipo de coleccionable ('photocard' o 'lightstick')
        source: Fuente de adquisición (por defecto "Test de API")
        days_ago: Días atrás para la fecha de adquisición (por defecto 0)
        include_price: Si se debe incluir un precio de compra (por defecto False)
        quantity: Cantidad del item (por defecto 1)
    
    Returns:
        dict: Datos validados para crear un coleccionable
    
    Raises:
        ValueError: Si test_item no es válido o falta el ID
    """
    if not test_item or 'id' not in test_item:
        raise ValueError("test_item debe ser un diccionario válido con un campo 'id'")
    
    if collectible_type not in ['photocard', 'lightstick']:
        raise ValueError("collectible_type debe ser o 'photocard' o 'lightstick'")
    
    # Calcular fecha dinámicamente
    acquisition_date = (datetime.now() - timedelta(days=days_ago)).date()
    
    # Construir datos base
    collectible_data = {
        'collectible_type': collectible_type,
        'source': source,
        'acquisition_date': acquisition_date.isoformat(),
        'quantity': quantity
    }
    
    # Añadir el ID correspondiente según el tipo
    if collectible_type == 'photocard':
        collectible_data['photocard'] = test_item['id']
    else:  # lightstick
        collectible_data['lightstick'] = test_item['id']
    
    # Añadir precio solo si se solicita
    if include_price:
        purchase_price = round(random.uniform(5.0, 50.0), 2)
        collectible_data['purchase_price'] = str(purchase_price)
    
    return collectible_data

def main():
    """Función principal de pruebas"""
    print("🚀 Iniciando pruebas de la API de Byeolpedia")
    print(f"URL base: {BASE_URL}")
    print("=" * 50)
    
    # 1. Probar endpoints públicos (sin autenticación)
    print("\n📋 Probando endpoints públicos...")
    
    # Lista de grupos
    test_endpoint('GET', '/catalog/groups/')
    
    # Lista de álbumes
    test_endpoint('GET', '/catalog/albums/')
    
    # Lista de photocards
    test_endpoint('GET', '/catalog/photocards/')
    
    # Lista de lightsticks
    test_endpoint('GET', '/catalog/lightsticks/')
    
    # 2. Probar registro de usuario
    print("\n👤 Probando registro de usuario...")
    register_response = test_endpoint('POST', '/auth/register/', TEST_USER, expected_status=201)
    
    if register_response and register_response.status_code == 201:
        tokens = register_response.json().get('tokens', {})
        access_token = tokens.get('access')
        headers = {'Authorization': f'Bearer {access_token}'}
        
        # 3. Probar endpoints protegidos (con autenticación)
        print("\n🔐 Probando endpoints protegidos...")
        
        # Perfil de usuario
        test_endpoint('GET', '/auth/profile/', headers=headers)
        
        # Estadísticas de usuario
        test_endpoint('GET', '/auth/stats/', headers=headers)
        
        # Colección personal (debería estar vacía)
        test_endpoint('GET', '/collection/collectibles/', headers=headers)
        
        # Wishlist (debería estar vacía)
        test_endpoint('GET', '/collection/wishlist/', headers=headers)
        
        # Grupos favoritos (debería estar vacía)
        test_endpoint('GET', '/collection/favorites/', headers=headers)
        
        # 4. Probar añadir a la colección
        print("\n➕ Probando añadir a la colección...")
        
        # Primero obtenemos una photocard de prueba
        photocards_response = test_endpoint('GET', '/catalog/photocards/?limit=1')
        if photocards_response and photocards_response.status_code == 200:
            photocards = photocards_response.json()
            if photocards.get('results') and len(photocards['results']) > 0:
                test_photocard = photocards['results'][0]
                
                try:
                    # Probar añadir una photocard
                    print("📸 Añadiendo photocard a la colección...")
                    photocard_data = create_collectible_data(
                        test_item=test_photocard,
                        collectible_type="photocard",
                        source="Test de API",
                        days_ago=7, 
                        include_price=False,  
                        quantity=2 
                    )
                    
                    response = test_endpoint('POST', '/collection/collectibles/', photocard_data, headers=headers, expected_status=201)
                    
                    if response and response.status_code != 201:
                        print(f"❌ Error al crear photocard: {response.text}")
                    
                    # Probar añadir un lightstick
                    print("💡 Añadiendo lightstick a la colección...")
                    lightsticks_response = test_endpoint('GET', '/catalog/lightsticks/?limit=1')
                    if lightsticks_response and lightsticks_response.status_code == 200:
                        lightsticks = lightsticks_response.json()
                        if lightsticks.get('results') and len(lightsticks['results']) > 0:
                            test_lightstick = lightsticks['results'][0]
                            
                            lightstick_data = create_collectible_data(
                                test_item=test_lightstick,
                                collectible_type="lightstick",
                                source="Test de API",
                                days_ago=3,
                                include_price=True,
                                quantity=1
                            )
                            
                            response = test_endpoint('POST', '/collection/collectibles/', lightstick_data, headers=headers, expected_status=201)
                            
                            if response and response.status_code != 201:
                                print(f"❌ Error al crear lightstick: {response.text}")
                        else:
                            print("⚠️ No se encontraron lightsticks para probar")
                    else:
                        print("⚠️ Error al obtener lightsticks para prueba")
                        
                except ValueError as e:
                    print(f"❌ Error en los datos: {e}")
                except Exception as e:
                    print(f"❌ Error inesperado: {e}")
        
        # 5. Probar refresh token
        print("\n🔄 Probando refresh token...")
        refresh_data = {'refresh': tokens.get('refresh')}
        test_endpoint('POST', '/auth/token/refresh/', refresh_data)
        
        # 6. Probar logout
        print("\n🚪 Probando logout...")
        test_endpoint('POST', '/auth/logout/', refresh_data, headers=headers)
    
    print("\n" + "=" * 50)
    print("🏁 Pruebas completadas")
    print("\nNotas:")
    print("- Algunas pruebas pueden fallar si no hay datos en la base de datos")
    print("- Para pruebas completas, carga datos de ejemplo en el admin de Django")
    print("- El servidor Django debe estar corriendo en http://localhost:8000")

if __name__ == '__main__':
    main()