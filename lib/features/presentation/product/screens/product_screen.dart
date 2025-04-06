import 'package:flutter/material.dart';
import 'package:laravel_ecommerce/core/utils/widgets/custom_cached_image.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../../domain/product details/entities/product_details.dart';
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
      final provider = Provider.of<ProductDetailsProvider>(context, listen: false);
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
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildProductImage(product),
                  title: Opacity(
                    opacity: _appBarOpacity,
                    child: Text(product.name),
                  ),
                ),
                leading: Opacity(
                  opacity: _appBarOpacity,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                actions: [
                  Opacity(
                    opacity: _appBarOpacity,
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.white,
                      ),
                      onPressed: () => setState(() => isFavorite = !isFavorite),
                    ),
                  ),
                  Opacity(
                    opacity: _appBarOpacity,
                    child: Stack(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.shopping_cart_outlined),
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
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProductHeader(product, provider.isEditing),
                    _buildColorVariants(product),
                    _buildDescription(product, provider.isEditing),
                    _buildBottomActions(provider.isEditing),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductImage(ProductDetails product) {
    print('ddddd${product.thumbnailImage}');
    return CustomImage(
      imageUrl: product.thumbnailImage,
    );
  }

  Widget _buildProductHeader(ProductDetails product, bool isEditing) {
    final titleController = TextEditingController(text: product.name);
    final priceController = TextEditingController(text: product.price);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.mainCategoryName, // Use real category name
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorVariants(ProductDetails product) {
    // Convert hex color strings to Color objects, fallback to hardcoded list if empty
    final colorList = product.colors.isNotEmpty
        ? product.colors.map((color) {
      try {
        return Color(int.parse(color.replaceAll('#', '0xff')));
      } catch (e) {
        return Colors.grey; // Fallback color if parsing fails
      }
    }).toList()
        : [
      const Color(0xFFFF9E80),
      const Color(0xFF1E88E5),
      const Color(0xFF42A5F5),
      const Color(0xFF2962FF),
      const Color(0xFF212121),
    ];

    return Container(
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
                border: selectedColorIndex == index
                    ? Border.all(color: Colors.blue, width: 2)
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDescription(ProductDetails product, bool isEditing) {
    final descriptionController = TextEditingController(text: product.description);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isEditing)
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            )
          else
            Text(
              product.description.isNotEmpty
                  ? product.description
                  : 'No description available',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          TextButton(
            onPressed: () {},
            child: const Text('Read More'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(bool isEditing) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: () => setState(() => isFavorite = !isFavorite),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (isEditing) {
                  context.read<ProductDetailsProvider>().toggleEdit();
                  // Add save logic here if needed
                } else {
                  // Add to cart logic
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                isEditing ? 'Save' : 'Add to Cart',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}