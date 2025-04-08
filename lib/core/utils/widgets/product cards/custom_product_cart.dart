import 'package:flutter/material.dart';
import 'package:laravel_ecommerce/core/config/themes.dart/theme.dart';
import 'package:laravel_ecommerce/core/utils/extension/text_style_extension.dart';
import '../../../../features/domain/cart/entities/cart.dart';
import '../../../config/routes.dart/routes.dart';


class ProductItemInCart extends StatelessWidget {
  final CartItem item;
  final int index;
  final Function? onDelete;
  final bool isFavorite;
  final Function(int)? onQuantityChanged;

  const ProductItemInCart({
    super.key,
    required this.item,
    required this.index,
    this.onDelete,
    this.isFavorite = false,
    this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Dismissible(
        key: Key(item.id.toString()),
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
              Expanded(
                flex: 5,
                child: InkWell(
                  onTap: () {
                    AppRoutes.navigateTo(
                      context,
                      AppRoutes.productDetailScreen,
                      arguments: {'slug': item.productSlug},
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.1),
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
                          const SizedBox(width: 15),
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
        child: Image.network(
          item.thumbnailImage,
          width: 60,
          height: 60,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
                strokeWidth: 2,
              ),
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
            item.productName,
            style: context.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5),
          // Display variant if available
          if (item.variant.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Text(
                'Variant: ${item.variant}',
                style: context.bodySmall?.copyWith(color: Colors.grey),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          Text(
            '${item.currencySymbol}${item.mainPrice}',
            style: context.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
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
                  if (item.quantity > item.lowerLimit && onQuantityChanged != null) {
                    onQuantityChanged!(item.quantity - 1);
                  }
                },
                enabled: item.quantity > item.lowerLimit,
              ),
            ),
            // Quantity display
            Expanded(
              child: Center(
                child: Text(
                  '${item.quantity}',
                  style: context.titleSmall.copyWith(color: AppTheme.white),
                ),
              ),
            ),
            // Plus button
            Expanded(
              child: _buildQuantityButton(
                icon: Icons.add,
                onPressed: () {
                  if (item.quantity < item.upperLimit && onQuantityChanged != null) {
                    onQuantityChanged!(item.quantity + 1);
                  }
                },
                enabled: item.quantity < item.upperLimit,
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