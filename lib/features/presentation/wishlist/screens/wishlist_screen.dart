import 'package:flutter/material.dart';

import '../../../../core/utils/widgets/product cards/custom_product_row.dart';
class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  // In a real app, you would probably use a state management solution
  // like Provider, Bloc, GetX, etc. to manage this data
  List<ProductModel> _wishlistItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWishlistItems();
  }

  // Mock function to fetch wishlist items
  Future<void> _fetchWishlistItems() async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, you would fetch this data from your API or local storage
    setState(() {
      _wishlistItems = [
        ProductModel(
          id: '1',
          name: 'Leather Jacket',
          price: 199.99,
          originalPrice: 249.99,
          imageUrl: 'https://img.freepik.com/free-vector/modern-sale-banner-with-product-description_1361-1259.jpg?t=st=1742030631~exp=1742034231~hmac=f721b974be505f9239d492d2bdb472910a5877f607a0fb6c6fa1e069eabe8ea7&w=996',
          isBestSeller: true,
        ),
        ProductModel(
          id: '2',
          name: 'Running Shoes',
          price: 89.99,
          originalPrice: 120.00,
          imageUrl: 'https://img.freepik.com/free-vector/modern-sale-banner-with-product-description_1361-1259.jpg?t=st=1742030631~exp=1742034231~hmac=f721b974be505f9239d492d2bdb472910a5877f607a0fb6c6fa1e069eabe8ea7&w=996',
          isBestSeller: false,
        ),
        ProductModel(
          id: '3',
          name: 'Smart Watch',
          price: 299.99,
          originalPrice: 0,
          imageUrl: 'https://img.freepik.com/free-vector/modern-sale-banner-with-product-description_1361-1259.jpg?t=st=1742030631~exp=1742034231~hmac=f721b974be505f9239d492d2bdb472910a5877f607a0fb6c6fa1e069eabe8ea7&w=996',
          isBestSeller: true,
        ),
      ];
      _isLoading = false;
    });
  }

  // Function to toggle favorite status (remove from wishlist)
  void _toggleFavorite(String productId) {
    setState(() {
      _wishlistItems.removeWhere((product) => product.id == productId);
    });

    // In a real app, you would call your API to update the wishlist
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Item removed from wishlist')),
    );
  }

  // Function to add item to cart
  void _addToCart(String productId) {
    // In a real app, you would add the item to the cart here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Item added to cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _wishlistItems.isEmpty
                ? null
                : () {
              // Show confirmation dialog before clearing wishlist
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear Wishlist'),
                  content: const Text('Are you sure you want to remove all items from your wishlist?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('CANCEL'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _wishlistItems.clear();
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Wishlist cleared')),
                        );
                      },
                      child: const Text('CLEAR'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _wishlistItems.isEmpty
          ? _buildEmptyWishlist()
          : _buildWishlistContent(),
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

  Widget _buildWishlistContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_wishlistItems.length} item${_wishlistItems.length > 1 ? 's' : ''}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: _wishlistItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final product = _wishlistItems[index];
                return SizedBox(
                  height: 150, // Adjust the height as needed
                  child: ProductItemInRow1(
                    imageUrl: product.imageUrl,
                    productName: product.name,
                    price: product.price.toString(),
                    originalPrice: product.originalPrice.toString(),
                    isBestSeller: product.isBestSeller,
                    productSlug: 'slug',
                    isFavorite: true, // Always true in wishlist
                    onFavoriteToggle: () => _toggleFavorite(product.id),
                    onAddToCart: () => _addToCart(product.id),
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

// Assuming you have a Product model class like this
// If not, you'll need to create one or modify the code to match your data structure
class ProductModel {
  final String id;
  final String name;
  final double price;
  final double originalPrice;
  final String imageUrl;
  final bool isBestSeller;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    this.originalPrice = 0,
    required this.imageUrl,
    this.isBestSeller = false,
  });
}