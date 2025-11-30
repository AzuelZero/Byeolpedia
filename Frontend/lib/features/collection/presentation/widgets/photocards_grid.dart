import 'package:flutter/material.dart';

class Photocard {
  final String id;
  final String imageUrl;
  final String memberName;
  final String albumTitle;
  final bool isOwned;
  final bool isDuplicate;
  final int duplicateCount;

  Photocard({
    required this.id,
    required this.imageUrl,
    required this.memberName,
    required this.albumTitle,
    this.isOwned = false,
    this.isDuplicate = false,
    this.duplicateCount = 0,
  });
}

class PhotocardsGrid extends StatelessWidget {
  final List<Photocard> photocards;
  final Function(Photocard)? onPhotocardTap;
  final Function(Photocard)? onPhotocardLongPress;

  const PhotocardsGrid({
    super.key,
    required this.photocards,
    this.onPhotocardTap,
    this.onPhotocardLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: photocards.length,
      itemBuilder: (context, index) {
        final photocard = photocards[index];
        return PhotocardItem(
          photocard: photocard,
          onTap: () => onPhotocardTap?.call(photocard),
          onLongPress: () => onPhotocardLongPress?.call(photocard),
        );
      },
    );
  }
}

class PhotocardItem extends StatelessWidget {
  final Photocard photocard;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const PhotocardItem({
    super.key,
    required this.photocard,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  photocard.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Theme.of(context).colorScheme.surface,
                      child: const Icon(Icons.image_not_supported),
                    );
                  },
                ),
              ),
            ),
            if (photocard.isOwned)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            if (photocard.isDuplicate)
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'x${photocard.duplicateCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}