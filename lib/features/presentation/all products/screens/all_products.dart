import 'package:flutter/material.dart';
import 'package:laravel_ecommerce/core/config/routes.dart/routes.dart';
import 'package:laravel_ecommerce/core/utils/extension/text_style_extension.dart';
import 'package:laravel_ecommerce/core/utils/extension/translate_extension.dart';
import 'package:laravel_ecommerce/core/utils/widgets/custom_loading.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/shimmer/category_without_image_shimmer.dart';
import '../../../../core/utils/shimmer/product_shimmer.dart';
import '../../../../core/utils/widgets/custom_back_button.dart';
import '../../../../core/utils/widgets/product cards/custom_gridview_prodcut.dart';
import '../../../domain/product/entities/product.dart';
import '../../category/controller/provider.dart';
import '../../home/controller/home_provider.dart';
import '../../home/widgets/search_bar.dart';

class AllProductsScreen extends StatefulWidget {
  final String? initialCategoryName;
  final List<Product>? initialProducts;

  const AllProductsScreen({
    super.key,
    this.initialCategoryName,
    this.initialProducts,
  });

  @override
  _AllProductsScreenState createState() => _AllProductsScreenState();
}


class _AllProductsScreenState extends State<AllProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final String _searchQuery = '';
  String _selectedCategoryName = 'All';
  int? _selectedCategoryId;
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _selectedCategoryName = widget.initialCategoryName ?? 'All';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeProvider = Provider.of<HomeProvider>(context, listen: false);
      final categoryProvider = Provider.of<CategoryProvider>(
        context,
        listen: false,
      );

      if (widget.initialProducts != null && widget.initialProducts!.isNotEmpty) {
        homeProvider.setInitialProducts(widget.initialProducts!);
      } else {
        homeProvider.fetchFilteredProducts(name: _searchQuery, refresh: true);
      }
      categoryProvider.getFilterPageCategories();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreProducts();
    }
  }

  Future<void> _loadMoreProducts() async {
    if (_isLoading) return;
    final provider = Provider.of<HomeProvider>(context, listen: false);

    if (_selectedCategoryId == null) {
      if (!provider.hasMoreFilteredProducts) return;
    } else {
      if (!provider.hasMoreCategoryProducts) return;
    }

    setState(() => _isLoading = true);

    if (_selectedCategoryId == null) {
      await provider.fetchFilteredProducts(name: _searchQuery);
    } else {
      await provider.fetchCategoryProducts(
        _selectedCategoryId!,
        name: _searchQuery,
      );
    }

    setState(() => _isLoading = false);
  }

  void _selectCategory(String name, int? id) {
    setState(() {
      _selectedCategoryName = name;
      _selectedCategoryId = id;
      final provider = Provider.of<HomeProvider>(context, listen: false);

      if (name == widget.initialCategoryName && widget.initialProducts != null) {
        // If re-selecting the initial category (e.g., "Best Seller"), use initial products
        provider.setInitialProducts(widget.initialProducts!);
      } else if (id == null) {
        // For "All" or other null-ID categories (excluding initial category)
        provider.fetchFilteredProducts(name: _searchQuery, refresh: true);
      } else {
        // For categories with an ID
        provider.fetchCategoryProducts(id, refresh: true, name: _searchQuery);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Provider.of<HomeProvider>(context)),
        ChangeNotifierProvider.value(
          value: Provider.of<CategoryProvider>(context),
        ),
      ],
      child: Consumer2<HomeProvider, CategoryProvider>(
        builder: (context, homeProvider, categoryProvider, child) {
          // Show shimmer if initial data is loading and no products are available yet
          if ((homeProvider.filteredProductsState == HomeLoadingState.loading &&
              homeProvider.filteredProducts.isEmpty) ||
              (categoryProvider.filterPageCategoriesState ==
                  CategoryLoadingState.loading &&
                  categoryProvider.filterPageCategoriesResponse == null)) {
            return const ProductShimmer();
          }

          return Scaffold(
            backgroundColor: Colors.grey[50],
            body: SafeArea(
              child: Column(
                children: [
                  _buildAppBar(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: CustomSearchBar(),
                  ),
                  _buildCategoryList(categoryProvider),
                  Expanded(child: _buildProductGrid(homeProvider)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomBackButton(),
          Text('discover_products'.tr(context), style: context.headlineMedium),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              AppRoutes.navigateTo(context, AppRoutes.cartScreen);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList(CategoryProvider categoryProvider) {
    if (categoryProvider.filterPageCategoriesState ==
        CategoryLoadingState.loading) {
      return const CategoryWithoutImageShimmer();
    }

    if (categoryProvider.filterPageCategoriesState ==
        CategoryLoadingState.error) {
      return SizedBox(
        height: 50,
        child: Center(child: Text('Error: ${categoryProvider.errorMessage}')),
      );
    }

    final categories = <Map<String, dynamic>>[];

    // Add initial category if provided (e.g., "Best Seller")
    if (widget.initialCategoryName != null) {
      categories.add({
        'name': widget.initialCategoryName!,
        'id': null,
      });
    }

    // Add the rest of the categories from the provider
    categories.addAll(
      categoryProvider.filterPageCategoriesResponse?.data
          .map((c) => {'name': c.name, 'id': c.id}) ??
          [],
    );

    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category['name'] == _selectedCategoryName;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
            child: Material(
              color: isSelected ? Colors.blue : Colors.white,
              borderRadius: BorderRadius.circular(20),
              elevation: isSelected ? 4 : 1,
              child: InkWell(
                onTap: () => _selectCategory(
                  category['name'] as String,
                  category['id'] as int?,
                ),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Center(
                    child: Text(
                      category['name'] as String,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid(HomeProvider provider) {
    final products =
        _selectedCategoryId == null
            ? provider.filteredProducts
            : provider.categoryProducts;
    final state =
        _selectedCategoryId == null
            ? provider.filteredProductsState
            : provider.categoryProductsState;
    final error =
        _selectedCategoryId == null
            ? provider.filteredProductsError
            : provider.categoryProductsError;

    if (state == HomeLoadingState.loading && products.isEmpty) {
      return const Center(child: CustomLoadingWidget());
    }

    if (state == HomeLoadingState.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $error'),
            ElevatedButton(
              onPressed: () {
                if (_selectedCategoryId == null) {
                  provider.fetchFilteredProducts(
                    name: _searchQuery,
                    refresh: true,
                  );
                } else {
                  provider.fetchCategoryProducts(
                    _selectedCategoryId!,
                    refresh: true,
                    name: _searchQuery,
                  );
                }
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (products.isEmpty) {
      return const Center(
        child: Text(
          'No products found',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length + (_isLoading ? 2 : 0),
      itemBuilder: (context, index) {
        if (index >= products.length) {
          return const Center(child: CustomLoadingWidget());
        }
        final product = products[index];
        return ProductGridCard(
          imageUrl: product.thumbnailImage,
          productName: product.name,
          price: product.mainPrice.toString(),
          isBestSeller: product.hasDiscount,
          onAddToCart: () {},
          onFavoriteToggle: () {},
        );
      },
    );
  }

}
