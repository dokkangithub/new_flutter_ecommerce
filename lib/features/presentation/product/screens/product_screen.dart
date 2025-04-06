import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:laravel_ecommerce/core/utils/extension/text_style_extension.dart';
import 'package:laravel_ecommerce/core/utils/widgets/custom_cached_image.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../../domain/product details/entities/product_details.dart';
import '../../review/screens/products_review_screen.dart';
import '../controller/product_provider.dart';

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
  double _appBarOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ProductDetailsProvider>(
        context,
        listen: false,
      );
      provider.fetchProductDetails(widget.slug);
    });

    _scrollController.addListener(() {
      setState(() {
        _appBarOpacity = (_scrollController.offset / 100).clamp(0.0, 1.0);
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

    return Consumer<ProductDetailsProvider>(
      builder: (context, provider, child) {
        if (provider.productDetailsState == LoadingState.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (provider.productDetailsState == LoadingState.error) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${provider.productDetailsError}'),
                  ElevatedButton(
                    onPressed: () => provider.fetchProductDetails(widget.slug),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (provider.selectedProduct == null) {
          return const Scaffold(
            body: Center(child: Text('No product data available')),
          );
        }

        final product = provider.selectedProduct!;
        return Scaffold(
          body: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: screenHeight * 0.5,
                floating: false,
                pinned: true,
                stretch: true, // Enable stretch effect for the image
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [StretchMode.zoomBackground], // Zoom the image while stretching
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildProductImage(product), // Your product image
                      // Add a gradient overlay to make the title/icons more visible when collapsed
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.3),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  title: Text(
                    product.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  centerTitle: true, // Center the title
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white,
                    ),
                    onPressed: () => setState(() => isFavorite = !isFavorite),
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
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
                backgroundColor: Colors.blue, // Match the background color in the screenshot
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProductHeader(product, provider.isEditing),
                    _buildColorVariants(product),
                    _buildDescription(product, provider.isEditing),
                    ProductReviews()
                  ],
                ),
              ),            ],
          ),
          bottomSheet: Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Price
                Text(
                  '${product.price} ريال', // Assuming price is in Saudi Riyal (ريال) as per the screenshot
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                // Add to Cart Button
                ElevatedButton(
                  onPressed: () {

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'أضف إلى السلة', // Match the Arabic text in the screenshot
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
        children: [Text(product.name, style: context.titleMedium)],
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
        : SizedBox.shrink();
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
                    fontSize: FontSize(16.0), // Slightly larger font for readability
                    lineHeight: LineHeight(1.6), // Match the spacing in the screenshot
                    direction: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    color: Colors.black87,
                    fontFamily: 'ArabicFont', // Use an Arabic font if available
                  ),
                  'li': Style(
                    margin: Margins.only(bottom: 8.0), // Space between bullet points
                  ),
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

}
