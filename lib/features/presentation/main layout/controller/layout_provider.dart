import 'package:flutter/material.dart';
import 'package:laravel_ecommerce/core/config/routes.dart/routes.dart';
import 'package:laravel_ecommerce/features/presentation/category/screens/category_screen.dart';
import 'package:laravel_ecommerce/features/presentation/home/screens/home.dart';
import 'package:laravel_ecommerce/features/presentation/profile/screens/profile_screen.dart';
import 'package:laravel_ecommerce/features/presentation/wishlist/screens/wishlist_screen.dart';

class LayoutProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }


  List<Widget> mainScreens=[
    HomeScreen(),
    CategoryScreen(),
    WishlistScreen(),
    ProfileScreen(),
  ];

  void handleCenterButtonTap(BuildContext context) {
    AppRoutes.navigateTo(context, AppRoutes.cartScreen);
    notifyListeners();
  }
}