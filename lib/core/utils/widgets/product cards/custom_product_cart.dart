import 'package:flutter/material.dart';
import 'package:laravel_ecommerce/core/utils/extension/text_style_extension.dart';

class ProductItemInCart extends StatelessWidget {
  final Map<String, dynamic> item;
  final int index;
  final Function? onDelete;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;
  final Function(int)? onQuantityChanged;

  const ProductItemInCart({
    super.key,
    required this.item,
    required this.index,
    this.onDelete,
    this.isFavorite = false,
    this.onFavoriteToggle,
    this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
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
        child: Container(
          width: MediaQuery.of(context).size.width,
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
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  spacing: 15,
                  children: [
                    _productImage(),
                    _productDetails(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _productImage(){
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
              color:
              index == 0
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

  Widget _productDetails(BuildContext context){
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
          const SizedBox(height: 8),

          _quantityButtonsWidget(),
        ],
      ),
    );
  }

  Widget _quantityButtonsWidget(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Minus button
        _buildQuantityButton(
          icon: Icons.remove,
          onPressed: () {
            if ((item['quantity'] as int) > 1 &&
                onQuantityChanged != null) {
              onQuantityChanged!(
                (item['quantity'] as int) - 1,
              );
            }
          },
          enabled: (item['quantity'] as int) > 1,
        ),
        // Quantity display
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 8,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${item['quantity']}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // Plus button
        _buildQuantityButton(
          icon: Icons.add,
          onPressed: () {
            if (onQuantityChanged != null) {
              onQuantityChanged!(
                (item['quantity'] as int) + 1,
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
    bool enabled = true,
  }) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: enabled ? Colors.blue : Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        icon: Icon(icon, size: 16, color: Colors.white),
        onPressed: enabled ? onPressed : null,
      ),
    );
  }


}
