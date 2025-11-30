import 'package:flutter/material.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: const Text('Comunidad'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Add new post
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        child: const Icon(Icons.person),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Usuario ${index + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Hace ${index + 1} horas',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '¡Acabo de conseguir mi photocard favorita de ${['ITZY', 'aespa', 'NMIXX', 'LE SSERAFIM', 'IVE'][index]}! 🎵✨',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.image,
                      size: 64,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.favorite_border, size: 20),
                      const SizedBox(width: 4),
                      Text('${(index + 1) * 15}'),
                      const SizedBox(width: 16),
                      const Icon(Icons.comment_outlined, size: 20),
                      const SizedBox(width: 4),
                      Text('${(index + 1) * 3}'),
                      const Spacer(),
                      const Icon(Icons.share_outlined, size: 20),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}