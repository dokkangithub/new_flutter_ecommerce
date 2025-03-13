import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:laravel_ecommerce/core/utils/constants/app_assets.dart';
import 'dart:math' show pi;
import 'package:laravel_ecommerce/core/utils/extension/text_style_extension.dart';
import 'package:laravel_ecommerce/features/presentation/main%20layout/controller/layout_provider.dart';
import 'package:provider/provider.dart';
import '../../../../core/config/themes.dart/theme.dart';
import 'drawer_menu.dart';


class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final double _maxSlide = 255.0;
  final double _minDragStartEdge = 60;
  final double _maxDragStartEdge = 300;
  bool _canBeDragged = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggle() =>
      _animationController.isDismissed
          ? _animationController.forward()
          : _animationController.reverse();

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft =
        _animationController.isDismissed &&
            details.globalPosition.dx < _minDragStartEdge;
    bool isDragCloseFromRight =
        _animationController.isCompleted &&
            details.globalPosition.dx > _maxDragStartEdge;

    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta! / _maxSlide;
      _animationController.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    if (_animationController.isDismissed || _animationController.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() >= 365.0) {
      double visualVelocity =
          details.velocity.pixelsPerSecond.dx /
              MediaQuery
                  .of(context)
                  .size
                  .width;
      _animationController.fling(velocity: visualVelocity);
    } else if (_animationController.value < 0.5) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      onTap: () {
        if (_animationController.isCompleted) {
          _animationController.reverse();
        }
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, _) {
          final double slide = _maxSlide * _animationController.value;
          final double scale = 1 - (_animationController.value * 0.3);
          final double rotate = _animationController.value * (-pi / 36);

          return Stack(
            children: [
              const DrawerMenu(),
              Transform(
                transform:
                Matrix4.identity()
                  ..translate(slide)
                  ..scale(scale)
                  ..rotateZ(rotate),
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    if (_animationController.isCompleted) {
                      _animationController.reverse();
                    }
                  },
                  child: Stack(
                    children: [
                      // Shadow overlay when drawer is open
                      if (_animationController.value > 0)
                        Positioned.fill(
                          child: GestureDetector(
                            onTap: () => _animationController.reverse(),
                            child: Container(
                              color: Colors.black.withOpacity(
                                0.3 * _animationController.value,
                              ),
                            ),
                          ),
                        ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          20 * _animationController.value,
                        ),
                        child: const ExploreScreen(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

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


class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {

    LayoutProvider provider =Provider.of<LayoutProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appbar(context),
      body: provider.mainScreens[provider.currentIndex],
      bottomNavigationBar: Consumer<LayoutProvider>(
        builder: (context, layoutProvider, _) {
          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              // First layer: Container with navigation items
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                ),
                child: Stack(
                  children: [
                    // The SVG background shape
                    SvgPicture.asset(
                      AppSvgs.bottomNavShape,
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ),

                    // Navigation items
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildNavItem(context, AppIcons.home, 0, layoutProvider),
                        _buildNavItem(context, AppIcons.category, 1, layoutProvider),
                        Container(width: 60), // Space for center button
                        _buildNavItem(context, AppIcons.heart, 2, layoutProvider),
                        _buildNavItem(context, AppIcons.profile, 3, layoutProvider),
                      ],
                    ),
                  ],
                ),
              ),

              // Top layer: The elevated center button
              Positioned(
                top: -10,
                child: GestureDetector(
                  onTap: () {
                    layoutProvider.handleCenterButtonTap(context);
                  },
                  child: Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withAlpha(76), // fixed .withValues to .withAlpha
                          spreadRadius: 2,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        AppIcons.cart,
                        width: 20,
                        height: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }


  PreferredSizeWidget _appbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Text('Explore', style: context.headlineSmall),
              Positioned(
                top: -5,
                left: 0,
                child: Icon(
                  Icons.auto_awesome,
                  size: 16,
                  color: AppTheme.black,
                ),
              ),
            ],
          ),
        ],
      ),
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.black),
        onPressed: () {
          final _MainLayoutScreenState? state =
          context.findAncestorStateOfType<_MainLayoutScreenState>();
          state?.toggle();
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.black),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildNavItem(BuildContext context, String iconPath, int index,
      LayoutProvider provider) {
    bool isSelected = provider.currentIndex == index;

    return InkWell(
      onTap: () => provider.setCurrentIndex(index),
      child: SvgPicture.asset(
        iconPath,
        width: 24,
        height: 24,
        color: isSelected ? Colors.blue : Colors.grey,
      ),
    );
  }



}