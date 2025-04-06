import 'package:flutter/material.dart';
import 'package:laravel_ecommerce/core/config/routes.dart/routes.dart';
import 'package:laravel_ecommerce/core/utils/extension/text_style_extension.dart';
import 'package:laravel_ecommerce/core/utils/extension/translate_extension.dart';
import 'package:laravel_ecommerce/core/utils/widgets/custom_loading.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../../../core/utils/enums/products_type.dart';
import '../../../../core/utils/shimmer/all_category_products_shimmer.dart';
import '../../../../core/utils/widgets/custom_back_button.dart';
import '../../../../core/utils/widgets/product cards/custom_gridview_prodcut.dart';
import '../../../domain/product/entities/product.dart';
import '../../home/controller/home_provider.dart';
import '../../home/widgets/search_bar.dart';

class AllProductsByTypeScreen extends StatefulWidget {
  final ProductType productType; // Changed from String to ProductType
  final String title;

  const AllProductsByTypeScreen({
    super.key,
    required this.productType,
    required this.title,
  });

  @override
  _AllProductsByTypeScreenState createState() => _AllProductsByTypeScreenState();
}

class _AllProductsByTypeScreenState extends State<AllProductsByTypeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeProvider = Provider.of<HomeProvider>(context, listen: false);
      _fetchProducts(homeProvider, refresh: true);
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

    if (!_hasMoreProducts(provider)) return;

    setState(() => _isLoading = true);
    await _fetchProducts(provider);
    setState(() => _isLoading = false);
  }

  Future<void> _fetchProducts(HomeProvider provider, {bool refresh = false}) async {
    switch (widget.productType) {
      case ProductType.all:
        await provider.fetchAllProducts(refresh: refresh);
        break;
      case ProductType.bestSelling:
        await provider.fetchBestSellingProducts(refresh: refresh);
        break;
      case ProductType.featured:
        await provider.fetchFeaturedProducts(refresh: refresh);
        break;
      case ProductType.newArrival:
        await provider.fetchNewProducts(refresh: refresh);
        break;
      case ProductType.todaysDeal:
        await provider.fetchTodaysDealProducts();
        break;
    }
  }

  bool _hasMoreProducts(HomeProvider provider) {
    switch (widget.productType) {
      case ProductType.all:
        return provider.hasMoreAllProducts;
      case ProductType.bestSelling:
        return provider.hasMoreBestSellingProducts;
      case ProductType.featured:
        return provider.hasMoreFeaturedProducts;
      case ProductType.newArrival:
        return provider.hasMoreNewProducts;
      case ProductType.todaysDeal:
        return false; // No pagination for today's deal
    }
  }

  List<Product> _getProducts(HomeProvider provider) {
    switch (widget.productType) {
      case ProductType.all:
        return provider.allProducts;
      case ProductType.bestSelling:
        return provider.bestSellingProducts;
      case ProductType.featured:
        return provider.featuredProducts;
      case ProductType.newArrival:
        return provider.newProducts;
      case ProductType.todaysDeal:
        return provider.todaysDealProducts;
    }
  }

  LoadingState _getLoadingState(HomeProvider provider) {
    switch (widget.productType) {
      case ProductType.all:
        return provider.allProductsState;
      case ProductType.bestSelling:
        return provider.bestSellingProductsState;
      case ProductType.featured:
        return provider.featuredProductsState;
      case ProductType.newArrival:
        return provider.newProductsState;
      case ProductType.todaysDeal:
        return provider.todaysDealProductsState;
    }
  }

  String _getErrorMessage(HomeProvider provider) {
    switch (widget.productType) {
      case ProductType.all:
        return provider.allProductsError;
      case ProductType.bestSelling:
        return provider.bestSellingProductsError;
      case ProductType.featured:
        return provider.featuredProductsError;
      case ProductType.newArrival:
        return provider.newProductsError;
      case ProductType.todaysDeal:
        return provider.todaysDealProductsError;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        final products = _getProducts(homeProvider);
        final state = _getLoadingState(homeProvider);

        if (state == LoadingState.loading && products.isEmpty) {
          return const Scaffold(
            body: SafeArea(child: AllCategoryProductsShimmer()),
          );
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
                Expanded(child: _buildProductGrid(homeProvider)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomBackButton(),
          Text(widget.title.tr(context), style: context.headlineMedium),
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

  Widget _buildProductGrid(HomeProvider provider) {
    final products = _getProducts(provider);
    final state = _getLoadingState(provider);
    final error = _getErrorMessage(provider);

    if (state == LoadingState.loading && products.isEmpty) {
      return const Center(child: CustomLoadingWidget());
    }

    if (state == LoadingState.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $error'),
            ElevatedButton(
              onPressed: () => _fetchProducts(provider, refresh: true),
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
          productSlug: product.slug,
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