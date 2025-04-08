import 'package:flutter/material.dart';
import 'package:laravel_ecommerce/core/utils/enums/loading_state.dart';
import 'package:laravel_ecommerce/core/utils/widgets/product%20cards/custom_gridview_prodcut.dart';
import 'package:laravel_ecommerce/features/presentation/home/controller/home_provider.dart';
import 'package:laravel_ecommerce/features/presentation/product/widgets/product_theme.dart';
import 'package:laravel_ecommerce/features/presentation/product/widgets/shimmers/shimmer_widget.dart';

class RelatedProductsWidget extends StatelessWidget {
  final HomeProvider provider;

  const RelatedProductsWidget({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 12.0),
            child: Text(
              'Related Products',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          if (provider.relatedProductsState == LoadingState.loading)
            const ShimmerWidget(height: 200)
          else if (provider.relatedProductsState == LoadingState.error)
            Center(
                child: Text('Error: ${provider.relatedProductsError}',
                    style: const TextStyle(color: ProductTheme.errorColor)))
          else if (provider.relatedProducts.isEmpty)
              const Center(child: Text('No related products available'))
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: provider.relatedProducts.length,
                itemBuilder: (context, index) {
                  final product = provider.relatedProducts[index];
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
              ),
        ],
      ),
    );
  }
}