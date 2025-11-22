import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/models/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        final User? user = authService.currentUser;
        
        return Scaffold(
          appBar: AppBar(
            title: const Text('Byeolpedia'),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  // TODO: Implementar búsqueda
                },
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'profile') {
                    // TODO: Navegar a perfil
                  } else if (value == 'settings') {
                    // TODO: Navegar a configuración
                  } else if (value == 'logout') {
                    _showLogoutDialog(context, authService);
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem<String>(
                      value: 'profile',
                      child: Row(
                        children: [
                          Icon(Icons.person),
                          SizedBox(width: 8),
                          Text('Perfil'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'settings',
                      child: Row(
                        children: [
                          Icon(Icons.settings),
                          SizedBox(width: 8),
                          Text('Configuración'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout),
                          SizedBox(width: 8),
                          Text('Cerrar sesión'),
                        ],
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),
          body: IndexedStack(
            index: _currentIndex,
            children: [
              _buildHomeTab(user),
              _buildCatalogTab(),
              _buildCollectionTab(),
              _buildFavoritesTab(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Inicio',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.library_music),
                label: 'Catálogo',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.collections),
                label: 'Colección',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favoritos',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHomeTab(User? user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bienvenida
          Text(
            '¡Hola, ${user?.collectorName ?? 'Coleccionista'}!',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '¿Qué vamos a añadir hoy a tu colección?',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          
          // Estadísticas rápidas
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tu colección',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Álbumes',
                          user?.totalAlbums.toString() ?? '0',
                          Icons.album,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'Photocards',
                          user?.totalPhotocards.toString() ?? '0',
                          Icons.photo,
                          Colors.pink,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Lightsticks',
                          user?.totalLightsticks.toString() ?? '0',
                          Icons.highlight,
                          Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(child: SizedBox()), // Espacio vacío para balance
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Acciones rápidas
          const Text(
            'Acciones rápidas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _buildActionCard(
                'Añadir Álbum',
                Icons.add_box,
                Colors.blue,
                () {
                  // TODO: Navegar a añadir álbum
                },
              ),
              _buildActionCard(
                'Añadir Photocard',
                Icons.add_photo_alternate,
                Colors.pink,
                () {
                  // TODO: Navegar a añadir photocard
                },
              ),
              _buildActionCard(
                'Añadir Lightstick',
                Icons.highlight,
                Colors.orange,
                () {
                  // TODO: Navegar a añadir lightstick
                },
              ),
              _buildActionCard(
                'Escanear Lightstick',
                Icons.camera_alt,
                Colors.green,
                () {
                  // TODO: Abrir cámara para escanear
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCatalogTab() {
    return const Center(
      child: Text('Catálogo - Próximamente'),
    );
  }

  Widget _buildCollectionTab() {
    return const Center(
      child: Text('Mi Colección - Próximamente'),
    );
  }

  Widget _buildFavoritesTab() {
    return const Center(
      child: Text('Favoritos - Próximamente'),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthService authService) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar sesión'),
          content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await authService.logout();
              },
              child: const Text('Cerrar sesión'),
            ),
          ],
        );
      },
    );
  }
}