import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:laravel_ecommerce/core/config/routes.dart/routes.dart';
import 'package:provider/provider.dart';
import 'package:laravel_ecommerce/core/utils/extension/responsive_extension.dart';
import 'package:laravel_ecommerce/core/utils/widgets/product%20cards/custom_product_card.dart';
import 'package:laravel_ecommerce/core/utils/widgets/see_all_widget.dart';
import 'package:laravel_ecommerce/core/utils/widgets/product cards/custom_gridview_prodcut.dart';
import 'package:laravel_ecommerce/core/utils/widgets/product cards/custom_product_row.dart';
import 'package:laravel_ecommerce/features/presentation/category/controller/provider.dart';
import 'package:laravel_ecommerce/features/presentation/home/controller/home_provider.dart';
import 'package:laravel_ecommerce/features/presentation/home/widgets/category_card.dart';
import 'package:laravel_ecommerce/features/presentation/home/widgets/search_bar.dart';
import '../../main layout/controller/layout_provider.dart';
import '../widgets/banners_widget.dart';
import 'package:laravel_ecommerce/features/presentation/home/widgets/shimmer/category_shimmer.dart';
import 'package:laravel_ecommerce/features/presentation/home/widgets/shimmer/product_shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);

    homeProvider.initHomeData();
    categoryProvider.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final homeProvider = Provider.of<HomeProvider>(context, listen: false);
        final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);

        await Future.wait([
          homeProvider.refreshHomeData(),
          categoryProvider.getFeaturedCategories(),
        ]);
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomSearchBar(),
            const SizedBox(height: 15),
            _buildCategories(),
            const SizedBox(height: 15),
            _buildBestSellingProducts(),
            const SizedBox(height: 15),
            const SimpleBannerCarousel(),
            const SizedBox(height: 15),
            _buildFeaturedProducts(),
            const SizedBox(height: 15),
            _buildNewProducts(),
            const SizedBox(height: 15),
            _buildAllProducts(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        if (categoryProvider.featuredCategoriesState == CategoryLoadingState.loading) {
          return const CategoryShimmer();
        }
        if (categoryProvider.featuredCategoriesState == CategoryLoadingState.error) {
          return _buildErrorState("Couldn't load categories");
        }
        final categories = categoryProvider.categoriesResponse?.data ?? [];
        if (categories.isEmpty) {
          return _buildEmptyState("No categories available");
        }
        return SizedBox(
          height: context.responsive(150),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SeeAllWidget(title: 'CATEGORIES', onTap: () {
                Provider.of<LayoutProvider>(context,listen: false).currentIndex=1;
              },),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) => CategoryCard(
                    imageUrl: categories[index].banner ?? 'https://via.placeholder.com/150',
                    name: categories[index].name ?? 'Category',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${categories[index].name} selected'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBestSellingProducts() {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        if (homeProvider.bestSellingProductsState == HomeLoadingState.loading) {
          return const ProductShimmer(title: 'BEST SELLER');
        }
        if (homeProvider.bestSellingProductsState == HomeLoadingState.error) {
          return _buildErrorState("Couldn't load best selling products");
        }
        final products = homeProvider.bestSellingProducts;
        if (products.isEmpty) {
          return _buildEmptyState("No best selling products available");
        }
        return Column(
          children: [
            SeeAllWidget(title: 'BEST SELLER', onTap: () {
              AppRoutes.navigateTo(context, AppRoutes.allProductsScreen);
            },),
            const SizedBox(height: 10),
            SizedBox(
              height: 230,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) => ProductCard(
                  imageUrl: products[index].thumbnailImage,
                  productName: products[index].name,
                  price: products[index].mainPrice.toString() ?? '...',
                  isBestSeller: true,
                  onAddToCart: () {},
                  onFavoriteToggle: () {},
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFeaturedProducts() {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        if (homeProvider.featuredProductsState == HomeLoadingState.loading) {
          return const ProductShimmer(title: 'TOP RATED');
        }
        if (homeProvider.featuredProductsState == HomeLoadingState.error) {
          return _buildErrorState("Couldn't load featured products");
        }
        final products = homeProvider.featuredProducts;
        if (products.isEmpty) {
          return _buildEmptyState("No featured products available");
        }
        return Column(
          children: [
            SeeAllWidget(title: 'TOP RATED', onTap: () {  },),
            const SizedBox(height: 10),
            SizedBox(
              height: 240,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) => ProductCard(
                  imageUrl: products[index].thumbnailImage ?? 'https://via.placeholder.com/150',
                  productName: products[index].name ?? 'Product',
                  price: products[index].mainPrice.toString() ?? '...',
                  isBestSeller: true,
                  onAddToCart: () {},
                  onFavoriteToggle: () {},
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNewProducts() {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        if (homeProvider.newProductsState == HomeLoadingState.loading) {
          return const ProductShimmer(title: 'POPULAR');
        }
        if (homeProvider.newProductsState == HomeLoadingState.error) {
          return _buildErrorState("Couldn't load new products");
        }
        final products = homeProvider.newProducts;
        if (products.isEmpty) {
          return _buildEmptyState("No new products available");
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SeeAllWidget(title: 'POPULAR', onTap: () {  },),
            const SizedBox(height: 12),
            CarouselSlider.builder(
              itemCount: products.length,
              options: CarouselOptions(
                height: 175,
                viewportFraction: 0.98,
                enableInfiniteScroll: products.length > 3,
                autoPlay: products.length > 1,
                autoPlayInterval: const Duration(seconds: 5),
                enlargeCenterPage: true,
                padEnds: true,
              ),
              itemBuilder: (context, index, realIndex) {
                final product = products[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ProductItemInRow1(
                    imageUrl: product.thumbnailImage ?? 'https://via.placeholder.com/150',
                    productName: product.name ?? 'Product',
                    price: product.mainPrice.toString() ?? '...',
                    originalPrice: product.discount.toString() ?? '...',
                    isBestSeller: product.hasDiscount ?? false,
                    isFavorite: false,
                    onFavoriteToggle: () {},
                    onAddToCart: () {},
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildAllProducts() {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        final allProducts = <dynamic>{
          ...homeProvider.featuredProducts,
          ...homeProvider.bestSellingProducts,
          ...homeProvider.newProducts,
        }.toList();
        if (allProducts.isEmpty) {
          return _buildEmptyState("No products available");
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SeeAllWidget(title: 'ALL PRODUCTS', onTap: () {  },),
            const SizedBox(height: 12),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: allProducts.length > 8 ? 8 : allProducts.length,
              itemBuilder: (context, index) {
                final product = allProducts[index];
                return ProductGridCard(
                  imageUrl: product.thumbnailImage,
                  productName: product.name,
                  price: product.mainPrice.toString() ?? '...',
                  isBestSeller: product.hasDiscount ?? false,
                  onAddToCart: () {},
                  onFavoriteToggle: () {},
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildErrorState(String message) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return SizedBox.shrink();
  }
}