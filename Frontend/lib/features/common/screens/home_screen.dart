import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:byeolpedia_frontend/data/services/auth_service.dart';
import 'package:byeolpedia_frontend/data/services/notification_service.dart';
import 'package:byeolpedia_frontend/features/notifications/presentation/pages/notifications_screen.dart';
import 'package:byeolpedia_frontend/data/models/user.dart';
import 'package:byeolpedia_frontend/app/router/app_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        final User? user = authService.currentUser;
        
        return Scaffold(
          appBar: AppBar(
            title: const Text('Byeolpedia'),
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            actions: [
              IconButton(
                icon: Badge(
                  label: Text('${NotificationService().unreadCount}'),
                  isLabelVisible: NotificationService().unreadCount > 0,
                  child: const Icon(Icons.notifications),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  // Navegar a la pantalla de búsqueda
                  Navigator.of(context).pushNamed(AppRouter.search);
                },
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'profile') {
                    Navigator.of(context).pushNamed(AppRouter.profile);
                  } else if (value == 'settings') {
                    Navigator.of(context).pushNamed(AppRouter.settingsRoute);
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
          body: SingleChildScrollView(
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
                        Navigator.of(context).pushNamed(AppRouter.addAlbum);
                      },
                    ),
                    _buildActionCard(
                      'Añadir Photocard',
                      Icons.add_photo_alternate,
                      Colors.pink,
                      () {
                        Navigator.of(context).pushNamed(AppRouter.addPhotocard);
                      },
                    ),
                    _buildActionCard(
                      'Añadir Lightstick',
                      Icons.highlight,
                      Colors.orange,
                      () {
                        Navigator.of(context).pushNamed(AppRouter.addLightstick);
                      },
                    ),
                    _buildActionCard(
                      'Escanear Lightstick',
                      Icons.camera_alt,
                      Colors.green,
                      () {
                        Navigator.of(context).pushNamed(AppRouter.lightstickRecognition);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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