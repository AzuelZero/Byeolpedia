import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/providers/theme_provider.dart';
import '../app/theme/app_theme.dart';
import '../app/router/app_router.dart';
import '../features/common/screens/home_screen.dart';
import '../features/collection/presentation/pages/collection_screen.dart';
import '../features/search/presentation/pages/search_screen.dart';
import '../features/community/presentation/pages/community_screen.dart';
import '../features/authentication/presentation/pages/profile_screen.dart';
import '../shared/widgets/custom_bottom_navigation.dart';

class ByeolpediaApp extends StatelessWidget {
  const ByeolpediaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Byeolpedia',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          initialRoute: AppRouter.login,
          onGenerateRoute: AppRouter.generateRoute,
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const CollectionScreen();
      case 2:
        return const SearchScreen();
      case 3:
        return const CommunityScreen();
      case 4:
        return const ProfileScreen();
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.music_note, color: Colors.white, size: 40),
                  SizedBox(height: 8),
                  Text(
                    'Byeolpedia',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Tu tracker de K-Pop',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              selected: _currentIndex == 0,
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.collections),
              title: const Text('Colección'),
              selected: _currentIndex == 1,
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Buscar'),
              selected: _currentIndex == 2,
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 2);
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Comunidad'),
              selected: _currentIndex == 3,
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 3);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              selected: _currentIndex == 4,
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 4);
              },
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Para pantallas grandes (web/tablet), usar NavigationRail
          if (constraints.maxWidth > 600) {
            return Row(
              children: [
                NavigationRail(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (index) {
                    setState(() => _currentIndex = index);
                  },
                  extended: constraints.maxWidth > 1200,
                  labelType: constraints.maxWidth > 800 && constraints.maxWidth <= 1200
                      ? NavigationRailLabelType.all
                      : NavigationRailLabelType.none,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: Text('Inicio'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.collections_outlined),
                      selectedIcon: Icon(Icons.collections),
                      label: Text('Colección'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.search_outlined),
                      selectedIcon: Icon(Icons.search),
                      label: Text('Buscar'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.people_outline),
                      selectedIcon: Icon(Icons.people),
                      label: Text('Comunidad'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: Text('Perfil'),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  child: _buildPage(_currentIndex),
                ),
              ],
            );
          } else {
            // Para móviles, diseño simple
            return _buildPage(_currentIndex);
          }
        },
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          // Solo mostrar bottom navigation en pantallas pequeñas
          if (constraints.maxWidth <= 600) {
            return CustomBottomNavigation(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() => _currentIndex = index);
              },
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}