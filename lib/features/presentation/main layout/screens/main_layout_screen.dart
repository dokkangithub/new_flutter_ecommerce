import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:laravel_ecommerce/core/utils/constants/app_assets.dart';
import 'package:laravel_ecommerce/core/utils/extension/text_style_extension.dart';
import 'package:laravel_ecommerce/features/presentation/main%20layout/controller/layout_provider.dart';
import 'package:provider/provider.dart';
import '../../../../core/config/themes.dart/theme.dart';
import 'drawer_menu.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => MainLayoutScreenState();
}

class MainLayoutScreenState extends State<MainLayoutScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  // Animation for drawer width
  late Animation<double> _drawerWidthAnimation;

  // Animation for content scale & position
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;

  // Animation for background opacity
  late Animation<double> _opacityAnimation;

  // Animation for drawer content fade-in
  late Animation<double> _drawerContentOpacity;

  // Animation for corner radius
  late Animation<double> _borderRadiusAnimation;

  // Flag to track drawer state
  bool _isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // Setup animations
    _drawerWidthAnimation = Tween<double>(
      begin: 0.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutQuart,
      reverseCurve: Curves.easeInQuart,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.85,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 0.6,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
    ));

    _drawerContentOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
    ));

    _borderRadiusAnimation = Tween<double>(
      begin: 0.0,
      end: 24.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleDrawer() {
    setState(() {
      if (_isDrawerOpen) {
        _animationController.reverse().then((_) {
          setState(() {
            _isDrawerOpen = false;
          });
        });
      } else {
        _isDrawerOpen = true;
        _animationController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    LayoutProvider provider = Provider.of<LayoutProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          // Backdrop color
          Container(
            color: const Color(0xFF1E88E5).withOpacity(0.4),
          ),

          // Animated drawer
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: screenWidth * _drawerWidthAnimation.value,
                child: FadeTransition(
                  opacity: _drawerContentOpacity,
                  child: const DrawerMenu(),
                ),
              );
            },
          ),

          // Main content with animation
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                width: screenWidth,
                child: Transform.translate(
                  offset: Offset(screenWidth * 0.65 * _slideAnimation.value, 0),
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    alignment: Alignment.centerRight,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(_borderRadiusAnimation.value),
                      child: Stack(
                        children: [
                          // Main content scaffold
                          _buildMainContent(context, provider),

                          // Overlay when drawer is open
                          if (_animationController.value > 0)
                            GestureDetector(
                              onTap: () {
                                if (_isDrawerOpen) toggleDrawer();
                              },
                              child: Container(
                                width: screenWidth,
                                height: screenHeight,
                                color: Colors.black.withOpacity(_opacityAnimation.value),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Build the main content
  Widget _buildMainContent(BuildContext context, LayoutProvider provider) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: provider.mainScreens[provider.currentIndex],
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  // Build the app bar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
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
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animationController,
          color: Colors.black,
        ),
        onPressed: () {
          print('Menu button pressed');
          toggleDrawer();
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

  // Build the bottom navigation bar
  Widget _buildBottomNavBar(BuildContext context) {
    return Consumer<LayoutProvider>(
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
                        color: Colors.blue.withAlpha(76),
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
    );
  }

  // Build a navigation item
  Widget _buildNavItem(
      BuildContext context, String iconPath, int index, LayoutProvider provider) {
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