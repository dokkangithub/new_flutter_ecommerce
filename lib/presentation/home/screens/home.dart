import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShopEasy'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // TODO: Navigate to cart
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategories(),
            _buildBannerSlider(),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Popular Products",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            _buildProductGrid(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildCategories() {
    List<String> categories = ["All", "Electronics", "Clothing", "Shoes", "Beauty"];
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Chip(
              label: Text(categories[index]),
              backgroundColor: Colors.blueAccent.withOpacity(0.1),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBannerSlider() {
    List<String> banners = [
      'https://via.placeholder.com/400x150',
      'https://via.placeholder.com/400x150'
    ];
    return SizedBox(
      height: 150,
      child: PageView.builder(
        itemCount: banners.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(banners[index], fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                  child: Image.network(
                    'https://via.placeholder.com/150',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Product Name",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text("\$99.99", style: TextStyle(color: Colors.green)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
