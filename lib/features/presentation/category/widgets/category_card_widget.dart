// lib/features/presentation/category/widgets/category_card_widget.dart
import 'package:flutter/material.dart';

class CategoryCardInCategoryScreen extends StatelessWidget {
  final String categoryName;
  final int itemCount;
  final IconData icon;
  final String? imageUrl;

  const CategoryCardInCategoryScreen({
    super.key,
    required this.categoryName,
    required this.itemCount,
    required this.icon,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Show image if URL is available, otherwise show icon
            if (imageUrl != null && imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      icon,
                      size: 50,
                      color: Colors.green[800],
                    );
                  },
                ),
              )
            else
              Icon(
                icon,
                size: 50,
                color: Colors.green[800],
              ),
            const SizedBox(height: 10),
            Text(
              categoryName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            Text(
              '$itemCount items',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}