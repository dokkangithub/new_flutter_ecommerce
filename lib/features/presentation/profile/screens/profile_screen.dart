import 'package:flutter/material.dart';
import 'package:laravel_ecommerce/core/config/routes.dart/routes.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/config/themes.dart/theme.dart';
import '../../../../core/utils/constants/app_strings.dart';
import '../../../data/profile/models/profile_counters_model.dart';
import '../../address/screens/address_list_screen.dart';
import '../../auth/controller/auth_provider.dart';
import '../../auth/screens/login_screen.dart';
import '../controller/profile_provider.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider = context.read<ProfileProvider>();
      profileProvider.getUserProfile();
      profileProvider.getProfileCounters();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final counters = profileProvider.profileCounters;
    final isLoggedIn = AppStrings.token != null;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Profile Picture Section
            _buildProfileHeader(context),
            const SizedBox(height: 16),
            // Counters Section
            if (isLoggedIn && counters != null) _buildCounters(counters),
            const SizedBox(height: 24),
            // Menu Items
            _buildMenuItems(context),
          ],
        ),
      ),
    );
  }



  Widget _buildProfileHeader(BuildContext context) {
    final isLoggedIn = AppStrings.token != null;
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Center(
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              color: AppTheme.accentColor.withValues(alpha: 0.2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: profileProvider.profileImageUrl != null
                  ? Image.network(
                      profileProvider.profileImageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey,
                      ),
                    )
                  : const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.grey,
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.userName??'Guest User',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            AppStrings.userEmail?? '',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          if (isLoggedIn)
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
                );
              },
              child: const Text(
                'تعديل المعلومات الشخصية',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 15,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCounters(ProfileCountersModel counters) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCounterItem(counters.cartItemCount, 'Cart Items', Icons.shopping_cart),
          _buildCounterItem(counters.wishlistItemCount, 'Wishlist', Icons.favorite),
          _buildCounterItem(counters.orderCount, 'Orders', Icons.shopping_bag),
        ],
      ),
    );
  }

  Widget _buildCounterItem(int count, String label, IconData icon) {
    return GestureDetector(
      onTap: () {
        // Navigate based on the counter type
        if (label == 'Cart Items') {
          AppRoutes.navigateTo(context, AppRoutes.cartScreen);
        } else if (label == 'Wishlist') {
          AppRoutes.navigateTo(context, AppRoutes.wishListScreen);
        } else if (label == 'Orders') {
          AppRoutes.navigateTo(context, AppRoutes.allOrdersListScreen);
        }
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.accentColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primaryColor),
            const SizedBox(height: 8),
            Text(
              count.toString(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    final isLoggedIn = AppStrings.token != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.location_on_outlined,
            title: 'العناوين',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddressListScreen(),
                ),
              );
            },
            trailing: const Icon(Icons.chevron_right),
          ),

          _buildMenuItem(
            icon: Icons.language,
            title: 'اللغة',
            onTap: () {
              // Show language dialog
            },
            trailing: const Icon(Icons.chevron_right),
          ),
          _buildMenuItem(
            icon: Icons.star_border,
            title: 'تقييم التطبيق',
            onTap: () {
              // Open app store/play store
            },
            trailing: const Icon(Icons.chevron_right),
          ),
          _buildMenuItem(
            icon: Icons.help_outline,
            title: 'طلب المساعدة',
            onTap: () {
              // Navigate to help
            },
            trailing: const Icon(Icons.chevron_right),
          ),
          _buildMenuItem(
            icon: Icons.description_outlined,
            title: 'الشروط والأحكام',
            onTap: () {
              // Navigate to terms
            },
            trailing: const Icon(Icons.chevron_right),
          ),
          _buildMenuItem(
            icon: Icons.public,
            title: 'الموقع الخاص بنا',
            onTap: () async {
              final Uri url = Uri.parse('https://homelyhubmarket.com');
              if (!await launchUrl(url)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Could not launch website')),
                );
              }
            },
            trailing: const Icon(Icons.chevron_right),
          ),
          if (isLoggedIn)
            _buildMenuItem(
              icon: Icons.logout,
              title: 'تسجيل الخروج',
              onTap: () {
                _showLogoutConfirmation(context);
              },
              trailing: const Icon(Icons.chevron_right),
              textColor: Colors.red,
              iconColor: Colors.red,
            )
          else
            _buildMenuItem(
              icon: Icons.login,
              title: 'تسجيل الدخول',
              onTap: () {
                // Navigate to login
              },
              trailing: const Icon(Icons.chevron_right),
              textColor: AppTheme.primaryColor,
              iconColor: AppTheme.primaryColor,
            ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Widget? trailing,
    Color? textColor,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(color: textColor)),
      trailing: trailing,
      onTap: onTap,
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    // Store the outer context to use for navigation after dialog is closed
    final navigatorContext = context;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد أنك تريد تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              // Close the dialog first
              Navigator.pop(dialogContext);

              // Perform logout
              await navigatorContext.read<AuthProvider>().logout();

              // Clear user data
              AppStrings.userId = null;
              AppStrings.token = null;

              // Check if context is still valid and navigate to login screen
              if (navigatorContext.mounted) {
                // Use pushReplacement to ensure we're replacing the current route
                Navigator.of(navigatorContext).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text('تسجيل الخروج', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

