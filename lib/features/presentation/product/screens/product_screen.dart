import 'package:flutter/material.dart';
import 'package:laravel_ecommerce/core/utils/enums/loading_state.dart';
import 'package:laravel_ecommerce/core/utils/widgets/custom_back_button.dart';
import 'package:laravel_ecommerce/core/utils/widgets/custom_loading.dart';
import 'package:laravel_ecommerce/features/presentation/product/controller/product_provider.dart';
import 'package:laravel_ecommerce/features/presentation/product/widgets/reviews_section.dart';
import 'package:laravel_ecommerce/features/presentation/home/controller/home_provider.dart';
import 'package:laravel_ecommerce/features/presentation/review/controller/reviews_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/color_variants_widget.dart';
import '../widgets/description_widget.dart';
import '../widgets/product_image_widget.dart';
import '../widgets/product_theme.dart';
import '../widgets/quantity_selector_widget.dart';
import '../widgets/related_products_widget.dart';
import '../widgets/shimmers/shimmer_widget.dart';

class ProductDetailScreen extends StatefulWidget {
  final String slug;

  const ProductDetailScreen({super.key, required this.slug});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isFavorite = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productProvider = Provider.of<ProductDetailsProvider>(
        context,
        listen: false,
      );
      productProvider.fetchProductDetails(widget.slug).then((_) {
        if (productProvider.selectedProduct != null) {
          final homeProvider = Provider.of<HomeProvider>(
            context,
            listen: false,
          );
          homeProvider.fetchRelatedProducts(
            productProvider.selectedProduct!.id,
          );

          final reviewProvider = Provider.of<ReviewProvider>(
            context,
            listen: false,
          );
          reviewProvider.fetchReviews(productProvider.selectedProduct!.id);
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Consumer2<ProductDetailsProvider, HomeProvider>(
      builder: (context, productProvider, homeProvider, child) {
        if (productProvider.productDetailsState == LoadingState.loading) {
          return const Scaffold(
            body: Center(child: CustomLoadingWidget()),
          );
        }

        if (productProvider.productDetailsState == LoadingState.error) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${productProvider.productDetailsError}',
                    style: const TextStyle(color: ProductTheme.errorColor),
                  ),
                  ElevatedButton(
                    onPressed:
                        () => productProvider.fetchProductDetails(widget.slug),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (productProvider.selectedProduct == null) {
          return const Scaffold(
            body: Center(child: Text('No product data available')),
          );
        }

        final product = productProvider.selectedProduct!;

        return Scaffold(
          body: Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Stack(
                      children: [
                        ProductImageWidget(
                          product: product,
                          height: screenHeight * 0.4,
                        ),
                        const Positioned(
                          top: 16,
                          left: 16,
                          child: CustomBackButton(),
                        ),
                        Positioned(
                          top: 16,
                          right: 16,
                          child: IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: ProductTheme.favoriteColor,
                            ),
                            onPressed:
                                () => setState(() => isFavorite = !isFavorite),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: ProductTheme.titleLarge(context),
                          ),
                          const SizedBox(height: 8),
                          ColorVariantsWidget(product: product),
                          const SizedBox(height: 8),
                          DescriptionWidget(
                            product: product,
                            isEditing: productProvider.isEditing,
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                    ReviewsSectionWidget(productId: product.id),
                    RelatedProductsWidget(provider: homeProvider),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  color: ProductTheme.backgroundColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      QuantitySelectorWidget(product: product),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {},
                        style: ProductTheme.elevatedButtonStyle,
                        child: const Text(
                          'Add to cart',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
