import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/enums/loading_state.dart';
import '../../../../core/utils/widgets/product cards/custom_product_row.dart';
import '../controller/wishlist_provider.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WishlistProvider>(context, listen: false).fetchWishlist();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
        actions: [
          Consumer<WishlistProvider>(
            builder: (context, provider, child) {
              return IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: provider.wishlistItems.isEmpty
                    ? null
                    : () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Clear Wishlist'),
                      content: const Text(
                          'Are you sure you want to remove all items from your wishlist?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () {
                            for (var item in provider.wishlistItems) {
                              provider.removeFromWishlist(item.slug);
                            }
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Wishlist cleared')),
                            );
                          },
                          child: const Text('CLEAR'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<WishlistProvider>(
        builder: (context, provider, child) {
          if (provider.wishlistState == LoadingState.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          else if (provider.wishlistState == LoadingState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Something went wrong',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.wishlistError,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => provider.fetchWishlist(),
                    child: const Text('RETRY'),
                  ),
                ],
              ),
            );
          }
          else if (provider.wishlistItems.isEmpty) {
            return _buildEmptyWishlist();
          }
          else {
            return _buildWishlistContent(provider);
          }
        },
      ),
    );
  }

  Widget _buildEmptyWishlist() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Your wishlist is empty',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Items you add to your wishlist will appear here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Navigate to the products or categories screen
              Navigator.pop(context);
            },
            child: const Text('BROWSE PRODUCTS'),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistContent(WishlistProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${provider.wishlistItems.length} item${provider.wishlistItems.length > 1 ? 's' : ''}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: provider.wishlistItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final product = provider.wishlistItems[index];
                return SizedBox(
                  height: 150, // Adjust the height as needed
                  child: ProductItemInRow1(
                    imageUrl: product.thumbnailImage,
                    productName: product.name,
                    price: product.price,
                    originalPrice: '', // This might need to be added to your model
                    isBestSeller: false, // This might need to be added to your model
                    productSlug: product.slug,
                    productId: product.id,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}