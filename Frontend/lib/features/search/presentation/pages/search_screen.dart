import 'package:flutter/material.dart';
import '../../../../app/router/app_router.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<SearchResult> _results = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _results = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);
    
    // Simulate API call with debounce
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_searchController.text.isNotEmpty && mounted) {
        _performSearch(_searchController.text);
      }
    });
  }

  Future<void> _performSearch(String query) async {
    // Implement search logic here
    // final results = await ApiService.search(query);
    setState(() {
      _results = []; // Reemplazar con resultados reales
      _isSearching = false;
    });
  }

  void _navigateToLightstickRecognition() {
    Navigator.pushNamed(context, AppRouter.lightstickRecognition);
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              label: const Text('Álbumes'),
              onSelected: (bool value) {},
            ),
            const SizedBox(width: 8),
            FilterChip(
              label: const Text('Grupos'),
              onSelected: (bool value) {},
            ),
            const SizedBox(width: 8),
            FilterChip(
              label: const Text('Photocards'),
              onSelected: (bool value) {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHistory() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Busca álbumes, grupos, photocards...',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Usa el ícono de la cámara para reconocer lightsticks',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_results.isEmpty) {
      return Center(
        child: Text(
          'No se encontraron resultados para "${_searchController.text}"',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final result = _results[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: const Icon(Icons.album),
          ),
          title: Text(result.title),
          subtitle: Text(result.subtitle),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            // Navigate to detail
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Buscar álbumes, grupos, photocards...',
              prefixIcon: Icon(Icons.search),
              suffixIcon: Icon(Icons.camera_alt),
              border: InputBorder.none,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: _buildFilterChips(),
        ),
      ),
      body: _isSearching
          ? const Center(child: CircularProgressIndicator())
          : _searchController.text.isEmpty
              ? _buildSearchHistory()
              : _buildSearchResults(),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToLightstickRecognition,
        tooltip: 'Reconocimiento de Lightsticks',
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class SearchResult {
  final String title;
  final String subtitle;
  final String type;

  SearchResult({
    required this.title,
    required this.subtitle,
    required this.type,
  });
}