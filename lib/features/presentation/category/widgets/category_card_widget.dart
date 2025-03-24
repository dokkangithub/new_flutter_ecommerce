import 'package:flutter/material.dart';

class CategoryCardInCategoryScreen extends StatelessWidget {
  final String categoryName;
  final int itemCount;
  final IconData icon;

  const CategoryCardInCategoryScreen({
    super.key,
    required this.categoryName,
    required this.itemCount,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Subtle shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Green line-art icon
            Icon(
              icon,
              size: 50,
              color: Colors.green[800],
            ),
            const SizedBox(height: 10),
            // Category name in bold
            Text(
              categoryName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            // Item count in smaller font
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