import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1E88E5),
      width: double.infinity,
      height: double.infinity,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 48.0, // account for vertical padding
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile section
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        image: const DecorationImage(
                          image: NetworkImage('https://i.pravatar.cc/150?img=8'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Emmanuel Oyiboke',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Menu items
                    _buildMenuItem(Icons.person_outline, 'Profile'),
                    const SizedBox(height: 20),
                    _buildMenuItem(Icons.shopping_cart_outlined, 'My Cart'),
                    const SizedBox(height: 20),
                    _buildMenuItem(Icons.favorite_border, 'Favorite'),
                    const SizedBox(height: 20),
                    _buildMenuItem(Icons.local_shipping_outlined, 'Orders'),
                    const SizedBox(height: 20),
                    _buildMenuItem(Icons.notifications_none, 'Notifications'),
                    const SizedBox(height: 20),
                    _buildMenuItem(Icons.settings_outlined, 'Settings'),

                    // Divider
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.0),
                      child: Divider(color: Colors.white, thickness: 1),
                    ),

                    // Sign out at the bottom - using Expanded instead of Spacer
                    const Expanded(child: SizedBox()),
                    _buildMenuItem(Icons.logout, 'Sign Out'),
                    const SizedBox(height: 10), // Add some bottom padding
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return ClipRect(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

}