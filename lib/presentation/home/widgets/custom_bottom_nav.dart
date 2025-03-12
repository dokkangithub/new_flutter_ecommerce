import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _selectedIndex = 2; // Cart is selected by default

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 60,
      notchMargin: 8,
      shape: const CircularNotchedRectangle(),
      color: Colors.white,
      elevation: 10,
      shadowColor: Colors.black12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.home_outlined),
          _buildNavItem(1, Icons.favorite_border),
          const SizedBox(width: 40), // Space for FAB
          _buildNavItem(3, Icons.notifications_none),
          _buildNavItem(4, Icons.person_outline),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon) {
    return IconButton(
      icon: Icon(
        icon,
        color: _selectedIndex == index ? Theme.of(context).primaryColor : Colors.grey,
        size: 28,
      ),
      onPressed: () => _onItemTapped(index),
    );
  }
}

