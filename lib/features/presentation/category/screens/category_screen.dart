// lib/features/presentation/category/screens/category_screen.dart
import 'package:flutter/material.dart';
import 'package:laravel_ecommerce/core/utils/widgets/custom_loading.dart';
import 'package:provider/provider.dart';
import '../controller/provider.dart';
import '../widgets/category_card_widget.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().getCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<CategoryProvider>(
        builder: (context, categoryProvider, child) {
          if (categoryProvider.categoriesState == CategoryLoadingState.loading) {
            return const Center(child: CustomLoadingWidget());
          }

          // Show error if fetching failed
          if (categoryProvider.categoriesState == CategoryLoadingState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Failed to load categories'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => categoryProvider.getCategories(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Show categories if data is loaded
          if (categoryProvider.categoriesState == CategoryLoadingState.loaded &&
              categoryProvider.categoriesResponse?.data != null) {
            final categories = categoryProvider.categoriesResponse!.data;

            if (categories.isEmpty) {
              return const Center(child: Text('No categories found'));
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return CategoryCardInCategoryScreen(
                    categoryName: category.name ?? 'Unknown',
                    itemCount: category.productCount ?? 0,
                    icon: Icons.category,
                    imageUrl: category.icon, categoryId: category.id??0,
                  );
                },
              ),
            );
          }

          // Default empty state
          return const Center(child: Text('No categories available'));
        },
      ),
    );
  }
}