import 'package:flutter/material.dart';

enum ScreenType { mobile, tablet, desktop }

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ScreenType screenType) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return builder(context, ScreenType.mobile);
        } else if (constraints.maxWidth < 1024) {
          return builder(context, ScreenType.tablet);
        } else {
          return builder(context, ScreenType.desktop);
        }
      },
    );
  }
}

// Usage example
class ResponsiveCollectionScreen extends StatelessWidget {
  const ResponsiveCollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenType) {
        switch (screenType) {
          case ScreenType.mobile:
            return _buildMobileLayout();
          case ScreenType.tablet:
            return _buildTabletLayout();
          case ScreenType.desktop:
            return _buildDesktopLayout();
        }
      },
    );
  }

  Widget _buildMobileLayout() {
    // Mobile-specific layout with bottom navigation
    return Scaffold(
      body: _buildContent(),
      bottomNavigationBar: const CustomBottomNavigation(
        currentIndex: 1,
        onTap: null,
      ),
    );
  }

  Widget _buildTabletLayout() {
    // Tablet-specific layout with rail navigation
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: 1,
            onDestinationSelected: (index) {
              // Handle navigation
            },
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text('Inicio'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.collections),
                label: Text('Colección'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.search),
                label: Text('Buscar'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people),
                label: Text('Comunidad'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person),
                label: Text('Perfil'),
              ),
            ],
          ),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    // Desktop-specific layout with side navigation
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 250,
            child: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Text(
                      'Byeolpedia',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Inicio'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.collections),
                    title: const Text('Colección'),
                    selected: true,
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.search),
                    title: const Text('Buscar'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.people),
                    title: const Text('Comunidad'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Perfil'),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    // Common content for all layouts
    return const Center(
      child: Text('Contenido de la colección'),
    );
  }
}

// Import CustomBottomNavigation for the example
class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.collections),
          label: 'Colección',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Buscar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Comunidad',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }
}