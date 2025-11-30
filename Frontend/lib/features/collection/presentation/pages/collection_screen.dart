import 'package:flutter/material.dart';
import 'package:byeolpedia_frontend/shared/widgets/album_card.dart';
import 'package:byeolpedia_frontend/data/services/collection_service.dart';
import 'package:byeolpedia_frontend/data/services/api_service.dart';
import 'package:byeolpedia_frontend/data/models/album.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isFabVisible = true;
  CollectionService? _collectionService;
  Future<List<Album>>? _albumsFuture;

  @override
  void initState() {
    super.initState();
    _collectionService = CollectionService(ApiService());
    _albumsFuture = _collectionService!.getAlbums();
    
    _scrollController.addListener(() {
      if (_scrollController.offset > 100 && _isFabVisible) {
        setState(() => _isFabVisible = false);
      } else if (_scrollController.offset <= 100 && !_isFabVisible) {
        setState(() => _isFabVisible = true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            FilterChip(
              label: const Text('Todos'),
              onSelected: (bool value) {},
              selected: true,
            ),
            const SizedBox(width: 8),
            FilterChip(
              label: const Text('Poseídos'),
              onSelected: (bool value) {},
            ),
            const SizedBox(width: 8),
            FilterChip(
              label: const Text('Deseados'),
              onSelected: (bool value) {},
            ),
            const SizedBox(width: 8),
            FilterChip(
              label: const Text('Favoritos'),
              onSelected: (bool value) {},
            ),
          ],
        ),
      ),
    );
  }

  void _showAddAlbumDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Añadir Álbum'),
        content: const Text('Funcionalidad para añadir álbum a la colección'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Añadir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Album>>(
        future: _albumsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay álbumes en la colección'));
          }

          final albums = snapshot.data!;

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                leading: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
                title: const Text('Mi Colección'),
                floating: true,
                snap: true,
                backgroundColor: Theme.of(context).primaryColor,
                expandedHeight: 120,
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildFilterChips(),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverLayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = 2;
                    if (constraints.crossAxisExtent > 600) {
                      crossAxisCount = 3;
                    }
                    if (constraints.crossAxisExtent > 900) {
                      crossAxisCount = 4;
                    }
                    if (constraints.crossAxisExtent > 1200) {
                      crossAxisCount = 5;
                    }

                    return SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final album = albums[index];
                          return AlbumCard(
                            title: album.title,
                            artist: album.artist,
                            imageUrl: album.imageUrl,
                            isOwned: album.isOwned,
                            isWishlist: album.isWishlist,
                            onTap: () {
                              // Navigate to details
                            },
                          );
                        },
                        childCount: albums.length,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: AnimatedOpacity(
        opacity: _isFabVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: FloatingActionButton(
          onPressed: () => _showAddAlbumDialog(),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}