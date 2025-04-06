import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:laravel_ecommerce/core/utils/widgets/custom_back_button.dart';
import 'package:laravel_ecommerce/core/utils/widgets/custom_cached_image.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../../../core/utils/widgets/product cards/custom_gridview_prodcut.dart';
import '../../../domain/product details/entities/product_details.dart';
import '../controller/product_provider.dart';
import '../../home/controller/home_provider.dart';
import '../../../domain/product/entities/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final String slug;

  const ProductDetailScreen({super.key, required this.slug});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int selectedColorIndex = 0;
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
        // After fetching product details, fetch related products
        if (productProvider.selectedProduct != null) {
          final homeProvider = Provider.of<HomeProvider>(context, listen: false);
          homeProvider.fetchRelatedProducts(productProvider.selectedProduct!.id);
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
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (productProvider.productDetailsState == LoadingState.error) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${productProvider.productDetailsError}'),
                  ElevatedButton(
                    onPressed: () => productProvider.fetchProductDetails(widget.slug),
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
          body: SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image with overlay icons
                  Stack(
                    children: [
                      // Product image
                      Container(
                        height: screenHeight * 0.4,
                        width: double.infinity,
                        child: _buildProductImage(product),
                      ),

                      // Back button
                      Positioned(top: 16, left: 16, child: CustomBackButton()),

                      // Favorite and cart icons
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite ? Colors.red : Colors.white,
                              ),
                              onPressed:
                                  () =>
                                  setState(() => isFavorite = !isFavorite),
                            ),
                            Stack(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.shopping_cart_outlined,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {},
                                ),
                                Positioned(
                                  right: 8,
                                  top: 8,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Product details content
                  _buildProductHeader(product, productProvider.isEditing),
                  _buildColorVariants(product),
                  _buildDescription(product, productProvider.isEditing),

                  // Related Products
                  _buildRelatedProducts(homeProvider),

                  const SizedBox(height: 80), // Space for bottom sheet
                ],
              ),
            ),
          ),
          bottomSheet: Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${product.price} ريال',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'أضف إلى السلة',
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
        );
      },
    );
  }

  Widget _buildProductImage(ProductDetails product) {
    return CustomImage(imageUrl: product.thumbnailImage);
  }

  Widget _buildProductHeader(ProductDetails product, bool isEditing) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildColorVariants(ProductDetails product) {
    final colorList =
    product.colors.map((color) {
      try {
        return Color(int.parse(color.replaceAll('#', '0xff')));
      } catch (e) {
        return Colors.grey;
      }
    }).toList();

    return product.colors.isNotEmpty
        ? Container(
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: colorList.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => setState(() => selectedColorIndex = index),
            child: Container(
              width: 48,
              height: 48,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: colorList[index],
                shape: BoxShape.circle,
                border:
                selectedColorIndex == index
                    ? Border.all(color: Colors.blue, width: 2)
                    : null,
              ),
            ),
          );
        },
      ),
    )
        : const SizedBox.shrink();
  }

  Widget _buildDescription(ProductDetails product, bool isEditing) {
    final descriptionController = TextEditingController(
      text: product.description,
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'وصف المنتج',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 8),
            if (isEditing)
              TextField(
                controller: descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              )
            else
              product.description.isNotEmpty
                  ? Html(
                data: product.description,
                style: {
                  '*': Style(
                    fontSize: FontSize(16.0),
                    lineHeight: LineHeight(1.6),
                    direction: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    color: Colors.black87,
                    fontFamily: 'ArabicFont',
                  ),
                  'li': Style(margin: Margins.only(bottom: 8.0)),
                },
              )
                  : const Text(
                'لا يوجد وصف متاح',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelatedProducts(HomeProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 12.0),
            child: Text(
              'منتجات ذات صلة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          if (provider.relatedProductsState == LoadingState.loading)
            const Center(child: CircularProgressIndicator())
          else if (provider.relatedProductsState == LoadingState.error)
            Center(child: Text('Error: ${provider.relatedProductsError}'))
          else if (provider.relatedProducts.isEmpty)
              const Center(child: Text('لا توجد منتجات ذات صلة'))
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

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(slug: product.slug),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                child: CustomImage(
                  imageUrl: product.thumbnailImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),

            // Product info
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${product.mainPrice} ريال',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}