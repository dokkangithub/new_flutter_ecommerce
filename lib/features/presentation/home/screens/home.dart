import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:laravel_ecommerce/core/utils/extension/responsive_extension.dart';
import 'package:laravel_ecommerce/core/utils/widgets/product%20cards/custom_product_card.dart';
import 'package:laravel_ecommerce/core/utils/widgets/see_all_widget.dart';
import 'package:laravel_ecommerce/features/presentation/home/widgets/category_card.dart';
import 'package:laravel_ecommerce/features/presentation/home/widgets/search_bar.dart';
import '../../../../core/utils/widgets/product cards/custom_gridview_prodcut.dart';
import '../../../../core/utils/widgets/product cards/custom_product_row.dart';
import '../widgets/banners_widget.dart';


final List<Map<String, String>> categories = [
  {
    'name': 'Electronics',
    'imageUrl': 'https://img.freepik.com/free-psd/stylish-modern-sneaker-design-white-gray-black-red-teal-accents-thick-sole-casual-footwear-trendy-shoe_632498-30181.jpg?t=st=1741854021~exp=1741857621~hmac=d7275cdb0553ef5b4e0953b6fc1a09215516a7905d28fb346e63c85c382b5c23&w=740',
  },
  {
    'name': 'Fashion',
    'imageUrl': 'https://img.freepik.com/free-psd/stylish-modern-sneaker-design-white-gray-black-red-teal-accents-thick-sole-casual-footwear-trendy-shoe_632498-30181.jpg?t=st=1741854021~exp=1741857621~hmac=d7275cdb0553ef5b4e0953b6fc1a09215516a7905d28fb346e63c85c382b5c23&w=740',
  },
  {
    'name': 'Home',
    'imageUrl': 'https://img.freepik.com/free-psd/stylish-modern-sneaker-design-white-gray-black-red-teal-accents-thick-sole-casual-footwear-trendy-shoe_632498-30181.jpg?t=st=1741854021~exp=1741857621~hmac=d7275cdb0553ef5b4e0953b6fc1a09215516a7905d28fb346e63c85c382b5c23&w=740',
  },
  {
    'name': 'Sports',
    'imageUrl': 'https://img.freepik.com/free-psd/stylish-modern-sneaker-design-white-gray-black-red-teal-accents-thick-sole-casual-footwear-trendy-shoe_632498-30181.jpg?t=st=1741854021~exp=1741857621~hmac=d7275cdb0553ef5b4e0953b6fc1a09215516a7905d28fb346e63c85c382b5c23&w=740',
  },
  {
    'name': 'Books',
    'imageUrl': 'https://img.freepik.com/free-psd/stylish-modern-sneaker-design-white-gray-black-red-teal-accents-thick-sole-casual-footwear-trendy-shoe_632498-30181.jpg?t=st=1741854021~exp=1741857621~hmac=d7275cdb0553ef5b4e0953b6fc1a09215516a7905d28fb346e63c85c382b5c23&w=740',
  },
  {
    'name': 'Beauty',
    'imageUrl': 'https://img.freepik.com/free-psd/stylish-modern-sneaker-design-white-gray-black-red-teal-accents-thick-sole-casual-footwear-trendy-shoe_632498-30181.jpg?t=st=1741854021~exp=1741857621~hmac=d7275cdb0553ef5b4e0953b6fc1a09215516a7905d28fb346e63c85c382b5c23&w=740',
  },
];


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSearchBar(),
          _buildCategory(context),
          _buildBestSeller(context),
          SimpleBannerCarousel(),
          _buildTopRated(context),
          _buildPopular(context),
          _allProducts(context),
        ],
      ),
    );
  }



  Widget _buildCategory(BuildContext context) {
    return SizedBox(
      height: context.responsive(120),
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SeeAllWidget(title: 'CATEGORIES'),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) =>
                  CategoryCard(
                    imageUrl: categories[index]['imageUrl']!,
                    name: categories[index]['name']!,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              '${categories[index]['name']} selected'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
              itemCount: categories.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBestSeller(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        SeeAllWidget(title: 'BEST SELLER'),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder:
                (context, index) =>
                ProductCard(
                  imageUrl:
                  'https://img.freepik.com/free-psd/modern-sectional-sofa-with-wooden-coffee-table-plant_632498-24117.jpg?t=st=1741856935~exp=1741860535~hmac=c3bc34d818afc9ad79cd75894fbd7125c7d70de858b07d389d8bc06a43e9d1ac&w=740',
                  productName: 'productName',
                  price: 200,
                  isBestSeller: true,
                  onAddToCart: () {},
                  onFavoriteToggle: () {},
                ),
            itemCount: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildTopRated(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        SeeAllWidget(title: 'TOP RATED'),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder:
                (context, index) =>
                ProductCard(
                  imageUrl:
                  'https://img.freepik.com/free-psd/modern-sectional-sofa-with-wooden-coffee-table-plant_632498-24117.jpg?t=st=1741856935~exp=1741860535~hmac=c3bc34d818afc9ad79cd75894fbd7125c7d70de858b07d389d8bc06a43e9d1ac&w=740',
                  productName: 'productName',
                  price: 200,
                  isBestSeller: true,
                  onAddToCart: () {},
                  onFavoriteToggle: () {},
                ),
            itemCount: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildPopular(BuildContext context) {
    final List<Map<String, dynamic>> products = [
      {
        'imageUrl': 'https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/skwgyqrbfzhu6uyeh0gg/air-jordan-1-mid-shoes-BpARGV.png',
        'productName': 'Nike Jordan',
        'price': 302.00,
        'originalPrice': 350.00,
        'isBestSeller': true,
        'isFavorite': false,
      },
      {
        'imageUrl': 'https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/skwgyqrbfzhu6uyeh0gg/air-jordan-1-mid-shoes-BpARGV.png',
        'productName': 'Nike Jordan',
        'price': 302.00,
        'originalPrice': 350.00,
        'isBestSeller': true,
        'isFavorite': false,
      },
      {
        'imageUrl': 'https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/skwgyqrbfzhu6uyeh0gg/air-jordan-1-mid-shoes-BpARGV.png',
        'productName': 'Nike Jordan',
        'price': 302.00,
        'originalPrice': 350.00,
        'isBestSeller': true,
        'isFavorite': false,
      },
      {
        'imageUrl': 'https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/skwgyqrbfzhu6uyeh0gg/air-jordan-1-mid-shoes-BpARGV.png',
        'productName': 'Nike Jordan',
        'price': 302.00,
        'originalPrice': 350.00,
        'isBestSeller': true,
        'isFavorite': false,
      },
      {
        'imageUrl': 'https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/skwgyqrbfzhu6uyeh0gg/air-jordan-1-mid-shoes-BpARGV.png',
        'productName': 'Air Max 90',
        'price': 275.00,
        'originalPrice': 320.00,
        'isBestSeller': false,
        'isFavorite': true,
      },

    ];
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SeeAllWidget(title: 'POPULAR'),
        CarouselSlider.builder(
          itemCount: products.isNotEmpty ? products.length : 10,
          options: CarouselOptions(
            height: 200,
            viewportFraction: 0.98,
            enableInfiniteScroll: products.length > 3,
            autoPlay: products.length > 1,
            autoPlayInterval: const Duration(seconds: 5),
            enlargeCenterPage: true,
            padEnds: true,
          ),
          itemBuilder: (context, index, realIndex) {
            final product = products.isNotEmpty ? products[index] : null;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ProductItemInRow1(
                imageUrl: product?['imageUrl'] ??
                    'https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/skwgyqrbfzhu6uyeh0gg/air-jordan-1-mid-shoes-BpARGV.png',
                productName: product?['productName'] ?? 'Nike Product',
                price: product?['price'] ?? 299.99,
                originalPrice: product?['originalPrice'] ?? 350.00,
                isBestSeller: product?['isBestSeller'] ?? false,
                isFavorite: product?['isFavorite'] ?? false,
                onFavoriteToggle: () {
                  // Handle favorite toggle logic
                  print('Toggled favorite for product ${index + 1}');
                },
                onAddToCart: () {
                  // Handle add to cart logic
                  print('Added product ${index + 1} to cart');
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _allProducts(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        SeeAllWidget(title: 'ALL PRODUCTS'),
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
          itemCount: 10,
          itemBuilder: (context, index) {
            return ProductGridCard(
              imageUrl:
              'https://img.freepik.com/free-psd/modern-sectional-sofa-with-wooden-coffee-table-plant_632498-24117.jpg?t=st=1741856935~exp=1741860535~hmac=c3bc34d818afc9ad79cd75894fbd7125c7d70de858b07d389d8bc06a43e9d1ac&w=740',
              productName: 'productName',
              price: 200,
              isBestSeller: true,
              onAddToCart: () {},
              onFavoriteToggle: () {},
            );
          },
        ),
      ],
    );
  }



}