import 'package:flutter/material.dart';
import 'package:awesome_drawer_bar/awesome_drawer_bar.dart';
import 'package:laravel_ecommerce/config/themes.dart/theme.dart';
import 'package:laravel_ecommerce/core/utils/extension/text_style_extension.dart';
import '../widgets/category_selector.dart';
import '../widgets/popular_shoes.dart';
import '../widgets/new_arrivals.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/search_bar.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Text(
                  'Explore',
                  style: context.headlineSmall.copyWith(color:AppTheme.white),
                ),
                Positioned(
                  top: -5,
                  left: 0,
                  child: Icon(
                    Icons.auto_awesome,
                    size: 16,
                    color:AppTheme.white,
                  ),
                ),
              ],
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_sharp, color:AppTheme.white),
                onPressed: () {},
              ),
              Positioned(
                top: 10,
                right: 10,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              CustomSearchBar(),
              const SizedBox(height: 24),
              const CategorySelector(),
              const SizedBox(height: 24),
              const PopularShoes(),
              const SizedBox(height: 24),
              const NewArrivals(),
              const SizedBox(height: 80), // Space for bottom nav
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.shopping_bag_outlined,
          color: Colors.white,
          size: 28,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}

