import 'package:flutter/material.dart';
import 'package:laravel_ecommerce/core/config/themes.dart/theme.dart';
import 'package:laravel_ecommerce/core/utils/extension/text_style_extension.dart';
import '../../../config/routes.dart/routes.dart';

class ProductItemInCart extends StatelessWidget {
  final Map<String, dynamic> item;
  final int index;
  final String productSlug;
  final Function? onDelete;
  final bool isFavorite;
  final Function(int)? onQuantityChanged;

  const ProductItemInCart({
    super.key,
    required this.item,
    required this.index,
    required this.productSlug,
    this.onDelete,
    this.isFavorite = false,
    this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0), // Adjusted 'custom' to 'top'
      child: Dismissible(
        key: Key(item['name']),
        direction: DismissDirection.endToStart,
        background: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(15),
          ),
          alignment: Alignment.centerRight,
          child: const Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(Icons.delete_outline, color: Colors.white, size: 30),
          ),
        ),
        onDismissed: (direction) {
          if (onDelete != null) {
            onDelete!();
          }
        },
        child: SizedBox(
          height: 100,
          child: Row(
            children: [
              _quantityButtonsWidget(context),
              const SizedBox(width: 8),
              Expanded( // Moved Expanded here, direct child of Row
                flex: 5,
                child: InkWell(
                  onTap: () {
                    AppRoutes.navigateTo(
                      context,
                      AppRoutes.productDetailScreen,
                      arguments: {'slug': productSlug},
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          _productImage(),
                          const SizedBox(width: 15), // Replaced Row(spacing: 15)
                          _productDetails(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _productImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Image.asset(
          index == 0
              ? 'assets/blue_shoe.png'
              : index == 1
              ? 'assets/orange_shoe.png'
              : 'assets/purple_shoe.png',
          width: 60,
          height: 60,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.image,
              size: 40,
              color: index == 0
                  ? Colors.blue
                  : index == 1
                  ? Colors.orange
                  : Colors.purple,
            );
          },
        ),
      ),
    );
  }

  Widget _productDetails(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            item['name'],
            style: context.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5),
          Text(
            '\$${item['price'].toStringAsFixed(2)}',
            style: context.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _quantityButtonsWidget(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            // Minus button
            Expanded(
              child: _buildQuantityButton(
                icon: Icons.remove,
                onPressed: () {
                  if ((item['quantity'] as int) > 1 && onQuantityChanged != null) {
                    onQuantityChanged!((item['quantity'] as int) - 1);
                  }
                },
                enabled: (item['quantity'] as int) > 1,
              ),
            ),
            // Quantity display
            Expanded(
              child: Text(
                '${item['quantity']}',
                style: context.titleSmall.copyWith(color: AppTheme.white),
              ),
            ),
            // Plus button
            Expanded(
              child: _buildQuantityButton(
                icon: Icons.add,
                onPressed: () {
                  if (onQuantityChanged != null) {
                    onQuantityChanged!((item['quantity'] as int) + 1);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
    bool enabled = true,
  }) {
    return InkWell(
      onTap: enabled ? onPressed : null,
      child: Icon(
        icon,
        size: 24,
        color: enabled ? AppTheme.white : AppTheme.lightDividerColor,
      ),
    );
  }
}