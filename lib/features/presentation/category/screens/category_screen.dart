import 'package:flutter/material.dart';
import 'package:laravel_ecommerce/core/utils/extension/text_style_extension.dart';
import '../widgets/category_card_widget.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {'name': 'Fruits', 'count': 3, 'icon': Icons.local_dining},
      {'name': 'Grains', 'count': 12, 'icon': Icons.grass},
      {'name': 'Meat', 'count': 17, 'icon': Icons.fastfood},
      {'name': 'Vegetables', 'count': 12, 'icon': Icons.local_florist},
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return CategoryCardInCategoryScreen(
                        categoryName: categories[index]['name'],
                        itemCount: categories[index]['count'],
                        icon: categories[index]['icon'],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}